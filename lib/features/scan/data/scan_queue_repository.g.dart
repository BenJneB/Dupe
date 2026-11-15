// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_queue_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scanQueueRepository)
final scanQueueRepositoryProvider = ScanQueueRepositoryProvider._();

final class ScanQueueRepositoryProvider
    extends
        $FunctionalProvider<
          ScanQueueRepository,
          ScanQueueRepository,
          ScanQueueRepository
        >
    with $Provider<ScanQueueRepository> {
  ScanQueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanQueueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanQueueRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScanQueueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanQueueRepository create(Ref ref) {
    return scanQueueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanQueueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanQueueRepository>(value),
    );
  }
}

String _$scanQueueRepositoryHash() =>
    r'd8629514c3e04a4a4e35f263a843c4ebf06be40c';

@ProviderFor(scanQueue)
final scanQueueProvider = ScanQueueProvider._();

final class ScanQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ScanQueueEntry>>,
          List<ScanQueueEntry>,
          Stream<List<ScanQueueEntry>>
        >
    with
        $FutureModifier<List<ScanQueueEntry>>,
        $StreamProvider<List<ScanQueueEntry>> {
  ScanQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanQueueHash();

  @$internal
  @override
  $StreamProviderElement<List<ScanQueueEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ScanQueueEntry>> create(Ref ref) {
    return scanQueue(ref);
  }
}

String _$scanQueueHash() => r'9825f33fb10b1bd2f7fd9dd5137852da7fa5dc6f';
