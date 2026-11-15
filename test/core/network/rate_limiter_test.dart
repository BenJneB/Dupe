import 'package:dupe/core/network/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('spaces out consecutive calls by the minimum interval', () async {
    var now = DateTime.utc(2026);
    final waits = <Duration>[];
    final limiter = RateLimiter(
      const Duration(seconds: 1),
      now: () => now,
      wait: (d) async => waits.add(d),
    );

    await Future.wait([
      limiter.run(() async => 1),
      limiter.run(() async => 2),
      limiter.run(() async => 3),
    ]);
    expect(waits, [const Duration(seconds: 1), const Duration(seconds: 2)]);

    now = now.add(const Duration(seconds: 10));
    waits.clear();
    await limiter.run(() async => 4);
    expect(waits, isEmpty);
  });
}
