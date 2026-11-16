import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/metadata/series_lookup.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_count.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

/// AniList answering "One Piece" with 107 volumes (Japanese edition).
class FakeAniList implements SeriesMetadataProvider {
  int calls = 0;

  @override
  SeriesSource get seriesSource => SeriesSource.anilist;

  @override
  Future<List<SeriesMetadata>> searchSeries(String query) async {
    calls++;
    return const [
      SeriesMetadata(
        source: SeriesSource.anilist,
        sourceId: '1',
        title: 'One Piece Film',
        totalVolumes: 1,
      ),
      SeriesMetadata(
        source: SeriesSource.anilist,
        sourceId: '30013',
        title: 'ONE PIECE',
        totalVolumes: 107,
      ),
    ];
  }
}

late Series onePiece;
late Series kaamelott;

Future<void> seedSeries(AppDatabase db) async {
  final repo = repoOf(db);
  onePiece = repo.newSeries(CollectionType.manga).copyWith(title: 'One Piece');
  kaamelott = repo.newSeries(CollectionType.bd).copyWith(title: 'Kaamelott');
  await repo.saveSeries(onePiece);
  await repo.saveSeries(kaamelott);
}

Series series(String title, {String? original}) => Series(
  id: 's',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  type: CollectionType.manga,
  title: title,
  originalTitle: original,
);

SeriesMetadata result(String title, int? total) => SeriesMetadata(
  source: SeriesSource.anilist,
  sourceId: title,
  title: title,
  totalVolumes: total,
);

void main() {
  test('only an exact title with a total is proposed', () {
    final results = [result('One Piece Film', 1), result('One Piece', 107)];
    expect(matchSeriesTotal(series('One piece'), results)?.totalVolumes, 107);
    expect(matchSeriesTotal(series('Naruto'), results), isNull);
    expect(
      matchSeriesTotal(series('One Piece'), [result('One Piece', null)]),
      isNull,
    );
  });

  testWidgets('series menu: check the total, confirm, missing volumes shown', (
    tester,
  ) async {
    final anilist = FakeAniList();
    final db = await pumpApp(
      tester,
      seed: seedSeries,
      seriesLookup: SeriesLookup(anilist: anilist),
    );
    await goTo(tester, AppRoutes.series(CollectionType.manga, onePiece.id));

    await tester.tap(find.byKey(const Key('seriesMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('checkTotalAction')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'AniList : « ONE PIECE », 107 tomes (nombre de l’édition japonaise)',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('saveSeriesTotal')));
    await tester.pumpAndSettle();

    final saved = await tester.runAsync(
      () => (db.select(
        db.seriesTable,
      )..where((t) => t.id.equals(onePiece.id))).getSingle(),
    );
    expect(saved!.totalVolumes, 107);
    expect(find.text('One Piece : 107 tomes'), findsOneWidget);
  });

  testWidgets('no series source for BD: no "check" action', (tester) async {
    await pumpApp(
      tester,
      seed: seedSeries,
      seriesLookup: SeriesLookup(anilist: FakeAniList()),
    );
    await goTo(tester, AppRoutes.series(CollectionType.bd, kaamelott.id));
    await tester.tap(find.byKey(const Key('seriesMenu')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('checkTotalAction')), findsNothing);
  });

  testWidgets('first volume: the total is asked, prefilled by AniList', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      seed: seedSeries,
      seriesLookup: SeriesLookup(anilist: FakeAniList()),
    );
    await goTo(
      tester,
      AppRoutes.newItem(
        CollectionType.manga,
        seriesId: onePiece.id,
        volume: '1',
      ),
    );
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    expect(find.text('Combien de tomes compte la série ?'), findsOneWidget);
    expect(find.widgetWithText(TextField, '107'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveSeriesTotal')));
    await tester.pumpAndSettle();

    final saved = await tester.runAsync(
      () => (db.select(
        db.seriesTable,
      )..where((t) => t.id.equals(onePiece.id))).getSingle(),
    );
    expect(saved!.totalVolumes, 107);
  });

  testWidgets('"Plus tard" keeps the total unknown', (tester) async {
    final db = await pumpApp(tester, seed: seedSeries);
    await goTo(
      tester,
      AppRoutes.newItem(CollectionType.bd, seriesId: kaamelott.id, volume: '1'),
    );
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();
    // No source for BD: asked without suggestion.
    final field = tester.widget<TextField>(
      find.byKey(const Key('seriesTotalField')),
    );
    expect(field.controller!.text, isEmpty);
    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();

    final saved = await tester.runAsync(
      () => (db.select(
        db.seriesTable,
      )..where((t) => t.id.equals(kaamelott.id))).getSingle(),
    );
    expect(saved!.totalVolumes, isNull);
    expect(find.text('Combien de tomes compte la série ?'), findsNothing);
  });

  testWidgets('settings: check every series, uncheck one, apply the rest', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      seed: (db) async {
        await seedSeries(db);
        final repo = repoOf(db);
        await repo.saveSeries(
          repo.newSeries(CollectionType.manga).copyWith(title: 'Inconnue'),
        );
        await repo.saveSeries(
          repo
              .newSeries(CollectionType.manga)
              .copyWith(title: 'one piece', totalVolumes: 3),
        );
      },
      seriesLookup: SeriesLookup(anilist: FakeAniList()),
    );
    await goTo(tester, AppRoutes.volumeCounts);
    await tester.tap(find.byKey(const Key('volumeCountsRun')));
    await tester.pumpAndSettle();

    // 2 manga series without total (Kaamelott is a BD: no source; the
    // series with a total is not checked); only One Piece matches.
    expect(
      find.text('2 séries vérifiées · 1 nombre(s) de tomes trouvé(s)'),
      findsOneWidget,
    );
    expect(find.text('One Piece : 107 tomes'), findsOneWidget);
    await tester.tap(find.byKey(const Key('volumeCountsApply')));
    await tester.pumpAndSettle();

    expect(find.text('1 série mise à jour'), findsOneWidget);
    final totals = await tester.runAsync(
      () => db.select(db.seriesTable).map((s) => s.totalVolumes).get(),
    );
    expect(totals, unorderedEquals([107, null, null, 3]));
  });
}
