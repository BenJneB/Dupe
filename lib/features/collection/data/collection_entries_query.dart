import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Rows of a collection tab: series of [type] with their counts, plus
/// standalone items of [type].
///
/// The counts come from [VolumeGrid], the series grid itself: one rule for
/// "owned", "to read", the cover… (they used to be rewritten in SQL, and
/// drifted apart). A personal collection is a few thousand items: grouping
/// them in Dart costs less than the correlated subqueries did.
Stream<List<CollectionEntry>> watchCollectionEntries(
  AppDatabase db,
  CollectionType type,
) => combineLatest(
  (db.select(
    db.seriesTable,
  )..where((t) => t.type.equalsValue(type) & t.deletedAt.isNull())).watch(),
  (db.select(db.itemsTable)..where((t) => t.deletedAt.isNull())).watch(),
  (series, items) => collectionEntries(series, items, type),
);

/// [series] of [type] with their counts from [items], then the standalone
/// items of [type].
List<CollectionEntry> collectionEntries(
  List<Series> series,
  List<Item> items,
  CollectionType type,
) {
  final bySeries = <String, List<Item>>{};
  for (final i in items) {
    if (i.seriesId case final id?) (bySeries[id] ??= []).add(i);
  }
  return [
    for (final s in series) _entry(s, bySeries[s.id] ?? const []),
    for (final i in items)
      if (i.seriesId == null && i.type == type) ItemEntry(i),
  ];
}

SeriesEntry _entry(Series series, List<Item> items) {
  final grid = VolumeGrid.compute(
    items: items,
    totalVolumes: series.totalVolumes,
    followed: false,
  );
  int? highest;
  for (final i in items) {
    final n = VolumeNumber.asInt(i.volumeNumber);
    if (n != null && (highest == null || n > highest)) highest = n;
  }
  return SeriesEntry(
    series: series,
    ownedCount: grid.ownedCount,
    unreadCount: grid.toReadCount,
    itemCount: items.length,
    firstVolumeCover: grid.firstCover,
    highestVolume: highest,
    missingIsbnCount: items.where((i) => i.lacksIsbn).length,
    signedCount: items.where((i) => i.isSigned).length,
  );
}
