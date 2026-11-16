import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/volume_title_fill.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_metadata.dart';
import '../../../helpers/test_repositories.dart';

const k9 = '9782203085053';
const k8 = '9782203063716';

void main() {
  test('volumes already in the collection get their title, by ISBN', () async {
    final env = TestEnv();
    addTearDown(env.dispose);
    final bnf = FakeProvider(
      MetadataSource.bnf,
      byIsbn: {
        k9: const MetadataResult(
          source: MetadataSource.bnf,
          sourceId: 'k9',
          title: 'Les renforts maléfiques',
          seriesTitle: 'Kaamelott',
          volumeNumber: '9',
        ),
        // Only the series title: nothing to add.
        k8: const MetadataResult(
          source: MetadataSource.bnf,
          sourceId: 'k8',
          title: 'Kaamelott',
          volumeNumber: '8',
        ),
      },
    );
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(env.db),
        collectionRepositoryProvider.overrideWithValue(env.repo),
        metadataAggregatorProvider.overrideWithValue(
          MetadataAggregator(providers: [bnf]),
        ),
      ],
    );
    addTearDown(container.dispose);
    final repo = env.repo;
    final kaamelott = repo
        .newSeries(CollectionType.bd)
        .copyWith(title: 'Kaamelott');
    await repo.saveSeries(kaamelott);
    final v9 = repo
        .newItem(CollectionType.bd, series: kaamelott, volumeNumber: '9')
        .copyWith(title: 'Kaamelott', isbn13: k9);
    final v8 = repo
        .newItem(CollectionType.bd, series: kaamelott, volumeNumber: '8')
        .copyWith(title: 'Kaamelott', isbn13: k8);
    final typed = repo
        .newItem(CollectionType.bd, series: kaamelott, volumeNumber: '7')
        .copyWith(isbn13: k9, volumeTitle: 'Mon titre');
    final noIsbn = repo.newItem(
      CollectionType.bd,
      series: kaamelott,
      volumeNumber: '6',
    );
    for (final i in [v9, v8, typed, noIsbn]) {
      await repo.saveItem(i);
    }

    await container.read(volumeTitleFillProvider.notifier).run();

    final state = container.read(volumeTitleFillProvider);
    expect((state.total, state.found), (2, 1));
    expect((await repo.getItem(v9.id))!.volumeTitle, 'Les renforts maléfiques');
    expect((await repo.getItem(v8.id))!.volumeTitle, isNull);
    expect((await repo.getItem(typed.id))!.volumeTitle, 'Mon titre');
    expect((await repo.getItem(noIsbn.id))!.volumeTitle, isNull);
  });
}
