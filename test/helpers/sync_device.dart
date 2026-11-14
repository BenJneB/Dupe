import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/sync/sync_engine.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:uuid/uuid.dart';

import 'fake_sync_remote.dart';

const user = '00000000-0000-0000-0000-00000000000a';

/// One installation of the app (phone or PC).
class Device {
  new(this.remote, {int pageSize = 500}) : db = AppDatabase.memory() {
    repo = CollectionRepository(db, now: _tick, newId: const Uuid().v7);
    loans = LoansRepository(db, now: _tick, newId: const Uuid().v7);
    engine = SyncEngine(db, remote, AppSettingsStore(db), pageSize: pageSize);
  }

  final FakeSyncRemote remote;
  final AppDatabase db;
  late final CollectionRepository repo;
  late final LoansRepository loans;
  late final SyncEngine engine;
  DateTime now = DateTime(2026, 11, 14, 10);

  static var _ticks = 0;

  /// A real clock never returns the same instant twice: two writes of a row
  /// always get different `updated_at` (the sync relies on it). The ticks
  /// are shared so that devices with the same [now] stay in write order.
  DateTime _tick() => now.add(Duration(microseconds: ++_ticks));

  Future<SyncReport> sync() => engine.sync(user);
  Future<void> dispose() => db.close();
}
