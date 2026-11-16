import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';
import '../../../helpers/scan_helpers.dart';

/// Burst-scans One Piece 3 and 4 (unknown series) and an unknown ISBN.
Future<AppDatabase> scanShelf(WidgetTester tester) async {
  final db = await pumpApp(
    tester,
    size: desktopSize,
    overrides: [
      fakeMetadataSources(
        byIsbn: {onePieceT3Isbn: onePieceT3, onePieceT4Isbn: onePieceT4},
      ),
    ],
  );
  await openScan(tester);
  await tester.tap(find.text('Rafale'));
  await tester.pumpAndSettle();

  await typeCode(tester, onePieceT3Isbn);
  expect(find.text('Ajouté à la file (1)'), findsOneWidget);
  await typeCode(tester, onePieceT4Isbn);
  await typeCode(tester, onePieceT3Isbn);
  expect(find.text('Déjà dans la file'), findsOneWidget);
  await typeCode(tester, duneIsbn);

  expect(find.text('3/3 recherchés'), findsOneWidget);
  await tester.tap(find.byKey(const Key('burstReviewButton')));
  await tester.pumpAndSettle();
  return db;
}

void main() {
  testWidgets('burst scans are looked up in the background, reviewed, then '
      'added in one go into a new series', (tester) async {
    final db = await scanShelf(tester);

    expect(find.text('Nouvelle série « One Piece »'), findsNWidgets(2));
    expect(find.text('Introuvable : appuie pour chercher'), findsOneWidget);
    await tester.tap(find.byKey(const Key('burstAddAll')));
    await tester.pumpAndSettle();

    expect(find.text('2 ouvrages ajoutés'), findsOneWidget);
    final result = await tester.runAsync(() async {
      final series = await db.select(db.seriesTable).get();
      final items = await db.select(db.itemsTable).get();
      final queue = await db.select(db.scanQueueTable).get();
      return (series: series, items: items, queue: queue);
    });
    expect(result!.series.single.title, 'One Piece');
    expect(
      result.items.map((i) => i.volumeNumber),
      unorderedEquals(['3', '4']),
    );
    expect(result.items.map((i) => i.seriesId).toSet(), {
      result.series.single.id,
    });
    // The unknown ISBN stays in the queue, to search by hand.
    expect(result.queue.single.isbn13, duneIsbn);
  }, variant: linux);

  testWidgets('an entry corrected from the review is marked as added', (
    tester,
  ) async {
    await scanShelf(tester);

    await tester.tap(find.text('One Piece – tome 3'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    // Back on the review screen.
    expect(find.text('Déjà dans ta collection'), findsOneWidget);
    expect(find.text('Ajouter 1 ouvrage'), findsOneWidget);
  }, variant: linux);

  testWidgets('a volume added without ISBN is completed, not duplicated', (
    tester,
  ) async {
    late String emptyId;
    final db = await pumpApp(
      tester,
      size: desktopSize,
      overrides: [
        fakeMetadataSources(byIsbn: {onePieceT3Isbn: onePieceT3}),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        final series = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'One Piece');
        await repo.saveSeries(series);
        final empty = repo.newItem(
          CollectionType.manga,
          series: series,
          volumeNumber: '3',
        );
        emptyId = empty.id;
        await repo.saveItem(empty);
      },
    );
    await openScan(tester);
    await tester.tap(find.text('Rafale'));
    await tester.pumpAndSettle();
    await typeCode(tester, onePieceT3Isbn);
    await tester.tap(find.byKey(const Key('burstReviewButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('burstAddAll')));
    await tester.pumpAndSettle();

    final items = await tester.runAsync(() => db.select(db.itemsTable).get());
    final volume = items!.single;
    expect(volume.id, emptyId);
    expect(volume.isbn13, onePieceT3Isbn);
    expect(volume.publisher, 'Glénat');
  }, variant: linux);
}
