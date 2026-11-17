import 'dart:convert';

import 'package:dupe/app/router.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_parser.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_http.dart';
import '../../../helpers/fake_suggestion_sources.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

FakeSuggestionSources _sources() => FakeSuggestionSources(
  byAuthor: {
    'Manu Larcenet': parseUnimarcResponse(fixture('bnf/author_larcenet.xml')),
  },
  byTitle: {
    'Vinland Saga': parseAniListNeighbours(
      jsonDecode(fixture('anilist/neighbours_vinland.json'))
          as Map<String, dynamic>,
    )!,
  },
);

Finder _card(String key) => find.byKey(ValueKey('suggestion-$key'));

/// The list is lazy: back to its top (filters), then down to [key].
Future<void> _tap(WidgetTester tester, String key) async {
  await tester.fling(find.byType(ListView), const Offset(0, 3000), 3000);
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.byKey(ValueKey(key)),
    200,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey(key)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('suggestions with reasons; wish, dismiss, filter, refresh', (
    tester,
  ) async {
    final sources = _sources();
    final db = await pumpApp(
      tester,
      suggestionSources: sources,
      seed: (db) async {
        final repo = repoOf(db);
        final combat = repo
            .newSeries(CollectionType.bd)
            .copyWith(title: 'Le combat ordinaire');
        final vinland = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'Vinland Saga');
        await repo.saveSeries(combat);
        await repo.saveSeries(vinland);
        await repo.saveItem(
          repo
              .newItem(CollectionType.bd, series: combat, volumeNumber: '1')
              .copyWith(
                authors: ['Manu Larcenet'],
                readingStatus: ReadingStatus.lu,
                rating: 5,
              ),
        );
        await repo.saveItem(
          repo.newItem(
            CollectionType.manga,
            series: vinland,
            volumeNumber: '1',
          ),
        );
      },
    );

    await goTo(tester, AppRoutes.more);
    await tester.tap(find.byKey(const Key('moreSuggestions')));
    await tester.pumpAndSettle();

    // Computed on first opening: the author at the BnF, the manga on AniList.
    expect(sources.calls, ['author:Manu Larcenet', 'manga:Vinland Saga']);
    expect(_card('work:blast'), findsOneWidget);
    expect(find.text('Parce que tu as 1 livre de Manu Larcenet'), findsWidgets);
    expect(find.textContaining('Calculées le'), findsOneWidget);

    // Add Blast to the wishes: volume 1 of a new series, not followed.
    await _tap(tester, 'wishSuggestion-work:blast');
    expect(find.text('« Blast » ajouté aux envies'), findsOneWidget);
    expect(_card('work:blast'), findsNothing);
    final wish = await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.title.equals('Blast'))).getSingle(),
    );
    expect((wish!.ownership, wish.volumeNumber), (Ownership.envie, '1'));
    final blast = await tester.runAsync(
      () => (db.select(
        db.seriesTable,
      )..where((t) => t.title.equals('Blast'))).getSingle(),
    );
    expect(blast!.followed, isFalse);

    // Manga only, then dismiss Vagabond (AniList id 30656).
    await _tap(tester, 'suggestionType-manga');
    expect(_card('work:blast'), findsNothing);
    expect(find.textContaining('Les lecteurs de Vinland Saga'), findsWidgets);
    await _tap(tester, 'dismissSuggestion-anilist:30656');
    expect(_card('anilist:30656'), findsNothing);
    final feedback = await tester.runAsync(
      () => db.select(db.recommendationFeedbackTable).getSingle(),
    );
    expect(
      (feedback!.suggestionKey, feedback.reasonKind, feedback.syncPending),
      ('anilist:30656', 'community', true),
    );

    // Computed again: neither the wish nor the dismissed one come back.
    await tester.tap(find.byKey(const Key('refreshSuggestions')));
    await tester.pumpAndSettle();
    expect(sources.calls, hasLength(4));
    expect(_card('anilist:30656'), findsNothing);
    await _tap(tester, 'suggestionType-bd');
    expect(_card('work:blast'), findsNothing);
  });

  testWidgets('cached a week: no new lookup when opened again', (tester) async {
    final sources = _sources();
    await pumpApp(tester, suggestionSources: sources);
    await goTo(tester, AppRoutes.suggestions);
    expect(sources.calls, isEmpty, reason: 'empty collection');
    expect(find.textContaining('Aucune suggestion'), findsOneWidget);

    await goTo(tester, AppRoutes.more);
    await goTo(tester, AppRoutes.suggestions);
    expect(sources.calls, isEmpty);
  });
}
