// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_rows.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Re-runs on queue changes and on any write to the items table.

@ProviderFor(_itemChanges)
final _itemChangesProvider = _ItemChangesProvider._();

/// Re-runs on queue changes and on any write to the items table.

final class _ItemChangesProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
  /// Re-runs on queue changes and on any write to the items table.
  _ItemChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_itemChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_itemChangesHash();

  @$internal
  @override
  $StreamProviderElement<void> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<void> create(Ref ref) {
    return _itemChanges(ref);
  }
}

String _$_itemChangesHash() => r'4febe947a730f23592d20a5965789ffe64305905';

@ProviderFor(reviewRows)
final reviewRowsProvider = ReviewRowsProvider._();

final class ReviewRowsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReviewRow>>,
          List<ReviewRow>,
          FutureOr<List<ReviewRow>>
        >
    with $FutureModifier<List<ReviewRow>>, $FutureProvider<List<ReviewRow>> {
  ReviewRowsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewRowsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewRowsHash();

  @$internal
  @override
  $FutureProviderElement<List<ReviewRow>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReviewRow>> create(Ref ref) {
    return reviewRows(ref);
  }
}

String _$reviewRowsHash() => r'9f8c6b7dee49461f81c9934146d3ca33a45a0cb3';
