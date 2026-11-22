// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_background.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(releaseBackground)
final releaseBackgroundProvider = ReleaseBackgroundProvider._();

final class ReleaseBackgroundProvider
    extends
        $FunctionalProvider<
          ReleaseBackground,
          ReleaseBackground,
          ReleaseBackground
        >
    with $Provider<ReleaseBackground> {
  ReleaseBackgroundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseBackgroundProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseBackgroundHash();

  @$internal
  @override
  $ProviderElement<ReleaseBackground> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReleaseBackground create(Ref ref) {
    return releaseBackground(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReleaseBackground value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReleaseBackground>(value),
    );
  }
}

String _$releaseBackgroundHash() => r'9a0e2e3920fc325854176f82f2c59d3775cb8ae4';
