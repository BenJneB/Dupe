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
          FutureOr<CollectionQuality>
        >
    with
        $FutureModifier<CollectionQuality>,
        $FutureProvider<CollectionQuality> {
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
  $FutureProviderElement<CollectionQuality> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CollectionQuality> create(Ref ref) {
    return collectionQuality(ref);
  }
}

String _$collectionQualityHash() => r'5dc66f4a83f0f8febd5909943b4de3ada4373504';

/// Setting: mark the owned volumes without ISBN (dot on the series grid,
/// icon on series, books and authors in the lists). On by default (user's
/// choice, 2026-11-16).

@ProviderFor(MissingIsbnInGrid)
final missingIsbnInGridProvider = MissingIsbnInGridProvider._();

/// Setting: mark the owned volumes without ISBN (dot on the series grid,
/// icon on series, books and authors in the lists). On by default (user's
/// choice, 2026-11-16).
final class MissingIsbnInGridProvider
    extends $AsyncNotifierProvider<MissingIsbnInGrid, bool> {
  /// Setting: mark the owned volumes without ISBN (dot on the series grid,
  /// icon on series, books and authors in the lists). On by default (user's
  /// choice, 2026-11-16).
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

String _$missingIsbnInGridHash() => r'6b8828b26750c3ab3eecb06476275d96ffda0399';

/// Setting: mark the owned volumes without ISBN (dot on the series grid,
/// icon on series, books and authors in the lists). On by default (user's
/// choice, 2026-11-16).

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
