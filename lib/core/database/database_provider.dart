import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/metadata/response_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'database_provider.g.dart';

/// The local database, the app's source of truth. Overridden in tests.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
}

/// Current time; overridable in tests.
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;

/// Client-side id generator (UUID v7: time-ordered, index friendly).
@Riverpod(keepAlive: true)
String Function() idGenerator(Ref ref) => const Uuid().v7;

@Riverpod(keepAlive: true)
AppSettingsStore appSettingsStore(Ref ref) =>
    AppSettingsStore(ref.watch(appDatabaseProvider));

/// On-disk cache of metadata source answers.
@Riverpod(keepAlive: true)
ResponseStore responseStore(Ref ref) =>
    DriftResponseStore(ref.watch(appDatabaseProvider));
