import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/tables/releases_tables.drift.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'releases_repository.g.dart';

@Riverpod(keepAlive: true)
ReleasesRepository releasesRepository(Ref ref) => ReleasesRepository(
  ref.watch(appDatabaseProvider),
  now: ref.watch(clockProvider),
  newId: ref.watch(idGeneratorProvider),
);

/// Alerts still to look at (new and seen), newest first.
@riverpod
Stream<List<ReleaseAlert>> releaseAlerts(Ref ref) =>
    ref.watch(releasesRepositoryProvider).watchAlerts();

@riverpod
Stream<List<FollowedAuthor>> followedAuthors(Ref ref) =>
    ref.watch(releasesRepositoryProvider).watchFollowed();

/// New release alerts and followed authors (PLAN_V4 phase 33). Same write
/// rules as the collection: updated_at bumped, pending sync, soft delete.
class ReleasesRepository {
  new(this._db, {required this.now, required this.newId});

  final AppDatabase _db;
  final DateTime Function() now;
  final String Function() newId;

  /// Same release, same id on every device (UUID v5 of its key).
  static String alertId(String key) =>
      const Uuid().v5(Namespace.url.value, 'dupe:release:$key');

  Stream<List<ReleaseAlert>> watchAlerts() =>
      (_db.select(_db.releaseAlertsTable)
            ..where(
              (t) =>
                  t.deletedAt.isNull() &
                  t.status.isInValues([AlertStatus.nouveau, AlertStatus.vu]),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  /// Saves [alert] unless that release is already known (in any status:
  /// an ignored one never comes back). True when added.
  Future<bool> addIfNew(ReleaseAlert alert) async {
    final id = alertId(alert.key);
    final known = await (_db.select(
      _db.releaseAlertsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (known != null) return false;
    final at = now();
    await _db
        .into(_db.releaseAlertsTable)
        .insert(
          alert.copyWith(id: id, createdAt: at, updatedAt: at).toInsertable(),
        );
    return true;
  }

  Future<void> setStatus(ReleaseAlert alert, AlertStatus status) => _db
      .into(_db.releaseAlertsTable)
      .insertOnConflictUpdate(
        alert
            .copyWith(status: status, updatedAt: now(), syncPending: true)
            .toInsertable(),
      );

  /// The new alerts become seen (the screen was opened).
  Future<void> markAllSeen() async {
    final fresh = await (_db.select(
      _db.releaseAlertsTable,
    )..where((t) => t.status.equalsValue(AlertStatus.nouveau))).get();
    for (final a in fresh) {
      await setStatus(a, AlertStatus.vu);
    }
  }

  Stream<List<FollowedAuthor>> watchFollowed() => (_db.select(
    _db.followedAuthorsTable,
  )..where((t) => t.deletedAt.isNull())).watch();

  Future<List<FollowedAuthor>> listFollowed() => (_db.select(
    _db.followedAuthorsTable,
  )..where((t) => t.deletedAt.isNull())).get();

  /// Follows [name] (nothing when already followed, whatever the spelling).
  Future<void> follow(String name) async {
    final key = authorKey(name);
    if ((await listFollowed()).any((a) => authorKey(a.name) == key)) return;
    final at = now();
    await _db
        .into(_db.followedAuthorsTable)
        .insert(
          FollowedAuthor(
            id: newId(),
            createdAt: at,
            updatedAt: at,
            name: displayAuthorName(name),
          ).toInsertable(),
        );
  }

  Future<void> unfollow(String name) async {
    final key = authorKey(name);
    final at = now();
    for (final a in await listFollowed()) {
      if (authorKey(a.name) != key) continue;
      await _db
          .into(_db.followedAuthorsTable)
          .insertOnConflictUpdate(
            a
                .copyWith(deletedAt: at, updatedAt: at, syncPending: true)
                .toInsertable(),
          );
    }
  }
}
