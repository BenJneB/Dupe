import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/quality/data/isbn_assignment.dart';
import 'package:dupe/features/quality/domain/collection_quality.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_metadata.dart';
import '../../helpers/test_repositories.dart';

const dune = '9782266320481';
const fowl = '9782075215091';

void main() {
  test('gaps of the collection, each counted where it belongs', () {
    final env = TestEnv();
    addTearDown(env.dispose);
    final repo = env.repo;
    final naruto = repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Naruto', totalVolumes: 72);
    final fowlSeries = repo
        .newSeries(CollectionType.livre)
        .copyWith(title: 'Les jumeaux Fowl');
    final complete = repo
        .newItem(CollectionType.manga, series: naruto, volumeNumber: '1')
        .copyWith(isbn13: '1', coverUrl: 'https://c/1.jpg');
    final bare = repo.newItem(CollectionType.manga, series: naruto);
    final wish = repo
        .newItem(CollectionType.livre)
        .copyWith(title: 'Dune', ownership: Ownership.envie);
    final tome3 = repo
        .newItem(CollectionType.livre)
        .copyWith(title: 'Free Quest Tome 3', isbn13: '3');
    final orphan = repo
        .newItem(CollectionType.livre)
        .copyWith(title: 'Les Jumeaux Fowl', isbn13: '4');

    final q = computeQuality(
      [complete, bare, wish, tome3, orphan],
      [naruto, fowlSeries],
    );

    // A wish without ISBN is not a gap: it is not owned.
    expect(q.items[QualityIssue.noIsbn], [bare]);
    expect(q.count(QualityIssue.noCover), 4);
    expect(q.items[QualityIssue.noVolumeNumber], [bare]);
    expect(q.items[QualityIssue.looksLikeVolume], [tome3, orphan]);
    expect(q.series, [fowlSeries]);
    expect(q.count(QualityIssue.seriesWithoutTotal), 1);
  });

  test(
    'scanned ISBN: duplicate, coherent title, filled on assignment',
    () async {
      final env = TestEnv();
      addTearDown(env.dispose);
      final repo = env.repo;
      final owner = repo
          .newItem(CollectionType.livre)
          .copyWith(title: 'Dune', isbn13: dune);
      final target = repo
          .newItem(CollectionType.livre, volumeNumber: '3')
          .copyWith(title: 'Les jumeaux Fowl');
      await repo.saveItem(owner);
      await repo.saveItem(target);
      final assignment = IsbnAssignment(
        repo,
        MetadataAggregator(
          providers: [
            FakeProvider(
              MetadataSource.bnf,
              byIsbn: {
                dune: const MetadataResult(
                  source: MetadataSource.bnf,
                  sourceId: 'd',
                  title: 'Dune',
                ),
                fowl: const MetadataResult(
                  source: MetadataSource.bnf,
                  sourceId: 'f',
                  title: 'Les jumeaux Fowl',
                  volumeNumber: '3',
                  publisher: 'Gallimard',
                  coverUrl: 'https://c/fowl3.jpg',
                ),
              },
            ),
          ],
        ),
      );

      final taken = await assignment.check(target, dune);
      expect(taken.duplicate?.id, owner.id);
      expect(taken.coherent, isFalse); // "Dune" is not "Les jumeaux Fowl".

      final ok = await assignment.check(target, fowl);
      expect(ok.duplicate, isNull);
      expect(ok.coherent, isTrue);
      await assignment.assign(target, fowl, found: ok.found);
      final saved = (await repo.getItem(target.id))!;
      expect(saved.isbn13, fowl);
      expect(saved.publisher, 'Gallimard');
      expect(saved.coverUrl, 'https://c/fowl3.jpg');
    },
  );
}
