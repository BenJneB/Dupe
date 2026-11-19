import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

const CollectionType _livre = CollectionType.livre;

void main() {
  // Recette 2026-11-19: Les fourmis, Le jour des fourmis… are not linked
  // by the BnF; the user files them by hand.
  late Series fourmis;
  late Item jour;
  late Item revolution;

  Future<AppDatabase> pump(WidgetTester tester) => pumpApp(
    tester,
    seed: (db) async {
      final repo = repoOf(db);
      fourmis = repo.newSeries(_livre).copyWith(title: 'Les fourmis');
      await repo.saveSeries(fourmis);
      jour = repo.newItem(_livre).copyWith(title: 'Le jour des fourmis');
      revolution = repo
          .newItem(_livre, series: fourmis, volumeNumber: '3')
          .copyWith(title: 'La révolution des fourmis');
      await repo.saveItem(jour);
      await repo.saveItem(revolution);
    },
  );

  Future<Item> saved(WidgetTester tester, AppDatabase db, String id) async =>
      (await tester.runAsync(
        () => (db.select(
          db.itemsTable,
        )..where((t) => t.id.equals(id))).getSingle(),
      ))!;

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
  }

  testWidgets('a standalone book is filed in an existing series', (
    tester,
  ) async {
    final db = await pump(tester);
    await goTo(tester, AppRoutes.itemEdit(_livre, jour.id));

    await tester.tap(find.byKey(const Key('noSeries')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('seriesPickerField')), 'fourm');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('seriesPick-${fourmis.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Série : Les fourmis'), findsOneWidget);
    await save(tester);

    expect((await saved(tester, db, jour.id)).seriesId, fourmis.id);
  });

  testWidgets('a volume can leave its series, or go into a new one', (
    tester,
  ) async {
    final db = await pump(tester);
    await goTo(tester, AppRoutes.itemEdit(_livre, revolution.id));

    await tester.tap(find.byKey(const Key('attachedSeries')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('seriesPickerNone')));
    await tester.pumpAndSettle();
    await save(tester);
    expect((await saved(tester, db, revolution.id)).seriesId, isNull);

    await goTo(tester, AppRoutes.itemEdit(_livre, jour.id));
    await tester.tap(find.byKey(const Key('noSeries')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('seriesPickerField')),
      'Trilogie des fourmis',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('seriesPickerNew')));
    await tester.pumpAndSettle();
    await save(tester);

    final item = await saved(tester, db, jour.id);
    final series = await tester.runAsync(
      () => repoOf(db).getSeries(item.seriesId!),
    );
    expect(series!.title, 'Trilogie des fourmis');
    expect(series.type, _livre);
  });

  testWidgets('the tab shows the totals of its visible entries', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (db) async {
        final repo = repoOf(db);
        final s = repo.newSeries(_livre).copyWith(title: 'Les fourmis');
        await repo.saveSeries(s);
        await repo.addVolumeRange(s, from: 1, to: 3);
        await repo.saveItem(repo.newItem(_livre).copyWith(title: 'Dune'));
        await repo.saveItem(
          repo
              .newItem(_livre)
              .copyWith(title: 'Hypérion', ownership: Ownership.envie),
        );
      },
    );
    await goTo(tester, AppRoutes.base(_livre));

    expect(
      tester.widget<Text>(find.byKey(const Key('tabSummary'))).data,
      '1 série · 2 livres · 4 possédés',
    );
  });
}
