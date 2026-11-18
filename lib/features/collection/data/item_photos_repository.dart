import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/tables/item_photos_table.drift.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item_photo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_photos_repository.g.dart';

@Riverpod(keepAlive: true)
ItemPhotosRepository itemPhotosRepository(Ref ref) => ItemPhotosRepository(
  ref.watch(appDatabaseProvider),
  now: ref.watch(clockProvider),
  newId: ref.watch(idGeneratorProvider),
);

/// Live photos of [itemId], in order.
@riverpod
Stream<List<ItemPhoto>> itemPhotos(Ref ref, String itemId) =>
    ref.watch(itemPhotosRepositoryProvider).watch(itemId);

/// Photos of the items (signatures…), PLAN_V4 phase 31. Same write rules as
/// the collection: updated_at bumped, pending sync, soft delete.
class ItemPhotosRepository {
  new(this._db, {required this.now, required this.newId});

  final AppDatabase _db;
  final DateTime Function() now;
  final String Function() newId;

  SimpleSelectStatement<$ItemPhotosTableTable, ItemPhoto> _live(
    String itemId,
  ) => _db.select(_db.itemPhotosTable)
    ..where((t) => t.itemId.equals(itemId) & t.deletedAt.isNull())
    ..orderBy([(t) => OrderingTerm.asc(t.position)]);

  Stream<List<ItemPhoto>> watch(String itemId) => _live(itemId).watch();

  Future<List<ItemPhoto>> list(String itemId) => _live(itemId).get();

  /// Adds [url] (a `dupe-cover:` photo) after the other photos of [itemId].
  Future<ItemPhoto> add(
    String itemId,
    String url, {
    PhotoKind kind = PhotoKind.dedicace,
  }) async {
    final at = now();
    final photos = await list(itemId);
    final photo = ItemPhoto(
      id: newId(),
      createdAt: at,
      updatedAt: at,
      itemId: itemId,
      url: url,
      kind: kind,
      position: photos.isEmpty ? 0 : photos.last.position + 1,
    );
    await _db.into(_db.itemPhotosTable).insert(photo.toInsertable());
    return photo;
  }

  Future<void> delete(ItemPhoto photo) {
    final at = now();
    return _db
        .into(_db.itemPhotosTable)
        .insertOnConflictUpdate(
          photo
              .copyWith(deletedAt: at, updatedAt: at, syncPending: true)
              .toInsertable(),
        );
  }
}
