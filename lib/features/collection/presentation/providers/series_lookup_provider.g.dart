// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(seriesLookupResults)
final seriesLookupResultsProvider = SeriesLookupResultsFamily._();

final class SeriesLookupResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SeriesMetadata>>,
          List<SeriesMetadata>,
          FutureOr<List<SeriesMetadata>>
        >
    with
        $FutureModifier<List<SeriesMetadata>>,
        $FutureProvider<List<SeriesMetadata>> {
  SeriesLookupResultsProvider._({
    required SeriesLookupResultsFamily super.from,
    required (String, CollectionType) super.argument,
  }) : super(
         retry: null,
         name: r'seriesLookupResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesLookupResultsHash();

  @override
  String toString() {
    return r'seriesLookupResultsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SeriesMetadata>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SeriesMetadata>> create(Ref ref) {
    final argument = this.argument as (String, CollectionType);
    return seriesLookupResults(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesLookupResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesLookupResultsHash() =>
    r'946c78cc433b6d56490fb3343abc00c9077b0121';

final class SeriesLookupResultsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SeriesMetadata>>,
          (String, CollectionType)
        > {
  SeriesLookupResultsFamily._()
    : super(
        retry: null,
        name: r'seriesLookupResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeriesLookupResultsProvider call(String query, CollectionType type) =>
      SeriesLookupResultsProvider._(argument: (query, type), from: this);

  @override
  String toString() => r'seriesLookupResultsProvider';
}
