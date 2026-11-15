import 'dart:io';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/sync/supabase_sync.dart';
import 'package:dupe/core/sync/sync_engine.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

/// Access to the LOCAL Supabase started by `tool/supabase_tests.sh`
/// (PLAN_V3 phase 17). Never the remote project.
abstract final class LocalSupabase {
  static final Map<String, String> _env = Platform.environment;
  static String get url => _env['SUPABASE_TEST_URL'] ?? '';
  static String get anonKey => _env['SUPABASE_TEST_ANON_KEY'] ?? '';
  static String get dbUrl => _env['SUPABASE_TEST_DB_URL'] ?? '';

  /// `skip:` value of the tests: a reason when no local Supabase is given.
  static Object get skip => url.isEmpty || anonKey.isEmpty
      ? 'No local Supabase: run tool/supabase_tests.sh'
      : false;

  static SupabaseClient client() => SupabaseClient(
    url,
    anonKey,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

  /// A fresh account per test (email confirmation is off locally).
  static Future<Account> newAccount() async {
    final email = 'dupe-${const Uuid().v4()}@example.test';
    const password = 'local-test-password';
    final client = LocalSupabase.client();
    final response = await client.auth.signUp(email: email, password: password);
    return (
      client: client,
      userId: response.user!.id,
      email: email,
      password: password,
    );
  }

  /// The same account signed in on another client (a second device).
  static Future<SupabaseClient> signIn(Account account) async {
    final client = LocalSupabase.client();
    await client.auth.signInWithPassword(
      email: account.email,
      password: account.password,
    );
    return client;
  }

  /// Runs SQL on the local database as its owner, e.g. to set
  /// `server_updated_at` with the sync trigger disabled (ties, late commits).
  static Future<String> sql(String statement) async {
    final result = await Process.run('psql', [
      dbUrl,
      '-v',
      'ON_ERROR_STOP=1',
      '-At',
      '-c',
      statement,
    ]);
    if (result.exitCode != 0) throw StateError('psql: ${result.stderr}');
    return (result.stdout as String).trim();
  }

  /// Sets `server_updated_at` of items rows without the trigger (which would
  /// overwrite it).
  static Future<void> stampItems(List<String> ids, String instant) => sql('''
begin;
alter table public.items disable trigger items_sync;
update public.items set server_updated_at = '$instant'
  where id in (${ids.map((id) => "'$id'").join(', ')});
alter table public.items enable trigger items_sync;
commit;''');
}

typedef Account = ({
  SupabaseClient client,
  String userId,
  String email,
  String password,
});

/// One installation of the app synced with the local Supabase.
class RealDevice {
  new(SupabaseClient client, {int pageSize = 500}) : db = AppDatabase.memory() {
    remote = SupabaseSyncRemote(client);
    repo = CollectionRepository(db, now: DateTime.now, newId: const Uuid().v7);
    engine = SyncEngine(db, remote, AppSettingsStore(db), pageSize: pageSize);
  }

  final AppDatabase db;
  late final SupabaseSyncRemote remote;
  late final CollectionRepository repo;
  late final SyncEngine engine;

  Future<SyncReport> sync(String userId) => engine.sync(userId);
  Future<void> dispose() => db.close();
}
