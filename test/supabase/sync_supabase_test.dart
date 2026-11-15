@Tags(['supabase'])
library;

import 'package:dupe/core/sync/sync_remote.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'local_supabase.dart';

/// The sync against a real PostgREST/Postgres (what fake_sync_remote.dart
/// simulates): pull filter, ties, late commits, triggers, soft deletes, RLS.
void main() {
  late Account account;
  late RealDevice phone;
  late RealDevice pc;

  setUp(() async {
    if (LocalSupabase.skip != false) return;
    account = await LocalSupabase.newAccount();
    phone = RealDevice(account.client);
    pc = RealDevice(await LocalSupabase.signIn(account), pageSize: 2);
  });
  tearDown(() async {
    if (LocalSupabase.skip != false) return;
    await phone.dispose();
    await pc.dispose();
  });

  Future<String> addBook(RealDevice d, String title) async {
    final item = d.repo.newItem(CollectionType.livre).copyWith(title: title);
    await d.repo.saveItem(item);
    return item.id;
  }

  Future<List<String>> titlesOn(RealDevice d) async => [
    for (final i in await d.db.select(d.db.itemsTable).get())
      if (i.deletedAt == null) i.title,
  ]..sort();

  test('additions and deletions go both ways', () async {
    final dune = await addBook(phone, 'Dune');
    await phone.sync(account.userId);
    await pc.sync(account.userId);
    expect(await titlesOn(pc), ['Dune']);

    await addBook(pc, 'Fondation');
    await pc.sync(account.userId);
    await phone.repo.deleteItem(dune);
    await phone.sync(account.userId);
    await pc.sync(account.userId);
    expect(await titlesOn(phone), ['Fondation']);
    expect(await titlesOn(pc), ['Fondation']);
  }, skip: LocalSupabase.skip);

  test('rows sharing one server stamp across pages are all pulled '
      '(real or() filter)', () async {
    final ids = [for (var i = 0; i < 5; i++) await addBook(phone, 'L$i')];
    await phone.sync(account.userId);
    await LocalSupabase.stampItems(ids, '2026-11-14T10:00:00.123456Z');

    // pc pulls 2 rows per page: the ties are split across pages.
    await pc.sync(account.userId);
    expect(await titlesOn(pc), ['L0', 'L1', 'L2', 'L3', 'L4']);
  }, skip: LocalSupabase.skip);

  test('a row stamped before the cursor (late commit) is pulled', () async {
    await addBook(phone, 'A');
    await phone.sync(account.userId);
    await pc.sync(account.userId);

    final late = await addBook(phone, 'B');
    await phone.sync(account.userId);
    // B looks committed 5 s before what pc already pulled.
    final before = DateTime.now().toUtc().subtract(const Duration(seconds: 5));
    await LocalSupabase.stampItems([late], before.toIso8601String());
    await pc.sync(account.userId);
    expect(await titlesOn(pc), ['A', 'B']);
  }, skip: LocalSupabase.skip);

  test('the server keeps the most recent write and the owner', () async {
    final id = await addBook(phone, 'Dune');
    await phone.sync(account.userId);
    final row = (await phone.remote.changesSince(
      'items',
      null,
      limit: 10,
    )).single;
    final older = DateTime.parse(row['updated_at']! as String)
        .subtract(const Duration(hours: 1));
    await phone.remote.upsert(
      'items',
      [
        {...row, 'title': 'Old', 'updated_at': older.toUtc().toIso8601String()},
      ]..forEach((r) => r.remove('server_updated_at')),
    );

    final after = (await phone.remote.changesSince(
      'items',
      null,
      limit: 10,
    )).single;
    expect(after['id'], id);
    expect(after['title'], 'Dune');
    expect(after['user_id'], account.userId);
  }, skip: LocalSupabase.skip);

  test('another account sees nothing and cannot overwrite', () async {
    final id = await addBook(phone, 'Dune');
    await phone.sync(account.userId);
    final row = (await phone.remote.changesSince(
      'items',
      null,
      limit: 10,
    )).single;

    final other = await LocalSupabase.newAccount();
    final intruder = RealDevice(other.client);
    addTearDown(intruder.dispose);
    expect(
      await intruder.remote.changesSince('items', null, limit: 10),
      isEmpty,
    );
    await expectLater(
      intruder.remote.upsert('items', [
        {...row, 'title': 'Hacked', 'user_id': other.userId}
          ..remove('server_updated_at'),
      ]),
      throwsA(isA<SyncException>()),
    );
    final still = (await phone.remote.changesSince(
      'items',
      null,
      limit: 10,
    )).single;
    expect(still['id'], id);
    expect(still['title'], 'Dune');
  }, skip: LocalSupabase.skip);
}
