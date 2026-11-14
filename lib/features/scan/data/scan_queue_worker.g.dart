// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_queue_worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scanQueueWorker)
final scanQueueWorkerProvider = ScanQueueWorkerProvider._();

final class ScanQueueWorkerProvider
    extends
        $FunctionalProvider<ScanQueueWorker, ScanQueueWorker, ScanQueueWorker>
    with $Provider<ScanQueueWorker> {
  ScanQueueWorkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanQueueWorkerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanQueueWorkerHash();

  @$internal
  @override
  $ProviderElement<ScanQueueWorker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScanQueueWorker create(Ref ref) {
    return scanQueueWorker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanQueueWorker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanQueueWorker>(value),
    );
  }
}

String _$scanQueueWorkerHash() => r'd0c5abd6c2b2678ef81660588291d0ba53d941cb';
