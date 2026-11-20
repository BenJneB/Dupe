import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/data/live_collection.dart';
import 'package:dupe/features/stats/domain/collection_stats.dart';
import 'package:dupe/features/stats/domain/reading_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_providers.g.dart';

/// Statistics, recomputed on every change of the collection.
@riverpod
Future<CollectionStats> collectionStats(Ref ref) async {
  final c = await ref.watch(liveCollectionProvider.future);
  return computeCollectionStats(
    c.items,
    c.series,
    now: ref.read(clockProvider)(),
  );
}

/// Reading statistics, recomputed on every change of the collection.
@riverpod
Future<ReadingStats> readingStats(Ref ref) async {
  final c = await ref.watch(liveCollectionProvider.future);
  return computeReadingStats(c.items, c.series, now: ref.read(clockProvider)());
}
