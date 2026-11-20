// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Statistics, recomputed on every change of the collection.

@ProviderFor(collectionStats)
final collectionStatsProvider = CollectionStatsProvider._();

/// Statistics, recomputed on every change of the collection.

final class CollectionStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<CollectionStats>,
          CollectionStats,
          FutureOr<CollectionStats>
        >
    with $FutureModifier<CollectionStats>, $FutureProvider<CollectionStats> {
  /// Statistics, recomputed on every change of the collection.
  CollectionStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionStatsHash();

  @$internal
  @override
  $FutureProviderElement<CollectionStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CollectionStats> create(Ref ref) {
    return collectionStats(ref);
  }
}

String _$collectionStatsHash() => r'afa6af2f7e3eddd6a586fad35127eb697deb6afa';

/// Reading statistics, recomputed on every change of the collection.

@ProviderFor(readingStats)
final readingStatsProvider = ReadingStatsProvider._();

/// Reading statistics, recomputed on every change of the collection.

final class ReadingStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReadingStats>,
          ReadingStats,
          FutureOr<ReadingStats>
        >
    with $FutureModifier<ReadingStats>, $FutureProvider<ReadingStats> {
  /// Reading statistics, recomputed on every change of the collection.
  ReadingStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingStatsHash();

  @$internal
  @override
  $FutureProviderElement<ReadingStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReadingStats> create(Ref ref) {
    return readingStats(ref);
  }
}

String _$readingStatsHash() => r'770e050bc8fc423acb069903dff3b9ffca025eea';
