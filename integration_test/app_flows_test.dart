import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/helpers/app_harness.dart';
import '../test/helpers/fake_sources.dart';
import '../test/helpers/scan_helpers.dart';
import '../test/helpers/screen_helpers.dart';

/// Key user flows on the real app build (PLAN_V3 phase 18), with simulated
/// metadata sources and no sync. Linux (CI): `xvfb-run flutter test
/// integration_test -d linux`. Phone: see TESTS_MANUELS.md.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const wishedIsbn = '9782070360024';
  const unknownIsbn = '9782290000014';

  testWidgets('a volume is added by hand to a series', (tester) async {
    await pumpApp(tester);
    await createSeries(tester, title: 'Naruto', total: '10', ownedUpTo: '7');
    expect(find.text('7/10 tomes, il manque 8, 9, 10'), findsOneWidget);

    await tester.longPress(find.byKey(const ValueKey('slot-8')));
    await tester.pumpAndSettle();
    expect(find.text('8/10 tomes, il manque 9, 10'), findsOneWidget);
  });

  testWidgets(
    'store mode: owned, wished, missing volume of a series, unknown',
    (tester) async {
      await pumpApp(
        tester,
        size: desktopSize,
        overrides: [
          fakeMetadataSources(byIsbn: {onePieceT3Isbn: onePieceT3}),
        ],
        seed: (db) async {
          final repo = repoOf(db);
          await repo.saveItem(
            repo
                .newItem(CollectionType.livre)
                .copyWith(title: 'Dune', isbn13: duneIsbn),
          );
          await repo.saveItem(
            repo
                .newItem(CollectionType.livre)
                .copyWith(
                  title: 'Envie',
                  isbn13: wishedIsbn,
                  ownership: Ownership.envie,
                ),
          );
          final series = repo
              .newSeries(CollectionType.manga)
              .copyWith(title: 'One Piece', publisher: 'Glénat');
          await repo.saveSeries(series);
          await repo.addVolumeRange(series, from: 1, to: 2);
        },
      );
      await openScan(tester);

      for (final (isbn, verdict) in [
        (duneIsbn, 'owned'),
        (wishedIsbn, 'wished'),
        (onePieceT3Isbn, 'seriesNotOwned'),
        (unknownIsbn, 'unknown'),
      ]) {
        await typeCode(tester, isbn);
        expect(find.byKey(Key('store_$verdict')), findsOneWidget, reason: isbn);
      }
    },
    // On a phone the scan screen opens the camera (permission dialog).
    skip: defaultTargetPlatform == TargetPlatform.android,
  );

  testWidgets('lend a book, then mark it returned', (tester) async {
    late String id;
    await pumpApp(
      tester,
      seed: (db) async {
        final repo = repoOf(db);
        final item = repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
        id = item.id;
        await repo.saveItem(item);
      },
    );
    await goTo(tester, AppRoutes.item(CollectionType.livre, id));

    await tester.tap(find.byKey(const Key('lendButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('borrowerField')), 'Alice');
    await tester.pump();
    await tester.tap(find.byKey(const Key('confirmLend')));
    await tester.pumpAndSettle();
    expect(find.text('Prêté à Alice'), findsOneWidget);

    await tester.tap(find.byKey(const Key('markReturned')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('lendButton')), findsOneWidget);
  });

  testWidgets('a deletion is undone', (tester) async {
    late String id;
    final db = await pumpApp(
      tester,
      seed: (db) async {
        final repo = repoOf(db);
        final item = repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
        id = item.id;
        await repo.saveItem(item);
      },
    );
    await goTo(tester, AppRoutes.item(CollectionType.livre, id));
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('undoDelete')));
    await tester.pumpAndSettle();
    final item = await (db.select(
      db.itemsTable,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(item.deletedAt, isNull);
  });
}
