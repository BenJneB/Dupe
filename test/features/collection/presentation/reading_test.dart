import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/app_harness.dart';
import '../../../helpers/scan_helpers.dart';
import '../../../helpers/screen_helpers.dart';

late Series naruto;

/// Naruto 1-5 owned, unread; plus "Akira" with every volume read.
Future<void> seedReading(AppDatabase db) async {
  final repo = repoOf(db);
  naruto = repo
      .newSeries(CollectionType.manga)
      .copyWith(title: 'Naruto', totalVolumes: 5);
  await repo.saveSeries(naruto);
  await repo.addVolumeRange(naruto, from: 1, to: 5);
  final akira = repo.newSeries(CollectionType.manga).copyWith(title: 'Akira');
  await repo.saveSeries(akira);
  await repo.saveItem(
    repo
        .newItem(CollectionType.manga, series: akira, volumeNumber: '1')
        .copyWith(readingStatus: ReadingStatus.lu),
  );
}

void main() {
  testWidgets('"À lire" keeps only series with unread volumes', (tester) async {
    await pumpApp(tester, seed: seedReading);
    expect(find.text('Akira'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toReadFilter')));
    await tester.pumpAndSettle();

    expect(find.text('Naruto'), findsOneWidget);
    expect(find.text('Akira'), findsNothing);
    await tester.tap(find.byKey(const Key('toReadFilter')));
    await tester.pumpAndSettle();
    // Every owned volume of Akira is read.
    expect(find.textContaining('tout lu'), findsOneWidget);
  });

  testWidgets('mark volumes 1 to N as read from the series sheet', (
    tester,
  ) async {
    final db = await pumpApp(tester, seed: seedReading);
    await tester.tap(find.text('Naruto'));
    await tester.pumpAndSettle();
    expect(find.text('5 tomes à lire'), findsOneWidget);

    await tester.tap(find.byKey(const Key('seriesMenu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('markReadAction')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('readUpToField')), '3');
    await tester.tap(find.byKey(const Key('confirmMarkRead')));
    await tester.pumpAndSettle();

    expect(find.text('3 tomes marqués comme lus'), findsOneWidget);
    expect(find.text('2 tomes à lire'), findsOneWidget);
    // Read volumes carry a check mark in the grid.
    expect(find.byKey(const ValueKey('read-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('read-4')), findsNothing);
    final read = await tester.runAsync(
      () => (db.select(
        db.itemsTable,
      )..where((t) => t.readingStatus.equalsValue(ReadingStatus.lu))).get(),
    );
    // Akira 1 + Naruto 1-3, the latter with a read date.
    expect(read, hasLength(4));
    expect(
      read!.where((i) => i.seriesId == naruto.id).map((i) => i.readDate),
      everyElement(isNotNull),
    );
  });

  testWidgets('reading status is one tap away on the item sheet', (
    tester,
  ) async {
    await pumpApp(tester, seed: seedReading);
    await tester.tap(find.text('Naruto'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('slot-1')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('reading-lu')));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    container
        .read(appRouterProvider)
        .go(AppRoutes.series(CollectionType.manga, naruto.id));
    await tester.pumpAndSettle();
    expect(find.text('4 tomes à lire'), findsOneWidget);
  });

  testWidgets('choosing "Lu" in the form fills the read date', (tester) async {
    final db = await pumpApp(tester, seed: seedReading);
    final volume = (await tester.runAsync(
      () => repoOf(db).listSeriesItems(naruto.id),
    ))!.first;
    await goTo(tester, AppRoutes.itemEdit(CollectionType.manga, volume.id));

    final status = find.text('Non lu');
    await tester.scrollUntilVisible(
      status,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(status);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lu').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    final saved = await tester.runAsync(() => repoOf(db).getItem(volume.id));
    expect(saved!.readingStatus, ReadingStatus.lu);
    expect(saved.readDate, isNotNull);
  });
}
