// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_haptics.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storeHaptics)
final storeHapticsProvider = StoreHapticsProvider._();

final class StoreHapticsProvider
    extends $FunctionalProvider<StoreHaptics, StoreHaptics, StoreHaptics>
    with $Provider<StoreHaptics> {
  StoreHapticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeHapticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeHapticsHash();

  @$internal
  @override
  $ProviderElement<StoreHaptics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoreHaptics create(Ref ref) {
    return storeHaptics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoreHaptics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoreHaptics>(value),
    );
  }
}

String _$storeHapticsHash() => r'05d2b7a55a50e567f5d76d61ff7211c260157ecf';
