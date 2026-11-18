// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/core/database/tables/series_table.drift.dart' as i1;
import 'package:dupe/core/database/tables/items_table.drift.dart' as i2;
import 'package:dupe/core/database/tables/loans_table.drift.dart' as i3;
import 'package:dupe/core/database/tables/recommendation_feedback_table.drift.dart'
    as i4;
import 'package:dupe/core/database/tables/item_photos_table.drift.dart' as i5;
import 'package:dupe/core/database/tables/releases_tables.drift.dart' as i6;
import 'package:dupe/core/database/tables/local_tables.drift.dart' as i7;

abstract class $AppDatabase extends i0.GeneratedDatabase {
  $AppDatabase(i0.QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final i1.$SeriesTableTable seriesTable = i1.$SeriesTableTable(this);
  late final i2.$ItemsTableTable itemsTable = i2.$ItemsTableTable(this);
  late final i3.$LoansTableTable loansTable = i3.$LoansTableTable(this);
  late final i4.$RecommendationFeedbackTableTable recommendationFeedbackTable =
      i4.$RecommendationFeedbackTableTable(this);
  late final i5.$ItemPhotosTableTable itemPhotosTable = i5
      .$ItemPhotosTableTable(this);
  late final i6.$ReleaseAlertsTableTable releaseAlertsTable = i6
      .$ReleaseAlertsTableTable(this);
  late final i6.$FollowedAuthorsTableTable followedAuthorsTable = i6
      .$FollowedAuthorsTableTable(this);
  late final i7.$AppSettingsTableTable appSettingsTable = i7
      .$AppSettingsTableTable(this);
  late final i7.$MetadataCacheTableTable metadataCacheTable = i7
      .$MetadataCacheTableTable(this);
  late final i7.$ScanQueueTableTable scanQueueTable = i7.$ScanQueueTableTable(
    this,
  );
  @override
  Iterable<i0.TableInfo<i0.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<i0.TableInfo<i0.Table, Object?>>();
  @override
  List<i0.DatabaseSchemaEntity> get allSchemaEntities => [
    seriesTable,
    itemsTable,
    loansTable,
    recommendationFeedbackTable,
    itemPhotosTable,
    releaseAlertsTable,
    followedAuthorsTable,
    appSettingsTable,
    metadataCacheTable,
    scanQueueTable,
    i2.itemsIsbn13Idx,
    i2.itemsSeriesIdIdx,
    i3.loansItemIdIdx,
    i5.itemPhotosItemIdIdx,
  ];
  @override
  i0.DriftDatabaseOptions get options =>
      const i0.DriftDatabaseOptions(storeDateTimeAsText: true);
}

class $AppDatabaseManager {
  final $AppDatabase _db;
  $AppDatabaseManager(this._db);
  i1.$$SeriesTableTableTableManager get seriesTable =>
      i1.$$SeriesTableTableTableManager(_db, _db.seriesTable);
  i2.$$ItemsTableTableTableManager get itemsTable =>
      i2.$$ItemsTableTableTableManager(_db, _db.itemsTable);
  i3.$$LoansTableTableTableManager get loansTable =>
      i3.$$LoansTableTableTableManager(_db, _db.loansTable);
  i4.$$RecommendationFeedbackTableTableTableManager
  get recommendationFeedbackTable =>
      i4.$$RecommendationFeedbackTableTableTableManager(
        _db,
        _db.recommendationFeedbackTable,
      );
  i5.$$ItemPhotosTableTableTableManager get itemPhotosTable =>
      i5.$$ItemPhotosTableTableTableManager(_db, _db.itemPhotosTable);
  i6.$$ReleaseAlertsTableTableTableManager get releaseAlertsTable =>
      i6.$$ReleaseAlertsTableTableTableManager(_db, _db.releaseAlertsTable);
  i6.$$FollowedAuthorsTableTableTableManager get followedAuthorsTable =>
      i6.$$FollowedAuthorsTableTableTableManager(_db, _db.followedAuthorsTable);
  i7.$$AppSettingsTableTableTableManager get appSettingsTable =>
      i7.$$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  i7.$$MetadataCacheTableTableTableManager get metadataCacheTable =>
      i7.$$MetadataCacheTableTableTableManager(_db, _db.metadataCacheTable);
  i7.$$ScanQueueTableTableTableManager get scanQueueTable =>
      i7.$$ScanQueueTableTableTableManager(_db, _db.scanQueueTable);
}
