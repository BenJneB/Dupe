import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/failing_repository.dart';
import '../../helpers/fake_file_io.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

void main() {
  testWidgets('JSON backup and CSV export are saved as files', (tester) async {
    final files = FakeFileIo();
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [
        fileIoProvider.overrideWithValue(files),
        clockProvider.overrideWithValue(() => DateTime(2026, 11, 14)),
      ],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo.newItem(CollectionType.livre).copyWith(title: 'Dune'),
        );
      },
    );
    await openSettings(tester);

    await tapTile(tester, 'exportJson');
    expect(find.text('Fichier enregistré'), findsOneWidget);
    final backup = jsonDecode(
      files.text('dupe-sauvegarde-2026-11-14.json'),
    ) as Map<String, dynamic>;
    expect(
      (backup['items']! as List<dynamic>).single,
      containsPair('title', 'Dune'),
    );

    await tapTile(tester, 'exportCsv');
    await tester.tap(find.byKey(const Key('csvType-livre')));
    await tester.pumpAndSettle();
    expect(files.text('dupe-livre-2026-11-14.csv'), contains(';Dune;'));
  });

  testWidgets('export finished after leaving the screen: still reported', (
    tester,
  ) async {
    final files = FakeFileIo()..gate = Completer<void>();
    await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fileIoProvider.overrideWithValue(files)],
    );
    await openSettings(tester);
    await tapTile(tester, 'exportJson');
    // The share sheet is open; the user goes back meanwhile.
    await goBack(tester);
    files.gate!.complete();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Fichier enregistré'), findsOneWidget);
  });

  testWidgets('CSV import: guessed mapping, defaults, then import', (
    tester,
  ) async {
    const csv =
        'Series;Issue Nr;Publisher;Barcode;Read\n'
        'Batman;1;Urban Comics;9782365770484;Yes\n'
        'Batman;2;Urban Comics;;No\n';
    final files = FakeFileIo()
      ..toOpen = (name: 'clz.csv', bytes: Uint8List.fromList(utf8.encode(csv)));
    final db = await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fileIoProvider.overrideWithValue(files)],
    );
    await openSettings(tester);

    await tapTile(tester, 'importCsv');
    expect(find.text('clz.csv : 2 lignes'), findsOneWidget);
    await tester.tap(find.byKey(const Key('defaultType-comic')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('csvImportButton')));
    await tester.pumpAndSettle();

    expect(
      find.text('2 ajoutés, 1 séries créées, 0 déjà présents'),
      findsOneWidget,
    );
    final result = await tester.runAsync(() async {
      final series = await db.select(db.seriesTable).getSingle();
      final items = await db.select(db.itemsTable).get();
      return (series: series, items: items);
    });
    expect(result!.series.title, 'Batman');
    expect(result.series.type, CollectionType.comic);
    expect(result.items, hasLength(2));
  });

  testWidgets('CSV import failing midway: reported, button usable again', (
    tester,
  ) async {
    const csv = 'Series;Title\nDune;Dune 1\n';
    final files = FakeFileIo()
      ..toOpen = (name: 'a.csv', bytes: Uint8List.fromList(utf8.encode(csv)));
    final db = await pumpApp(
      tester,
      size: desktopSize,
      overrides: [fileIoProvider.overrideWithValue(files), failingRepository()],
    );
    await openSettings(tester);

    await tapTile(tester, 'importCsv');
    await tester.tap(find.byKey(const Key('csvImportButton')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Import interrompu'), findsOneWidget);
    // One transaction: the series created before the failure is undone.
    final series = await tester.runAsync(() => db.select(db.seriesTable).get());
    expect(series, isEmpty);
    final button = tester.widget<ButtonStyleButton>(
      find.byKey(const Key('csvImportButton')),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('dark mode can be forced and is remembered', (tester) async {
    final db = await pumpApp(tester, size: desktopSize);
    await openSettings(tester);

    await tester.tap(find.text('Sombre'));
    await tester.pumpAndSettle();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    final saved = await tester.runAsync(
      () => db
          .customSelect(
            "SELECT value FROM app_settings WHERE key = 'theme_mode'",
          )
          .getSingle(),
    );
    expect(saved!.read<String>('value'), 'dark');
  });

  testWidgets('About shows the version and the licenses', (tester) async {
    await pumpApp(tester);
    await goTo(tester, AppRoutes.about);

    expect(find.text('Données comics fournies par Comic Vine'), findsOneWidget);
    expect(find.byKey(const Key('aboutVersion')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const Key('licensesTile')), 200);
    await tester.tap(find.byKey(const Key('licensesTile')));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });
}
