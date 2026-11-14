/// Position in the pull order: rows are sorted by `server_updated_at`, then
/// `id` (ties are possible). `at` is an ISO-8601 UTC instant; a null `id`
/// means "from `at` included".
typedef SyncCursor = ({String at, String? id});

/// Remote side of the sync (Supabase in the app, in-memory in tests).
///
/// Rows are JSON maps with the SQL column names (snake_case). The server
/// stamps every write with `server_updated_at`, used as the pull cursor,
/// and ignores writes older (`updated_at`) than the stored row.
abstract interface class SyncRemote {
  /// Inserts or updates [rows] of [table] for the signed-in user.
  Future<void> upsert(String table, List<Map<String, Object?>> rows);

  /// Rows of [table] strictly after [after] in the pull order (everything
  /// when null), at most [limit].
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    SyncCursor? after, {
    required int limit,
  });
}

/// Why a sync request failed.
enum SyncFailure {
  /// Network unreachable (retried silently later).
  offline,

  /// Session expired or revoked: sign in again.
  session,

  /// Server error (5xx): down, or Supabase Free project paused after a week
  /// without activity.
  unavailable,

  /// The server refused the request.
  rejected,
}

/// The remote could not be reached or refused the request.
class SyncException implements Exception {
  const new(this.message, {this.failure = SyncFailure.rejected});

  const new network(this.message) : failure = SyncFailure.offline;

  final String message;
  final SyncFailure failure;

  bool get offline => failure == SyncFailure.offline;

  @override
  String toString() => 'SyncException(${failure.name}): $message';
}
