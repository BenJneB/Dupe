import 'package:dupe/core/network/memory_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('caches until expiry, never caches failures, bounds size', () async {
    var now = DateTime.utc(2026);
    var calls = 0;
    final cache = MemoryCache<int>(
      ttl: const Duration(minutes: 1),
      maxEntries: 2,
      now: () => now,
    );
    Future<int> compute() async => ++calls;

    expect(await cache.getOrCompute('a', compute), 1);
    expect(await cache.getOrCompute('a', compute), 1);
    now = now.add(const Duration(minutes: 2));
    expect(await cache.getOrCompute('a', compute), 2);

    await expectLater(
      cache.getOrCompute('b', () => Future.error(Exception())),
      throwsException,
    );
    expect(await cache.getOrCompute('b', compute), 3);

    await cache.getOrCompute('c', compute); // evicts 'a'
    expect(await cache.getOrCompute('a', compute), 5);
  });
}
