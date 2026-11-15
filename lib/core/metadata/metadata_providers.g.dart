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

/// All metadata sources. Google Books is only used with an API key
/// (GOOGLE_BOOKS_API_KEY in env.json): without one it answers HTTP 429.

@ProviderFor(metadataAggregator)
final metadataAggregatorProvider = MetadataAggregatorProvider._();

/// All metadata sources. Google Books is only used with an API key
/// (GOOGLE_BOOKS_API_KEY in env.json): without one it answers HTTP 429.

final class MetadataAggregatorProvider
    extends
        $FunctionalProvider<
          MetadataAggregator,
          MetadataAggregator,
          MetadataAggregator
        >
    with $Provider<MetadataAggregator> {
  /// All metadata sources. Google Books is only used with an API key
  /// (GOOGLE_BOOKS_API_KEY in env.json): without one it answers HTTP 429.
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
    r'584248f4914c59d2582c0077afe5d58473741291';

/// Series-level sources (AniList, Comic Vine when a key is set).

@ProviderFor(seriesLookup)
final seriesLookupProvider = SeriesLookupProvider._();

/// Series-level sources (AniList, Comic Vine when a key is set).

final class SeriesLookupProvider
    extends $FunctionalProvider<SeriesLookup, SeriesLookup, SeriesLookup>
    with $Provider<SeriesLookup> {
  /// Series-level sources (AniList, Comic Vine when a key is set).
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

String _$seriesLookupHash() => r'21ccfd1627d6e1f3826f9ae37103586863091672';
