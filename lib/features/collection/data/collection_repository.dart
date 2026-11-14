import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/tables/items_table.drift.dart';
import 'package:dupe/core/database/tables/series_table.drift.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collection_repository.g.dart';

@Riverpod(keepAlive: true)
CollectionRepository collectionRepository(Ref ref) => CollectionRepository(
  ref.watch(appDatabaseProvider),
  now: ref.watch(clockProvider),
  newId: ref.watch(idGeneratorProvider),
);

/// Local CRUD for series and items. Every write bumps `updated_at` and marks
/// the row as pending sync; deletions are soft (`deleted_at`).
class CollectionRepository {
  new(this._db, {required this._now, required this._newId});

  final AppDatabase _db;
  final DateTime Function() _now;
  final String Function() _newId;

  // ---- Drafts -------------------------------------------------------------

  Series newSeries(CollectionType type) {
    final now = _now();
    return Series(
      id: _newId(),
      createdAt: now,
      updatedAt: now,
      type: type,
      title: '',
    );
  }

  Item newItem(CollectionType type, {Series? series, String? volumeNumber}) {
    final now = _now();
    return Item(
      id: _newId(),
      createdAt: now,
      updatedAt: now,
      type: series?.type ?? type,
      seriesId: series?.id,
      title: series?.title ?? '',
      volumeNumber: volumeNumber,
      authors: series?.authors ?? const [],
      publisher: series?.publisher,
    );
  }

  // ---- Writes -------------------------------------------------------------

  Future<void> saveSeries(Series series) => _db
      .into(_db.seriesTable)
      .insertOnConflictUpdate(
        series.copyWith(updatedAt: _now(), syncPending: true).toInsertable(),
      );

  Future<void> saveItem(Item item) => _db
      .into(_db.itemsTable)
      .insertOnConflictUpdate(
        item.copyWith(updatedAt: _now(), syncPending: true).toInsertable(),
      );

  /// Creates owned/wished volumes [from]..[to] of [series], skipping numbers
  /// that already exist. Returns the number of created items.
  Future<int> addVolumeRange(
    Series series, {
    required int from,
    required int to,
    Ownership ownership = Ownership.possede,
  }) => _db.transaction(() async {
    final existing = await _activeItemsOfSeries(series.id).get();
    final taken = {
      for (final i in existing) ?VolumeNumber.asInt(i.volumeNumber),
    };
    var created = 0;
    for (var n = from; n <= to; n++) {
      if (taken.contains(n)) continue;
      await saveItem(
        newItem(
          series.type,
          series: series,
          volumeNumber: '$n',
        ).copyWith(ownership: ownership),
      );
      created++;
    }
    return created;
  });

  /// Soft-deletes a series and all its items.
  Future<void> deleteSeries(String id) => _db.transaction(() async {
    final now = _now();
    await (_db.update(_db.seriesTable)..where((t) => t.id.equals(id))).write(
      SeriesTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        syncPending: const Value(true),
      ),
    );
    await (_db.update(
      _db.itemsTable,
    )..where((t) => t.seriesId.equals(id) & t.deletedAt.isNull())).write(
      ItemsTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        syncPending: const Value(true),
      ),
    );
  });

  Future<void> deleteItem(String id) {
    final now = _now();
    return (_db.update(_db.itemsTable)..where((t) => t.id.equals(id))).write(
      ItemsTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        syncPending: const Value(true),
      ),
    );
  }

  // ---- Reads --------------------------------------------------------------

  Future<Series?> getSeries(String id) => (_db.select(
    _db.seriesTable,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();

  /// All non-deleted series (optionally of one [type]).
  Future<List<Series>> listSeries({CollectionType? type}) =>
      (_db.select(_db.seriesTable)..where(
            (t) =>
                t.deletedAt.isNull() &
                (type == null
                    ? const Constant(true)
                    : t.type.equalsValue(type)),
          ))
          .get();

  /// Non-deleted series of [type] with exactly this [title].
  Future<Series?> findSeries(CollectionType type, String title) =>
      (_db.select(_db.seriesTable)
            ..where(
              (t) =>
                  t.type.equalsValue(type) &
                  t.title.equals(title) &
                  t.deletedAt.isNull(),
            )
            ..limit(1))
          .getSingleOrNull();

  /// Non-deleted standalone item (no series) of [type] with this [title].
  Future<Item?> findStandaloneItem(CollectionType type, String title) =>
      (_db.select(_db.itemsTable)
            ..where(
              (t) =>
                  t.type.equalsValue(type) &
                  t.title.equals(title) &
                  t.seriesId.isNull() &
                  t.deletedAt.isNull(),
            )
            ..limit(1))
          .getSingleOrNull();

  /// First non-deleted item with this ISBN-13 (any ownership).
  Future<Item?> findItemByIsbn(String isbn13) =>
      (_db.select(_db.itemsTable)
            ..where((t) => t.isbn13.equals(isbn13) & t.deletedAt.isNull())
            ..limit(1))
          .getSingleOrNull();

  Future<Item?> getItem(String id) => (_db.select(
    _db.itemsTable,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();

  Stream<Series?> watchSeries(String id) => (_db.select(
    _db.seriesTable,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).watchSingleOrNull();

  Stream<Item?> watchItem(String id) => (_db.select(
    _db.itemsTable,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).watchSingleOrNull();

  Stream<List<Item>> watchSeriesItems(String seriesId) =>
      _activeItemsOfSeries(seriesId).watch().map(
        (items) => items
          ..sort(
            (a, b) => VolumeNumber.compare(a.volumeNumber, b.volumeNumber),
          ),
      );

  SimpleSelectStatement<$ItemsTableTable, Item> _activeItemsOfSeries(
    String seriesId,
  ) =>
      _db.select(_db.itemsTable)
        ..where((t) => t.seriesId.equals(seriesId) & t.deletedAt.isNull());

  /// Series of [type] with owned/total item counts, plus standalone items.
  Stream<List<CollectionEntry>> watchEntries(CollectionType type) {
    final s = _db.seriesTable;
    final i = _db.itemsTable;
    final activeItem = i.deletedAt.isNull();
    final ownedCount = i.id.count(
      filter: activeItem & i.ownership.equalsValue(Ownership.possede),
    );
    final itemCount = i.id.count(filter: activeItem);

    final seriesQuery =
        _db.select(s).join([leftOuterJoin(i, i.seriesId.equalsExp(s.id))])
          ..where(s.type.equalsValue(type) & s.deletedAt.isNull())
          ..groupBy([s.id])
          ..addColumns([ownedCount, itemCount]);

    final seriesStream = seriesQuery.watch().map(
      (rows) => [
        for (final row in rows)
          SeriesEntry(
            series: row.readTable(s),
            ownedCount: row.read(ownedCount) ?? 0,
            itemCount: row.read(itemCount) ?? 0,
          ),
      ],
    );
    final standalone =
        (_db.select(i)..where(
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
}
