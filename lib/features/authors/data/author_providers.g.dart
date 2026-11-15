// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Authors of the volumes of each series of [type] (series created by a
/// scan or an import may list none themselves).

@ProviderFor(seriesItemAuthors)
final seriesItemAuthorsProvider = SeriesItemAuthorsFamily._();

/// Authors of the volumes of each series of [type] (series created by a
/// scan or an import may list none themselves).

final class SeriesItemAuthorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Set<String>>>,
          Map<String, Set<String>>,
          Stream<Map<String, Set<String>>>
        >
    with
        $FutureModifier<Map<String, Set<String>>>,
        $StreamProvider<Map<String, Set<String>>> {
  /// Authors of the volumes of each series of [type] (series created by a
  /// scan or an import may list none themselves).
  SeriesItemAuthorsProvider._({
    required SeriesItemAuthorsFamily super.from,
    required CollectionType super.argument,
  }) : super(
         retry: null,
         name: r'seriesItemAuthorsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesItemAuthorsHash();

  @override
  String toString() {
    return r'seriesItemAuthorsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, Set<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Set<String>>> create(Ref ref) {
    final argument = this.argument as CollectionType;
    return seriesItemAuthors(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesItemAuthorsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesItemAuthorsHash() => r'f89d831b2d6e6cda2d543a8a7ba89ede0ecb0ec1';

/// Authors of the volumes of each series of [type] (series created by a
/// scan or an import may list none themselves).

final class SeriesItemAuthorsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<String, Set<String>>>,
          CollectionType
        > {
  SeriesItemAuthorsFamily._()
    : super(
        retry: null,
        name: r'seriesItemAuthorsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Authors of the volumes of each series of [type] (series created by a
  /// scan or an import may list none themselves).

  SeriesItemAuthorsProvider call(CollectionType type) =>
      SeriesItemAuthorsProvider._(argument: type, from: this);

  @override
  String toString() => r'seriesItemAuthorsProvider';
}

/// "Par auteur" view of a tab: follows its filters ("À lire"…).

@ProviderFor(visibleAuthorGroups)
final visibleAuthorGroupsProvider = VisibleAuthorGroupsFamily._();

/// "Par auteur" view of a tab: follows its filters ("À lire"…).

final class VisibleAuthorGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AuthorGroup>>,
          AsyncValue<List<AuthorGroup>>,
          AsyncValue<List<AuthorGroup>>
        >
    with $Provider<AsyncValue<List<AuthorGroup>>> {
  /// "Par auteur" view of a tab: follows its filters ("À lire"…).
  VisibleAuthorGroupsProvider._({
    required VisibleAuthorGroupsFamily super.from,
    required CollectionType super.argument,
  }) : super(
         retry: null,
         name: r'visibleAuthorGroupsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$visibleAuthorGroupsHash();

  @override
  String toString() {
    return r'visibleAuthorGroupsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<AuthorGroup>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<AuthorGroup>> create(Ref ref) {
    final argument = this.argument as CollectionType;
    return visibleAuthorGroups(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<AuthorGroup>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<AuthorGroup>>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VisibleAuthorGroupsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$visibleAuthorGroupsHash() =>
    r'40e40f9b6f7e8d116bda5fbf5668c82c852dc5e3';

/// "Par auteur" view of a tab: follows its filters ("À lire"…).

final class VisibleAuthorGroupsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<List<AuthorGroup>>,
          CollectionType
        > {
  VisibleAuthorGroupsFamily._()
    : super(
        retry: null,
        name: r'visibleAuthorGroupsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Par auteur" view of a tab: follows its filters ("À lire"…).

  VisibleAuthorGroupsProvider call(CollectionType type) =>
      VisibleAuthorGroupsProvider._(argument: type, from: this);

  @override
  String toString() => r'visibleAuthorGroupsProvider';
}

/// One author's page: everything of the tab, unfiltered.

@ProviderFor(authorGroup)
final authorGroupProvider = AuthorGroupFamily._();

/// One author's page: everything of the tab, unfiltered.

final class AuthorGroupProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthorGroup?>,
          AsyncValue<AuthorGroup?>,
          AsyncValue<AuthorGroup?>
        >
    with $Provider<AsyncValue<AuthorGroup?>> {
  /// One author's page: everything of the tab, unfiltered.
  AuthorGroupProvider._({
    required AuthorGroupFamily super.from,
    required (CollectionType, String) super.argument,
  }) : super(
         retry: null,
         name: r'authorGroupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authorGroupHash();

  @override
  String toString() {
    return r'authorGroupProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<AuthorGroup?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AuthorGroup?> create(Ref ref) {
    final argument = this.argument as (CollectionType, String);
    return authorGroup(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AuthorGroup?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AuthorGroup?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AuthorGroupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authorGroupHash() => r'0327f8652037c622a5179bad93adb3c313cb2b89';

/// One author's page: everything of the tab, unfiltered.

final class AuthorGroupFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<AuthorGroup?>,
          (CollectionType, String)
        > {
  AuthorGroupFamily._()
    : super(
        retry: null,
        name: r'authorGroupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One author's page: everything of the tab, unfiltered.

  AuthorGroupProvider call(CollectionType type, String name) =>
      AuthorGroupProvider._(argument: (type, name), from: this);

  @override
  String toString() => r'authorGroupProvider';
}
