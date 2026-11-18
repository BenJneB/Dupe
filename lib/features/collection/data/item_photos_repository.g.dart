// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_photos_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(itemPhotosRepository)
final itemPhotosRepositoryProvider = ItemPhotosRepositoryProvider._();

final class ItemPhotosRepositoryProvider
    extends
        $FunctionalProvider<
          ItemPhotosRepository,
          ItemPhotosRepository,
          ItemPhotosRepository
        >
    with $Provider<ItemPhotosRepository> {
  ItemPhotosRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemPhotosRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemPhotosRepositoryHash();

  @$internal
  @override
  $ProviderElement<ItemPhotosRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ItemPhotosRepository create(Ref ref) {
    return itemPhotosRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItemPhotosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItemPhotosRepository>(value),
    );
  }
}

String _$itemPhotosRepositoryHash() =>
    r'93970ce2eb848b13d37ea0c5cde2e505fdcdfea6';

/// Live photos of [itemId], in order.

@ProviderFor(itemPhotos)
final itemPhotosProvider = ItemPhotosFamily._();

/// Live photos of [itemId], in order.

final class ItemPhotosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ItemPhoto>>,
          List<ItemPhoto>,
          Stream<List<ItemPhoto>>
        >
    with $FutureModifier<List<ItemPhoto>>, $StreamProvider<List<ItemPhoto>> {
  /// Live photos of [itemId], in order.
  ItemPhotosProvider._({
    required ItemPhotosFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'itemPhotosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemPhotosHash();

  @override
  String toString() {
    return r'itemPhotosProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ItemPhoto>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ItemPhoto>> create(Ref ref) {
    final argument = this.argument as String;
    return itemPhotos(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemPhotosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemPhotosHash() => r'4bb1da34069f543308dca3123f847e4b449ee06f';

/// Live photos of [itemId], in order.

final class ItemPhotosFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ItemPhoto>>, String> {
  ItemPhotosFamily._()
    : super(
        retry: null,
        name: r'itemPhotosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live photos of [itemId], in order.

  ItemPhotosProvider call(String itemId) =>
      ItemPhotosProvider._(argument: itemId, from: this);

  @override
  String toString() => r'itemPhotosProvider';
}
