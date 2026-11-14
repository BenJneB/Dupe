import 'dart:async';

import 'package:dupe/core/sync/sync_auth.dart';

/// Supabase-like accounts in memory: passwords of at least 6 characters,
/// optional email confirmation ([confirmEmail]).
class FakeSyncAuth implements SyncAuth {
  new({String? signedInAs, this.confirmEmail = false}) : _email = signedInAs {
    if (signedInAs != null) passwords[signedInAs] = 'secret1';
  }

  /// Supabase "Confirm email" option.
  bool confirmEmail;
  final passwords = <String, String>{};
  final unconfirmed = <String>{};
  final _changes = StreamController<void>.broadcast();
  String? _email;

  static const id = '00000000-0000-0000-0000-00000000000a';

  @override
  bool get configured => true;
  @override
  String? get userId => _email == null ? null : id;
  @override
  String? get email => _email;
  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<void> restore() async => _changes.add(null);

  @override
  Future<void> signIn(String email, String password) async {
    if (passwords[email] != password) {
      throw const SignInException(SignInFailure.invalidCredentials, 'x');
    }
    if (unconfirmed.contains(email)) {
      throw const SignInException(SignInFailure.emailNotConfirmed, 'x');
    }
    _email = email;
    _changes.add(null);
  }

  @override
  Future<bool> signUp(String email, String password) async {
    if (passwords.containsKey(email)) {
      throw const SignInException(SignInFailure.emailTaken, 'x');
    }
    _checkStrength(password);
    passwords[email] = password;
    if (confirmEmail) {
      unconfirmed.add(email);
      return false;
    }
    _email = email;
    _changes.add(null);
    return true;
  }

  /// The user opened the confirmation link.
  void confirm(String email) => unconfirmed.remove(email);

  @override
  Future<void> setPassword(String password) async {
    final email = _email;
    if (email == null) throw StateError('signed out');
    _checkStrength(password);
    passwords[email] = password;
  }

  static void _checkStrength(String password) {
    if (password.length < 6) {
      throw const SignInException(SignInFailure.weakPassword, 'x');
    }
  }

  @override
  Future<void> signOut() async {
    _email = null;
    _changes.add(null);
  }
}
