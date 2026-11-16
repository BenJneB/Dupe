import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_sources.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

const k1 = '9782203370166';
const other = '9782070612758';
late Series kaamelott;
late List<Item> volumes;
late Item duneBook;

/// Kaamelott 1-3 owned without ISBN, and Dune with one.
Future<void> seedGaps(AppDatabase db) async {
  final repo = repoOf(db);
  kaamelott = repo.newSeries(CollectionType.bd).copyWith(title: 'Kaamelott');
  await repo.saveSeries(kaamelott);
  volumes = [
    for (final n in ['1', '2', '3'])
      repo
          .newItem(CollectionType.bd, series: kaamelott, volumeNumber: n)
          .copyWith(title: 'Kaamelott'),
  ];
  for (final v in volumes) {
    await repo.saveItem(v);
  }
  duneBook = repo
      .newItem(CollectionType.livre)
      .copyWith(title: 'Dune', isbn13: duneIsbn);
  await repo.saveItem(duneBook);
}

final Override sources = fakeMetadataSources(
  byIsbn: {
    k1: const MetadataResult(
      source: MetadataSource.bnf,
      sourceId: 'k1',
      title: "L'armée du Nécromant",
      seriesTitle: 'Kaamelott',
      volumeNumber: '1',
      publisher: 'Casterman',
    ),
    other: const MetadataResult(
      source: MetadataSource.bnf,
      sourceId: 'x',
      title: 'Le Petit Prince',
    ),
  },
);

Text countOf(WidgetTester tester, String issue) => tester.widget<Text>(
  find
      .descendant(
        of: find.byKey(Key('quality-$issue')),
        matching: find.byType(Text),
      )
      .last,
);

void main() {
  testWidgets('scan ISBNs one after the other: checks, then the count drops', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      size: desktopSize,
      overrides: [sources],
      seed: seedGaps,
    );
    await goTo(tester, AppRoutes.quality);
    expect(countOf(tester, 'noIsbn').data, '3');

    await tester.tap(find.byKey(const Key('startIsbnCompletion')));
    await tester.pumpAndSettle();
    expect(find.text('Livre 1 sur 3'), findsOneWidget);

    // Volume 1: its record fits (series Kaamelott) and completes it.
    await typeCode(tester, k1);
    expect(find.text('Livre 2 sur 3'), findsOneWidget);

    // Already Dune's ISBN: refused.
    await typeCode(tester, duneIsbn);
    expect(find.text('Cet ISBN est déjà celui de « Dune ».'), findsOneWidget);
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(find.text('Livre 2 sur 3'), findsOneWidget);

    // Another title online: kept only once confirmed.
    await typeCode(tester, other);
    expect(
      find.text(
        'Le livre trouvé en ligne est « Le Petit Prince ». Est-ce bien « '
        'Kaamelott » ?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('isbnAssignAnyway')));
    await tester.pumpAndSettle();

    // Volume 3: skipped.
    await tester.tap(find.byKey(const Key('isbnSkip')));
    await tester.pumpAndSettle();
    expect(find.text('Terminé : 2 ISBN enregistrés.'), findsOneWidget);

    final saved = await tester.runAsync(() => db.select(db.itemsTable).get());
    final byId = {for (final i in saved!) i.id: i};
    expect(byId[volumes[0].id]!.isbn13, k1);
    expect(byId[volumes[0].id]!.publisher, 'Casterman');
    expect(byId[volumes[0].id]!.volumeTitle, "L'armée du Nécromant");
    expect(byId[volumes[1].id]!.isbn13, other);
    expect(byId[volumes[2].id]!.isbn13, isNull);

    await goBack(tester);
    expect(countOf(tester, 'noIsbn').data, '1');
  }, variant: linux);

  testWidgets('item sheet: "ISBN manquant" opens the scan for that book', (
    tester,
  ) async {
    await pumpApp(tester, size: desktopSize, seed: seedGaps);
    await goTo(tester, AppRoutes.item(CollectionType.bd, volumes[2].id));
    expect(find.byKey(const Key('missingIsbnChip')), findsOneWidget);

    await tester.tap(find.byKey(const Key('missingIsbnChip')));
    await tester.pumpAndSettle();

    expect(find.text('Livre 1 sur 1'), findsOneWidget);
    expect(find.text('Kaamelott – tome 3'), findsOneWidget);
  }, variant: linux);

  testWidgets('grid: a dot on owned volumes without ISBN, once enabled', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedGaps);
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));
    expect(find.byKey(const ValueKey('noIsbn-1')), findsNothing);

    await goTo(tester, AppRoutes.quality);
    await tester.tap(find.byKey(const Key('missingIsbnGridSwitch')));
    await tester.pumpAndSettle();
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));

    expect(find.byKey(const ValueKey('noIsbn-1')), findsOneWidget);
  });
}
