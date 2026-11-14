import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';

Future<void> openStats(WidgetTester tester) async {
  ProviderScope.containerOf(tester.element(find.byType(Scaffold).first))
      .read(appRouterProvider)
      .go(AppRoutes.stats);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('empty collection: explanation instead of figures', (
    tester,
  ) async {
    await pumpApp(tester);
    await openStats(tester);
    expect(
      find.text('Ajoute des ouvrages pour voir tes statistiques'),
      findsOneWidget,
    );
  });

  testWidgets('totals, monthly chart and its table view', (tester) async {
    await pumpApp(
      tester,
      overrides: [
        clockProvider.overrideWithValue(() => DateTime(2026, 11, 14)),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo
              .newItem(CollectionType.livre)
              .copyWith(
                title: 'Dune',
                purchasePrice: 11.95,
                purchaseDate: DateTime(2026, 11, 3),
              ),
        );
      },
    );
    await openStats(tester);

    expect(
      find.descendant(
        of: find.byKey(const Key('statSpent')),
        matching: find.textContaining('11,95'),
      ),
      findsOneWidget,
    );
    expect(
      find.text('prix payé saisi pour 1 exemplaire sur 1'),
      findsOneWidget,
    );
    expect(find.text('0 %'), findsOneWidget);

    await tester.scrollUntilVisible(find.byKey(const Key('toggleTable')), 100);
    await tester.tap(find.byKey(const Key('toggleTable')));
    await tester.pumpAndSettle();
    expect(find.text('novembre 2026'), findsOneWidget);
  });
}
