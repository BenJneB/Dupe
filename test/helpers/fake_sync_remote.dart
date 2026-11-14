import 'package:dupe/core/sync/sync_remote.dart';

/// In-memory server with the rules of the Supabase migration: server
/// timestamp on every write, older writes (`updated_at`) ignored, pull
/// ordered by (`server_updated_at`, `id`).
class FakeSyncRemote implements SyncRemote {
  final tables = <String, Map<String, Map<String, Object?>>>{};
  bool offline = false;

  /// Thrown by every call when set (server refusal…).
  SyncException? failure;
  var _clock = DateTime.utc(2026);
  int upserts = 0;

  /// Time between two server stamps; zero gives ties (same stamp).
  Duration step = const Duration(milliseconds: 1);

  /// Answer of [serverTime] (null: unknown, like a project without
  /// `keep_alive()`).
  DateTime? serverNow;

  @override
  Future<DateTime?> serverTime() async => serverNow;

  /// Stamps the next upsert this much in the past: a transaction that took
  /// its timestamps before committing, after other writes became visible.
  Duration? nextUpsertLag;

  void _check() {
    if (offline) throw const SyncException.network('offline');
    if (failure case final error?) throw error;
  }

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) async {
    _check();
    upserts++;
    final lag = nextUpsertLag;
    nextUpsertLag = null;
    final stored = tables.putIfAbsent(table, () => {});
    for (final row in rows) {
      final id = row['id']! as String;
      final existing = stored[id];
      if (existing != null &&
          DateTime.parse(row['updated_at']! as String)
              .isBefore(DateTime.parse(existing['updated_at']! as String))) {
        continue;
      }
      _clock = _clock.add(step);
      final stamp = lag == null ? _clock : _clock.subtract(lag);
      stored[id] = {...row, 'server_updated_at': stamp.toIso8601String()};
    }
  }

  static int _compare(Map<String, Object?> a, Map<String, Object?> b) {
    final byTime = DateTime.parse(a['server_updated_at']! as String)
        .compareTo(DateTime.parse(b['server_updated_at']! as String));
    return byTime != 0
        ? byTime
        : (a['id']! as String).compareTo(b['id']! as String);
  }

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    SyncCursor? after, {
    required int limit,
  }) async {
    _check();
    bool isAfter(Map<String, Object?> r) {
      if (after == null) return true;
      final at = DateTime.parse(r['server_updated_at']! as String);
      final from = DateTime.parse(after.at);
      return switch (after.id) {
        null => !at.isBefore(from),
        final id =>
          at.isAfter(from) ||
              (at.isAtSameMomentAs(from) &&
                  (r['id']! as String).compareTo(id) > 0),
      };
    }

    final rows =
        (tables[table]?.values ?? const <Map<String, Object?>>[])
            .where(isAfter)
            .toList()
          ..sort(_compare);
    return rows.take(limit).toList();
  }
}
