import 'package:dupe/app/router.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/fake_http.dart';
import '../../../../helpers/fake_series_catalog.dart';
import '../../../../helpers/scan_helpers.dart';
import '../../../../helpers/screen_helpers.dart';

FakeSeriesCatalogSource _bnf() => FakeSeriesCatalogSource(
  byTitle: {
    'Everdark': parseUnimarcResponse(fixture('bnf/series_everdark.xml')),
  },
);

void main() {
  testWidgets('a new series of 7 volumes in a few taps, with ISBNs', (
    tester,
  ) async {
    final db = await pumpApp(tester, seriesCatalog: _bnf());
    await goTo(tester, '/mangas');
    await tester.tap(find.byKey(const Key('addMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addWholeSeries')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('catalogQuery')), 'Everdark');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('catalogVolume-7')), findsOneWidget);

    // "Possédés jusqu'au tome 5", the 6th wished.
    await tester.enterText(find.byKey(const Key('catalogUpTo')), '5');
    await tester.tap(find.byKey(const Key('catalogAllOwned')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('catalogChoice-6')),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('catalogChoice-6')),
        matching: find.byIcon(Icons.favorite_border),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('catalogSave')));
    await tester.pumpAndSettle();

    final items =
        await tester.runAsync(() => db.select(db.itemsTable).get()) ?? const [];
    expect(items, hasLength(6));
    expect(items.every((i) => i.isbn13 != null), isTrue);
    expect(
      items.where((i) => i.ownership == Ownership.envie).single.volumeNumber,
      '6',
    );
    final series =
        await tester.runAsync(() => db.select(db.seriesTable).get()) ??
        const [];
    expect(series.single.title, 'Everdark');
  });

  testWidgets('series menu: the volumes without ISBN get theirs', (
    tester,
  ) async {
    late String id;
    final db = await pumpApp(
      tester,
      seriesCatalog: _bnf(),
      seed: (db) async {
        final repo = repoOf(db);
        final s = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'Everdark', publisher: 'Pika');
        id = s.id;
        await repo.saveSeries(s);
        for (var n = 1; n <= 7; n++) {
          await repo.saveItem(
            repo.newItem(CollectionType.manga, series: s, volumeNumber: '$n'),
          );
        }
      },
    );
    await goTo(tester, AppRoutes.series(CollectionType.manga, id));
    await tester.tap(find.byKey(const Key('seriesMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('completeFromBnfAction')));
    await tester.pumpAndSettle();

    expect(find.text('Enregistrer (7)'), findsOneWidget);
    await tester.tap(find.byKey(const Key('catalogSave')));
    await tester.pumpAndSettle();
    expect(find.text('Aucun tome ajouté, 7 ISBN complétés'), findsOneWidget);

    final items =
        await tester.runAsync(() => db.select(db.itemsTable).get()) ?? const [];
    expect(items, hasLength(7));
    expect(
      items.firstWhere((i) => i.volumeNumber == '1').isbn13,
      '9782811619428',
    );
  });

  testWidgets('Qualité: every series completed at once', (tester) async {
    final db = await pumpApp(
      tester,
      seriesCatalog: _bnf(),
      seed: (db) async {
        final repo = repoOf(db);
        final s = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'Everdark');
        await repo.saveSeries(s);
        for (final n in ['1', '2']) {
          await repo.saveItem(
            repo.newItem(CollectionType.manga, series: s, volumeNumber: n),
          );
        }
      },
    );
    await goTo(tester, AppRoutes.quality);
    await tester.scrollUntilVisible(
      find.byKey(const Key('seriesIsbnTile')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.ensureVisible(find.byKey(const Key('seriesIsbnTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('seriesIsbnTile')));
    await tester.pumpAndSettle();

    expect(find.textContaining('2 ISBN ajoutés'), findsOneWidget);
    final items =
        await tester.runAsync(() => db.select(db.itemsTable).get()) ?? const [];
    expect(items.map((i) => i.isbn13).toSet(), {
      '9782811619428',
      '9782811637699',
    });
  });
}
