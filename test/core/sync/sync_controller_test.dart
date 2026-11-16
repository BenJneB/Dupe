import 'dart:async';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_controller.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_sync_auth.dart';
import '../../helpers/fake_sync_remote.dart';
import '../../helpers/test_repositories.dart';

/// Remote whose pulls wait for [gate] while it is set.
class _HeldRemote extends FakeSyncRemote {
  Completer<void>? gate;
  int pulls = 0;

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    SyncCursor? after, {
    required int limit,
  }) async {
    pulls++;
    await gate?.future;
    return await super.changesSince(table, after, limit: limit);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a session ended during a sync: triggers restart at sign-in', () async {
    await appLog.clear();
    final env = TestEnv();
    addTearDown(env.dispose);
    final auth = FakeSyncAuth(signedInAs: 'a@b.c');
    final remote = _HeldRemote()..gate = Completer<void>();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(env.db),
        syncAuthProvider.overrideWithValue(auth),
        syncRemoteProvider.overrideWithValue(remote),
        coverStoreProvider.overrideWithValue(null),
      ],
    );
    addTearDown(container.dispose);
    container.listen(syncControllerProvider, (_, _) {});
    SyncPhase phase() => container.read(syncControllerProvider).phase;

    // restore() signs in: a sync starts and waits on the server.
    await pumpEventQueue();
    expect(phase(), SyncPhase.syncing);

    // The session is revoked meanwhile (refresh token refused).
    await auth.signOut();
    expect(phase(), SyncPhase.signedOut);
    remote.gate!.complete();
    remote.gate = null;
    await pumpEventQueue();
    expect(phase(), SyncPhase.signedOut);

    // Signing in again syncs at once.
    final before = remote.pulls;
    await auth.signIn('a@b.c', 'secret1');
    await pumpEventQueue();
    expect(remote.pulls, greaterThan(before));
    expect(phase(), SyncPhase.idle);
  });
}
