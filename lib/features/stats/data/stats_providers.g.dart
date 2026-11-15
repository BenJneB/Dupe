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
          Stream<CollectionStats>
        >
    with $FutureModifier<CollectionStats>, $StreamProvider<CollectionStats> {
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
  $StreamProviderElement<CollectionStats> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CollectionStats> create(Ref ref) {
    return collectionStats(ref);
  }
}

String _$collectionStatsHash() => r'76c3a020ed48ece31b62fbd0b92ea910820a0c76';
