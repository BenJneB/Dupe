import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/wishlist/data/wishlist_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' hide Column, Table;

import '../../helpers/app_harness.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';
import '../../helpers/test_repositories.dart';

Future<void> seedWishes(AppDatabase db) async {
  final repo = repoOf(db);
  final onePiece = repo
      .newSeries(CollectionType.manga)
      .copyWith(title: 'One Piece', totalVolumes: 5);
  await repo.saveSeries(onePiece);
  await repo.addVolumeRange(onePiece, from: 1, to: 2);
  await repo.saveItem(
    repo
        .newItem(CollectionType.manga, series: onePiece, volumeNumber: '3')
        .copyWith(
          ownership: Ownership.envie,
          wishlistPriority: 2,
          wishlistMaxPrice: 6.5,
        ),
  );
  // Not followed: no suggestion.
  final naruto = repo
      .newSeries(CollectionType.manga)
      .copyWith(title: 'Naruto', totalVolumes: 3, followed: false);
  await repo.saveSeries(naruto);
  await repo.addVolumeRange(naruto, from: 1, to: 1);
  await repo.saveItem(
    repo
        .newItem(CollectionType.livre)
        .copyWith(
          title: 'Dune',
          ownership: Ownership.envie,
          wishlistPriority: 1,
        ),
  );
}

void main() {
  testWidgets('wishlist by priority, next volumes of followed series', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedWishes);
    await goTo(tester, AppRoutes.wishlist);

    expect(find.text('Envies (2)'), findsOneWidget);
    final dune = tester.getTopLeft(find.text('Dune'));
    final onePiece3 = tester.getTopLeft(find.text('One Piece – tome 3'));
    expect(dune.dy, lessThan(onePiece3.dy));
    expect(find.text('Livres · Priorité 1'), findsOneWidget);
    expect(find.textContaining('Prix max : 6,50'), findsOneWidget);

    // Volume 3 is already wished: only 4 and 5 are suggested.
    expect(find.text('il manque 4, 5'), findsOneWidget);
    expect(find.text('Naruto'), findsNothing);

    await tester.tap(find.text('Ajouter aux envies'));
    await tester.pumpAndSettle();
    expect(find.text('2 tomes ajoutés aux envies'), findsOneWidget);
    expect(find.text('Envies (4)'), findsOneWidget);
    expect(
      find.text('Aucun tome manquant dans tes séries suivies'),
      findsOneWidget,
    );
  });

  testWidgets('swipe a wish away, then undo', (tester) async {
    final db = await pumpApp(tester, seed: seedWishes);
    await goTo(tester, AppRoutes.wishlist);
    Future<int> wishCount() async => (await tester.runAsync(
      () =>
          (db.select(db.itemsTable)..where(
                (t) =>
                    t.ownership.equalsValue(Ownership.envie) &
                    t.deletedAt.isNull(),
              ))
              .get(),
    ))!.length;

    await tester.drag(find.text('Dune'), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(find.text('Dune'), findsNothing);
    expect(find.text('« Dune » retiré des envies'), findsOneWidget);
    expect(await wishCount(), 1);

    await tester.tap(find.byKey(const Key('undoDelete')));
    await tester.pumpAndSettle();
    expect(find.text('Dune'), findsOneWidget);
    expect(await wishCount(), 2);
  });

  test('missing volumes wished twice (double tap): added once', () async {
    final env = TestEnv();
    addTearDown(env.dispose);
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Naruto');
    await env.repo.saveSeries(series);
    final wishlist = WishlistRepository(env.db, env.repo);

    await Future.wait([
      wishlist.wish(series, [2, 3]),
      wishlist.wish(series, [2, 3]),
    ]);

    final items = await env.repo.listSeriesItems(series.id);
    expect(items.map((i) => i.volumeNumber), unorderedEquals(['2', '3']));
  });
}
