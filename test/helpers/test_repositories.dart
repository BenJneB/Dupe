import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';

/// Repository on an in-memory database with a controllable clock.
class TestEnv {
  new() : db = AppDatabase.memory() {
    repo = CollectionRepository(
      db,
      now: () => now,
      newId: () => 'id-${_nextId++}',
    );
  }

  final AppDatabase db;
  late final CollectionRepository repo;
  DateTime now = DateTime.utc(2026, 1, 1, 12);
  int _nextId = 1;

  Future<void> dispose() => db.close();
}
