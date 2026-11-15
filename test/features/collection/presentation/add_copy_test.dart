import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

late Series dreamland;
late Item first;

const firstEdition = '9782845995581';
const newEdition = '9782811666644';

Future<void> seedDreamland(AppDatabase db) async {
  final repo = repoOf(db);
  dreamland = repo
      .newSeries(CollectionType.manga)
      .copyWith(title: 'Dreamland', publisher: 'Pika');
  await repo.saveSeries(dreamland);
  first = repo
      .newItem(CollectionType.manga, series: dreamland, volumeNumber: '1')
      .copyWith(isbn13: firstEdition, edition: 'Première édition');
  await repo.saveItem(first);
}

Future<List<Item>> volume1Copies(WidgetTester tester, AppDatabase db) async =>
    (await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.volumeNumber.equals('1'))).get(),
    ))!;

void main() {
  testWidgets('"Ajouter un exemplaire" from the item sheet', (tester) async {
    final db = await pumpApp(tester, seed: seedDreamland);
    await goTo(tester, AppRoutes.item(first.type, first.id));

    await tester.tap(find.byKey(const Key('addCopy')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Dreamland'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    final copies = await volume1Copies(tester, db);
    expect(copies, hasLength(2));
    expect(copies.map((c) => c.seriesId).toSet(), {dreamland.id});
  });

  testWidgets('store mode: another edition of an owned volume can be added', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      size: desktopSize,
      seed: seedDreamland,
      overrides: [
        fakeMetadataSources(
          result: onePieceT3.copyWith(
            title: 'Dreamland',
            volumeNumber: '1',
            publisher: 'Pika',
            isbn13: newEdition,
          ),
        ),
      ],
    );
    await openScan(tester);
    await typeCode(tester, newEdition);

    expect(find.byKey(const Key('store_owned')), findsOneWidget);
    expect(find.text('Tu as ce tome dans une autre édition'), findsOneWidget);
    await tester.tap(find.byKey(const Key('addThisCopy')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    final copies = await volume1Copies(tester, db);
    expect(
      copies.map((c) => c.isbn13),
      unorderedEquals([firstEdition, newEdition]),
    );
  }, variant: linux);
}
