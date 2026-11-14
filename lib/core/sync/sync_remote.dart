/// Remote side of the sync (Supabase in the app, in-memory in tests).
///
/// Rows are JSON maps with the SQL column names (snake_case). The server
/// stamps every write with `server_updated_at`, used as the pull cursor,
/// and ignores writes older (`updated_at`) than the stored row.
abstract interface class SyncRemote {
  /// Inserts or updates [rows] of [table] for the signed-in user.
  Future<void> upsert(String table, List<Map<String, Object?>> rows);

  /// Rows of [table] written after [cursor] (a `server_updated_at` value,
  /// null for everything), oldest first, at most [limit].
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    String? cursor, {
    required int limit,
  });
}

/// The remote could not be reached or refused the request.
class SyncException implements Exception {
  const new(this.message, {this.offline = false});

  final String message;

  /// Network unreachable (retried silently later).
  final bool offline;

  @override
  String toString() => 'SyncException: $message';
}
