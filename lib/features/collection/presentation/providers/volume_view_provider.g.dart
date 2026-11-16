// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_view_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Series screen: volumes as a list (cover, title, status) instead of the
/// grid of pastilles. Remembered on this device.

@ProviderFor(VolumesAsList)
final volumesAsListProvider = VolumesAsListProvider._();

/// Series screen: volumes as a list (cover, title, status) instead of the
/// grid of pastilles. Remembered on this device.
final class VolumesAsListProvider
    extends $AsyncNotifierProvider<VolumesAsList, bool> {
  /// Series screen: volumes as a list (cover, title, status) instead of the
  /// grid of pastilles. Remembered on this device.
  VolumesAsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'volumesAsListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$volumesAsListHash();

  @$internal
  @override
  VolumesAsList create() => VolumesAsList();
}

String _$volumesAsListHash() => r'5b0bf38969177da28a7b69ddde1a953f6594033d';

/// Series screen: volumes as a list (cover, title, status) instead of the
/// grid of pastilles. Remembered on this device.

abstract class _$VolumesAsList extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
