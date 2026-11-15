import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dupe/core/database/app_database.drift.dart';
import 'package:dupe/core/database/tables/items_table.dart';
import 'package:dupe/core/database/tables/loans_table.dart';
import 'package:dupe/core/database/tables/series_table.dart';
import 'package:dupe/core/utils/text_fold.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

@DriftDatabase(tables: [SeriesTable, ItemsTable, LoansTable])
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
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
