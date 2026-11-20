import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/tables/local_tables.drift.dart';
import 'package:dupe/core/metadata/response_store.dart';

/// [ResponseStore] backed by the `metadata_cache` table.
class DriftResponseStore implements ResponseStore {
  new(this._db, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  @override
  Future<StoredResponse?> read(String key) async {
    final row = await (_db.select(
      _db.metadataCacheTable,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row == null
        ? null
        : (payload: row.payload, fetchedAt: row.fetchedAt);
  }

  @override
  Future<void> write(String key, String payload) => _db
      .into(_db.metadataCacheTable)
      .insertOnConflictUpdate(
        MetadataCacheTableCompanion.insert(
          key: key,
          payload: payload,
          fetchedAt: _now().toUtc(),
        ),
      );
}

/// Key/value settings in the `app_settings` table.
class AppSettingsStore {
  new(this._db);

  final AppDatabase _db;

  Future<String?> get(String key) async => (await (_db.select(
    _db.appSettingsTable,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  /// A switch stored as '1' / '0'; [orElse] when never set.
  Future<bool> getBool(String key, {required bool orElse}) async =>
      switch (await get(key)) {
        null => orElse,
        final v => v != '0',
      };

  Future<void> setBool(String key, {required bool value}) =>
      set(key, value ? '1' : '0');

  Future<void> set(String key, String value) => _db
      .into(_db.appSettingsTable)
      .insertOnConflictUpdate(
        AppSettingsTableCompanion.insert(key: key, value: value),
      );
}
