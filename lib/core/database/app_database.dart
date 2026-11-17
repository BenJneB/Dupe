import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dupe/core/database/app_database.drift.dart';
import 'package:dupe/core/database/tables/item_photos_table.dart';
import 'package:dupe/core/database/tables/item_photos_table.drift.dart';
import 'package:dupe/core/database/tables/items_table.dart';
import 'package:dupe/core/database/tables/loans_table.dart';
import 'package:dupe/core/database/tables/local_tables.dart';
import 'package:dupe/core/database/tables/recommendation_feedback_table.dart';
import 'package:dupe/core/database/tables/series_table.dart';
import 'package:dupe/core/utils/text_fold.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

@DriftDatabase(
  tables: [
    SeriesTable,
    ItemsTable,
    LoansTable,
    RecommendationFeedbackTable,
    ItemPhotosTable,
    AppSettingsTable,
    MetadataCacheTable,
    ScanQueueTable,
  ],
)
class AppDatabase extends $AppDatabase {
  new(super.e);

  /// Opens the on-disk database in the app support directory
  /// (e.g. ~/.local/share/dev.dupe.dupe on Linux), on a background isolate.
  factory open() => AppDatabase(
    LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final tmp = await getTemporaryDirectory();
      return NativeDatabase.createInBackground(
        File(p.join(dir.path, 'dupe.sqlite')),
        setup: setupConnection,
        // Android cannot use /tmp for sqlite temp files.
        isolateSetup: () => sqlite.sqlite3.tempDirectory = tmp.path,
      );
    }),
  );

  /// In-memory database for tests.
  factory memory() =>
      AppDatabase(NativeDatabase.memory(setup: setupConnection));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v2: device-local tables (settings, response cache, burst queue).
        await m.createTable(appSettingsTable);
        await m.createTable(metadataCacheTable);
        await m.createTable(scanQueueTable);
      }
      if (from < 3) {
        // v3: the volume's own title (PLAN_V4 phase 24).
        await m.addColumn(itemsTable, itemsTable.volumeTitle);
      }
      if (from < 4) {
        // v4: dismissed suggestions (PLAN_V4 phase 30).
        await m.createTable(recommendationFeedbackTable);
      }
      if (from < 5) {
        // v5: signed copies and their photos (PLAN_V4 phase 31).
        for (final c in [
          itemsTable.isSigned,
          itemsTable.signedBy,
          itemsTable.signedOn,
          itemsTable.signedPlace,
          itemsTable.signingNote,
        ]) {
          await m.addColumn(itemsTable, c);
        }
        await m.createTable(itemPhotosTable);
        await m.createIndex(itemPhotosItemIdIdx);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

/// Registers custom SQL functions on every connection.
void setupConnection(sqlite.Database db) {
  db.createFunction(
    functionName: 'fold',
    argumentCount: const sqlite.AllowedArgumentCount(1),
    deterministic: true,
    function: (args) {
      final value = args[0];
      return value is String ? foldForSearch(value) : value;
    },
  );
}

/// SQL `fold(expr)`: lowercase without diacritics.
Expression<String> fold(Expression<String> expr) =>
    FunctionCallExpression<String>('fold', [expr]);
