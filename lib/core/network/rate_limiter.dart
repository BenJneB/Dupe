/// Spaces out calls to one remote source: at most one start every
/// [minInterval], in call order.
class RateLimiter {
  new(
    this.minInterval, {
    DateTime Function()? now,
    Future<void> Function(Duration)? wait,
  }) : _now = now ?? DateTime.now,
       _wait = wait ?? Future<void>.delayed;

  final Duration minInterval;
  final DateTime Function() _now;
  final Future<void> Function(Duration) _wait;
  DateTime? _nextSlot;

  Future<T> run<T>(Future<T> Function() task) async {
    final now = _now();
    final slot = _nextSlot == null || _nextSlot!.isBefore(now)
        ? now
        : _nextSlot!;
    _nextSlot = slot.add(minInterval);
    final delay = slot.difference(now);
    if (delay > Duration.zero) await _wait(delay);
    return await task();
  }
}
