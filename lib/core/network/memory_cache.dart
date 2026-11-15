/// Small in-memory cache with expiry and a size bound (oldest evicted).
class MemoryCache<V> {
  new({
    this.ttl = const Duration(hours: 12),
    this.maxEntries = 200,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final Duration ttl;
  final int maxEntries;
  final DateTime Function() _now;
  final _entries = <String, ({DateTime expires, V value})>{};

  /// Returns the cached value for [key], or computes, stores and returns it.
  /// Failures are not cached.
  Future<V> getOrCompute(String key, Future<V> Function() compute) async {
    final entry = _entries[key];
    if (entry != null && entry.expires.isAfter(_now())) return entry.value;
    final value = await compute();
    _entries.remove(key);
    if (_entries.length >= maxEntries) _entries.remove(_entries.keys.first);
    _entries[key] = (expires: _now().add(ttl), value: value);
    return value;
  }
}
