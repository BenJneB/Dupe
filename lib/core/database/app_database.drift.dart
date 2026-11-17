// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/core/database/tables/series_table.drift.dart' as i1;
import 'package:dupe/core/database/tables/items_table.drift.dart' as i2;
import 'package:dupe/core/database/tables/loans_table.drift.dart' as i3;
import 'package:dupe/core/database/tables/recommendation_feedback_table.drift.dart'
    as i4;
import 'package:dupe/core/database/tables/local_tables.drift.dart' as i5;

abstract class $AppDatabase extends i0.GeneratedDatabase {
  $AppDatabase(i0.QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final i1.$SeriesTableTable seriesTable = i1.$SeriesTableTable(this);
  late final i2.$ItemsTableTable itemsTable = i2.$ItemsTableTable(this);
  late final i3.$LoansTableTable loansTable = i3.$LoansTableTable(this);
  late final i4.$RecommendationFeedbackTableTable recommendationFeedbackTable =
      i4.$RecommendationFeedbackTableTable(this);
  late final i5.$AppSettingsTableTable appSettingsTable = i5
      .$AppSettingsTableTable(this);
  late final i5.$MetadataCacheTableTable metadataCacheTable = i5
      .$MetadataCacheTableTable(this);
  late final i5.$ScanQueueTableTable scanQueueTable = i5.$ScanQueueTableTable(
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
    appSettingsTable,
    metadataCacheTable,
    scanQueueTable,
    i2.itemsIsbn13Idx,
    i2.itemsSeriesIdIdx,
    i3.loansItemIdIdx,
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
  i5.$$AppSettingsTableTableTableManager get appSettingsTable =>
      i5.$$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  i5.$$MetadataCacheTableTableTableManager get metadataCacheTable =>
      i5.$$MetadataCacheTableTableTableManager(_db, _db.metadataCacheTable);
  i5.$$ScanQueueTableTableTableManager get scanQueueTable =>
      i5.$$ScanQueueTableTableTableManager(_db, _db.scanQueueTable);
}
