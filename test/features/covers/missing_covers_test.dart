import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/mangadex/mangadex_covers.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/missing_covers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_covers.dart';
import '../../helpers/fake_http.dart';
import '../../helpers/fake_metadata.dart';
import '../../helpers/test_repositories.dart';

const withCover = '9782075215091';
const brokenCover = '9782075198134';
const google = 'https://books.google.com/c.jpg';
const broken = 'https://books.google.com/broken.jpg';

MetadataResult result(String isbn, String cover) => MetadataResult(
  source: MetadataSource.googleBooks,
  sourceId: isbn,
  title: 'Les jumeaux Fowl',
  isbn13: isbn,
  coverUrl: cover,
);

void main() {
  test('fills missing or broken covers with one that downloads', () async {
    final env = TestEnv();
    addTearDown(env.dispose);
    // Answers every ISBN, but never has images: must not be asked.
    final bnf = FakeProvider(
      MetadataSource.bnf,
      isbnResult: result(withCover, '').copyWith(source: MetadataSource.bnf),
    );
    final cache = FakeCoverCache()
      ..failing.addAll([
        broken,
        'https://covers.openlibrary.org/b/isbn/$brokenCover-L.jpg?default=false',
      ]);
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(env.db),
        collectionRepositoryProvider.overrideWithValue(env.repo),
        coverCacheProvider.overrideWithValue(cache),
        metadataAggregatorProvider.overrideWithValue(
          MetadataAggregator(
            providers: [
              bnf,
              FakeProvider(
                MetadataSource.googleBooks,
                byIsbn: {
                  withCover: result(withCover, google),
                  brokenCover: result(brokenCover, broken),
                },
              ),
            ],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final repo = env.repo;
    final found = repo
        .newItem(CollectionType.livre)
        .copyWith(isbn13: withCover);
    final notFound = repo
        .newItem(CollectionType.livre)
        .copyWith(isbn13: brokenCover, coverUrl: '');
    final hasOne = repo
        .newItem(CollectionType.livre)
        .copyWith(isbn13: withCover, coverUrl: 'https://mine.jpg');
    final brokenOne = repo
        .newItem(CollectionType.livre)
        .copyWith(isbn13: withCover, coverUrl: 'https://old/404.jpg');
    final photo = repo
        .newItem(CollectionType.livre)
        .copyWith(isbn13: withCover, coverUrl: '${CoverPhotos.scheme}p.jpg');
    final noIsbn = repo.newItem(CollectionType.livre);
    cache.failing.add('https://old/404.jpg');
    for (final item in [found, notFound, hasOne, brokenOne, photo, noIsbn]) {
      await repo.saveItem(item);
    }

    await container.read(missingCoversFillProvider.notifier).run();

    final state = container.read(missingCoversFillProvider);
    // The photo is not even counted (never replaced).
    expect((state.total, state.done, state.found), (4, 4, 2));
    expect(state.finished, isTrue);
    expect((await repo.getItem(found.id))!.coverUrl, google);
    expect((await repo.getItem(notFound.id))!.coverUrl, '');
    expect((await repo.getItem(hasOne.id))!.coverUrl, 'https://mine.jpg');
    // A cover that does not download is replaced; a photo never.
    expect((await repo.getItem(brokenOne.id))!.coverUrl, google);
    expect(
      (await repo.getItem(photo.id))!.coverUrl,
      '${CoverPhotos.scheme}p.jpg',
    );
    expect((await repo.getItem(noIsbn.id))!.coverUrl, isNull);
    expect(bnf.calls, 0);
    // The found cover is already on the device (offline).
    expect(cache.cached, contains(google));

    // Second run: covers on the device are skipped at once, and the book
    // searched for nothing is not searched again for 30 days.
    await container.read(missingCoversFillProvider.notifier).run();
    expect(container.read(missingCoversFillProvider).total, 0);
    final skipped = await env.db
        .customSelect(
          "SELECT value FROM app_settings WHERE key = '$notFoundKey'",
        )
        .getSingle();
    expect(skipped.read<String>('value'), contains(brokenCover));
  });

  test(
    'a manga volume without cover gets its French one from MangaDex',
    () async {
      final env = TestEnv();
      addTearDown(env.dispose);
      final http = FakeHttpAdapter()
        ..on(
          (u) => u.path == '/manga',
          fixture('mangadex/search_dreamland.json'),
        )
        ..on(
          (u) => u.path == '/cover',
          fixture('mangadex/covers_dreamland.json'),
        );
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(env.db),
          collectionRepositoryProvider.overrideWithValue(env.repo),
          coverCacheProvider.overrideWithValue(FakeCoverCache()),
          // Google Books and co. have no image for it.
          metadataAggregatorProvider.overrideWithValue(
            MetadataAggregator(providers: const []),
          ),
          mangaDexCoversProvider.overrideWithValue(
            MangaDexCovers(fakeDio(http), limiter: RateLimiter(Duration.zero)),
          ),
        ],
      );
      addTearDown(container.dispose);
      final series = env.repo
          .newSeries(CollectionType.manga)
          .copyWith(title: 'Dreamland');
      await env.repo.saveSeries(series);
      final volume = env.repo
          .newItem(CollectionType.manga, series: series, volumeNumber: '4')
          .copyWith(isbn13: '9782845998773');
      await env.repo.saveItem(volume);

      await container.read(missingCoversFillProvider.notifier).run();

      final cover = (await env.repo.getItem(volume.id))!.coverUrl;
      expect(cover, startsWith('https://uploads.mangadex.org/covers/'));
      expect(container.read(missingCoversFillProvider).found, 1);
    },
  );
}
