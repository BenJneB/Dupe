import 'package:dupe/core/sync/supabase_sync.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';

void main() {
  SyncFailure of(String? code) => SupabaseSyncRemote.failureOf(
    PostgrestException(message: 'm', code: code),
  );

  test('an anonymous request (42501) asks to sign in again', () {
    // Seen after a refused token refresh: "permission denied for table".
    expect(of('42501'), SyncFailure.session);
    expect(of('PGRST301'), SyncFailure.session);
    expect(of('PGRST303'), SyncFailure.session);
  });

  test('only an HTTP status of 5xx means the server is unavailable', () {
    expect(of('502'), SyncFailure.unavailable);
    expect(of('404'), SyncFailure.rejected);
    // SQLSTATE codes are not HTTP statuses (was "unavailable").
    expect(of('23502'), SyncFailure.rejected);
    expect(of('PGRST205'), SyncFailure.rejected);
    expect(of(null), SyncFailure.rejected);
  });

  test('without a session nothing is queried as anonymous', () async {
    final remote = SupabaseSyncRemote(
      SupabaseClient('http://127.0.0.1:9', 'anon'),
    );
    await expectLater(
      remote.changesSince('series', null, limit: 10),
      throwsA(
        isA<SyncException>().having(
          (e) => e.failure,
          'failure',
          SyncFailure.session,
        ),
      ),
    );
  });
}
