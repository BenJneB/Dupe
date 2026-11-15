import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;

  setUp(() => env = TestEnv());
  tearDown(() => env.dispose());

  test('saves and reads back a series with lists and enums', () async {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(
          title: 'One Piece',
          authors: ['Eiichirō Oda'],
          statusPublication: PublicationStatus.enCours,
          totalVolumes: 10,
          externalIds: {'anilist_id': '30013'},
        );
    await env.repo.saveSeries(series);

    final read = await env.repo.watchSeries(series.id).first;
    expect(read, isNotNull);
    expect(read!.title, 'One Piece');
    expect(read.authors, ['Eiichirō Oda']);
    expect(read.statusPublication, PublicationStatus.enCours);
    expect(read.externalIds, {'anilist_id': '30013'});
    expect(read.syncPending, isTrue);
  });

  test('stores enums with their snake_case db value', () async {
    final series = env.repo
        .newSeries(CollectionType.bd)
        .copyWith(
          title: 'Blacksad',
          statusPublication: PublicationStatus.enCours,
        );
    await env.repo.saveSeries(series);

    final row = await env.db
        .customSelect('SELECT type, status_publication FROM series')
        .getSingle();
    expect(row.read<String>('type'), 'bd');
    expect(row.read<String>('status_publication'), 'en_cours');
  });

  test('save bumps updated_at', () async {
    final series = env.repo.newSeries(CollectionType.bd).copyWith(title: 'A');
    await env.repo.saveSeries(series);
    env.now = env.now.add(const Duration(hours: 1));
    await env.repo.saveSeries(series.copyWith(title: 'B'));

    final read = (await env.repo.watchSeries(series.id).first)!;
    expect(read.title, 'B');
    expect(read.updatedAt, env.now);
    expect(read.createdAt, series.createdAt);
  });

  test('addVolumeRange creates missing numbers only', () async {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Naruto', totalVolumes: 10);
    await env.repo.saveSeries(series);
    await env.repo.saveItem(
      env.repo.newItem(CollectionType.manga, series: series, volumeNumber: '3'),
    );

    final created = await env.repo.addVolumeRange(series, from: 1, to: 7);

    expect(created, 6);
    final items = await env.repo.watchSeriesItems(series.id).first;
    expect(items.map((i) => i.volumeNumber), [
      for (var n = 1; n <= 7; n++) '$n',
    ]);
    expect(items.first.title, 'Naruto');
  });

  test('deleteSeries soft-deletes the series and its items', () async {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Bleach');
    await env.repo.saveSeries(series);
    await env.repo.addVolumeRange(series, from: 1, to: 2);

    await env.repo.deleteSeries(series.id);

    expect(await env.repo.watchSeries(series.id).first, isNull);
    expect(await env.repo.watchSeriesItems(series.id).first, isEmpty);
    final rows = await env.db
        .customSelect(
          'SELECT COUNT(*) AS c FROM items WHERE deleted_at IS NOT NULL',
        )
        .getSingle();
    expect(rows.read<int>('c'), 2);
  });

  test(
    'watchEntries returns series with counts and standalone items',
    () async {
      final series = env.repo
          .newSeries(CollectionType.manga)
          .copyWith(title: 'Akira', totalVolumes: 6);
      await env.repo.saveSeries(series);
      await env.repo.addVolumeRange(series, from: 1, to: 4);
      await env.repo.addVolumeRange(
        series,
        from: 5,
        to: 5,
        ownership: Ownership.envie,
      );
      await env.repo.saveItem(
        env.repo.newItem(CollectionType.manga).copyWith(title: 'One-shot'),
      );
      // Other type: must not appear.
      await env.repo.saveSeries(
        env.repo.newSeries(CollectionType.bd).copyWith(title: 'Tintin'),
      );

      final entries = await env.repo.watchEntries(CollectionType.manga).first;

      final seriesEntry = entries.whereType<SeriesEntry>().single;
      expect(seriesEntry.title, 'Akira');
      expect(seriesEntry.ownedCount, 4);
      expect(seriesEntry.itemCount, 5);
      expect(seriesEntry.progress, closeTo(4 / 6, 1e-9));
      expect(entries.whereType<ItemEntry>().single.title, 'One-shot');
    },
  );
}
