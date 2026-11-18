import 'package:dupe/core/sync/sync_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_sync_auth.dart';
import '../../helpers/fake_sync_remote.dart';
import '../../helpers/screen_helpers.dart';

Future<FakeSyncAuth> pumpWith(WidgetTester tester, FakeSyncAuth auth) async {
  await pumpApp(
    tester,
    overrides: [
      syncAuthProvider.overrideWithValue(auth),
      syncRemoteProvider.overrideWithValue(FakeSyncRemote()),
    ],
  );
  await openSettings(tester);
  return auth;
}

Finder fieldIn(String key) =>
    find.descendant(of: find.byKey(Key(key)), matching: find.byType(TextField));

void main() {
  testWidgets('sign in: wrong password, then the right one', (tester) async {
    final auth = FakeSyncAuth()..passwords['moi@exemple.be'] = 'secret1';
    await pumpWith(tester, auth);
    await tester.tap(find.byKey(const Key('signInTile')));
    await tester.pumpAndSettle();

    await fillSignIn(tester, 'pas-un-email', 'x');
    expect(find.text('Adresse email invalide'), findsOneWidget);
    await fillSignIn(tester, 'moi@exemple.be', 'mauvais');
    expect(find.text('Email ou mot de passe incorrect.'), findsOneWidget);
    await fillSignIn(tester, 'moi@exemple.be', 'secret1');

    expect(find.text('Connecté : moi@exemple.be'), findsOneWidget);
  });

  testWidgets('sign up without email confirmation signs in at once', (
    tester,
  ) async {
    final auth = await pumpWith(tester, FakeSyncAuth());
    await tester.tap(find.byKey(const Key('signInTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggleModeButton')));
    await tester.pumpAndSettle();

    await fillSignIn(tester, 'moi@exemple.be', '123', confirm: '123');
    expect(find.textContaining('trop court'), findsOneWidget);
    await fillSignIn(tester, 'moi@exemple.be', 'secret1', confirm: 'secret1');

    expect(find.text('Connecté : moi@exemple.be'), findsOneWidget);
    expect(auth.passwords, {'moi@exemple.be': 'secret1'});
  });

  testWidgets('an account created by email link gets a password', (
    tester,
  ) async {
    final auth = await pumpWith(
      tester,
      FakeSyncAuth(signedInAs: 'moi@exemple.be'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('setPasswordTile')));
    await tester.pumpAndSettle();

    await tester.enterText(fieldIn('newPasswordField'), 'nouveau1');
    await tester.enterText(fieldIn('newPasswordConfirmField'), 'nouveau2');
    await tester.tap(find.byKey(const Key('savePasswordButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('setPasswordError')), findsOneWidget);

    await tester.enterText(fieldIn('newPasswordConfirmField'), 'nouveau1');
    await tester.tap(find.byKey(const Key('savePasswordButton')));
    await tester.pumpAndSettle();
    expect(find.text('Mot de passe enregistré'), findsOneWidget);
    expect(auth.passwords['moi@exemple.be'], 'nouveau1');
  });

  testWidgets('sign up confirmed with the email code (phase 34)', (
    tester,
  ) async {
    final auth = await pumpWith(tester, FakeSyncAuth(confirmEmail: true));
    await tester.tap(find.byKey(const Key('signInTile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggleModeButton')));
    await tester.pumpAndSettle();
    await fillSignIn(tester, 'moi@exemple.be', 'secret1', confirm: 'secret1');

    // Wrong code: refused, the right one signs in.
    await tester.enterText(fieldIn('confirmCodeField'), '000000');
    await tester.tap(find.byKey(const Key('confirmCodeButton')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Code incorrect'), findsOneWidget);
    await tester.tap(find.byKey(const Key('resendCodeButton')));
    await tester.pumpAndSettle();
    expect(auth.sent, ['confirm:moi@exemple.be']);
    await tester.enterText(fieldIn('confirmCodeField'), '123456');
    await tester.tap(find.byKey(const Key('confirmCodeButton')));
    await tester.pumpAndSettle();

    expect(find.text('Connecté : moi@exemple.be'), findsOneWidget);
  });

  testWidgets('forgot password: code by email, new password, signed in', (
    tester,
  ) async {
    final auth = FakeSyncAuth()..passwords['moi@exemple.be'] = 'oublie';
    await pumpWith(tester, auth);
    await tester.tap(find.byKey(const Key('signInTile')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'moi@exemple.be',
    );
    await tester.tap(find.byKey(const Key('forgotPasswordButton')));
    await tester.pumpAndSettle();

    // The address typed on the sign-in screen is kept.
    await tester.tap(find.byKey(const Key('sendResetButton')));
    await tester.pumpAndSettle();
    expect(auth.sent, ['reset:moi@exemple.be']);
    // Default Supabase email (no SMTP): its link pasted instead of a code.
    await tester.enterText(
      fieldIn('resetCodeField'),
      'https://abc.supabase.co/auth/v1/verify?token=654321&type=recovery'
      '&redirect_to=http://localhost:3000',
    );
    await tester.enterText(fieldIn('newPasswordField'), 'nouveau1');
    await tester.enterText(fieldIn('newPasswordConfirmField'), 'nouveau1');
    await tester.tap(find.byKey(const Key('resetPasswordButton')));
    await tester.pumpAndSettle();

    expect(auth.passwords['moi@exemple.be'], 'nouveau1');
    expect(find.text('Connecté : moi@exemple.be'), findsOneWidget);
  });
}
