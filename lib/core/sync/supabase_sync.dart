import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/email_sign_in.dart';
import 'package:dupe/core/sync/sync_auth.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:http/http.dart' show ClientException;
import 'package:supabase/supabase.dart';

/// [SyncAuth] with Supabase email OTP. The session is kept in the local
/// `app_settings` table and its token refreshed automatically.
class SupabaseSyncAuth implements SyncAuth {
  new(this.client, this._settings) {
    _sub = client.auth.onAuthStateChange.listen(_onAuthChange);
  }

  final SupabaseClient client;
  final AppSettingsStore _settings;
  final _changes = StreamController<void>.broadcast();
  late final StreamSubscription<AuthState> _sub;

  static const _sessionKey = 'supabase_session';

  @override
  bool get configured => true;
  @override
  String? get userId => client.auth.currentUser?.id;
  @override
  String? get email => client.auth.currentUser?.email;
  @override
  Stream<void> get changes => _changes.stream;

  Future<void> _onAuthChange(AuthState state) async {
    final session = state.session;
    if (state.event == AuthChangeEvent.signedOut || session == null) {
      await _settings.set(_sessionKey, '');
    } else {
      await _settings.set(_sessionKey, jsonEncode(session.toJson()));
    }
    _changes.add(null);
  }

  @override
  Future<void> restore() async {
    final saved = await _settings.get(_sessionKey);
    if (saved == null || saved.isEmpty) return;
    try {
      // No network needed; an expired token is refreshed when possible.
      await client.auth.setInitialSession(saved);
      if (client.auth.currentSession?.isExpired ?? false) {
        await client.auth.refreshSession();
      }
    } on Object catch (e) {
      appLog.warning('auth', 'Session not restored now: $e');
    }
    _changes.add(null);
  }

  @override
  Future<void> sendCode(String email) => _signInGuard(
    () =>
        client.auth.signInWithOtp(email: email.trim(), shouldCreateUser: true),
  );

  @override
  Future<void> verify(String email, EmailCredential credential) =>
      _signInGuard(() => _verify(email, credential));

  /// Supabase errors become [SignInException] / offline [SyncException].
  Future<void> _signInGuard(Future<void> Function() call) async {
    try {
      await call();
    } on AuthRetryableFetchException catch (e) {
      throw SyncException.network(e.message);
    } on SocketException catch (e) {
      throw SyncException.network(e.message);
    } on ClientException catch (e) {
      throw SyncException.network(e.message);
    } on AuthException catch (e) {
      throw SignInException(switch ((e.statusCode, e.code)) {
        ('429', _) ||
        (_, 'over_email_send_rate_limit') => SignInFailure.tooManyAttempts,
        (_, 'otp_expired') || ('403', _) => SignInFailure.invalidCode,
        _ => SignInFailure.refused,
      }, e.message);
    }
  }

  Future<void> _verify(String email, EmailCredential credential) =>
      switch (credential) {
        EmailCode(:final code) => client.auth.verifyOTP(
          email: email.trim(),
          token: code,
          type: OtpType.email,
        ),
        EmailLink(:final tokenHash, :final type) => client.auth.verifyOTP(
          tokenHash: tokenHash,
          type: switch (type) {
            'signup' => OtpType.signup,
            'invite' => OtpType.invite,
            'email' => OtpType.email,
            _ => OtpType.magiclink,
          },
        ),
      };

  @override
  Future<void> signOut() => client.auth.signOut();

  void dispose() {
    unawaited(_sub.cancel());
    unawaited(_changes.close());
  }
}

/// [SyncRemote] on the Supabase REST API (tables of the migration).
class SupabaseSyncRemote implements SyncRemote {
  const new(this.client);

  final SupabaseClient client;

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) =>
      _guard(() => client.from(table).upsert(rows, onConflict: 'id'));

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    SyncCursor? after, {
    required int limit,
  }) => _guard(() {
    final query = client.from(table).select();
    final filtered = switch (after) {
      null => query,
      (:final at, id: null) => query.gte('server_updated_at', at),
      // Keyset on (server_updated_at, id); values quoted for PostgREST.
      (:final at, :final id?) => query.or(
        'server_updated_at.gt."$at",'
        'and(server_updated_at.eq."$at",id.gt.$id)',
      ),
    };
    return filtered
        .order('server_updated_at', ascending: true)
        .order('id', ascending: true)
        .limit(limit);
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on SocketException catch (e) {
      throw SyncException.network(e.message);
    } on ClientException catch (e) {
      throw SyncException.network(e.message);
    } on TimeoutException {
      throw const SyncException.network('timeout');
    } on PostgrestException catch (e) {
      // PGRST301/303: JWT invalid or expired.
      final expired = e.code == 'PGRST301' || e.code == 'PGRST303';
      throw SyncException(
        e.message,
        failure: expired ? SyncFailure.session : SyncFailure.rejected,
      );
    } on AuthException catch (e) {
      throw SyncException(e.message, failure: SyncFailure.session);
    }
  }
}
