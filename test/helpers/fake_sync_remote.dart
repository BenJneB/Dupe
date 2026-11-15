import 'package:dupe/core/sync/sync_remote.dart';

/// In-memory server with the rules of the Supabase migration: server
/// timestamp on every write, older writes (`updated_at`) ignored.
class FakeSyncRemote implements SyncRemote {
  final tables = <String, Map<String, Map<String, Object?>>>{};
  bool offline = false;
  var _clock = DateTime.utc(2026);
  int upserts = 0;

  void _check() {
    if (offline) throw const SyncException('offline', offline: true);
  }

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) async {
    _check();
    upserts++;
    final stored = tables.putIfAbsent(table, () => {});
    for (final row in rows) {
      final id = row['id']! as String;
      final existing = stored[id];
      if (existing != null &&
          DateTime.parse(row['updated_at']! as String)
              .isBefore(DateTime.parse(existing['updated_at']! as String))) {
        continue;
      }
      _clock = _clock.add(const Duration(milliseconds: 1));
      stored[id] = {...row, 'server_updated_at': _clock.toIso8601String()};
    }
  }

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    String? cursor, {
    required int limit,
  }) async {
    _check();
    final after = cursor == null ? null : DateTime.parse(cursor);
    final rows =
        (tables[table]?.values ?? const <Map<String, Object?>>[])
            .where(
              (r) =>
                  after == null ||
                  DateTime.parse(r['server_updated_at']! as String)
                      .isAfter(after),
            )
            .toList()
          ..sort(
            (a, b) => (a['server_updated_at']! as String).compareTo(
              b['server_updated_at']! as String,
            ),
          );
    return rows.take(limit).toList();
  }
}
