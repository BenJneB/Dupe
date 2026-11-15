// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(seriesById)
final seriesByIdProvider = SeriesByIdFamily._();

final class SeriesByIdProvider
    extends $FunctionalProvider<AsyncValue<Series?>, Series?, Stream<Series?>>
    with $FutureModifier<Series?>, $StreamProvider<Series?> {
  SeriesByIdProvider._({
    required SeriesByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seriesByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesByIdHash();

  @override
  String toString() {
    return r'seriesByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Series?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Series?> create(Ref ref) {
    final argument = this.argument as String;
    return seriesById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesByIdHash() => r'52a6ce915782147a4a2171c8b893d9a731fd1448';

final class SeriesByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Series?>, String> {
  SeriesByIdFamily._()
    : super(
        retry: null,
        name: r'seriesByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeriesByIdProvider call(String id) =>
      SeriesByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'seriesByIdProvider';
}

@ProviderFor(itemById)
final itemByIdProvider = ItemByIdFamily._();

final class ItemByIdProvider
    extends $FunctionalProvider<AsyncValue<Item?>, Item?, Stream<Item?>>
    with $FutureModifier<Item?>, $StreamProvider<Item?> {
  ItemByIdProvider._({
    required ItemByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'itemByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemByIdHash();

  @override
  String toString() {
    return r'itemByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Item?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Item?> create(Ref ref) {
    final argument = this.argument as String;
    return itemById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemByIdHash() => r'10337f6f37cd99b1467f8167ccdf822d214da78b';

final class ItemByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Item?>, String> {
  ItemByIdFamily._()
    : super(
        retry: null,
        name: r'itemByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ItemByIdProvider call(String id) =>
      ItemByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'itemByIdProvider';
}

@ProviderFor(seriesItems)
final seriesItemsProvider = SeriesItemsFamily._();

final class SeriesItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Item>>,
          List<Item>,
          Stream<List<Item>>
        >
    with $FutureModifier<List<Item>>, $StreamProvider<List<Item>> {
  SeriesItemsProvider._({
    required SeriesItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seriesItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesItemsHash();

  @override
  String toString() {
    return r'seriesItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Item>> create(Ref ref) {
    final argument = this.argument as String;
    return seriesItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesItemsHash() => r'7785d0c7f0dd410ba8717ceaef42ff4c813b5bea';

final class SeriesItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Item>>, String> {
  SeriesItemsFamily._()
    : super(
        retry: null,
        name: r'seriesItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeriesItemsProvider call(String seriesId) =>
      SeriesItemsProvider._(argument: seriesId, from: this);

  @override
  String toString() => r'seriesItemsProvider';
}

@ProviderFor(loanedItemIds)
final loanedItemIdsProvider = LoanedItemIdsProvider._();

final class LoanedItemIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  LoanedItemIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanedItemIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanedItemIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    return loanedItemIds(ref);
  }
}

String _$loanedItemIdsHash() => r'66e7e1540fcc662ef928e3d2832ede5c088fc4a3';

/// A series with its items and computed volume grid; data is null when the
/// series does not exist (or was deleted).

@ProviderFor(seriesDetail)
final seriesDetailProvider = SeriesDetailFamily._();

/// A series with its items and computed volume grid; data is null when the
/// series does not exist (or was deleted).

final class SeriesDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeriesDetail?>,
          AsyncValue<SeriesDetail?>,
          AsyncValue<SeriesDetail?>
        >
    with $Provider<AsyncValue<SeriesDetail?>> {
  /// A series with its items and computed volume grid; data is null when the
  /// series does not exist (or was deleted).
  SeriesDetailProvider._({
    required SeriesDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seriesDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesDetailHash();

  @override
  String toString() {
    return r'seriesDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<SeriesDetail?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<SeriesDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return seriesDetail(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SeriesDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SeriesDetail?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesDetailHash() => r'3652160e787d58bf0a8a7e69cd6284bf188d89c2';

/// A series with its items and computed volume grid; data is null when the
/// series does not exist (or was deleted).

final class SeriesDetailFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<SeriesDetail?>, String> {
  SeriesDetailFamily._()
    : super(
        retry: null,
        name: r'seriesDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A series with its items and computed volume grid; data is null when the
  /// series does not exist (or was deleted).

  SeriesDetailProvider call(String id) =>
      SeriesDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'seriesDetailProvider';
}
