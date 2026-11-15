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
    r'19d8967741f5d12e52b9e69ffd65db923b5729a5';

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

String _$seriesLookupHash() => r'df7b1fcd6d3fcfe44d418758b646a42dcd083074';
