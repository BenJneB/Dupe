// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_completion_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(seriesCatalogSource)
final seriesCatalogSourceProvider = SeriesCatalogSourceProvider._();

final class SeriesCatalogSourceProvider
    extends
        $FunctionalProvider<
          SeriesCatalogSource,
          SeriesCatalogSource,
          SeriesCatalogSource
        >
    with $Provider<SeriesCatalogSource> {
  SeriesCatalogSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seriesCatalogSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seriesCatalogSourceHash();

  @$internal
  @override
  $ProviderElement<SeriesCatalogSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SeriesCatalogSource create(Ref ref) {
    return seriesCatalogSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeriesCatalogSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeriesCatalogSource>(value),
    );
  }
}

String _$seriesCatalogSourceHash() =>
    r'b3f4c4e54e19256d14477575ae87b515f10b6a87';
