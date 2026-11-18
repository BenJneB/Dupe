/// Account used for the sync: email + password (PLAN_V2 phase 10).
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

  Future<void> signIn(String email, String password);

  /// Creates the account. Returns true when signed in right away, false when
  /// the email must be confirmed first (Supabase "Confirm email" option).
  Future<bool> signUp(String email, String password);

  /// Sets or changes the password of the signed-in user (accounts created
  /// with an email link before phase 10 have none).
  Future<void> setPassword(String password);

  /// Confirms the address with the 6-digit code of the confirmation email
  /// (PLAN_V4 phase 34), then signs in.
  Future<void> confirmSignUp(String email, String code);

  /// Sends the confirmation email (and its code) again.
  Future<void> resendConfirmation(String email);

  /// Sends a password reset email with a 6-digit code (signed out).
  Future<void> sendPasswordReset(String email);

  /// Checks the reset [code], sets [password] and signs in.
  Future<void> resetPassword(String email, String code, String password);

  Future<void> signOut();
}

/// The token of an email link pasted instead of a code: the default
/// Supabase emails (no SMTP: templates cannot hold the 6-digit code) only
/// have a link, `…/auth/v1/verify?token=<hash>&type=…`. Null for a code.
String? emailLinkToken(String input) {
  final uri = Uri.tryParse(input.trim());
  if (uri == null || !uri.hasScheme) return null;
  final token =
      uri.queryParameters['token'] ?? uri.queryParameters['token_hash'];
  return token == null || token.isEmpty ? null : token;
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
  Future<void> signIn(String email, String password) =>
      throw UnsupportedError('local only');
  @override
  Future<bool> signUp(String email, String password) =>
      throw UnsupportedError('local only');
  @override
  Future<void> setPassword(String password) =>
      throw UnsupportedError('local only');
  @override
  Future<void> confirmSignUp(String email, String code) =>
      throw UnsupportedError('local only');
  @override
  Future<void> resendConfirmation(String email) =>
      throw UnsupportedError('local only');
  @override
  Future<void> sendPasswordReset(String email) =>
      throw UnsupportedError('local only');
  @override
  Future<void> resetPassword(String email, String code, String password) =>
      throw UnsupportedError('local only');
  @override
  Future<void> signOut() async {}
}

/// Why a sign-in / sign-up step was refused.
enum SignInFailure {
  invalidCredentials,
  emailNotConfirmed,
  emailTaken,
  weakPassword,
  tooManyAttempts,

  /// Wrong or expired email code (phase 34).
  invalidCode,
  refused,
}

class SignInException implements Exception {
  const new(this.failure, this.message);

  final SignInFailure failure;
  final String message;

  @override
  String toString() => 'SignInException(${failure.name}): $message';
}
