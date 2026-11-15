import 'dart:async';

/// Emits [combine] of the latest values once both streams have emitted
/// (minimal combineLatest, avoids depending on rxdart).
Stream<R> combineLatest<A, B, R>(
  Stream<A> a,
  Stream<B> b,
  R Function(A, B) combine,
) async* {
  A? lastA;
  B? lastB;
  var hasA = false;
  var hasB = false;
  final controller = StreamController<R>();
  final subA = a.listen((v) {
    lastA = v;
    hasA = true;
    if (hasB) controller.add(combine(v, lastB as B));
  }, onError: controller.addError);
  final subB = b.listen((v) {
    lastB = v;
    hasB = true;
    if (hasA) controller.add(combine(lastA as A, v));
  }, onError: controller.addError);
  try {
    yield* controller.stream;
  } finally {
    await subA.cancel();
    await subB.cancel();
    await controller.close();
  }
}
