import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
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
