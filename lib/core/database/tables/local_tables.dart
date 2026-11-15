import 'package:drift/drift.dart';
import 'package:dupe/core/database/converters.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';

// Device-local tables: never synced, so no SyncedColumns.

/// Key/value app settings (enabled sources…).
@DataClassName('AppSetting')
class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Raw answers of the metadata sources, to work offline and spare the
/// rate-limited APIs.
@DataClassName('CachedResponse')
class MetadataCacheTable extends Table {
  @override
  String get tableName => 'metadata_cache';

  /// `source:isbn:isbn13` or `source:text:query`.
  TextColumn get key => text()();

  /// JSON-encoded result.
  TextColumn get payload => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Burst cataloguing queue: scanned ISBNs waiting for review.
@UseRowClass(ScanQueueEntry, generateInsertable: true)
class ScanQueueTable extends Table {
  @override
  String get tableName => 'scan_queue';

  TextColumn get id => text()();
  TextColumn get isbn13 => text().unique()();
  TextColumn get type =>
      text().map(const DbEnumConverter(CollectionType.values))();
  TextColumn get status => text()
      .map(const DbEnumConverter(ScanStatus.values))
      .withDefault(const Constant('pending'))();
  TextColumn get result =>
      text().map(const MetadataResultConverter()).nullable()();
  DateTimeColumn get scannedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
