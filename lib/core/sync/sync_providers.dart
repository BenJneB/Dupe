import 'package:dupe/core/config/env.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/sync/supabase_sync.dart';
import 'package:dupe/core/sync/sync_auth.dart';
import 'package:dupe/core/sync/sync_engine.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase/supabase.dart';

part 'sync_providers.g.dart';

/// Supabase client, or null in local-only mode (no URL/key in env.json).
@Riverpod(keepAlive: true)
SupabaseClient? supabaseClient(Ref ref) {
  if (Env.supabaseUrl.isEmpty || Env.supabaseAnonKey.isEmpty) return null;
  final client = SupabaseClient(
    Env.supabaseUrl,
    Env.supabaseAnonKey,
    // Email codes only: no redirect, so no PKCE verifier to store.
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );
  ref.onDispose(client.dispose);
  return client;
}

@Riverpod(keepAlive: true)
SyncAuth syncAuth(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const LocalOnlyAuth();
  final auth = SupabaseSyncAuth(client, ref.watch(appSettingsStoreProvider));
  ref.onDispose(auth.dispose);
  return auth;
}

@Riverpod(keepAlive: true)
SyncRemote? syncRemote(Ref ref) => switch (ref.watch(supabaseClientProvider)) {
  final client? => SupabaseSyncRemote(client),
  null => null,
};

@Riverpod(keepAlive: true)
SyncEngine? syncEngine(Ref ref) => switch (ref.watch(syncRemoteProvider)) {
  final remote? => SyncEngine(
    ref.watch(appDatabaseProvider),
    remote,
    ref.watch(appSettingsStoreProvider),
  ),
  null => null,
};
