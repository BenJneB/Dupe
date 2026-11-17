import 'package:drift/drift.dart';
import 'package:dupe/core/database/converters.dart';
import 'package:dupe/core/database/tables/synced_columns.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';

/// New releases found (schema v6), synced.
@UseRowClass(ReleaseAlert, generateInsertable: true)
class ReleaseAlertsTable extends Table with SyncedColumns {
  @override
  String get tableName => 'release_alerts';

  TextColumn get key => text()();
  TextColumn get kind => text().map(const DbEnumConverter(AlertKind.values))();
  TextColumn get type =>
      text().map(const DbEnumConverter(CollectionType.values))();
  TextColumn get title => text()();
  TextColumn get status => text()
      .map(const DbEnumConverter(AlertStatus.values))
      .withDefault(const Constant('nouveau'))();
  TextColumn get seriesId => text().nullable()();
  TextColumn get volumeNumber => text().nullable()();
  TextColumn get authorName => text().nullable()();
  TextColumn get authors => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get isbn13 => text().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get publishDate => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
}

/// Authors followed for new releases (schema v6), synced.
@UseRowClass(FollowedAuthor, generateInsertable: true)
class FollowedAuthorsTable extends Table with SyncedColumns {
  @override
  String get tableName => 'followed_authors';

  TextColumn get name => text()();
}
