import 'package:drift/drift.dart';
import 'package:dupe/core/database/converters.dart';
import 'package:dupe/core/database/tables/items_table.dart';
import 'package:dupe/core/database/tables/synced_columns.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item_photo.dart';

/// Photos of an item (signature…), schema v5, synced.
@UseRowClass(ItemPhoto, generateInsertable: true)
@TableIndex(name: 'item_photos_item_id_idx', columns: {#itemId})
class ItemPhotosTable extends Table with SyncedColumns {
  @override
  String get tableName => 'item_photos';

  TextColumn get itemId => text().references(ItemsTable, #id)();
  TextColumn get url => text()();
  TextColumn get kind => text()
      .map(const DbEnumConverter(PhotoKind.values))
      .withDefault(const Constant('dedicace'))();
  IntColumn get position => integer().withDefault(const Constant(0))();
}
