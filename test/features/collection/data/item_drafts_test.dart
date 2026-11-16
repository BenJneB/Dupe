import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/item_drafts.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_repositories.dart';

void main() {
  test('a scanned volume keeps its own title (phase 24)', () async {
    final env = TestEnv();
    addTearDown(env.dispose);
    final kaamelott = env.repo
        .newSeries(CollectionType.bd)
        .copyWith(title: 'Kaamelott');
    await env.repo.saveSeries(kaamelott);

    // BnF 9782203085053: the volume's title, its series in 461 / 225.
    const record = MetadataResult(
      source: MetadataSource.bnf,
      sourceId: 'ark',
      title: 'Les renforts maléfiques',
      seriesTitle: 'Kaamelott',
      volumeNumber: '9',
      isbn13: '9782203085053',
    );
    final draft = (await loadItemDraft(
      env.repo,
      type: CollectionType.bd,
      prefill: (metadata: record, ownership: Ownership.possede),
    ))!;

    expect(draft.item.seriesId, kaamelott.id);
    expect(draft.item.volumeNumber, '9');
    expect(draft.item.volumeTitle, 'Les renforts maléfiques');
  });
}
