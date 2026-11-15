import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/stats/domain/collection_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_providers.g.dart';

/// Statistics, recomputed on every change of the collection.
@riverpod
Stream<CollectionStats> collectionStats(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = ref.watch(clockProvider);
  return combineLatest(
    (db.select(db.itemsTable)..where((t) => t.deletedAt.isNull())).watch(),
    (db.select(db.seriesTable)..where((t) => t.deletedAt.isNull())).watch(),
    (items, series) => computeCollectionStats(items, series, now: now()),
  );
}
