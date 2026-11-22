import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

/// Naruto 1 read and 2 not yet; a standalone book not read.
Future<void> seedPile(AppDatabase db) async {
  final repo = repoOf(db);
  final naruto = repo.newSeries(CollectionType.manga).copyWith(title: 'Naruto');
  await repo.saveSeries(naruto);
  await repo.saveItem(
    repo
        .newItem(CollectionType.manga, series: naruto, volumeNumber: '1')
        .copyWith(readingStatus: ReadingStatus.lu),
  );
  await repo.saveItem(
    repo.newItem(CollectionType.manga, series: naruto, volumeNumber: '2'),
  );
  await repo.saveItem(
    repo.newItem(CollectionType.livre).copyWith(title: 'Dune'),
  );
}

Future<void> openNextRead(WidgetTester tester) async {
  await goTo(tester, AppRoutes.more);
  await tester.tap(find.byKey(const Key('moreNextRead')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a book from the pile, another one, then started', (
    tester,
  ) async {
    final db = await pumpApp(tester, seed: seedPile);
    await openNextRead(tester);

    String shown() =>
        tester.widget<Text>(find.byKey(const Key('nextReadTitle'))).data!;
    final first = shown();
    expect(['Naruto – tome 2', 'Dune'], contains(first));
    await tester.tap(find.byKey(const Key('nextReadAnother')));
    await tester.pumpAndSettle();
    final second = shown();
    expect({first, second}, {'Naruto – tome 2', 'Dune'});
    // The next volume of a series already started says so.
    if (second == 'Naruto – tome 2') {
      expect(find.text('La suite d’une série commencée'), findsOneWidget);
    }

    await tester.tap(find.byKey(const Key('nextReadStart')));
    await tester.pumpAndSettle();
    expect(find.text('Bonne lecture !'), findsOneWidget);
    final started = await tester.runAsync(
      () =>
          (db.select(db.itemsTable)..where(
                (t) => t.readingStatus.equalsValue(ReadingStatus.enCours),
              ))
              .get(),
    );
    expect(started, hasLength(1));
  });

  testWidgets('nothing left to read: said plainly', (tester) async {
    await pumpApp(tester);
    await openNextRead(tester);
    expect(
      find.text(
        'Rien à proposer : tes livres possédés sont tous lus ou commencés.',
      ),
      findsOneWidget,
    );
  });
}
