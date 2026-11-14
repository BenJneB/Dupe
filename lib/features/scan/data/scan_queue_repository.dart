import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/tables/local_tables.drift.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_queue_repository.g.dart';

/// Burst mode queue, persisted so that a closed app loses no scan.
class ScanQueueRepository {
  new(this._db, {required this.now, required this.newId});

  final AppDatabase _db;
  final DateTime Function() now;
  final String Function() newId;

  $ScanQueueTableTable get _t => _db.scanQueueTable;

  /// Adds [isbn13]; false when it is already queued.
  Future<bool> enqueue(String isbn13, CollectionType type) =>
      _db.transaction(() async {
        final existing = await (_db.select(
          _t,
        )..where((t) => t.isbn13.equals(isbn13))).getSingleOrNull();
        if (existing != null) return false;
        await _db
            .into(_t)
            .insert(
              ScanQueueTableCompanion.insert(
                id: newId(),
                isbn13: isbn13,
                type: type,
                scannedAt: now().toUtc(),
              ),
            );
        return true;
      });

  Future<int> count() async {
    final n = _t.id.count();
    return await (_db.selectOnly(
          _t,
        )..addColumns([n])).map((row) => row.read(n)).getSingle() ??
        0;
  }

  /// Oldest entry waiting for its lookup.
  Future<ScanQueueEntry?> nextPending() =>
      (_db.select(_t)
            ..where((t) => t.status.equalsValue(ScanStatus.pending))
            ..orderBy([(t) => OrderingTerm.asc(t.scannedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> setResult(String id, ScanStatus status, MetadataResult? r) =>
      (_db.update(_t)..where((t) => t.id.equals(id))).write(
        ScanQueueTableCompanion(status: Value(status), result: Value(r)),
      );

  /// Failed lookups go back to the queue.
  Future<void> retryFailed() =>
      (_db.update(
        _t,
      )..where((t) => t.status.equalsValue(ScanStatus.failed))).write(
        const ScanQueueTableCompanion(status: Value(ScanStatus.pending)),
      );

  Future<void> remove(String id) =>
      (_db.delete(_t)..where((t) => t.id.equals(id))).go();

  Stream<List<ScanQueueEntry>> watchQueue() =>
      (_db.select(_t)..orderBy([(t) => OrderingTerm.asc(t.scannedAt)])).watch();
}

@Riverpod(keepAlive: true)
ScanQueueRepository scanQueueRepository(Ref ref) => ScanQueueRepository(
  ref.watch(appDatabaseProvider),
  now: ref.watch(clockProvider),
  newId: ref.watch(idGeneratorProvider),
);

@riverpod
Stream<List<ScanQueueEntry>> scanQueue(Ref ref) =>
    ref.watch(scanQueueRepositoryProvider).watchQueue();
