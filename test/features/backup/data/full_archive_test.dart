import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dupe/features/backup/data/full_archive.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/features/collection/data/item_photos_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_cover_store.dart';
import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv source;
  late TestEnv blank;
  late Directory dir;
  late Directory emptyDir;
  final jpeg = Uint8List.fromList([0xff, 0xd8, 0xff, 9]);

  setUp(() async {
    source = TestEnv();
    blank = TestEnv();
    dir = await Directory.systemTemp.createTemp('dupe_archive');
    emptyDir = await Directory.systemTemp.createTemp('dupe_archive_new');
  });
  tearDown(() async {
    await source.dispose();
    await blank.dispose();
    await dir.delete(recursive: true);
    await emptyDir.delete(recursive: true);
  });

  test(
    'every photo goes with the collection, back on a blank device',
    () async {
      final photos = CoverPhotos(() async => dir);
      final at = DateTime(2026, 11, 17);
      final cover = await photos.save('i', jpeg, extension: '.jpg', now: at);
      final item = source.repo
          .newItem(CollectionType.bd)
          .copyWith(title: 'Blast', coverUrl: cover, isSigned: true);
      await source.repo.saveItem(item);
      final signature = await photos.save(
        item.id,
        jpeg,
        extension: '.jpg',
        now: at.add(const Duration(seconds: 1)),
      );
      await ItemPhotosRepository(
        source.db,
        now: () => at,
        newId: () => 'p1',
      ).add(item.id, signature);
      // Taken on another device: downloaded from the account for the archive.
      final store = FakeCoverStore()..files['remote.jpg'] = jpeg;
      await source.repo.saveItem(
        source.repo
            .newItem(CollectionType.bd)
            .copyWith(title: 'Remote', coverUrl: 'dupe-cover:remote.jpg'),
      );

      final export = await FullArchive(
        source.db,
        photos,
        store,
      ).export(now: at);
      expect(export.photos, 3);
      final names = ZipDecoder()
          .decodeBytes(export.bytes)
          .files
          .map((f) => f.name);
      expect(names, contains(FullArchive.backupEntry));

      final restored = await FullArchive(
        blank.db,
        CoverPhotos(() async => emptyDir),
        null,
      ).restore(export.bytes);

      expect(restored.photos, 3);
      final items = await blank.db.select(blank.db.itemsTable).get();
      expect(items.firstWhere((i) => i.title == 'Blast').isSigned, isTrue);
      expect(
        await blank.db.select(blank.db.itemPhotosTable).get(),
        hasLength(1),
      );
      expect(
        File('${emptyDir.path}/${CoverPhotos.nameOf(signature)}').existsSync(),
        isTrue,
      );
    },
  );

  test('a file outside the photo folder is never written', () async {
    final archive = Archive()
      ..addFile(
        ArchiveFile.bytes(
          FullArchive.backupEntry,
          utf8.encode(await JsonBackup(source.db).export(now: DateTime(2026))),
        ),
      )
      ..addFile(ArchiveFile.bytes('photos/../evil.jpg', jpeg));
    final result = await FullArchive(
      blank.db,
      CoverPhotos(() async => emptyDir),
      null,
    ).restore(Uint8List.fromList(ZipEncoder().encode(archive)));
    expect(result.photos, 0);
    expect(File('${emptyDir.parent.path}/evil.jpg').existsSync(), isFalse);
  });

  test('not an archive: refused', () {
    expect(
      FullArchive(
        blank.db,
        CoverPhotos(() async => emptyDir),
        null,
      ).restore(Uint8List.fromList([1, 2, 3])),
      throwsA(isA<BackupFormatException>()),
    );
  });
}
