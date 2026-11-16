import 'package:cached_network_image/cached_network_image.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

const cover = 'https://example.com/kaamelott-1.jpg';

late Series kaamelott;

/// A series created while scanning: no cover of its own, volume 1 has one.
Future<void> seedKaamelott(AppDatabase db) async {
  final repo = repoOf(db);
  kaamelott = repo.newSeries(CollectionType.bd).copyWith(title: 'Kaamelott');
  await repo.saveSeries(kaamelott);
  for (final n in ['2', '1']) {
    await repo.saveItem(
      repo
          .newItem(CollectionType.bd, series: kaamelott, volumeNumber: n)
          .copyWith(title: 'Kaamelott', coverUrl: n == '1' ? cover : null),
    );
  }
}

Iterable<String> shownCovers(WidgetTester tester) => tester
    .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
    .map((w) => w.imageUrl);

Future<void> systemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('back from a series reached by "Voir la série" goes to the tab', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedKaamelott);
    await goTo(tester, AppRoutes.base(CollectionType.bd));
    // The series row shows the cover of volume 1.
    expect(shownCovers(tester), [cover]);

    await tester.tap(find.text('Kaamelott'));
    await tester.pumpAndSettle();
    final seriesScreen = find.byKey(const Key('addVolumes'));
    expect(seriesScreen, findsOneWidget);
    expect(shownCovers(tester), contains(cover));

    await tester.tap(find.byKey(const ValueKey('slot-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voir la série'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('slot-2')));
    await tester.pumpAndSettle();
    expect(seriesScreen, findsNothing);

    await systemBack(tester);
    expect(seriesScreen, findsOneWidget);
    await systemBack(tester);
    // Back on the BD tab, not on volume 1.
    expect(seriesScreen, findsNothing);
    expect(find.text('Kaamelott'), findsOneWidget);
    expect(find.text('Voir la série'), findsNothing);
  });

  testWidgets('a tab always opens on its list', (tester) async {
    await pumpApp(tester, seed: seedKaamelott);
    await goTo(tester, AppRoutes.base(CollectionType.bd));
    await tester.tap(find.text('Kaamelott'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('addVolumes')), findsOneWidget);

    await tester.tap(find.text('Plus').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('BD').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('addVolumes')), findsNothing);
    expect(find.text('Kaamelott'), findsOneWidget);
  });

  testWidgets('adding volume N offers to add the missing ones before it', (
    tester,
  ) async {
    final db = await pumpApp(tester, seed: seedKaamelott);
    await goTo(
      tester,
      AppRoutes.newItem(CollectionType.bd, seriesId: kaamelott.id, volume: '5'),
    );
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    // Volumes 1 and 2 exist: 3 and 4 are missing.
    expect(
      find.text(
        'Il te manque 2 tomes avant le 5 : les ajouter comme possédés ?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('addPreviousVolumes')));
    await tester.pumpAndSettle();

    expect(find.text('2 tomes ajoutés'), findsOneWidget);
    final volumes = await tester.runAsync(
      () =>
          (db.select(db.itemsTable)
                ..where((t) => t.seriesId.equals(kaamelott.id)))
              .map((i) => i.volumeNumber)
              .get(),
    );
    expect(volumes!.toSet(), {'1', '2', '3', '4', '5'});
  });

  testWidgets('the grid legend is above the volumes', (tester) async {
    await pumpApp(tester, seed: seedKaamelott);
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));

    final legend = tester.getTopLeft(find.text('Manquant'));
    final firstVolume = tester.getTopLeft(find.byKey(const ValueKey('slot-1')));
    expect(legend.dy, lessThan(firstVolume.dy));
  });

  testWidgets('series without total: grey hint bar; with a total: real bar', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (db) async {
        final repo = repoOf(db);
        // Created by scans: volumes 1 and 3, total unknown.
        final fowl = repo.newSeries(CollectionType.bd).copyWith(title: 'Fowl');
        await repo.saveSeries(fowl);
        for (final n in ['1', '3']) {
          await repo.saveItem(
            repo.newItem(CollectionType.bd, series: fowl, volumeNumber: n),
          );
        }
        final naruto = repo
            .newSeries(CollectionType.bd)
            .copyWith(title: 'Naruto', totalVolumes: 4);
        await repo.saveSeries(naruto);
        await repo.addVolumeRange(naruto, from: 1, to: 2);
      },
    );
    await goTo(tester, AppRoutes.base(CollectionType.bd));

    final hint = tester.widget<LinearProgressIndicator>(
      find.byKey(const Key('indicativeProgress')),
    );
    expect(hint.value, closeTo(2 / 3, 0.001));
    final bars = tester
        .widgetList<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        )
        .map((b) => b.value)
        .toList();
    expect(bars, unorderedEquals([closeTo(2 / 3, 0.001), 0.5]));
  });

  testWidgets('volumes as a list: own titles and status, choice remembered', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (db) async {
        await seedKaamelott(db);
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.bd, series: kaamelott, volumeNumber: '9')
              .copyWith(
                title: 'Les renforts maléfiques',
                readingStatus: ReadingStatus.lu,
              ),
        );
      },
    );
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));
    await tester.tap(find.byKey(const Key('toggleVolumeView')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('volumeList')), findsOneWidget);
    expect(find.text('Tome 9'), findsOneWidget);
    expect(find.text('Les renforts maléfiques · Possédé · Lu'), findsOneWidget);
    // Same title as the series: not repeated.
    expect(find.text('Possédé'), findsNWidgets(2));
    await tester.scrollUntilVisible(
      find.text('Tome 3'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Manquant'), findsWidgets);

    // Leaving and coming back keeps the list.
    await goBack(tester);
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));
    expect(find.byKey(const Key('volumeList')), findsOneWidget);
  });
}
