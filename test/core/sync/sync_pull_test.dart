import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_sync_remote.dart';
import '../../helpers/sync_device.dart';

/// Pull edge cases (phase 9): rows must never be skipped by the cursor.
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

  Future<String> addBook(Device d, String title) async {
    final item = d.repo.newItem(CollectionType.livre).copyWith(title: title);
    await d.repo.saveItem(item);
    return item.id;
  }

  test('a row committed late, stamped before the cursor, is pulled', () async {
    final a = await addBook(phone, 'A');
    await phone.sync();
    await pc.sync();
    expect(await pc.repo.getItem(a), isNotNull);

    // The phone's next upsert took its server stamp before the PC's last
    // pull but committed after it.
    final b = await addBook(phone, 'B');
    remote.nextUpsertLag = const Duration(seconds: 5);
    await phone.sync();

    expect((await pc.sync()).pulled, 1);
    expect(await pc.repo.getItem(b), isNotNull);
  });

  test('rows sharing one server stamp across pages are all pulled', () async {
    remote.step = Duration.zero;
    final ids = [for (var i = 0; i < 5; i++) await addBook(phone, 'L$i')];
    await phone.sync();

    final small = Device(remote, pageSize: 2);
    addTearDown(small.dispose);
    expect((await small.sync()).pulled, 5);
    for (final id in ids) {
      expect(await small.repo.getItem(id), isNotNull);
    }
  });

  test('the overlap re-reads rows without rewriting them', () async {
    await addBook(phone, 'A');
    await phone.sync();
    expect(await pc.sync(), (pushed: 0, pulled: 1));

    final writes = <Object?>[];
    final sub = pc.db.tableUpdates().listen(writes.add);
    addTearDown(sub.cancel);
    expect(await pc.sync(), (pushed: 0, pulled: 0));
    expect(await phone.sync(), (pushed: 0, pulled: 0));
    await Future<void>.delayed(Duration.zero);
    expect(writes, isEmpty);
  });

  test('a row of an older schema (server not migrated, old backup) is '
      'pulled: newer columns keep their default or local value', () async {
    final id = await addBook(phone, 'Antidote');
    await phone.sync();
    // The server has no signing columns yet (phase 31 migration not run).
    const newer = [
      'is_signed',
      'signed_by',
      'signed_on',
      'signed_place',
      'signing_note',
    ];
    remote.tables['items']![id]!.removeWhere((k, _) => newer.contains(k));

    await pc.sync();
    final pulled = (await pc.repo.getItem(id))!;
    expect((pulled.title, pulled.isSigned), ('Antidote', false));

    // Signed on the PC, then changed elsewhere without those columns.
    await pc.repo.saveItem(pulled.copyWith(isSigned: true, signedBy: 'O. H.'));
    await pc.sync();
    final row = {...remote.tables['items']![id]!}
      ..removeWhere((k, _) => newer.contains(k) || k == 'server_updated_at');
    final later = DateTime.parse(row['updated_at']! as String)
        .add(const Duration(minutes: 1));
    // Another app version, not knowing the columns, writes the row.
    await remote.upsert('items', [
      {
        ...row,
        'title': 'Antidote au culte de la performance',
        'updated_at': later.toUtc().toIso8601String(),
      },
    ]);
    await pc.sync();
    final merged = (await pc.repo.getItem(id))!;
    expect(
      (merged.title, merged.isSigned, merged.signedBy),
      ('Antidote au culte de la performance', true, 'O. H.'),
    );
  });

  test('a new local schema pulls every row again (columns it added)', () async {
    final id = await addBook(phone, 'Dédicacé');
    final signed = (await phone.repo.getItem(id))!
        .copyWith(isSigned: true, signedBy: 'L’autrice');
    await phone.repo.saveItem(signed);
    await phone.sync();
    await pc.sync();
    // Pulled before its migration added the signing columns: they hold
    // their default, with the same updated_at as the server row.
    await pc.db.customStatement(
      "UPDATE items SET is_signed = 0, signed_by = NULL WHERE id = '$id'",
    );
    final quiet = await pc.sync();
    expect(quiet.pulled, 0);
    expect((await pc.repo.getItem(id))!.isSigned, isFalse);

    // First sync on a new schema: everything is read again and rewritten.
    await pc.db.customStatement(
      "DELETE FROM app_settings WHERE key = 'sync_schema_version'",
    );
    await pc.sync();
    final item = (await pc.repo.getItem(id))!;
    expect(item.isSigned, isTrue);
    expect(item.signedBy, 'L’autrice');
    // Done once: the next sync is incremental again.
    expect((await pc.sync()).pulled, 0);
  });
}
