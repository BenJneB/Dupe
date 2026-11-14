import 'dart:convert';
import 'dart:typed_data';

import 'package:dupe/app/router.dart';
import 'package:dupe/features/backup/data/auto_backups.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_file_io.dart';
import '../../helpers/memory_backup_store.dart';
import '../../helpers/scan_helpers.dart';
import '../../helpers/screen_helpers.dart';

void main() {
  testWidgets('a deleted item can be brought back from the message', (
    tester,
  ) async {
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

    expect(find.text('« Dune » supprimé'), findsOneWidget);
    await tester.tap(find.byKey(const Key('undoDelete')));
    await tester.pumpAndSettle();
    final item = await tester.runAsync(
      () =>
          (db.select(db.itemsTable)..where((t) => t.id.equals(id))).getSingle(),
    );
    expect(item!.deletedAt, isNull);
    expect(find.text('Dune'), findsOneWidget);
  });

  testWidgets('a CSV import is undone from the backup taken before it', (
    tester,
  ) async {
    final store = MemoryBackupStore();
    final files = FakeFileIo()
      ..toOpen = (
        name: 'livres.csv',
        bytes: Uint8List.fromList(utf8.encode('Titre;Type\nFondation;livre\n')),
      );
    final db = await pumpApp(
      tester,
      size: desktopSize,
      backups: store,
      overrides: [fileIoProvider.overrideWithValue(files)],
      seed: (db) async {
        final repo = repoOf(db);
        await repo.saveItem(
          repo.newItem(CollectionType.livre).copyWith(title: 'Dune'),
        );
      },
    );
    // Weekly backup taken at start-up.
    expect(store.files.keys.single, startsWith('weekly_'));

    await openSettings(tester);
    await tapTile(tester, 'importCsv');
    await tester.tap(find.byKey(const Key('csvImportButton')));
    await tester.pumpAndSettle();
    final before = store.files.keys
        .map(AutoBackup.parse)
        .singleWhere((b) => b!.kind == AutoBackupKind.beforeImport)!;
    expect(before.items, 1);

    await goTo(tester, AppRoutes.autoBackups);
    expect(find.text('Avant import CSV · 1 ouvrage'), findsOneWidget);
    await tester.tap(find.byKey(Key('autoBackup-${before.name}')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('restore-replace')));
    await tester.pumpAndSettle();

    expect(
      find.text('Collection restaurée : 1 ouvrages, 1 retirés'),
      findsOneWidget,
    );
    final titles = await tester.runAsync(
      () async => (await (db.select(
        db.itemsTable,
      )..where((t) => t.deletedAt.isNull())).get()).map((i) => i.title),
    );
    expect(titles, ['Dune']);
    // The state before the restore is itself kept.
    expect(
      store.files.keys.where((n) => n.startsWith('beforeRestore_')),
      hasLength(1),
    );
  });
}
