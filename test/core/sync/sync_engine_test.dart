import 'package:dupe/core/sync/sync_remote.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_sync_remote.dart';
import '../../helpers/sync_device.dart';

void main() {
  late FakeSyncRemote remote;
  late Device phone;
  late Device pc;

  setUp(() {
    remote = FakeSyncRemote();
    phone = Device(remote);
    pc = Device(remote);
  });
  tearDown(() async {
    await phone.dispose();
    await pc.dispose();
  });

  test(
    'an addition on the phone appears on the PC (phase 7 criterion)',
    () async {
      final series = phone.repo
          .newSeries(CollectionType.manga)
          .copyWith(
            title: 'Dreamland',
            authors: ['Reno Lemaire'],
            externalIds: {'anilist_id': '1'},
            totalVolumes: 24,
          );
      await phone.repo.saveSeries(series);
      final item = phone.repo
          .newItem(CollectionType.manga, series: series, volumeNumber: '1')
          .copyWith(
            isbn13: '9782845995581',
            purchasePrice: 7.2,
            purchaseDate: DateTime(2026, 11, 3),
            isFirstEdition: true,
            readingStatus: ReadingStatus.lu,
          );
      await phone.repo.saveItem(item);
      await phone.loans.lend(
        item.id,
        borrower: 'Alice',
        dueAt: DateTime(2026, 12),
      );

      expect(await phone.sync(), (pushed: 3, pulled: 3));
      expect(await pc.sync(), (pushed: 0, pulled: 3));

      final onPc = (await pc.repo.getItem(item.id))!;
      final onPhone = (await phone.repo.getItem(item.id))!;
      // Every field survives the round trip (dates as the same instants).
      expect(onPc, onPhone);
      expect(onPc.syncPending, isFalse);
      expect(onPc.userId, user);
      final seriesOnPc = (await pc.repo.getSeries(series.id))!;
      expect(seriesOnPc.authors, ['Reno Lemaire']);
      expect(seriesOnPc.externalIds, {'anilist_id': '1'});
      expect(await pc.loans.activeLoans(), hasLength(1));

      // Nothing left to do on either side.
      expect(await phone.sync(), (pushed: 0, pulled: 0));
      expect(await pc.sync(), (pushed: 0, pulled: 0));
    },
  );

  test('an offline change is synced when the network is back '
      '(phase 7 criterion)', () async {
    final item = pc.repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
    await pc.repo.saveItem(item);
    await pc.sync();
    await phone.sync();

    remote.offline = true;
    phone.now = phone.now.add(const Duration(hours: 1));
    await phone.repo.saveItem(
      (await phone.repo.getItem(item.id))!.copyWith(location: 'Salon'),
    );
    await expectLater(
      phone.sync(),
      throwsA(isA<SyncException>().having((e) => e.offline, 'offline', true)),
    );
    expect((await phone.repo.getItem(item.id))!.syncPending, isTrue);

    remote.offline = false;
    await phone.sync();
    await pc.sync();
    expect((await pc.repo.getItem(item.id))!.location, 'Salon');
  });

  test('conflict: the most recent change wins on both devices', () async {
    final item = pc.repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
    await pc.repo.saveItem(item);
    await pc.sync();
    await phone.sync();

    // PC edits first (offline), the phone later; the PC syncs last.
    pc.now = DateTime(2026, 11, 14, 11);
    await pc.repo.saveItem(item.copyWith(notes: 'from pc'));
    phone.now = DateTime(2026, 11, 14, 12);
    await phone.repo.saveItem(
      (await phone.repo.getItem(item.id))!.copyWith(notes: 'from phone'),
    );
    await phone.sync();
    await pc.sync();
    await phone.sync();

    expect((await pc.repo.getItem(item.id))!.notes, 'from phone');
    expect((await phone.repo.getItem(item.id))!.notes, 'from phone');
  });

  test('a local change newer than the pulled one is kept and pushed', () async {
    final item = pc.repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
    await pc.repo.saveItem(item);
    await pc.sync();
    await phone.sync();

    pc.now = DateTime(2026, 11, 14, 11);
    await pc.repo.saveItem(item.copyWith(notes: 'older'));
    await pc.sync();
    // Phone edited later but has not pushed yet when it pulls.
    phone.now = DateTime(2026, 11, 14, 12);
    await phone.repo.saveItem(
      (await phone.repo.getItem(item.id))!.copyWith(notes: 'newer'),
    );
    await phone.sync();
    await pc.sync();

    expect((await phone.repo.getItem(item.id))!.notes, 'newer');
    expect((await pc.repo.getItem(item.id))!.notes, 'newer');
  });

  test('deletions propagate (soft delete)', () async {
    final series = pc.repo.newSeries(CollectionType.bd).copyWith(title: 'X');
    await pc.repo.saveSeries(series);
    await pc.repo.addVolumeRange(series, from: 1, to: 3);
    await pc.sync();
    await phone.sync();

    await phone.repo.deleteSeries(series.id);
    await phone.sync();
    await pc.sync();

    expect(await pc.repo.getSeries(series.id), isNull);
    expect(await pc.repo.listSeriesItems(series.id), isEmpty);
  });

  test('large collections are pushed and pulled in pages', () async {
    final big = Device(remote, pageSize: 7);
    final other = Device(remote, pageSize: 7);
    addTearDown(big.dispose);
    addTearDown(other.dispose);
    final series = big.repo
        .newSeries(CollectionType.manga)
        .copyWith(title: 'OP');
    await big.repo.saveSeries(series);
    await big.repo.addVolumeRange(series, from: 1, to: 30);

    await big.sync();
    expect(remote.upserts, 1 + 5);
    expect((await other.sync()).pulled, 31);
  });
}
