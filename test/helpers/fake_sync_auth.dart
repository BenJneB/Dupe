import 'dart:async';

import 'package:dupe/core/sync/email_sign_in.dart';
import 'package:dupe/core/sync/sync_auth.dart';

/// Account accepting the code [validCode] for any email.
class FakeSyncAuth implements SyncAuth {
  new({this.validCode = '123456', String? signedInAs}) : _email = signedInAs;

  final String validCode;
  final _changes = StreamController<void>.broadcast();
  final sentTo = <String>[];
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
  Future<void> sendCode(String email) async => sentTo.add(email);

  /// Accepts [validCode], or a link whose token is [validLinkToken].
  static const validLinkToken = 'pkce-free-hash';

  @override
  Future<void> verify(String email, EmailCredential credential) async {
    final ok = switch (credential) {
      EmailCode(:final code) => code == validCode,
      EmailLink(:final tokenHash) => tokenHash == validLinkToken,
    };
    if (!ok) throw Exception('Token has expired or is invalid');
    _email = email;
    _changes.add(null);
  }

  @override
  Future<void> signOut() async {
    _email = null;
    _changes.add(null);
  }
}
