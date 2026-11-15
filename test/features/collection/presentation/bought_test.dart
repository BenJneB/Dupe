import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/fake_sources.dart';
import '../../../helpers/scan_helpers.dart';

late Item wish;

Future<void> seedWish(AppDatabase db) async {
  final repo = repoOf(db);
  wish = repo
      .newItem(CollectionType.livre)
      .copyWith(
        title: 'Dune',
        isbn13: duneIsbn,
        coverPrice: 11.95,
        ownership: Ownership.envie,
        wishlistPriority: 1,
      );
  await repo.saveItem(wish);
}

Future<Item> reload(WidgetTester tester, AppDatabase db) async =>
    (await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.id.equals(wish.id))).getSingle(),
    ))!;

final today = DateTime(2026, 11, 14, 15, 30);

void main() {
  testWidgets('"Je l\'ai acheté" from the wishlist, with the price paid', (
    tester,
  ) async {
    final db = await pumpApp(
      tester,
      seed: seedWish,
      overrides: [clockProvider.overrideWithValue(() => today)],
    );
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first))
        .read(appRouterProvider)
        .go(AppRoutes.wishlist);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ValueKey('bought-${wish.id}')));
    await tester.pumpAndSettle();
    // Prefilled with the cover price, corrected to the price paid.
    expect(find.widgetWithText(TextField, '11,95'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('paidPriceField')), '9,50');
    await tester.tap(find.byKey(const Key('confirmBought')));
    await tester.pumpAndSettle();

    expect(find.text('« Dune » ajouté à ta collection'), findsOneWidget);
    expect(find.text('Envies (0)'), findsOneWidget);
    final bought = await reload(tester, db);
    expect(bought.ownership, Ownership.possede);
    expect(bought.purchasePrice, 9.5);
    expect(bought.purchaseDate, DateTime(2026, 11, 14));
    expect(bought.wishlistPriority, isNull);
  });

  testWidgets('store mode: the yellow banner turns green once bought', (
    tester,
  ) async {
    await pumpApp(tester, size: desktopSize, seed: seedWish);
    await openScan(tester);
    await typeCode(tester, duneIsbn);
    expect(find.byKey(const Key('store_wished')), findsOneWidget);

    await tester.tap(find.byKey(const Key('storeBought')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmBought')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('store_owned')), findsOneWidget);
  }, variant: linux);
}
