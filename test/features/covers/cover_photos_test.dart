import 'dart:io';
import 'dart:typed_data';

import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/collection/data/item_photos_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/features/covers/data/cover_sync.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_cover_store.dart';
import '../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;
  late Directory dir;
  late CoverPhotos photos;
  final jpeg = Uint8List.fromList([0xff, 0xd8, 0xff, 1, 2, 3]);

  setUp(() async {
    env = TestEnv();
    dir = await Directory.systemTemp.createTemp('dupe_covers');
    photos = CoverPhotos(() async => dir);
  });
  tearDown(() async {
    await env.dispose();
    await dir.delete(recursive: true);
  });

  test('photos referenced by items are uploaded once', () async {
    final store = FakeCoverStore();
    final settings = AppSettingsStore(env.db);
    final url = await photos.save(
      'item-1',
      jpeg,
      extension: '.JPG',
      now: DateTime(2026, 11, 14),
    );
    expect(url, startsWith('dupe-cover:item-1-'));
    expect(url, endsWith('.jpg'));
    await env.repo.saveItem(
      env.repo
          .newItem(CollectionType.livre)
          .copyWith(title: 'A', coverUrl: url),
    );
    // Photo taken on another device: no local file, nothing to upload.
    await env.repo.saveItem(
      env.repo
          .newItem(CollectionType.livre)
          .copyWith(title: 'B', coverUrl: 'dupe-cover:other.jpg'),
    );

    Future<int> upload(String userId) =>
        uploadPendingCovers(env.db, photos, store, settings, userId: userId);
    expect(await upload('u1'), 1);
    expect(store.files[CoverPhotos.nameOf(url)], jpeg);
    expect(await upload('u1'), 0);
    expect(store.uploads, 1);
    // Another account (sign-out, sign-in): its own folder gets the photo.
    expect(await upload('u2'), 1);
    expect(store.uploads, 2);
  });

  test('a photo missing locally is downloaded and kept', () async {
    final store = FakeCoverStore()..files['x.jpg'] = jpeg;
    final container = ProviderContainer(
      overrides: [
        coverPhotosProvider.overrideWithValue(photos),
        coverStoreProvider.overrideWithValue(store),
      ],
    );
    addTearDown(container.dispose);

    final file = await container.read(userCoverFileProvider('x.jpg').future);
    expect(await file!.readAsBytes(), jpeg);
    store.files.clear();
    container.invalidate(userCoverFileProvider('x.jpg'));
    // Now served from the local copy.
    expect(
      await container.read(userCoverFileProvider('x.jpg').future),
      isNotNull,
    );
    expect(
      await container.read(userCoverFileProvider('missing.jpg').future),
      isNull,
    );
  });

  test(
    'originals: kept per item, measured, purged without the covers',
    () async {
      final url = await photos.save(
        'item-1',
        jpeg,
        extension: '.jpg',
        now: DateTime(2026, 11, 16),
      );
      await photos.saveOriginal('item-1', jpeg);
      // Cropped again: the original of the item is replaced, not added.
      await photos.saveOriginal('item-1', Uint8List.fromList([...jpeg, 4]));
      expect(await photos.originalsSize(), jpeg.length + 1);
      // Never mistaken for a cover photo.
      expect((await photos.originalOf('item-1')).path, contains('originals'));

      await photos.purgeOriginals();
      expect(await photos.originalsSize(), 0);
      expect(
        (await photos.fileOf(CoverPhotos.nameOf(url)!)).existsSync(),
        isTrue,
      );
    },
  );

  test('the other photos of an item (signature) are uploaded too', () async {
    final store = FakeCoverStore();
    final item = env.repo.newItem(CollectionType.bd).copyWith(title: 'Blast');
    await env.repo.saveItem(item);
    final url = await photos.save(
      item.id,
      jpeg,
      extension: '.jpg',
      now: DateTime(2026, 11, 17),
    );
    await ItemPhotosRepository(
      env.db,
      now: () => env.now,
      newId: () => 'p1',
    ).add(item.id, url);

    expect(
      await uploadPendingCovers(
        env.db,
        photos,
        store,
        AppSettingsStore(env.db),
        userId: 'u1',
      ),
      1,
    );
    expect(store.files[CoverPhotos.nameOf(url)], jpeg);
  });
}
