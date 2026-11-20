import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
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

  test('list counts are those of the series grid', () async {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Akira', totalVolumes: 10);
    await env.repo.saveSeries(series);
    Future<void> add(
      String? number, {
      ReadingStatus status = ReadingStatus.nonLu,
      Ownership ownership = Ownership.possede,
    }) => env.repo.saveItem(
      env.repo
          .newItem(CollectionType.manga, series: series, volumeNumber: number)
          .copyWith(readingStatus: status, ownership: ownership),
    );
    await add('1', status: ReadingStatus.lu);
    // Two editions of volume 2, one read: the volume is read.
    await add('2', status: ReadingStatus.lu);
    await add('2');
    for (var n = 3; n <= 9; n++) {
      await add('$n');
    }
    await add('07'); // Volume 7 again.
    await add(' 8 '); // Volume 8 again.
    await add('11'); // Beyond the total.
    await add('HS 1');
    await add(null);
    await add('10', ownership: Ownership.envie);

    final entry = (await env.repo.watchEntries(CollectionType.manga).first)
        .whereType<SeriesEntry>()
        .single;
    final grid = VolumeGrid.compute(
      items: await env.repo.listSeriesItems(series.id),
      totalVolumes: 10,
      followed: false,
    );

    expect(grid.ownedCount, 9);
    expect(entry.ownedCount, grid.ownedCount);
    expect(grid.isComplete, isFalse);
    expect(entry.progress, lessThan(1));
    // 3-9, 11, HS 1 and the unnumbered one.
    expect(grid.toReadCount, 10);
    expect(entry.unreadCount, grid.toReadCount);

    // Without a total, every owned volume counts: 1-9, 11, HS 1, "?".
    await env.repo.saveSeries(series.copyWith(totalVolumes: null));
    final noTotal = (await env.repo.watchEntries(CollectionType.manga).first)
        .whereType<SeriesEntry>()
        .single;
    final noTotalGrid = VolumeGrid.compute(
      items: await env.repo.listSeriesItems(series.id),
      totalVolumes: null,
      followed: false,
    );
    expect(noTotalGrid.ownedCount, 12);
    expect(noTotal.ownedCount, noTotalGrid.ownedCount);
  });

  test('renaming a series renames the volumes that had its title', () async {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'One Pice');
    await env.repo.saveSeries(series);
    await env.repo.addVolumeRange(series, from: 1, to: 2);
    final special = env.repo
        .newItem(CollectionType.manga, series: series, volumeNumber: '3')
        .copyWith(title: 'Romance Dawn');
    await env.repo.saveItem(special);

    await env.repo.saveSeries(series.copyWith(title: 'One Piece'));

    final items = await env.repo.listSeriesItems(series.id);
    expect(
      items.map((i) => i.title),
      unorderedEquals(['One Piece', 'One Piece', 'Romance Dawn']),
    );
    expect(items.every((i) => i.syncPending), isTrue);
  });

  test('saving an old copy never revives a deleted row', () async {
    // A dialog or form open while the sync (or another screen) deleted it.
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Akira');
    await env.repo.saveSeries(series);
    final item = env.repo.newItem(CollectionType.manga, series: series);
    await env.repo.saveItem(item);
    await env.repo.deleteSeries(series.id);

    await env.repo.saveSeries(series.copyWith(totalVolumes: 6));
    await env.repo.saveItem(item.copyWith(notes: 'edited'));

    expect(await env.repo.getSeries(series.id), isNull);
    expect(await env.repo.getItem(item.id), isNull);
  });

  test('a blank ISBN counts as missing, in the list as on the item', () async {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'Akira');
    await env.repo.saveSeries(series);
    final blank = env.repo
        .newItem(CollectionType.manga, series: series, volumeNumber: '1')
        .copyWith(isbn13: ' ');
    await env.repo.saveItem(blank);

    final entry = (await env.repo.watchEntries(CollectionType.manga).first)
        .whereType<SeriesEntry>()
        .single;
    expect(blank.lacksIsbn, isTrue);
    expect(entry.missingIsbnCount, 1);
  });
}
