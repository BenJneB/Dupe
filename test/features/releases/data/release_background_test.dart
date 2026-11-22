import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/collection/data/series_completion_service.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';
import 'package:dupe/features/releases/data/release_background.dart';
import 'package:dupe/features/releases/data/release_notifications.dart';
import 'package:dupe/features/releases/data/release_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_covers.dart';
import '../../../helpers/fake_http.dart';
import '../../../helpers/fake_release_background.dart';
import '../../../helpers/fake_release_notifications.dart';
import '../../../helpers/fake_series_catalog.dart';
import '../../../helpers/fake_suggestion_sources.dart';
import '../../../helpers/scan_helpers.dart';

void main() {
  late AppDatabase db;
  late FakeReleaseNotifications notifications;
  late FakeNetworkStatus network;

  /// Everdark 1 to 5 owned and followed; the BnF has 7 volumes, and 5 was
  /// the last one known at the previous check: 6 and 7 are new.
  setUp(() async {
    db = AppDatabase.memory();
    notifications = FakeReleaseNotifications();
    network = FakeNetworkStatus(NetworkKind.unmetered);
    final repo = repoOf(db);
    final s = repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Everdark', publisher: 'Pika');
    await repo.saveSeries(s);
    for (var n = 1; n <= 5; n++) {
      await repo.saveItem(
        repo.newItem(CollectionType.manga, series: s, volumeNumber: '$n'),
      );
    }
    await AppSettingsStore(db).set('releases_base_${s.id}', '5');
  });
  tearDown(() => db.close());

  Future<bool> runTask() => runReleaseTask(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      networkStatusProvider.overrideWithValue(network),
      releaseNotificationsProvider.overrideWithValue(notifications),
      suggestionSourcesProvider.overrideWithValue(FakeSuggestionSources()),
      seriesCatalogSourceProvider.overrideWithValue(
        FakeSeriesCatalogSource(
          byTitle: {
            'Everdark': parseUnimarcResponse(
              fixture('bnf/series_everdark.xml'),
            ),
          },
        ),
      ),
    ],
  );

  test('the background task checks, notifies, then waits a day', () async {
    expect(await runTask(), isTrue);
    expect(notifications.shown, [2]);
    expect(await db.select(db.releaseAlertsTable).get(), hasLength(2));

    // Run again by WorkManager a few hours later: nothing is checked.
    expect(await runTask(), isTrue);
    expect(notifications.shown, [2]);
  });

  test('the background task respects "Wi-Fi only"', () async {
    network.kind = NetworkKind.metered;
    expect(await runTask(), isTrue);
    expect(notifications.shown, isEmpty);
    expect(await db.select(db.releaseAlertsTable).get(), isEmpty);
  });

  test('settings changes schedule or cancel the background check', () async {
    final background = FakeReleaseBackground();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        releaseBackgroundProvider.overrideWithValue(background),
      ],
    );
    addTearDown(container.dispose);
    final settings = container.read(releaseSettingsProvider.notifier);

    await settings.scheduleBackground();
    await settings.set(wifiOnly: false);
    await settings.set(enabled: false);

    expect(background.scheduled, [
      ReleaseSettings.defaults,
      (enabled: true, wifiOnly: false, notify: true),
      (enabled: false, wifiOnly: false, notify: true),
    ]);
  });
}
