import 'package:drift/drift.dart';
import 'package:dupe/core/database/converters.dart';
import 'package:dupe/core/database/tables/series_table.dart';
import 'package:dupe/core/database/tables/synced_columns.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';

@UseRowClass(Item, generateInsertable: true)
@TableIndex(name: 'items_isbn13_idx', columns: {#isbn13})
@TableIndex(name: 'items_series_id_idx', columns: {#seriesId})
class ItemsTable extends Table with SyncedColumns {
  @override
  String get tableName => 'items';

  TextColumn get seriesId => text().nullable().references(SeriesTable, #id)();
  TextColumn get type =>
      text().map(const DbEnumConverter(CollectionType.values))();
  TextColumn get title => text()();

  /// Text to handle "1.5", "HS 2", "Annual 1".
  TextColumn get volumeNumber => text().nullable()();
  TextColumn get isbn13 => text().nullable()();
  TextColumn get upc => text().nullable()();
  TextColumn get authors => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get publisher => text().nullable()();
  TextColumn get edition => text().nullable()();
  TextColumn get format => text().nullable()();

  /// Free text: sources give "2005", "2005-03" or full dates.
  TextColumn get publishDate => text().nullable()();
  IntColumn get pageCount => integer().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get ownership => text()
      .map(const DbEnumConverter(Ownership.values))
      .withDefault(const Constant('possede'))();
  TextColumn get readingStatus => text()
      .map(const DbEnumConverter(ReadingStatus.values))
      .withDefault(const Constant('non_lu'))();
  DateTimeColumn get readDate => dateTime().nullable()();
  IntColumn get rating => integer().nullable()();
  BoolColumn get isFirstEdition =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isVariant => boolean().withDefault(const Constant(false))();
  TextColumn get condition => text().nullable()();
  RealColumn get purchasePrice => real().nullable()();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  RealColumn get coverPrice => real().nullable()();
  RealColumn get estimatedValue => real().nullable()();
  TextColumn get currency => text().withDefault(const Constant('EUR'))();
  IntColumn get wishlistPriority => integer().nullable()();
  RealColumn get wishlistMaxPrice => real().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get sourceId => text().nullable()();
}
