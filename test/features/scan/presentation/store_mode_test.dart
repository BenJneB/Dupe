import 'dart:io';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';
import '../../../helpers/scan_helpers.dart';

const offline = SocketException('Network is unreachable');

/// One Piece (Glénat) with volumes 1 and 2 owned, without ISBN (added
/// from the grid).
Future<void> seedOnePiece(AppDatabase db) async {
  final repo = repoOf(db);
  final series = repo
      .newSeries(CollectionType.manga)
      .copyWith(title: 'One Piece', publisher: 'Glénat');
  await repo.saveSeries(series);
  await repo.addVolumeRange(series, from: 1, to: 2);
}

void main() {
  testWidgets('an owned ISBN is recognised offline, with purchase details '
      '(phase 4 criterion)', (tester) async {
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources(error: offline)],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.livre)
              .copyWith(
                title: 'Dune',
                isbn13: duneIsbn,
                purchaseDate: DateTime(2024, 3, 12),
                location: 'Salon, étagère 2',
              ),
        );
      },
    );

    await openScan(tester);
    // From the scanned code to the verdict: the start of the test app
    // depends on the machine load, not on the store check.
    final stopwatch = Stopwatch()..start();
    await typeCode(tester, duneIsbn);

    expect(find.byKey(const Key('store_owned')), findsOneWidget);
    expect(find.text('Déjà possédé'), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Acheté le 12 mars 2024'), findsOneWidget);
    expect(find.text('Emplacement : Salon, étagère 2'), findsOneWidget);
    // Simulated time does not measure real speed; this bounds the real
    // time of the local lookup in the test environment.
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 3)));
  }, variant: linux);

  testWidgets('a wished ISBN shows the max price', (tester) async {
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources(error: offline)],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.livre)
              .copyWith(
                title: 'Dune',
                isbn13: duneIsbn,
                ownership: Ownership.envie,
                wishlistMaxPrice: 7.5,
              ),
        );
      },
    );

    await openScan(tester);
    await typeCode(tester, duneIsbn);

    expect(find.byKey(const Key('store_wished')), findsOneWidget);
    expect(find.textContaining('Prix max : 7,50'), findsOneWidget);
  }, variant: linux);

  testWidgets('next volume of a series: blue banner with owned volumes', (
    tester,
  ) async {
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources(result: onePieceT3)],
      seed: seedOnePiece,
    );

    await openScan(tester);
    await typeCode(tester, onePieceT3Isbn);

    expect(find.byKey(const Key('store_seriesNotOwned')), findsOneWidget);
    expect(find.text('Tome 3 de One Piece'), findsOneWidget);
    expect(find.text('tu as 1, 2'), findsOneWidget);
    expect(find.byKey(const Key('addOwned')), findsOneWidget);

    // Phase 37: the whole series from the BnF, its menu prefilled.
    await tester.tap(find.byKey(const Key('storeWholeSeries')));
    await tester.pumpAndSettle();
    expect(find.text('Série complète'), findsOneWidget);
    expect(find.text('Compléter depuis la BnF'), findsNothing);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('catalogQuery')))
          .controller!
          .text,
      'One Piece',
    );
  }, variant: linux);

  testWidgets('a volume owned without ISBN is recognised by series and '
      'number, and its ISBN is remembered', (tester) async {
    final db = await pumpApp(
      tester,
      size: desktopSize,
      overrides: [
        fakeMetadataSources(result: onePieceT3.copyWith(volumeNumber: '2')),
      ],
      seed: seedOnePiece,
    );

    await openScan(tester);
    await typeCode(tester, onePieceT3Isbn);

    expect(find.byKey(const Key('store_owned')), findsOneWidget);
    expect(
      find.text('ISBN mémorisé sur ce tome pour les prochains scans'),
      findsOneWidget,
    );
    final volume2 = await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.volumeNumber.equals('2'))).getSingle(),
    );
    expect(volume2!.isbn13, onePieceT3Isbn);
    // Its empty fields are completed (recette: WARP 1-2 left empty).
    expect(volume2.authors, ['Eiichirō Oda']);
    expect(volume2.publisher, 'Glénat');
  }, variant: linux);

  testWidgets('unknown ISBN offline: grey banner and online search button', (
    tester,
  ) async {
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fakeMetadataSources(error: offline)],
    );

    await openScan(tester);
    await typeCode(tester, duneIsbn);

    expect(find.byKey(const Key('store_unknown')), findsOneWidget);
    expect(
      find.text('Hors ligne : seule ta collection a été vérifiée'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('storeOnlineSearch')), findsOneWidget);
    // Not a series volume: no whole series to offer.
    expect(find.byKey(const Key('storeWholeSeries')), findsNothing);
  }, variant: linux);

  testWidgets('a series volume without number shows its own title', (
    tester,
  ) async {
    // Like BnF 9782075173827: series known, no volume number.
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [
        fakeMetadataSources(
          result: onePieceT3.copyWith(
            title: 'Romance Dawn',
            seriesTitle: 'One Piece',
            volumeNumber: null,
          ),
        ),
      ],
      seed: seedOnePiece,
    );

    await openScan(tester);
    await typeCode(tester, onePieceT3Isbn);

    expect(find.text('Romance Dawn — série One Piece'), findsOneWidget);
    expect(find.textContaining('Tome ?'), findsNothing);
  }, variant: linux);

  testWidgets('scan opened outside a tab: type chosen and remembered', (
    tester,
  ) async {
    await pumpApp(tester, size: desktopSize);
    await tester.tap(find.text('Plus').last);
    await tester.pumpAndSettle();
    await openScan(tester);
    final menu = find.byKey(const Key('scanTypeMenu'));
    expect(
      find.descendant(of: menu, matching: find.text('Livres')),
      findsOneWidget,
    );

    await tester.tap(menu);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('scanType_bd')));
    await tester.pumpAndSettle();
    await goBack(tester);
    await openScan(tester);

    expect(
      find.descendant(of: menu, matching: find.text('BD')),
      findsOneWidget,
    );
  }, variant: linux);

  testWidgets('a standalone book owned in another edition (title + author)', (
    tester,
  ) async {
    // Owned: Dune, large format, no ISBN known for the pocket one.
    const pocket = '9782266320481';
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [
        fakeMetadataSources(
          byIsbn: {
            pocket: const MetadataResult(
              source: MetadataSource.bnf,
              sourceId: 'p',
              title: 'Dune',
              authors: ['Frank Herbert'],
              publisher: 'Pocket',
            ),
            '9782070612758': const MetadataResult(
              source: MetadataSource.bnf,
              sourceId: 'n',
              title: 'Dune',
              authors: ['Ann Other'],
            ),
          },
        ),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.livre)
              .copyWith(
                title: 'Dune',
                authors: ['Frank Herbert'],
                publisher: 'Robert Laffont',
              ),
        );
      },
    );

    await openScan(tester);
    await typeCode(tester, pocket);
    expect(find.byKey(const Key('store_owned')), findsOneWidget);
    expect(find.text('Tu as ce livre dans une autre édition'), findsOneWidget);

    // Same title by someone else: not "already owned".
    await typeCode(tester, '9782070612758');
    expect(find.byKey(const Key('store_owned')), findsNothing);
  }, variant: linux);
}
