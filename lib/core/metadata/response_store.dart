typedef StoredResponse = ({String payload, DateTime fetchedAt});

/// Persistent cache of source answers (see `DriftResponseStore`).
abstract interface class ResponseStore {
  Future<StoredResponse?> read(String key);
  Future<void> write(String key, String payload);
}

/// How long cached answers are trusted before asking the source again.
/// Stale answers are still used when the source fails (offline).
class CachePolicy {
  const new({
    this.found = const Duration(days: 60),
    this.notFound = const Duration(days: 3),
    this.text = const Duration(days: 3),
  });

  /// ISBN known by the source: editions rarely change.
  final Duration found;

  /// ISBN unknown: the catalogue may add it soon.
  final Duration notFound;

  /// Text search results.
  final Duration text;
}
