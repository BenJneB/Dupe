import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';
import '../../../helpers/scan_helpers.dart';

/// Scan [isbn] from the Mangas tab and add the result to the collection.
Future<void> scanAndAdd(WidgetTester tester, String isbn) async {
  await openScan(tester);
  await typeCode(tester, isbn);
  await tester.tap(find.byKey(const Key('addOwned')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('scanning volume 3 files it in the existing series '
      '(phase 3 criterion)', (tester) async {
    late Series series;
    final db = await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources(result: onePieceT3)],
      seed: (db) async {
        final repo = repoOf(db);
        series = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'One Piece', publisher: 'Glénat', totalVolumes: 5);
        await repo.saveSeries(series);
        await repo.addVolumeRange(series, from: 1, to: 2);
      },
    );

    await scanAndAdd(tester, onePieceT3Isbn);
    expect(find.text('Série : One Piece'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    // Lands on the series sheet, volume 3 now owned.
    expect(find.text('3/5 tomes, il manque 4, 5'), findsOneWidget);
    final items = await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.volumeNumber.equals('3'))).get(),
    );
    expect(items!.single.seriesId, series.id);
    expect(items.single.isbn13, onePieceT3Isbn);
  }, variant: linux);

  testWidgets('first volume of an unknown series creates the series', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources(result: onePieceT3)],
    );

    await scanAndAdd(tester, onePieceT3Isbn);
    expect(find.text('Créer la série « One Piece »'), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    final series = await db.select(db.seriesTable).get();
    expect(series.single.title, 'One Piece');
    expect(series.single.type, CollectionType.manga);
    expect(series.single.publisher, 'Glénat');
    expect(find.text('1 tome, il manque 1, 2'), findsOneWidget);
  }, variant: linux);
}
