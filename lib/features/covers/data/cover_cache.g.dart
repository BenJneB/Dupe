// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_cache.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coverCache)
final coverCacheProvider = CoverCacheProvider._();

final class CoverCacheProvider
    extends $FunctionalProvider<CoverCache, CoverCache, CoverCache>
    with $Provider<CoverCache> {
  CoverCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverCacheHash();

  @$internal
  @override
  $ProviderElement<CoverCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CoverCache create(Ref ref) {
    return coverCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoverCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoverCache>(value),
    );
  }
}

String _$coverCacheHash() => r'ad8c1253c8808a4e4593f8428882fe42ac41304c';
