// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wishlistRepository)
final wishlistRepositoryProvider = WishlistRepositoryProvider._();

final class WishlistRepositoryProvider
    extends
        $FunctionalProvider<
          WishlistRepository,
          WishlistRepository,
          WishlistRepository
        >
    with $Provider<WishlistRepository> {
  WishlistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistRepositoryHash();

  @$internal
  @override
  $ProviderElement<WishlistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WishlistRepository create(Ref ref) {
    return wishlistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WishlistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WishlistRepository>(value),
    );
  }
}

String _$wishlistRepositoryHash() =>
    r'a913b657c2ab55b03e1e8b9de3fc5d20305a9ccc';

@ProviderFor(wishes)
final wishesProvider = WishesProvider._();

final class WishesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Item>>,
          List<Item>,
          Stream<List<Item>>
        >
    with $FutureModifier<List<Item>>, $StreamProvider<List<Item>> {
  WishesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishesHash();

  @$internal
  @override
  $StreamProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Item>> create(Ref ref) {
    return wishes(ref);
  }
}

String _$wishesHash() => r'ff574ff04aecac62c57f9ca70e74f2dad78a8690';

@ProviderFor(nextVolumes)
final nextVolumesProvider = NextVolumesProvider._();

final class NextVolumesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NextVolumes>>,
          List<NextVolumes>,
          Stream<List<NextVolumes>>
        >
    with
        $FutureModifier<List<NextVolumes>>,
        $StreamProvider<List<NextVolumes>> {
  NextVolumesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextVolumesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextVolumesHash();

  @$internal
  @override
  $StreamProviderElement<List<NextVolumes>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NextVolumes>> create(Ref ref) {
    return nextVolumes(ref);
  }
}

String _$nextVolumesHash() => r'3f9eac01b6ed1abab152a2582a05682a8e7a346e';
