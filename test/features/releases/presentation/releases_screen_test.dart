import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_http.dart';
import '../../../helpers/fake_release_notifications.dart';
import '../../../helpers/fake_series_catalog.dart';
import '../../../helpers/fake_suggestion_sources.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

Future<void> _check(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('checkReleases')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('followed series: next volumes, wished or ignored, once', (
    tester,
  ) async {
    final notifications = FakeReleaseNotifications();
    final everdark = parseUnimarcResponse(fixture('bnf/series_everdark.xml'));
    final db = await pumpApp(
      tester,
      releaseNotifications: notifications,
      seriesCatalog: FakeSeriesCatalogSource(byTitle: {'Everdark': everdark}),
      seed: (db) async {
        final repo = repoOf(db);
        final s = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'Everdark', publisher: 'Pika');
        await repo.saveSeries(s);
        for (var n = 1; n <= 5; n++) {
          await repo.saveItem(
            repo.newItem(CollectionType.manga, series: s, volumeNumber: '$n'),
          );
        }
      },
    );
    await goTo(tester, AppRoutes.more);
    await tester.tap(find.byKey(const Key('moreReleases')));
    await tester.pumpAndSettle();
    // First check: volumes 6 and 7 are already out, missing but not new.
    await _check(tester);
    expect(find.text('Aucune nouveauté'), findsOneWidget);
    expect(notifications.shown, isEmpty);

    final seven = everdark.firstWhere((r) => r.volumeNumber == '7');
    everdark.addAll([
      for (final n in [8, 9])
        seven.copyWith(sourceId: 'v$n', volumeNumber: '$n', isbn13: '97828$n'),
    ]);
    await _check(tester);
    expect(find.text('2 nouveautés'), findsOneWidget);
    expect(notifications.shown, [2]);
    expect(find.text('Everdark, tome 8'), findsOneWidget);
    expect(find.text('Everdark, tome 9'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Everdark, tome'), findsNothing);
    final wish = await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.ownership.equalsValue(Ownership.envie))).getSingle(),
    );
    expect(wish!.isbn13, isNotNull);
    final statuses = await tester.runAsync(
      () => db.select(db.releaseAlertsTable).get(),
    );
    expect(statuses!.map((a) => a.status).toSet(), {
      AlertStatus.ajoute,
      AlertStatus.ignore,
    });

    // Checked again: the wished volume is known, the ignored one stays out.
    await _check(tester);
    expect(find.text('Aucune nouveauté'), findsOneWidget);
    expect(notifications.shown, [2]);
  });

  testWidgets('followed author: the books out after the first check', (
    tester,
  ) async {
    final larcenet = <MetadataResult>[];
    final sources = FakeSuggestionSources(
      byAuthor: {'Manu Larcenet': larcenet},
    );
    await pumpApp(
      tester,
      suggestionSources: sources,
      overrides: [
        clockProvider.overrideWithValue(() => DateTime(2026, 11, 20, 10)),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.bd)
              .copyWith(title: 'Blast', authors: ['Manu Larcenet']),
        );
      },
    );
    await goTo(tester, '/bd/auteur?nom=Manu%20Larcenet');
    await tester.tap(find.byKey(const Key('followAuthor')));
    await tester.pumpAndSettle();

    await goTo(tester, AppRoutes.releases);
    // Source off or failing: nothing found is no reference.
    await _check(tester);
    larcenet.addAll(parseUnimarcResponse(fixture('bnf/author_larcenet.xml')));
    // First real check: only the recent books not owned (Gymnographies,
    // 2025; Blast is owned, even in other editions; older ones are not
    // news), then what exists is the reference.
    await _check(tester);
    expect(find.text('1 nouveauté'), findsOneWidget);
    expect(find.text('Gymnographies'), findsOneWidget);
    expect(find.text('Le combat ordinaire'), findsNothing);

    larcenet.add(
      const MetadataResult(
        source: MetadataSource.bnf,
        sourceId: 'new',
        title: 'Le nouveau Larcenet',
        isbn13: '9782205000000',
        authors: ['Manu Larcenet'],
      ),
    );
    await _check(tester);
    expect(find.text('1 nouveauté'), findsOneWidget);
    expect(find.text('Le nouveau Larcenet'), findsOneWidget);
    // A re-edition of a work already seen (new ISBN) is not news.
    larcenet.add(
      const MetadataResult(
        source: MetadataSource.bnf,
        sourceId: 'reprint',
        title: 'Gymnographies',
        isbn13: '9782205000017',
        authors: ['Manu Larcenet'],
      ),
    );
    await _check(tester);
    expect(find.text('Aucune nouveauté'), findsOneWidget);
  });

  testWidgets('a reference saved by the 1362cca build (sorted key) is used', (
    tester,
  ) async {
    final sources = FakeSuggestionSources(
      byAuthor: {
        'Manu Larcenet': [
          const MetadataResult(
            source: MetadataSource.bnf,
            sourceId: 'new',
            title: 'Le nouveau Larcenet',
            isbn13: '9782205000000',
            authors: ['Manu Larcenet'],
          ),
        ],
      },
    );
    await pumpApp(
      tester,
      suggestionSources: sources,
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.bd)
              .copyWith(title: 'Blast', authors: ['Manu Larcenet']),
        );
        await AppSettingsStore(db).set('releases_seen_larcenet manu', '[]');
      },
    );
    await goTo(tester, '/bd/auteur?nom=Manu%20Larcenet');
    await tester.tap(find.byKey(const Key('followAuthor')));
    await tester.pumpAndSettle();

    await goTo(tester, AppRoutes.releases);
    await _check(tester);
    expect(find.text('1 nouveauté'), findsOneWidget);
  });
}
