import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';

void main() {
  testWidgets('a volume owned in two editions shows ×2 and lists them', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (db) async {
        final repo = repoOf(db);
        final series = repo
            .newSeries(CollectionType.manga)
            .copyWith(title: 'Dreamland', totalVolumes: 2);
        await repo.saveSeries(series);
        for (final (number, isbn, edition) in [
          ('1', '9782845995581', 'Première édition'),
          ('1', '9782811666644', 'Nouvelle édition (2022)'),
          ('2', '9782845996489', 'Première édition'),
        ]) {
          await repo.saveItem(
            repo
                .newItem(
                  CollectionType.manga,
                  series: series,
                  volumeNumber: number,
                )
                .copyWith(isbn13: isbn, edition: edition),
          );
        }
      },
    );

    await tester.tap(find.text('Dreamland'));
    await tester.pumpAndSettle();
    expect(find.text('2/2 tomes · série complète'), findsOneWidget);
    expect(find.text('×2'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('slot-1')));
    await tester.pumpAndSettle();
    expect(find.text('Tome 1 : 2 exemplaires'), findsOneWidget);
    expect(find.text('ISBN 9782811666644'), findsOneWidget);

    await tester.tap(find.text('Nouvelle édition (2022)'));
    await tester.pumpAndSettle();
    // Item sheet of that copy.
    expect(find.text('Nouvelle édition (2022)'), findsOneWidget);
    expect(find.text('9782811666644'), findsOneWidget);
  });
}
