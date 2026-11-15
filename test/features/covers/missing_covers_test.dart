import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/missing_covers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_covers.dart';
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
    expect((state.total, state.done, state.found), (5, 5, 2));
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
  });
}
