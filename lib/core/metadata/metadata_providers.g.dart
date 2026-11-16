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
    r'0b3237d06c24241e8a14a2e70f4744fab1273119';

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

/// The one BnF client (lookups and suggestions share its rate limiter);
/// null when the source is off.

@ProviderFor(bnfSource)
final bnfSourceProvider = BnfSourceProvider._();

/// The one BnF client (lookups and suggestions share its rate limiter);
/// null when the source is off.

final class BnfSourceProvider
    extends $FunctionalProvider<BnfProvider?, BnfProvider?, BnfProvider?>
    with $Provider<BnfProvider?> {
  /// The one BnF client (lookups and suggestions share its rate limiter);
  /// null when the source is off.
  BnfSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bnfSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bnfSourceHash();

  @$internal
  @override
  $ProviderElement<BnfProvider?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BnfProvider? create(Ref ref) {
    return bnfSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BnfProvider? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BnfProvider?>(value),
    );
  }
}

String _$bnfSourceHash() => r'750cf7ced2f43e1d029607237b268e48ca328db7';

/// The one AniList client (series lookups and suggestions); null when off.

@ProviderFor(anilistSource)
final anilistSourceProvider = AnilistSourceProvider._();

/// The one AniList client (series lookups and suggestions); null when off.

final class AnilistSourceProvider
    extends
        $FunctionalProvider<
          AniListProvider?,
          AniListProvider?,
          AniListProvider?
        >
    with $Provider<AniListProvider?> {
  /// The one AniList client (series lookups and suggestions); null when off.
  AnilistSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'anilistSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$anilistSourceHash();

  @$internal
  @override
  $ProviderElement<AniListProvider?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AniListProvider? create(Ref ref) {
    return anilistSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AniListProvider? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AniListProvider?>(value),
    );
  }
}

String _$anilistSourceHash() => r'930b1af7a053f1cdfad192bfb95f806bed6fb667';

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

String _$seriesLookupHash() => r'5b7a0df9ec9ea1b66dc7be4c86347b2355ed35cf';
