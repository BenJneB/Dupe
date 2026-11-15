import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/wishlist/domain/next_volumes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_repository.g.dart';

/// Wishlist: items with ownership = envie (no separate table, PLAN.md §4),
/// plus the next volumes to buy computed from followed series.
class WishlistRepository {
  const new(this._db, this._collection);

  final AppDatabase _db;
  final CollectionRepository _collection;

  /// Every wished item, all types, by priority.
  Stream<List<Item>> watchWishes() =>
      (_db.select(_db.itemsTable)..where(
            (t) =>
                t.ownership.equalsValue(Ownership.envie) & t.deletedAt.isNull(),
          ))
          .watch()
          .map((items) => items..sort(compareWishes));

  Stream<List<NextVolumes>> watchNextVolumes() => combineLatest(
    (_db.select(
      _db.seriesTable,
    )..where((t) => t.followed.equals(true) & t.deletedAt.isNull())).watch(),
    (_db.select(
      _db.itemsTable,
    )..where((t) => t.seriesId.isNotNull() & t.deletedAt.isNull())).watch(),
    (series, items) =>
        nextVolumesToBuy(series, items)
          ..sort((a, b) => a.series.title.compareTo(b.series.title)),
  );

  /// Adds the volumes [numbers] of [series] to the wishlist.
  Future<void> wish(Series series, List<int> numbers) async {
    for (final n in numbers) {
      await _collection.saveItem(
        _collection
            .newItem(series.type, series: series, volumeNumber: '$n')
            .copyWith(ownership: Ownership.envie),
      );
    }
  }
}

@riverpod
WishlistRepository wishlistRepository(Ref ref) => WishlistRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(collectionRepositoryProvider),
);

@riverpod
Stream<List<Item>> wishes(Ref ref) =>
    ref.watch(wishlistRepositoryProvider).watchWishes();

@riverpod
Stream<List<NextVolumes>> nextVolumes(Ref ref) =>
    ref.watch(wishlistRepositoryProvider).watchNextVolumes();
