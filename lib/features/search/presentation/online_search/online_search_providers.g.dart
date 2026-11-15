// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isbnLookup)
final isbnLookupProvider = IsbnLookupFamily._();

final class IsbnLookupProvider
    extends
        $FunctionalProvider<
          AsyncValue<IsbnLookup>,
          IsbnLookup,
          FutureOr<IsbnLookup>
        >
    with $FutureModifier<IsbnLookup>, $FutureProvider<IsbnLookup> {
  IsbnLookupProvider._({
    required IsbnLookupFamily super.from,
    required (String, CollectionType) super.argument,
  }) : super(
         retry: null,
         name: r'isbnLookupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isbnLookupHash();

  @override
  String toString() {
    return r'isbnLookupProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<IsbnLookup> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<IsbnLookup> create(Ref ref) {
    final argument = this.argument as (String, CollectionType);
    return isbnLookup(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is IsbnLookupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isbnLookupHash() => r'c5b8bd8ad5735110e4a81c27d161dbce8b4e9ee3';

final class IsbnLookupFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<IsbnLookup>,
          (String, CollectionType)
        > {
  IsbnLookupFamily._()
    : super(
        retry: null,
        name: r'isbnLookupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsbnLookupProvider call(String isbn13, CollectionType type) =>
      IsbnLookupProvider._(argument: (isbn13, type), from: this);

  @override
  String toString() => r'isbnLookupProvider';
}

@ProviderFor(onlineTextSearch)
final onlineTextSearchProvider = OnlineTextSearchFamily._();

final class OnlineTextSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<TextSearch>,
          TextSearch,
          FutureOr<TextSearch>
        >
    with $FutureModifier<TextSearch>, $FutureProvider<TextSearch> {
  OnlineTextSearchProvider._({
    required OnlineTextSearchFamily super.from,
    required (String, CollectionType) super.argument,
  }) : super(
         retry: null,
         name: r'onlineTextSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$onlineTextSearchHash();

  @override
  String toString() {
    return r'onlineTextSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<TextSearch> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TextSearch> create(Ref ref) {
    final argument = this.argument as (String, CollectionType);
    return onlineTextSearch(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is OnlineTextSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$onlineTextSearchHash() => r'48ad34217cb6baa9c9657c1d8ee5c524a03e0199';

final class OnlineTextSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<TextSearch>,
          (String, CollectionType)
        > {
  OnlineTextSearchFamily._()
    : super(
        retry: null,
        name: r'onlineTextSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OnlineTextSearchProvider call(String query, CollectionType type) =>
      OnlineTextSearchProvider._(argument: (query, type), from: this);

  @override
  String toString() => r'onlineTextSearchProvider';
}

/// Local copy of a scanned ISBN, if any (100 % offline check).

@ProviderFor(localItemByIsbn)
final localItemByIsbnProvider = LocalItemByIsbnFamily._();

/// Local copy of a scanned ISBN, if any (100 % offline check).

final class LocalItemByIsbnProvider
    extends $FunctionalProvider<AsyncValue<Item?>, Item?, FutureOr<Item?>>
    with $FutureModifier<Item?>, $FutureProvider<Item?> {
  /// Local copy of a scanned ISBN, if any (100 % offline check).
  LocalItemByIsbnProvider._({
    required LocalItemByIsbnFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'localItemByIsbnProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$localItemByIsbnHash();

  @override
  String toString() {
    return r'localItemByIsbnProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Item?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Item?> create(Ref ref) {
    final argument = this.argument as String;
    return localItemByIsbn(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalItemByIsbnProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$localItemByIsbnHash() => r'24c9743c9206979a12461c2dad164dc1aed79ffc';

/// Local copy of a scanned ISBN, if any (100 % offline check).

final class LocalItemByIsbnFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Item?>, String> {
  LocalItemByIsbnFamily._()
    : super(
        retry: null,
        name: r'localItemByIsbnProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Local copy of a scanned ISBN, if any (100 % offline check).

  LocalItemByIsbnProvider call(String isbn13) =>
      LocalItemByIsbnProvider._(argument: isbn13, from: this);

  @override
  String toString() => r'localItemByIsbnProvider';
}
