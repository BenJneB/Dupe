// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'releases_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(releasesRepository)
final releasesRepositoryProvider = ReleasesRepositoryProvider._();

final class ReleasesRepositoryProvider
    extends
        $FunctionalProvider<
          ReleasesRepository,
          ReleasesRepository,
          ReleasesRepository
        >
    with $Provider<ReleasesRepository> {
  ReleasesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releasesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releasesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReleasesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReleasesRepository create(Ref ref) {
    return releasesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReleasesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReleasesRepository>(value),
    );
  }
}

String _$releasesRepositoryHash() =>
    r'77fae8e6f23959bd688b09b296a7099baa91c593';

/// Alerts still to look at (new and seen), newest first.

@ProviderFor(releaseAlerts)
final releaseAlertsProvider = ReleaseAlertsProvider._();

/// Alerts still to look at (new and seen), newest first.

final class ReleaseAlertsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReleaseAlert>>,
          List<ReleaseAlert>,
          Stream<List<ReleaseAlert>>
        >
    with
        $FutureModifier<List<ReleaseAlert>>,
        $StreamProvider<List<ReleaseAlert>> {
  /// Alerts still to look at (new and seen), newest first.
  ReleaseAlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseAlertsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseAlertsHash();

  @$internal
  @override
  $StreamProviderElement<List<ReleaseAlert>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ReleaseAlert>> create(Ref ref) {
    return releaseAlerts(ref);
  }
}

String _$releaseAlertsHash() => r'967a82982fc535371918bf1fbe3c632e18b6691c';

@ProviderFor(followedAuthors)
final followedAuthorsProvider = FollowedAuthorsProvider._();

final class FollowedAuthorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FollowedAuthor>>,
          List<FollowedAuthor>,
          Stream<List<FollowedAuthor>>
        >
    with
        $FutureModifier<List<FollowedAuthor>>,
        $StreamProvider<List<FollowedAuthor>> {
  FollowedAuthorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'followedAuthorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$followedAuthorsHash();

  @$internal
  @override
  $StreamProviderElement<List<FollowedAuthor>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FollowedAuthor>> create(Ref ref) {
    return followedAuthors(ref);
  }
}

String _$followedAuthorsHash() => r'016e81b117c7cc4b0adee58c93b6a329786c57d1';
