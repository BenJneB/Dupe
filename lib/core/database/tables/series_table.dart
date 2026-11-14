import 'package:drift/drift.dart';
import 'package:dupe/core/database/converters.dart';
import 'package:dupe/core/database/tables/synced_columns.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';

@UseRowClass(Series, generateInsertable: true)
class SeriesTable extends Table with SyncedColumns {
  @override
  String get tableName => 'series';

  TextColumn get type =>
      text().map(const DbEnumConverter(CollectionType.values))();
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get authors => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get publisher => text().nullable()();
  TextColumn get collection => text().nullable()();
  TextColumn get statusPublication => text()
      .map(const DbEnumConverter(PublicationStatus.values))
      .withDefault(const Constant('inconnue'))();
  IntColumn get totalVolumes => integer().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get externalIds => text()
      .map(const StringMapConverter())
      .withDefault(const Constant('{}'))();
  BoolColumn get followed => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
}
