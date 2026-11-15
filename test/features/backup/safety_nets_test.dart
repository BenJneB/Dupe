import 'package:dupe/features/backup/data/auto_backups.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/memory_backup_store.dart';
import '../../helpers/test_repositories.dart';

/// Phase 11: undo a deletion, full restore, automatic backups.
void main() {
  late TestEnv env;

  setUp(() => env = TestEnv());
  tearDown(() => env.dispose());

  Future<String> addBook(String title) async {
    final item = env.repo.newItem(CollectionType.livre).copyWith(title: title);
    await env.repo.saveItem(item);
    return item.id;
  }

  test(
    'a deleted series comes back with the volumes deleted with it',
    () async {
      final series = env.repo.newSeries(CollectionType.bd).copyWith(title: 'X');
      await env.repo.saveSeries(series);
      await env.repo.addVolumeRange(series, from: 1, to: 3);
      final volumes = await env.repo.listSeriesItems(series.id);
      // Volume 1 deleted earlier, on its own: it stays deleted.
      await env.repo.deleteItem(volumes.first.id);
      env.now = env.now.add(const Duration(minutes: 1));
      await env.repo.deleteSeries(series.id);
      expect(await env.repo.getSeries(series.id), isNull);

      env.now = env.now.add(const Duration(minutes: 1));
      await env.repo.restoreSeries(series.id);
      final restored = (await env.repo.getSeries(series.id))!;
      expect(restored.syncPending, isTrue);
      expect(restored.updatedAt, env.now);
      expect(
        (await env.repo.listSeriesItems(series.id)).map((i) => i.volumeNumber),
        ['2', '3'],
      );
    },
  );

  test('a deleted item comes back, to be pushed again', () async {
    final id = await addBook('Dune');
    await env.repo.deleteItem(id);
    await env.repo.restoreItem(id);
    final item = (await env.repo.getItem(id))!;
    expect(item.deletedAt, isNull);
    expect(item.syncPending, isTrue);
  });

  test('replace puts the collection back exactly as in the backup', () async {
    final kept = await addBook('Dune');
    final changed = await addBook('Fondation');
    final backup = await JsonBackup(env.db).export(now: env.now);

    env.now = env.now.add(const Duration(days: 1));
    await addBook('Ajout après la sauvegarde');
    await env.repo.saveItem(
      (await env.repo.getItem(changed))!.copyWith(title: 'Mauvais titre'),
    );
    await env.repo.deleteItem(kept);

    env.now = env.now.add(const Duration(days: 1));
    final report = await JsonBackup(env.db).replace(backup, now: env.now);
    expect(report, (restored: 2, removed: 1));

    final items = await (env.db.select(
      env.db.itemsTable,
    )..where((t) => t.deletedAt.isNull())).get();
    expect(items.map((i) => i.title), unorderedEquals(['Dune', 'Fondation']));
    // Newer than every other copy: wins at the next sync everywhere.
    expect(
      items.every(
        (i) => i.syncPending && i.updatedAt.isAtSameMomentAs(env.now),
      ),
      isTrue,
    );
    expect(
      () => JsonBackup(env.db).replace('{}', now: env.now),
      throwsA(isA<BackupFormatException>()),
    );
  });

  group('automatic backups', () {
    late MemoryBackupStore store;
    late AutoBackups backups;

    setUp(() {
      store = MemoryBackupStore();
      backups = AutoBackups(env.db, store, () => env.now, keep: 2);
    });

    test('nothing to save in an empty collection', () async {
      expect(await backups.create(AutoBackupKind.weekly), isNull);
      expect(store.files, isEmpty);
    });

    test('weekly at most, the last ones of each kind kept', () async {
      await addBook('Dune');
      final first = (await backups.weeklyIfDue())!;
      expect(first.items, 1);
      expect(AutoBackup.parse(first.name)!.at, env.now);
      expect(JsonBackup.decode(await backups.read(first)), isNotEmpty);

      env.now = env.now.add(const Duration(days: 6));
      expect(await backups.weeklyIfDue(), isNull);
      for (var week = 1; week <= 3; week++) {
        env.now = env.now.add(const Duration(days: 7));
        expect(await backups.weeklyIfDue(), isNotNull);
      }
      final lastWeekly = env.now;
      env.now = env.now.add(const Duration(minutes: 1));
      await backups.create(AutoBackupKind.beforeImport);

      final list = await backups.list();
      expect(list.map((b) => b.kind), [
        AutoBackupKind.beforeImport,
        AutoBackupKind.weekly,
        AutoBackupKind.weekly,
      ]);
      expect(list[1].at, lastWeekly);
      store.files['notes.txt'] = 'ignored';
      expect(await backups.list(), hasLength(3));
    });
  });
}
