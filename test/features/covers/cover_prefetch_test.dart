import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_prefetch.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_cover_store.dart';
import '../../helpers/fake_covers.dart';
import '../../helpers/test_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnv env;
  late Directory photosDir;
  late FakeNetworkStatus network;
  late FakeCoverCache cache;
  late ProviderContainer container;

  setUp(() async {
    await appLog.clear();
    env = TestEnv();
    photosDir = await Directory.systemTemp.createTemp('dupe_prefetch');
    network = FakeNetworkStatus(NetworkKind.unmetered);
    cache = FakeCoverCache()..failing.add('https://c/bad.jpg');
    final store = FakeCoverStore()
      ..files['p.jpg'] = Uint8List.fromList([1, 2, 3]);
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(env.db),
        networkStatusProvider.overrideWithValue(network),
        coverCacheProvider.overrideWithValue(cache),
        coverStoreProvider.overrideWithValue(store),
        coverPhotosProvider.overrideWithValue(
          CoverPhotos(() async => photosDir),
        ),
      ],
    );

    final repo = env.repo;
    final series = repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'One Piece', coverUrl: 'https://c/s.jpg');
    await repo.saveSeries(series);
    for (final url in [
      'https://c/1.jpg',
      'https://c/1.jpg', // Same cover twice: downloaded once.
      '${CoverPhotos.scheme}p.jpg',
      'https://c/bad.jpg',
      null,
    ]) {
      await repo.saveItem(
        repo.newItem(CollectionType.manga).copyWith(coverUrl: url),
      );
    }
    final deleted = repo
        .newItem(CollectionType.manga)
        .copyWith(coverUrl: 'https://c/deleted.jpg');
    await repo.saveItem(deleted);
    await repo.deleteItem(deleted.id);
  });

  tearDown(() async {
    container.dispose();
    await env.dispose();
    await photosDir.delete(recursive: true);
  });

  CoverPrefetch prefetch() => container.read(coverPrefetchProvider.notifier);
  PrefetchState state() => container.read(coverPrefetchProvider);
  PrefetchSettings settings() => container.read(prefetchSettingsProvider);

  test('downloads every live cover once, user photos included', () async {
    await prefetch().start();

    expect(
      cache.fetched,
      unorderedEquals([
        'https://c/1.jpg',
        'https://c/bad.jpg',
        'https://c/s.jpg',
      ]),
    );
    expect(File('${photosDir.path}/p.jpg').existsSync(), isTrue);
    expect(state().total, 4);
    expect(state().done, 4);
    expect(state().failed, 1);
    expect(state().running, isFalse);

    // Second run: only the missing one is tried again.
    cache.fetched.clear();
    await prefetch().restart();
    expect(cache.fetched, ['https://c/bad.jpg']);
    // Same failure again: written to the journal once, with its cause.
    final logged = appLog.entries.where((e) => e.source == 'covers').toList();
    expect(logged, hasLength(1));
    expect(logged.single.message, contains('https://c/bad.jpg (StateError)'));
  });

  test('Wi-Fi only by default; mobile data once allowed', () async {
    network.kind = NetworkKind.metered;
    await prefetch().start();
    expect(state().pause, PrefetchPause.metered);
    expect(cache.fetched, isEmpty);

    await settings().setWifiOnly(wifiOnly: false);
    await prefetch().restart();
    expect(cache.fetched, hasLength(3));
  });

  test('turned off: nothing is downloaded', () async {
    await settings().setEnabled(enabled: false);
    await prefetch().start();
    expect(state().pause, PrefetchPause.disabled);
    expect(cache.fetched, isEmpty);
  });

  test('stops as soon as the connection is lost, resumes after', () async {
    cache.gate = Completer<void>();
    final run = prefetch().start();
    while (cache.fetched.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    network.change(NetworkKind.none);
    await Future<void>.delayed(Duration.zero);
    cache.gate!.complete();
    await run;

    expect(state().pause, PrefetchPause.offline);
    expect(state().running, isFalse);
    expect(cache.fetched, hasLength(1));

    cache.gate = null;
    network.change(NetworkKind.unmetered);
    while (state().done < 4) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(state().pause, isNull);
    expect(cache.cached, containsAll(['https://c/1.jpg', 'https://c/s.jpg']));
  });
}
