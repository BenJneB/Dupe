import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_covers.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

void main() {
  testWidgets('covers fetched at start-up on Wi-Fi; size, then "Vider"', (
    tester,
  ) async {
    final cache = FakeCoverCache();
    await pumpApp(
      tester,
      network: FakeNetworkStatus(NetworkKind.unmetered),
      coverCache: cache,
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.livre)
              .copyWith(title: 'Dune', coverUrl: 'https://c/dune.jpg'),
        );
      },
    );
    expect(cache.cached, {'https://c/dune.jpg'});

    await openSettings(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('prefetchStatus')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('1 couverture disponible hors ligne'), findsOneWidget);
    expect(find.textContaining('0,1 Mo utilisés'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('clearCoverCache')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('clearCoverCache')));
    await tester.pumpAndSettle();
    expect(cache.cached, isEmpty);
    expect(find.textContaining('vos photos sont gardées'), findsOneWidget);
    expect(find.textContaining('0,0 Mo utilisés'), findsOneWidget);
  });

  testWidgets('mobile data: waits for Wi-Fi unless allowed', (tester) async {
    final cache = FakeCoverCache();
    await pumpApp(
      tester,
      network: FakeNetworkStatus(NetworkKind.metered),
      coverCache: cache,
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.livre)
              .copyWith(title: 'Dune', coverUrl: 'https://c/dune.jpg'),
        );
      },
    );
    await openSettings(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('prefetchStatus')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('En attente du Wi-Fi'), findsOneWidget);
    expect(cache.fetched, isEmpty);

    await tapTile(tester, 'prefetchWifiSwitch');
    expect(cache.cached, {'https://c/dune.jpg'});
  });
}
