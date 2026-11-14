import 'package:dupe/core/sync/email_sign_in.dart';

/// Account used for the sync (email + 6-digit code, PLAN.md §6).
abstract interface class SyncAuth {
  /// False when env.json has no Supabase URL / key: local-only mode.
  bool get configured;

  /// Signed-in user, or null.
  String? get userId;
  String? get email;

  /// Emits on sign-in / sign-out.
  Stream<void> get changes;

  /// Restores the saved session (call once at start-up).
  Future<void> restore();

  /// Sends a 6-digit code to [email] (creates the account if needed).
  Future<void> sendCode(String email);

  /// Signs in with the received code or pasted link.
  Future<void> verify(String email, EmailCredential credential);

  Future<void> signOut();
}

/// No Supabase configured: the app works locally only.
class LocalOnlyAuth implements SyncAuth {
  const new();

  @override
  bool get configured => false;
  @override
  String? get userId => null;
  @override
  String? get email => null;
  @override
  Stream<void> get changes => const Stream.empty();
  @override
  Future<void> restore() async {}
  @override
  Future<void> sendCode(String email) => throw UnsupportedError('local only');
  @override
  Future<void> verify(String email, EmailCredential credential) =>
      throw UnsupportedError('local only');
  @override
  Future<void> signOut() async {}
}
