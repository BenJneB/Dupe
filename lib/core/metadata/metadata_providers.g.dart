// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$httpClientHash() => r'4e10180a0be3b42289df3288b73be60ec95dc7c5';

/// Enabled metadata sources, with the on-disk response cache.

@ProviderFor(metadataAggregator)
final metadataAggregatorProvider = MetadataAggregatorProvider._();

/// Enabled metadata sources, with the on-disk response cache.

final class MetadataAggregatorProvider
    extends
        $FunctionalProvider<
          MetadataAggregator,
          MetadataAggregator,
          MetadataAggregator
        >
    with $Provider<MetadataAggregator> {
  /// Enabled metadata sources, with the on-disk response cache.
  MetadataAggregatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metadataAggregatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metadataAggregatorHash();

  @$internal
  @override
  $ProviderElement<MetadataAggregator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MetadataAggregator create(Ref ref) {
    return metadataAggregator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MetadataAggregator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MetadataAggregator>(value),
    );
  }
}

String _$metadataAggregatorHash() =>
    r'ad1762f2aba03336ffaf74e3e578d0b1ef134cc7';

/// The one Comic Vine client, shared by the volume lookups and the series
/// lookups: its rate limiter (1 request/s, or Comic Vine blocks the key)
/// then covers both. Null when the source is off or has no key.

@ProviderFor(comicVineSource)
final comicVineSourceProvider = ComicVineSourceProvider._();

/// The one Comic Vine client, shared by the volume lookups and the series
/// lookups: its rate limiter (1 request/s, or Comic Vine blocks the key)
/// then covers both. Null when the source is off or has no key.

final class ComicVineSourceProvider
    extends
        $FunctionalProvider<
          ComicVineProvider?,
          ComicVineProvider?,
          ComicVineProvider?
        >
    with $Provider<ComicVineProvider?> {
  /// The one Comic Vine client, shared by the volume lookups and the series
  /// lookups: its rate limiter (1 request/s, or Comic Vine blocks the key)
  /// then covers both. Null when the source is off or has no key.
  ComicVineSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'comicVineSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$comicVineSourceHash();

  @$internal
  @override
  $ProviderElement<ComicVineProvider?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ComicVineProvider? create(Ref ref) {
    return comicVineSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComicVineProvider? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComicVineProvider?>(value),
    );
  }
}

String _$comicVineSourceHash() => r'c2803cd94b433f1f401ae97ded654510b7f7ce89';

/// Enabled series-level sources (AniList, Comic Vine).

@ProviderFor(seriesLookup)
final seriesLookupProvider = SeriesLookupProvider._();

/// Enabled series-level sources (AniList, Comic Vine).

final class SeriesLookupProvider
    extends $FunctionalProvider<SeriesLookup, SeriesLookup, SeriesLookup>
    with $Provider<SeriesLookup> {
  /// Enabled series-level sources (AniList, Comic Vine).
  SeriesLookupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seriesLookupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seriesLookupHash();

  @$internal
  @override
  $ProviderElement<SeriesLookup> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SeriesLookup create(Ref ref) {
    return seriesLookup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeriesLookup value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeriesLookup>(value),
    );
  }
}

String _$seriesLookupHash() => r'886c7bc5159ffe6b15b1248e5c4f6739e0ffac02';
