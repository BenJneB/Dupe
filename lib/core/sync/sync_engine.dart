import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/sync/sync_codec.dart';
import 'package:dupe/core/sync/sync_remote.dart';

/// Result of one synchronisation.
typedef SyncReport = ({int pushed, int pulled});

/// SQLite <-> remote synchronisation (PLAN.md §6).
///
/// 1. Push: rows marked `sync_pending` are upserted, then unmarked unless
///    modified meanwhile.
/// 2. Pull: remote rows written since the per-table cursor are applied,
///    except over a local pending row that is newer (last write wins; the
///    server applies the same rule to pushes).
class SyncEngine {
  new(this._db, this._remote, this._settings, {this.pageSize = 500})
    : _codec = SyncCodec(_db);

  final AppDatabase _db;
  final SyncRemote _remote;
  final AppSettingsStore _settings;
  final SyncCodec _codec;
  final int pageSize;

  /// The server stamps a row when it is written, but other clients only see
  /// it once its transaction commits: a row can become visible with a stamp
  /// older than rows already pulled (two devices syncing at the same time).
  /// Each pull therefore re-reads this window before the cursor; applying a
  /// row twice changes nothing.
  static const overlap = Duration(minutes: 1);

  static String _cursorKey(String table) => 'sync_cursor_$table';

  /// Local schema of the last complete pull. A migration adds synced
  /// columns (`volume_title`, `is_signed`…) to rows pulled before it, with
  /// their default: the first sync on a new schema reads every row again,
  /// rewriting even rows of the same `updated_at`, so that those columns
  /// are filled (and not pushed back empty over other devices).
  static const _schemaKey = 'sync_schema_version';

  Future<SyncReport> sync(String userId) async {
    var pushed = 0;
    var pulled = 0;
    for (final table in _codec.tables) {
      pushed += await _push(table, userId);
    }
    final schema = '${_db.schemaVersion}';
    final refetch = await _settings.get(_schemaKey) != schema;
    // First pages of every table fetched at once (one round trip instead
    // of one per table, every 30 s), then applied in table order: a row
    // only refers to rows of tables before it.
    final starts = [
      for (final table in _codec.tables)
        await _start(table.actualTableName, refetch: refetch),
    ];
    final firstPages = await Future.wait([
      for (final (i, table) in _codec.tables.indexed)
        _remote.changesSince(
          table.actualTableName,
          starts[i].after,
          limit: pageSize,
        ),
    ]);
    for (final (i, table) in _codec.tables.indexed) {
      pulled += await _pull(
        table,
        newest: starts[i].newest,
        firstPage: firstPages[i],
        refetch: refetch,
      );
    }
    if (refetch) await _settings.set(_schemaKey, schema);
    return (pushed: pushed, pulled: pulled);
  }

  static const _userKey = 'sync_user_id';

  /// Called on sign-in. A new account (or the first one) receives the whole
  /// local collection: every row is marked to push and cursors restart.
  Future<void> adoptUser(String userId) async {
    if (await _settings.get(_userKey) == userId) return;
    await _db.transaction(() async {
      for (final table in _codec.tables) {
        await _db.customUpdate(
          'UPDATE ${table.actualTableName} SET sync_pending = 1',
          updates: {table},
        );
      }
    });
    await reset();
    await _settings.set(_userKey, userId);
  }

  /// Whether local changes wait to be pushed.
  Future<bool> hasPending() async {
    for (final table in _codec.tables) {
      final row = await _db
          .customSelect(
            'SELECT 1 FROM ${table.actualTableName} '
            'WHERE sync_pending = 1 LIMIT 1',
            readsFrom: {table},
          )
          .getSingleOrNull();
      if (row != null) return true;
    }
    return false;
  }

  /// Forgets the cursors (sign-out): the next account pulls everything.
  Future<void> reset() async {
    for (final table in _codec.tables) {
      await _settings.set(_cursorKey(table.actualTableName), '');
    }
  }

  Future<int> _push(TableInfo<Table, Object?> table, String userId) async {
    final name = table.actualTableName;
    final rows = await _db
        .customSelect(
          'SELECT * FROM $name WHERE sync_pending = 1',
          readsFrom: {table},
        )
        .get();
    if (rows.isEmpty) return 0;
    for (var start = 0; start < rows.length; start += pageSize) {
      final page = rows.skip(start).take(pageSize).toList();
      await _remote.upsert(name, [
        for (final r in page) _codec.toRemote(table, r.data, userId),
      ]);
      await _db.transaction(() async {
        for (final r in page) {
          // Same raw updated_at: not modified while pushing.
          await _db.customUpdate(
            'UPDATE $name SET sync_pending = 0 WHERE id = ? AND updated_at = ?',
            variables: [Variable(r.data['id']), Variable(r.data['updated_at'])],
            updates: {table},
          );
        }
      });
    }
    return rows.length;
  }

  /// Where the pull of [name] starts: its cursor minus [overlap], or the
  /// beginning (first sync, [refetch]).
  Future<({DateTime? newest, SyncCursor? after})> _start(
    String name, {
    required bool refetch,
  }) async {
    final stored = refetch ? null : await _settings.get(_cursorKey(name));
    final newest = stored == null || stored.isEmpty
        ? null
        : DateTime.parse(stored);
    // Re-read the last [overlap]: see [overlap].
    return (
      newest: newest,
      after: newest == null
          ? null
          : (at: _utc(newest.subtract(overlap)), id: null),
    );
  }

  Future<int> _pull(
    TableInfo<Table, Object?> table, {
    required DateTime? newest,
    required List<Map<String, Object?>> firstPage,
    required bool refetch,
  }) async {
    final name = table.actualTableName;
    var latest = newest;
    var applied = 0;
    var changes = firstPage;
    SyncCursor? after;
    while (true) {
      if (after != null) {
        changes = await _remote.changesSince(name, after, limit: pageSize);
      }
      if (changes.isEmpty) break;
      await _db.transaction(() async {
        for (final remote in changes) {
          if (await _codec.apply(
            table,
            remote,
            pending: false,
            refetch: refetch,
          )) {
            applied++;
          }
        }
      });
      final last = changes.last;
      final lastAt = DateTime.parse(last['server_updated_at']! as String);
      after = (at: _utc(lastAt), id: last['id']! as String);
      if (latest == null || lastAt.isAfter(latest)) {
        latest = lastAt;
        await _settings.set(_cursorKey(name), _utc(lastAt));
      }
      if (changes.length < pageSize) break;
    }
    return applied;
  }

  static String _utc(DateTime d) => d.toUtc().toIso8601String();
}
