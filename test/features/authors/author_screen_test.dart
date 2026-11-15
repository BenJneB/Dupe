import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

late Item dune;

/// Two Colfer series (one without author of its own) and Dune.
Future<void> seedBooks(AppDatabase db) async {
  final repo = repoOf(db);
  const type = CollectionType.livre;
  final fowl = repo.newSeries(type).copyWith(title: 'Les jumeaux Fowl');
  final artemis = repo
      .newSeries(type)
      .copyWith(title: 'Artemis Fowl', authors: ['Colfer, Eoin']);
  await repo.saveSeries(fowl);
  await repo.saveSeries(artemis);
  for (final (series, n) in [(fowl, '1'), (fowl, '2'), (artemis, '1')]) {
    await repo.saveItem(
      repo
          .newItem(type, series: series, volumeNumber: n)
          .copyWith(title: series.title, authors: ['Eoin Colfer']),
    );
  }
  dune = repo.newItem(type).copyWith(title: 'Dune', authors: ['Frank Herbert']);
  await repo.saveItem(dune);
}

void main() {
  testWidgets('"Par auteur" lists authors; an author page lists the rest', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedBooks);
    await goTo(tester, AppRoutes.base(CollectionType.livre));
    await tester.tap(find.byKey(const Key('byAuthorToggle')));
    await tester.pumpAndSettle();

    expect(find.text('Eoin Colfer'), findsOneWidget);
    expect(find.text('2 séries · 3 possédés'), findsOneWidget);
    expect(find.text('Frank Herbert'), findsOneWidget);
    expect(find.text('Artemis Fowl'), findsNothing);

    await tester.tap(find.text('Eoin Colfer'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('authorPage')), findsOneWidget);
    expect(find.text('Les jumeaux Fowl'), findsOneWidget);
    expect(find.text('Artemis Fowl'), findsOneWidget);
    expect(find.text('Dune'), findsNothing);
  });

  testWidgets('the author of a book opens the author page', (tester) async {
    await pumpApp(tester, seed: seedBooks);
    await goTo(tester, AppRoutes.item(CollectionType.livre, dune.id));

    await tester.tap(find.text('Frank Herbert'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('authorPage')), findsOneWidget);
    expect(find.text('1 livre · 1 possédé'), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
  });

  testWidgets('author <-> series back and forth: back returns to the tab', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedBooks);
    await goTo(tester, AppRoutes.base(CollectionType.livre));
    await tester.tap(find.byKey(const Key('byAuthorToggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eoin Colfer'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Artemis Fowl'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('authorLink-eoin colfer')));
      await tester.pumpAndSettle();
    }
    expect(find.byKey(const Key('authorPage')), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('authorPage')), findsNothing);
    expect(find.byKey(const Key('authorsList')), findsOneWidget);
  });
}
