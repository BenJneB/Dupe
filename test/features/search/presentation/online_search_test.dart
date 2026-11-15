import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';

Future<void> openOnlineSearch(WidgetTester tester, String query) async {
  await tester.tap(find.byKey(const Key('addMenu')));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Rechercher en ligne'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('onlineSearchField')), query);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('ISBN lookup, then add: the form is prefilled and saved', (
    tester,
  ) async {
    final db = await pumpApp(tester, overrides: [fakeMetadataSources()]);

    await openOnlineSearch(tester, '978-2-266-32048-1');
    expect(find.byKey(const Key('isbnResultTitle')), findsOneWidget);
    expect(find.text('Sources : BnF'), findsOneWidget);

    await tester.tap(find.byKey(const Key('addOwned')));
    await tester.pumpAndSettle();
    expect(find.text('Nouvel ouvrage'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    final item = (await db.select(db.itemsTable).get()).single;
    expect(item.title, 'Dune');
    expect(item.isbn13, duneIsbn);
    expect(item.authors, ['Frank Herbert']);
    expect(item.coverPrice, 11.95);
    expect(item.source, 'bnf');
    // Opened from the Mangas tab: the search type follows the tab.
    expect(item.type, CollectionType.manga);
  });

  testWidgets('an ISBN already in the collection is flagged', (tester) async {
    final db = await pumpApp(tester, overrides: [fakeMetadataSources()]);
    await openOnlineSearch(tester, duneIsbn);
    await tester.tap(find.byKey(const Key('addOwned')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
    expect(await db.select(db.itemsTable).get(), hasLength(1));

    await goBack(tester);
    await openOnlineSearch(tester, duneIsbn);

    expect(find.byKey(const Key('alreadyOwned')), findsOneWidget);
  });

  testWidgets('text search lists results that open a prefilled form', (
    tester,
  ) async {
    await pumpApp(tester, overrides: [fakeMetadataSources()]);

    await openOnlineSearch(tester, 'dune herbert');
    await tester.tap(find.text('Dune'));
    await tester.pumpAndSettle();

    expect(find.text('Nouvel ouvrage'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Dune'), findsOneWidget);
  });
}
