import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';

/// Rows of a collection tab: series of [type] with their counts, plus
/// standalone items.
Stream<List<CollectionEntry>> watchCollectionEntries(
  AppDatabase db,
  CollectionType type,
) {
  final s = db.seriesTable;
  final i = db.itemsTable;
  final activeItem = i.deletedAt.isNull();
  final owned = activeItem & i.ownership.equalsValue(Ownership.possede);
  // Distinct volumes: several copies (editions) of a volume count once.
  final volume = coalesce([i.volumeNumber, i.id]);
  final ownedCount = volume.count(distinct: true, filter: owned);
  final unreadCount = volume.count(
    distinct: true,
    filter: owned & i.readingStatus.isInValues(toReadStatuses),
  );
  final itemCount = i.id.count(filter: activeItem);
  // Cover of the first volume with one, numbered volumes first (as in the
  // series grid).
  const firstCover = CustomExpression<String>('''
    (SELECT c.cover_url FROM items c
     WHERE c.series_id = series.id AND c.deleted_at IS NULL
       AND c.cover_url IS NOT NULL AND c.cover_url <> ''
     ORDER BY c.volume_number GLOB '[0-9]*' DESC,
       CAST(c.volume_number AS REAL), c.volume_number, c.created_at
     LIMIT 1)''');
  // Highest plain volume number ("12", not "HS 2").
  const highestVolume = CustomExpression<int>('''
    (SELECT MAX(CAST(c.volume_number AS INTEGER)) FROM items c
     WHERE c.series_id = series.id AND c.deleted_at IS NULL
       AND c.volume_number GLOB '[0-9]*'
       AND c.volume_number NOT GLOB '*[^0-9]*')''');

  final seriesQuery =
      db.select(s).join([leftOuterJoin(i, i.seriesId.equalsExp(s.id))])
        ..where(s.type.equalsValue(type) & s.deletedAt.isNull())
        ..groupBy([s.id])
        ..addColumns([
          ownedCount,
          unreadCount,
          itemCount,
          firstCover,
          highestVolume,
        ]);

  final seriesStream = seriesQuery.watch().map(
    (rows) => [
      for (final row in rows)
        SeriesEntry(
          series: row.readTable(s),
          ownedCount: row.read(ownedCount) ?? 0,
          unreadCount: row.read(unreadCount) ?? 0,
          itemCount: row.read(itemCount) ?? 0,
          firstVolumeCover: row.read(firstCover),
          highestVolume: row.read(highestVolume),
        ),
    ],
  );
  final standalone =
      (db.select(i)..where(
            (t) =>
                t.type.equalsValue(type) &
                t.seriesId.isNull() &
                t.deletedAt.isNull(),
          ))
          .watch();

  // Both queries touch the items table, so drift re-runs them together on
  // item changes; combine the latest values of each.
  return combineLatest(seriesStream, standalone, (series, items) {
    return <CollectionEntry>[...series, ...items.map(ItemEntry.new)];
  });
}
