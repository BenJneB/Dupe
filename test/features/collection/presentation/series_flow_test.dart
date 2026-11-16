import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/failing_repository.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

void main() {
  testWidgets('series of 10 volumes, 7 owned, shows the 3 missing', (
    tester,
  ) async {
    await pumpApp(tester);

    await createSeries(tester, title: 'Naruto', total: '10', ownedUpTo: '7');

    // Series sheet opened after creation.
    expect(find.text('7/10 tomes, il manque 8, 9, 10'), findsOneWidget);
    for (var n = 1; n <= 10; n++) {
      expect(find.byKey(ValueKey('slot-$n')), findsOneWidget);
    }
    expect(find.bySemanticsLabel('Tome 8, Manquant'), findsOneWidget);
    expect(find.bySemanticsLabel('Tome 7, Possédé'), findsOneWidget);
  });

  testWidgets('long press on a missing volume adds it', (tester) async {
    await pumpApp(tester);
    await createSeries(tester, title: 'Naruto', total: '10', ownedUpTo: '7');

    // The grid is under its legend: scroll it clear of the scan button.
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.longPress(find.byKey(const ValueKey('slot-8')));
    await tester.pumpAndSettle();

    expect(find.text('8/10 tomes, il manque 9, 10'), findsOneWidget);
    expect(find.text('Tome 8 marqué comme possédé'), findsOneWidget);
  });

  testWidgets('long press on a wished volume: bought today', (tester) async {
    late Item wish;
    final db = await pumpApp(
      tester,
      overrides: [
        clockProvider.overrideWithValue(() => DateTime(2026, 11, 16, 15)),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        final series = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'Naruto', totalVolumes: 3);
        await repo.saveSeries(series);
        wish = repo
            .newItem(CollectionType.manga, series: series, volumeNumber: '2')
            .copyWith(ownership: Ownership.envie, wishlistPriority: 1);
        await repo.saveItem(wish);
      },
    );
    await goTo(tester, AppRoutes.series(CollectionType.manga, wish.seriesId!));
    await tester.longPress(find.byKey(const ValueKey('slot-2')));
    await tester.pumpAndSettle();

    final saved = await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.id.equals(wish.id))).getSingle(),
    );
    expect(saved!.ownership, Ownership.possede);
    expect(saved.purchaseDate, DateTime(2026, 11, 16));
    expect(saved.wishlistPriority, isNull);
  });

  testWidgets('a save that fails: error shown, form usable again', (
    tester,
  ) async {
    bool saveEnabled() =>
        tester
            .widget<TextButton>(find.byKey(const Key('saveButton')))
            .onPressed !=
        null;

    // Series form.
    await pumpApp(tester, overrides: [failingRepository(failSeries: true)]);
    await createSeries(tester, title: 'Akira', total: '6', ownedUpTo: '');
    expect(find.textContaining('Une erreur est survenue'), findsOneWidget);
    expect(saveEnabled(), isTrue);
  });

  testWidgets('an item save that fails: error shown, form usable again', (
    tester,
  ) async {
    await pumpApp(tester, overrides: [failingRepository()]);
    await createSeries(tester, title: 'Akira', total: '6', ownedUpTo: '');
    await tester.tap(find.byKey(const ValueKey('slot-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Une erreur est survenue'), findsOneWidget);
    expect(
      tester.widget<TextButton>(find.byKey(const Key('saveButton'))).onPressed,
      isNotNull,
    );
  });

  testWidgets('series appears in the tab list with its progress', (
    tester,
  ) async {
    await pumpApp(tester);
    await createSeries(tester, title: 'Naruto', total: '10', ownedUpTo: '7');

    await goBack(tester);

    expect(find.text('Naruto'), findsOneWidget);
    expect(find.text('7/10 tomes'), findsOneWidget);
  });

  testWidgets('tapping a missing volume opens a prefilled item form', (
    tester,
  ) async {
    final db = await pumpApp(tester);
    await createSeries(tester, title: 'Akira', total: '6', ownedUpTo: '');

    await tester.tap(find.byKey(const ValueKey('slot-3')));
    await tester.pumpAndSettle();
    expect(find.text('Nouvel ouvrage'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(find.text('1/6 tomes, il manque 1, 2, 4, 5, 6'), findsOneWidget);
    final items = await db.select(db.itemsTable).get();
    expect(items.single.volumeNumber, '3');
    expect(items.single.title, 'Akira');
  });

  testWidgets('global search finds a series without accents', (tester) async {
    await pumpApp(tester);
    await createSeries(tester, title: 'L’Épée', total: '2', ownedUpTo: '1');
    await goBack(tester);

    await tester.tap(find.byKey(const Key('globalSearchBar')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('searchField')), 'epee');
    await tester.pumpAndSettle();

    expect(find.text('L’Épée'), findsOneWidget);
    expect(find.text('Séries'), findsOneWidget);
  });
}
