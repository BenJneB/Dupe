import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/series_lookup.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';

class FakeAniList implements SeriesMetadataProvider {
  String? lastQuery;

  @override
  SeriesSource get seriesSource => SeriesSource.anilist;

  @override
  Future<List<SeriesMetadata>> searchSeries(String query) async {
    lastQuery = query;
    return const [
      SeriesMetadata(
        source: SeriesSource.anilist,
        sourceId: '30013',
        title: 'One Piece',
        originalTitle: 'ONE PIECE',
        authors: ['Eiichirou Oda'],
        status: PublicationStatus.enCours,
        description: 'Pirates.',
      ),
    ];
  }
}

void main() {
  testWidgets('new manga series can be completed from AniList', (tester) async {
    final anilist = FakeAniList();
    final db = await pumpApp(
      tester,
      overrides: [
        seriesLookupProvider.overrideWithValue(SeriesLookup(anilist: anilist)),
      ],
    );

    await tester.tap(find.byKey(const Key('addMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nouvelle série'));
    await tester.pumpAndSettle();
    // Title typed by the user is kept and used as the query.
    await tester.enterText(find.byKey(const Key('titleField')), 'One Piece');
    await tester.tap(find.byKey(const Key('completeFromOnline')));
    await tester.pumpAndSettle();
    expect(anilist.lastQuery, 'One Piece');
    await tester.tap(find.text('One Piece').last);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'ONE PIECE'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    final series = (await db.select(db.seriesTable).get()).single;
    expect(series.authors, ['Eiichirou Oda']);
    expect(series.statusPublication, PublicationStatus.enCours);
    expect(series.externalIds, {'anilist_id': '30013'});
  });

  testWidgets('no lookup button for BD (no series API)', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('BD'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('addMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nouvelle série'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('completeFromOnline')), findsNothing);
  });
}
