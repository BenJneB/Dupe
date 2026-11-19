import 'package:drift/drift.dart' show Value;
import 'package:dupe/core/database/tables/series_table.drift.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/item_drafts.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series_attachment.dart';
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

  test(
    'a deleted series is left on save, as with creation switched off',
    () async {
      final env = TestEnv();
      addTearDown(env.dispose);
      // Series deleted on another device: the book becomes standalone.
      final series = env.repo
          .newSeries(CollectionType.livre)
          .copyWith(title: 'Les fourmis');
      await env.repo.saveSeries(series);
      final item = env.repo
          .newItem(CollectionType.livre, series: series)
          .copyWith(title: 'Le jour des fourmis');
      await env.repo.saveItem(item);
      await env.db
          .update(env.db.seriesTable)
          .write(SeriesTableCompanion(deletedAt: Value(DateTime.utc(2026))));

      final draft = (await loadItemDraft(
        env.repo,
        type: CollectionType.livre,
        itemId: item.id,
      ))!;
      final left = await applyAttachment(
        env.repo,
        draft.item,
        draft.attachment,
      );
      expect(draft.attachment, isA<DetachSeries>());
      expect(left.seriesId, isNull);

      // "Créer la série" switched off: in no series, not the former one.
      final off = await applyAttachment(
        env.repo,
        item,
        const CreateSeries('Trilogie', enabled: false),
      );
      expect(off.seriesId, isNull);
    },
  );
}
