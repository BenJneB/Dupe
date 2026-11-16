// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_count_scan.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Checks, one by one (sources are rate limited), every series whose total
/// is unknown and that has a series source; nothing is saved before the
/// user confirms ([apply]).

@ProviderFor(VolumeCountScan)
final volumeCountScanProvider = VolumeCountScanProvider._();

/// Checks, one by one (sources are rate limited), every series whose total
/// is unknown and that has a series source; nothing is saved before the
/// user confirms ([apply]).
final class VolumeCountScanProvider
    extends $NotifierProvider<VolumeCountScan, VolumeCountScanState> {
  /// Checks, one by one (sources are rate limited), every series whose total
  /// is unknown and that has a series source; nothing is saved before the
  /// user confirms ([apply]).
  VolumeCountScanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'volumeCountScanProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$volumeCountScanHash();

  @$internal
  @override
  VolumeCountScan create() => VolumeCountScan();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VolumeCountScanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VolumeCountScanState>(value),
    );
  }
}

String _$volumeCountScanHash() => r'8254f98949f9185a87e8727dbb705337e31b8a43';

/// Checks, one by one (sources are rate limited), every series whose total
/// is unknown and that has a series source; nothing is saved before the
/// user confirms ([apply]).

abstract class _$VolumeCountScan extends $Notifier<VolumeCountScanState> {
  VolumeCountScanState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VolumeCountScanState, VolumeCountScanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VolumeCountScanState, VolumeCountScanState>,
              VolumeCountScanState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
