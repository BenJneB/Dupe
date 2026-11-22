import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/covers/data/missing_covers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_covers.dart';
import '../../helpers/fake_metadata.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

const isbn = '9782266320481';
const pocketCover = 'https://books.google.com/dune-pocket.jpg';
const otherCover = 'https://books.google.com/dune-other.jpg';
const largeCover = 'https://books.google.com/dune-large.jpg';
late Item dune;

Future<void> seedDune(AppDatabase db) async {
  final repo = repoOf(db);
  dune = repo
      .newItem(CollectionType.livre)
      .copyWith(title: 'Dune', authors: ['Frank Herbert'], isbn13: isbn);
  await repo.saveItem(dune);
}

/// ISBN known without image; the text search finds another edition with a
/// cover, and a namesake (other author) that must not be proposed.
final Override sources = metadataAggregatorProvider.overrideWithValue(
  MetadataAggregator(
    providers: [
      FakeProvider(
        MetadataSource.googleBooks,
        isbnResult: const MetadataResult(
          source: MetadataSource.googleBooks,
          sourceId: 'gb',
          title: 'Dune',
        ),
        textResults: const [
          MetadataResult(
            source: MetadataSource.googleBooks,
            sourceId: 'namesake',
            title: 'Dune',
            authors: ['Ann Other'],
            coverUrl: otherCover,
          ),
          MetadataResult(
            source: MetadataSource.googleBooks,
            sourceId: 'pocket',
            title: 'Dune : le cycle de Dune 1',
            authors: ['Frank Herbert'],
            coverUrl: pocketCover,
          ),
          // The same image under another URL: never proposed once refused.
          MetadataResult(
            source: MetadataSource.googleBooks,
            sourceId: 'pocket-zoom',
            title: 'Dune',
            authors: ['Frank Herbert'],
            coverUrl: '$pocketCover?zoom=2',
          ),
          // Another matching edition: next in line once the first is refused.
          MetadataResult(
            source: MetadataSource.googleBooks,
            sourceId: 'large',
            title: 'Dune',
            authors: ['Frank Herbert'],
            coverUrl: largeCover,
          ),
        ],
      ),
    ],
  ),
);

/// The Open Library guess by ISBN: missing (404) for this edition.
FakeCoverCache coversWithoutGuess() => FakeCoverCache()
  ..failing.add(
    'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg?default=false',
  );

Future<void> runFill(WidgetTester tester) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(Scaffold).first),
  );
  await tester.runAsync(
    () => container.read(missingCoversFillProvider.notifier).run(),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('another edition cover: proposed, kept only when approved', (
    tester,
  ) async {
    final covers = coversWithoutGuess();
    final db = await pumpApp(
      tester,
      seed: seedDune,
      overrides: [sources],
      coverCache: covers,
    );
    await runFill(tester);
    await goTo(tester, AppRoutes.quality);

    // Proposed, not applied.
    expect(find.byKey(const Key('qualityCoverProposals')), findsOneWidget);
    Future<String?> coverOf() async =>
        (await tester.runAsync(() => db.select(db.itemsTable).getSingle()))!
            .coverUrl;
    expect(await coverOf(), isNull);

    await tester.tap(find.byKey(const Key('qualityCoverProposals')));
    await tester.pumpAndSettle();
    expect(
      find.text('Trouvée via Google Books : « Dune : le cycle de Dune 1 »'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(ValueKey('keepCover-${dune.id}')));
    await tester.pumpAndSettle();

    expect(await coverOf(), pocketCover);
    expect(find.text('Aucune couverture à valider.'), findsOneWidget);
  });

  testWidgets('a refused image is never proposed again, another one is', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      seed: seedDune,
      overrides: [sources],
      coverCache: coversWithoutGuess(),
    );
    Future<void> refuseProposal() async {
      await goTo(tester, AppRoutes.coverProposals);
      await tester.tap(find.byKey(ValueKey('refuseCover-${dune.id}')));
      await tester.pumpAndSettle();
    }

    await runFill(tester);
    await refuseProposal();
    // Stored on the book, to be synced.
    final stored = await tester.runAsync(
      () => db.select(db.itemsTable).getSingle(),
    );
    expect(stored!.syncPending, isTrue);
    expect(stored.refusedCovers, ['books.google.com/dune-pocket.jpg']);

    // Next pass: the same image under another URL is skipped, another
    // edition's image is proposed.
    await runFill(tester);
    await goTo(tester, AppRoutes.coverProposals);
    expect(find.text('Trouvée via Google Books : « Dune »'), findsOneWidget);
    await refuseProposal();

    // Every matching image refused: nothing left to propose.
    await runFill(tester);
    await goTo(tester, AppRoutes.quality);
    expect(find.byKey(const Key('qualityCoverProposals')), findsNothing);
  });
}
