// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gaps of the live collection, updated as it changes.

@ProviderFor(collectionQuality)
final collectionQualityProvider = CollectionQualityProvider._();

/// Gaps of the live collection, updated as it changes.

final class CollectionQualityProvider
    extends
        $FunctionalProvider<
          AsyncValue<CollectionQuality>,
          CollectionQuality,
          Stream<CollectionQuality>
        >
    with
        $FutureModifier<CollectionQuality>,
        $StreamProvider<CollectionQuality> {
  /// Gaps of the live collection, updated as it changes.
  CollectionQualityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionQualityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionQualityHash();

  @$internal
  @override
  $StreamProviderElement<CollectionQuality> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CollectionQuality> create(Ref ref) {
    return collectionQuality(ref);
  }
}

String _$collectionQualityHash() => r'c9f4153ba47b8d595f6b1078c4a70327b5d98dc0';

/// Setting: mark the owned volumes without ISBN on the series grid (off by
/// default, not to overload it).

@ProviderFor(MissingIsbnInGrid)
final missingIsbnInGridProvider = MissingIsbnInGridProvider._();

/// Setting: mark the owned volumes without ISBN on the series grid (off by
/// default, not to overload it).
final class MissingIsbnInGridProvider
    extends $AsyncNotifierProvider<MissingIsbnInGrid, bool> {
  /// Setting: mark the owned volumes without ISBN on the series grid (off by
  /// default, not to overload it).
  MissingIsbnInGridProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'missingIsbnInGridProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missingIsbnInGridHash();

  @$internal
  @override
  MissingIsbnInGrid create() => MissingIsbnInGrid();
}

String _$missingIsbnInGridHash() => r'155cd4c86806e6f7a57b43dbe3891c99dbcd69bf';

/// Setting: mark the owned volumes without ISBN on the series grid (off by
/// default, not to overload it).

abstract class _$MissingIsbnInGrid extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(isbnAssignment)
final isbnAssignmentProvider = IsbnAssignmentProvider._();

final class IsbnAssignmentProvider
    extends $FunctionalProvider<IsbnAssignment, IsbnAssignment, IsbnAssignment>
    with $Provider<IsbnAssignment> {
  IsbnAssignmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isbnAssignmentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isbnAssignmentHash();

  @$internal
  @override
  $ProviderElement<IsbnAssignment> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IsbnAssignment create(Ref ref) {
    return isbnAssignment(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IsbnAssignment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IsbnAssignment>(value),
    );
  }
}

String _$isbnAssignmentHash() => r'6e7e1a8761e2a0540e7348616bebb077ab86c1a0';
