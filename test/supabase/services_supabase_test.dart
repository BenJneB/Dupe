@Tags(['supabase'])
library;

import 'dart:typed_data';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/sync/supabase_sync.dart';
import 'package:dupe/core/sync/sync_auth.dart';
import 'package:dupe/features/covers/data/supabase_cover_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'local_supabase.dart';

/// Password accounts, keep_alive(), private cover photos, on a real local
/// Supabase (GoTrue, PostgREST, Storage).
void main() {
  test('sign up, sign in, wrong password, email taken', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final auth = SupabaseSyncAuth(LocalSupabase.client(), AppSettingsStore(db));
    addTearDown(auth.dispose);
    final email = 'dupe-${const Uuid().v4()}@example.test';

    expect(await auth.signUp(email, 'first-password-1'), isTrue);
    expect(auth.userId, isNotNull);
    await auth.setPassword('second-password-2');
    await auth.signOut();
    expect(auth.userId, isNull);

    await expectLater(
      auth.signIn(email, 'first-password-1'),
      throwsA(
        isA<SignInException>().having(
          (e) => e.failure,
          'failure',
          SignInFailure.invalidCredentials,
        ),
      ),
    );
    await auth.signIn(email, 'second-password-2');
    expect(auth.email, email);
    await expectLater(
      auth.signUp(email, 'third-password-3'),
      throwsA(
        isA<SignInException>().having(
          (e) => e.failure,
          'failure',
          SignInFailure.emailTaken,
        ),
      ),
    );
  }, skip: LocalSupabase.skip);

  test(
    'keep_alive() answers without an account, with the server time',
    () async {
      final remote = SupabaseSyncRemote(LocalSupabase.client());
      final server = await remote.serverTime();
      expect(server, isNotNull);
      expect(
        server!.difference(DateTime.now()).abs(),
        lessThan(const Duration(minutes: 2)),
      );
    },
    skip: LocalSupabase.skip,
  );

  test('cover photos are private to their owner', () async {
    final owner = await LocalSupabase.newAccount();
    final other = await LocalSupabase.newAccount();
    final mine = SupabaseCoverStore(owner.client, () => owner.userId);
    final theirs = SupabaseCoverStore(other.client, () => other.userId);
    final bytes = Uint8List.fromList(List.generate(64, (i) => i));

    await mine.upload('item-1.jpg', bytes);
    expect(await mine.download('item-1.jpg'), bytes);
    // Same name in another account: its own (empty) folder.
    expect(await theirs.download('item-1.jpg'), isNull);
    final direct = other.client.storage.from('covers');
    await expectLater(
      direct.download('${owner.userId}/item-1.jpg'),
      throwsA(anything),
    );
  }, skip: LocalSupabase.skip);
}
