import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_metadata.dart';
import '../../helpers/fake_sources.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

const k1 = '9782203370166';
const other = '9782070612758';
const k4 = '9782203001343';
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
    k4: const MetadataResult(
      source: MetadataSource.bnf,
      sourceId: 'k4',
      title: 'Le duel',
      seriesTitle: 'Kaamelott',
      volumeNumber: '4',
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

    // Volume 4 of the same series on volume 3: warned, then cancelled.
    await typeCode(tester, k4);
    expect(
      find.text(
        'Le livre trouvé en ligne est le tome 4, pas le tome 3. Garder quand '
        'même cet ISBN ?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Annuler'));
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

  testWidgets('a code scanned during the online check is not lost', (
    tester,
  ) async {
    const k2 = '9782203001350';
    MetadataResult volume(String n) => MetadataResult(
      source: MetadataSource.bnf,
      sourceId: 'k$n',
      title: 'Kaamelott',
      volumeNumber: n,
    );
    await pumpApp(
      tester,
      size: desktopSize,
      seed: seedGaps,
      overrides: [
        metadataAggregatorProvider.overrideWithValue(
          MetadataAggregator(
            providers: [
              FakeProvider(
                MetadataSource.bnf,
                byIsbn: {k1: volume('1'), k2: volume('2')},
                delay: const Duration(seconds: 2),
              ),
            ],
          ),
        ),
      ],
    );
    await goTo(tester, AppRoutes.quality);
    await tester.tap(find.byKey(const Key('startIsbnCompletion')));
    await tester.pumpAndSettle();

    final field = find.byKey(const Key('codeEntryField'));
    await tester.enterText(field, k1);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(milliseconds: 500));
    // Next book scanned while the first one is still being checked.
    await tester.enterText(field, k2);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(find.text('Livre 3 sur 3'), findsOneWidget);
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

  testWidgets('missing ISBNs marked by default: dot on volumes, icon above', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedGaps);
    // Series row: one icon for its 3 owned volumes without ISBN.
    await goTo(tester, AppRoutes.base(CollectionType.bd));
    expect(find.byKey(const Key('missingIsbnMark')), findsOneWidget);
    expect(find.byTooltip('3 livres possédés sans ISBN'), findsOneWidget);
    // Dune has its ISBN: no icon in Livres.
    await goTo(tester, AppRoutes.base(CollectionType.livre));
    expect(find.byKey(const Key('missingIsbnMark')), findsNothing);
    // Volumes: a dot on each pastille.
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));
    expect(find.byKey(const ValueKey('noIsbn-1')), findsOneWidget);
    // List view of the volumes: an icon on each row too.
    await tester.tap(find.byKey(const Key('toggleVolumeView')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('missingIsbnMark')), findsNWidgets(3));
    await tester.tap(find.byKey(const Key('toggleVolumeView')));
    await tester.pumpAndSettle();

    // Turned off in Qualité: no marker anywhere.
    await goTo(tester, AppRoutes.quality);
    await tester.tap(find.byKey(const Key('missingIsbnGridSwitch')));
    await tester.pumpAndSettle();
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));
    expect(find.byKey(const ValueKey('noIsbn-1')), findsNothing);
    await goTo(tester, AppRoutes.base(CollectionType.bd));
    expect(find.byKey(const Key('missingIsbnMark')), findsNothing);
  });
}
