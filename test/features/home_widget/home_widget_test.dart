import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/home_widget/data/home_screen_widget.dart';
import 'package:dupe/features/home_widget/data/home_widget_updater.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_home_widget.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

Future<void> seed(AppDatabase db) async {
  final repo = repoOf(db);
  final dune = repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
  await repo.saveItem(dune);
  await repo.saveItem(
    repo.newItem(CollectionType.livre).copyWith(title: 'Fondation'),
  );
  await repo.saveItem(
    repo
        .newItem(CollectionType.livre)
        .copyWith(title: 'Envie', ownership: Ownership.envie),
  );
  await LoansRepository(
    db,
    now: () => DateTime(2026, 10),
    newId: () => 'loan-1',
  ).lend(dune.id, borrower: 'Alice', dueAt: DateTime(2026, 10, 15));
}

void main() {
  testWidgets('the widget button opens the scan, at launch and later', (
    tester,
  ) async {
    final widget = FakeHomeScreenWidget(launchedWith: Uri.parse('dupe://scan'));
    await pumpApp(tester, homeWidget: widget);
    expect(find.byKey(const Key('scanModeSelector')), findsOneWidget);

    await goTo(tester, AppRoutes.base(CollectionType.livre));
    expect(find.byKey(const Key('scanModeSelector')), findsNothing);
    widget.tap(Uri.parse('dupe://scan'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('scanModeSelector')), findsOneWidget);
  });

  test('counters: owned copies and overdue loans, grouped updates', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seed(db);
    final widget = FakeHomeScreenWidget();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        homeScreenWidgetProvider.overrideWithValue(widget),
        clockProvider.overrideWithValue(() => DateTime(2026, 11, 14)),
      ],
    );
    addTearDown(container.dispose);
    Future<void> wait(Duration d) => Future<void>.delayed(d);
    final settle = Duration(
      milliseconds: HomeWidgetUpdater.delay.inMilliseconds + 500,
    );

    container.read(homeWidgetUpdaterProvider);
    await wait(settle);
    expect(widget.shown, ['2 ouvrages · 1 prêt en retard']);

    // Three writes in a row: one update, after the last one.
    final repo = repoOf(db);
    for (final title in ['A', 'B', 'C']) {
      await repo.saveItem(
        repo.newItem(CollectionType.livre).copyWith(title: title),
      );
    }
    await wait(settle);
    expect(widget.shown, [
      '2 ouvrages · 1 prêt en retard',
      '5 ouvrages · 1 prêt en retard',
    ]);

    // A change that does not change the text: nothing sent.
    await repo.saveItem(
      repo
          .newItem(CollectionType.livre)
          .copyWith(title: 'Autre envie', ownership: Ownership.envie),
    );
    await wait(settle);
    expect(widget.shown, hasLength(2));
  });

  test('back in the app: a loan that became overdue is counted', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final repo = repoOf(db);
    final dune = repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
    await repo.saveItem(dune);
    await LoansRepository(
      db,
      now: () => DateTime(2026, 11),
      newId: () => 'loan-1',
    ).lend(dune.id, borrower: 'Alice', dueAt: DateTime(2026, 11, 14));
    var now = DateTime(2026, 11, 14, 20);
    final widget = FakeHomeScreenWidget();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        homeScreenWidgetProvider.overrideWithValue(widget),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    final settle = Duration(
      milliseconds: HomeWidgetUpdater.delay.inMilliseconds + 500,
    );
    container.read(homeWidgetUpdaterProvider);
    await Future<void>.delayed(settle);
    expect(widget.shown, ['1 ouvrage']);

    // The next morning, nothing changed in the data; the app is reopened.
    now = DateTime(2026, 11, 15, 9);
    var resumed = 0;
    final probe = AppLifecycleListener(onResume: () => resumed++);
    addTearDown(probe.dispose);
    TestWidgetsFlutterBinding.instance
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden)
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(resumed, 1);
    await Future<void>.delayed(settle);

    expect(widget.shown.last, '1 ouvrage · 1 prêt en retard');
  });
}
