import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'live_collection.g.dart';

/// Every live (not deleted) item and series.
typedef LiveCollection = ({List<Item> items, List<Series> series});

/// The whole live collection, watched once for the screens that compute
/// over all of it (statistics, quality): one pair of queries per change,
/// not one per screen or section.
@riverpod
Stream<LiveCollection> liveCollection(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return combineLatest(
    (db.select(db.itemsTable)..where((t) => t.deletedAt.isNull())).watch(),
    (db.select(db.seriesTable)..where((t) => t.deletedAt.isNull())).watch(),
    (items, series) => (items: items, series: series),
  );
}
