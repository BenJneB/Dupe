import 'package:dupe/core/database/tables/releases_tables.drift.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/releases/data/release_wish.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/collection_builders.dart';
import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;
  late ReleasesRepository alerts;
  setUp(() {
    env = TestEnv();
    alerts = ReleasesRepository(
      env.db,
      now: () => env.now,
      newId: () => 'unused',
    );
  });
  tearDown(() => env.dispose());

  ReleaseAlert alert(
    String key, {
    String? isbn,
    String? seriesId,
    String? volume,
  }) => ReleaseAlert(
    id: '',
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
    key: key,
    kind: seriesId == null ? AlertKind.auteur : AlertKind.serie,
    type: CollectionType.manga,
    title: 'Everdark',
    seriesId: seriesId,
    volumeNumber: volume,
    isbn13: isbn,
  );

  Future<Map<String, AlertStatus>> statuses() async => {
    for (final a in await env.db.select(env.db.releaseAlertsTable).get())
      a.key: a.status,
  };

  test('one alert per release: same key or same ISBN', () async {
    expect(await alerts.addIfNew(alert('series:s:8', isbn: '978')), isTrue);
    expect(await alerts.addIfNew(alert('series:s:8')), isFalse);
    // The same volume found through its followed author.
    expect(await alerts.addIfNew(alert('isbn:978', isbn: '978')), isFalse);
    expect(await alerts.addIfNew(alert('series:s:9')), isTrue);
    expect(await alerts.knownKeys(), {'series:s:8', 'series:s:9'});
  });

  test('alerts of volumes now in the collection become added', () async {
    await alerts.addIfNew(alert('series:s:8', seriesId: 's', volume: '8'));
    await alerts.addIfNew(alert('isbn:978', isbn: '978'));
    await alerts.addIfNew(alert('series:s:9', seriesId: 's', volume: '9'));
    await alerts.closeOwned([
      item('Everdark', seriesId: 's').copyWith(volumeNumber: '8'),
      item('Autre').copyWith(isbn13: '978'),
    ]);
    expect(await statuses(), {
      'series:s:8': AlertStatus.ajoute,
      'isbn:978': AlertStatus.ajoute,
      'series:s:9': AlertStatus.nouveau,
    });
  });

  test('opening the screen marks only the live new alerts seen', () async {
    await alerts.addIfNew(alert('series:s:8'));
    await alerts.addIfNew(alert('series:s:9'));
    final gone = await (env.db.select(
      env.db.releaseAlertsTable,
    )..where((t) => t.key.equals('series:s:9'))).getSingle();
    await env.db
        .into(env.db.releaseAlertsTable)
        .insertOnConflictUpdate(
          gone.copyWith(deletedAt: env.now, syncPending: false).toInsertable(),
        );
    await alerts.markAllSeen();
    final rows = await env.db.select(env.db.releaseAlertsTable).get();
    expect(
      {for (final a in rows) a.key: (a.status, a.syncPending)},
      {
        'series:s:8': (AlertStatus.vu, true),
        'series:s:9': (AlertStatus.nouveau, false),
      },
    );
  });

  test('wishing a release already in the collection creates nothing', () async {
    await env.repo.saveItem(
      env.repo.newItem(CollectionType.manga).copyWith(isbn13: '978'),
    );
    await alerts.addIfNew(alert('isbn:978', isbn: '978'));
    final a = (await env.db.select(env.db.releaseAlertsTable).get()).single;
    expect(
      await addAlertToWishes(env.repo, alerts, a),
      WishOutcome.alreadyThere,
    );
    expect(await env.repo.listItems(), hasLength(1));
    expect(await statuses(), {'isbn:978': AlertStatus.ajoute});
  });
}
