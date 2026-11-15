// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_settings_section.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storeHapticsEnabled)
final storeHapticsEnabledProvider = StoreHapticsEnabledProvider._();

final class StoreHapticsEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  StoreHapticsEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeHapticsEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeHapticsEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return storeHapticsEnabled(ref);
  }
}

String _$storeHapticsEnabledHash() =>
    r'8af5d044013bbc9458e4c7266a8c79936c186841';
