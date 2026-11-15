// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_covers_section.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prefetchOptions)
final prefetchOptionsProvider = PrefetchOptionsProvider._();

final class PrefetchOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<({bool enabled, bool wifiOnly})>,
          ({bool enabled, bool wifiOnly}),
          FutureOr<({bool enabled, bool wifiOnly})>
        >
    with
        $FutureModifier<({bool enabled, bool wifiOnly})>,
        $FutureProvider<({bool enabled, bool wifiOnly})> {
  PrefetchOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefetchOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefetchOptionsHash();

  @$internal
  @override
  $FutureProviderElement<({bool enabled, bool wifiOnly})> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({bool enabled, bool wifiOnly})> create(Ref ref) {
    return prefetchOptions(ref);
  }
}

String _$prefetchOptionsHash() => r'94673cc1ed5d3054166e5699299487756cb39865';

/// Disk space of the downloaded covers, measured again after each run.

@ProviderFor(coverCacheSize)
final coverCacheSizeProvider = CoverCacheSizeProvider._();

/// Disk space of the downloaded covers, measured again after each run.

final class CoverCacheSizeProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Disk space of the downloaded covers, measured again after each run.
  CoverCacheSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverCacheSizeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverCacheSizeHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return coverCacheSize(ref);
  }
}

String _$coverCacheSizeHash() => r'9313c5eb64ba3219c617bedb8d30a4f415670576';
