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
  // Same counts as the series grid (VolumeGrid): owned plain volumes from 1
  // to the total ("07" is volume 7, several editions count once), and owned
  // volumes (any number) none of whose owned copies is read.
  final ownedCount = CustomExpression<int>('''
    (SELECT COUNT(DISTINCT CAST(${_number('c')} AS INTEGER)) FROM items c
     WHERE ${_ownedIn('c')} AND ${_isPlain('c')}
       AND CAST(${_number('c')} AS INTEGER) >= 1
       AND (series.total_volumes IS NULL
         OR CAST(${_number('c')} AS INTEGER) <= series.total_volumes))''');
  final toRead = toReadStatuses.map((r) => "'${r.dbValue}'").join(', ');
  final unreadCount = CustomExpression<int>('''
    (SELECT COUNT(DISTINCT ${_volumeKey('c')}) FROM items c
     WHERE ${_ownedIn('c')} AND c.reading_status IN ($toRead)
       AND NOT EXISTS (SELECT 1 FROM items r
         WHERE ${_ownedIn('r')} AND r.reading_status NOT IN ($toRead)
           AND ${_volumeKey('r')} = ${_volumeKey('c')}))''');
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
  // Owned volumes without ISBN (quality marker, phase 22).
  const missingIsbn = CustomExpression<int>('''
    (SELECT COUNT(*) FROM items c
     WHERE c.series_id = series.id AND c.deleted_at IS NULL
       AND c.ownership = 'possede'
       AND (c.isbn13 IS NULL OR c.isbn13 = ''))''');
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
          missingIsbn,
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
          missingIsbnCount: row.read(missingIsbn) ?? 0,
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

/// Live owned copy [t] of the current series row.
String _ownedIn(String t) =>
    '$t.series_id = series.id AND $t.deleted_at IS NULL '
    "AND $t.ownership = '${Ownership.possede.dbValue}'";

String _number(String t) => "trim(coalesce($t.volume_number, ''))";

/// Plain integer volume number ("12", " 07 "), as VolumeNumber.asInt.
String _isPlain(String t) =>
    "${_number(t)} <> '' AND ${_number(t)} NOT GLOB '*[^0-9]*'";

/// Volume a copy belongs to, as VolumeGrid groups them: the integer value of
/// a plain number, the trimmed text of another ("HS 1"), the copy itself
/// when it has no number.
String _volumeKey(String t) =>
    'CASE WHEN ${_isPlain(t)} '
    'THEN CAST(CAST(${_number(t)} AS INTEGER) AS TEXT) '
    "WHEN ${_number(t)} = '' THEN $t.id ELSE ${_number(t)} END";
