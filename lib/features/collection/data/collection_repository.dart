import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/tables/items_table.drift.dart';
import 'package:dupe/core/database/tables/series_table.drift.dart';
import 'package:dupe/core/database/upsert.dart';
import 'package:dupe/features/collection/data/collection_entries_query.dart';
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

  /// Runs several writes in one transaction: all or nothing, and the open
  /// lists (collection, stats, sync) are refreshed once instead of per row.
  Future<T> inTransaction<T>(Future<T> Function() writes) =>
      _db.transaction(writes);

  /// Saves [series]; a new title also goes to the volumes that had the old
  /// one (copied from the series when they were created).
  Future<void> saveSeries(Series series) => _db.transaction(() async {
    final now = _now();
    final before = await getSeries(series.id);
    await _db.upsertKeepingDeletion(
      _db.seriesTable,
      series.copyWith(updatedAt: now, syncPending: true).toInsertable(),
    );
    if (before == null || before.title == series.title) return;
    await (_db.update(_db.itemsTable)..where(
          (t) =>
              t.seriesId.equals(series.id) &
              t.title.equals(before.title) &
              t.deletedAt.isNull(),
        ))
        .write(
          ItemsTableCompanion(
            title: Value(series.title),
            updatedAt: Value(now),
            syncPending: const Value(true),
          ),
        );
  });

  Future<void> saveItem(Item item) => _db.upsertKeepingDeletion(
    _db.itemsTable,
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
    return _markItem(id, deletedAt: now, now: now);
  }

  /// Undoes [deleteSeries]: the series and the items deleted with it.
  Future<void> restoreSeries(String id) => _db.transaction(() async {
    final series = await (_db.select(
      _db.seriesTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    final deletedAt = series?.deletedAt;
    if (deletedAt == null) return;
    final now = _now();
    await (_db.update(_db.seriesTable)..where((t) => t.id.equals(id))).write(
      SeriesTableCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(now),
        syncPending: const Value(true),
      ),
    );
    final items = await (_db.select(
      _db.itemsTable,
    )..where((t) => t.seriesId.equals(id) & t.deletedAt.isNotNull())).get();
    for (final i in items.where(
      (i) => i.deletedAt!.isAtSameMomentAs(deletedAt),
    )) {
      await _markItem(i.id, deletedAt: null, now: now);
    }
  });

  /// Undoes [deleteItem].
  Future<void> restoreItem(String id) =>
      _markItem(id, deletedAt: null, now: _now());

  Future<void> _markItem(
    String id, {
    required DateTime? deletedAt,
    required DateTime now,
  }) => (_db.update(_db.itemsTable)..where((t) => t.id.equals(id))).write(
    ItemsTableCompanion(
      deletedAt: Value(deletedAt),
      updatedAt: Value(now),
      syncPending: const Value(true),
    ),
  );

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

  /// Every non-deleted item (owned and wished), every type.
  Future<List<Item>> listItems() =>
      (_db.select(_db.itemsTable)..where((t) => t.deletedAt.isNull())).get();

  /// Non-deleted standalone items (no series), every type.
  Future<List<Item>> listStandaloneItems() => (_db.select(
    _db.itemsTable,
  )..where((t) => t.seriesId.isNull() & t.deletedAt.isNull())).get();

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

  Future<List<Item>> listSeriesItems(String seriesId) =>
      _activeItemsOfSeries(seriesId).get();

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

  /// Series of [type] with their counts, plus standalone items.
  Stream<List<CollectionEntry>> watchEntries(CollectionType type) =>
      watchCollectionEntries(_db, type);
}
