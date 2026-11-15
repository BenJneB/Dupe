// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entries_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collectionEntries)
final collectionEntriesProvider = CollectionEntriesFamily._();

final class CollectionEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CollectionEntry>>,
          List<CollectionEntry>,
          Stream<List<CollectionEntry>>
        >
    with
        $FutureModifier<List<CollectionEntry>>,
        $StreamProvider<List<CollectionEntry>> {
  CollectionEntriesProvider._({
    required CollectionEntriesFamily super.from,
    required CollectionType super.argument,
  }) : super(
         retry: null,
         name: r'collectionEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$collectionEntriesHash();

  @override
  String toString() {
    return r'collectionEntriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CollectionEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CollectionEntry>> create(Ref ref) {
    final argument = this.argument as CollectionType;
    return collectionEntries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionEntriesHash() => r'95829d8c72adfcf8851227f47e6bd3dd2cebcb02';

final class CollectionEntriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<CollectionEntry>>,
          CollectionType
        > {
  CollectionEntriesFamily._()
    : super(
        retry: null,
        name: r'collectionEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CollectionEntriesProvider call(CollectionType type) =>
      CollectionEntriesProvider._(argument: type, from: this);

  @override
  String toString() => r'collectionEntriesProvider';
}

/// Entries of a tab after filtering and sorting.

@ProviderFor(visibleEntries)
final visibleEntriesProvider = VisibleEntriesFamily._();

/// Entries of a tab after filtering and sorting.

final class VisibleEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CollectionEntry>>,
          AsyncValue<List<CollectionEntry>>,
          AsyncValue<List<CollectionEntry>>
        >
    with $Provider<AsyncValue<List<CollectionEntry>>> {
  /// Entries of a tab after filtering and sorting.
  VisibleEntriesProvider._({
    required VisibleEntriesFamily super.from,
    required CollectionType super.argument,
  }) : super(
         retry: null,
         name: r'visibleEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$visibleEntriesHash();

  @override
  String toString() {
    return r'visibleEntriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<CollectionEntry>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<CollectionEntry>> create(Ref ref) {
    final argument = this.argument as CollectionType;
    return visibleEntries(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<CollectionEntry>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<CollectionEntry>>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VisibleEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$visibleEntriesHash() => r'f71ceed8004c394410e6705a7fc97666bd63261f';

/// Entries of a tab after filtering and sorting.

final class VisibleEntriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<List<CollectionEntry>>,
          CollectionType
        > {
  VisibleEntriesFamily._()
    : super(
        retry: null,
        name: r'visibleEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Entries of a tab after filtering and sorting.

  VisibleEntriesProvider call(CollectionType type) =>
      VisibleEntriesProvider._(argument: type, from: this);

  @override
  String toString() => r'visibleEntriesProvider';
}
