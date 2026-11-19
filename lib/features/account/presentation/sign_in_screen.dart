import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/core/sync/sync_auth.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/features/account/presentation/email_code_field.dart';
import 'package:dupe/features/account/presentation/password_field.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Email + password sign-in, and account creation (PLAN_V2 phase 10).
class SignInScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _code = TextEditingController();
  var _signUp = false;

  /// Address waiting for its confirmation code (phase 34).
  String? _codeFor;
  String? _error;
  String? _info;
  var _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _code.dispose();
    super.dispose();
  }

  /// Checks the form; returns an error message or null.
  String? _invalid(AppLocalizations l10n) {
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email.text.trim())) {
      return l10n.invalidEmail;
    }
    if (_password.text.isEmpty) return l10n.passwordEmpty;
    if (_signUp && _confirm.text != _password.text) {
      return l10n.passwordsDontMatch;
    }
    return null;
  }

  /// Runs [action] with the busy state on; its error is shown in the form
  /// ([onError] first, for a failure that needs more, like the code field).
  Future<void> _run(
    Future<void> Function() action, {
    void Function(Object error)? onError,
  }) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on Object catch (e, stack) {
      if (mounted) {
        setState(() {
          _error = reportError(l10n, 'auth', e, stack);
          onError?.call(e);
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final invalid = _invalid(l10n);
    setState(() {
      _error = invalid;
      _info = null;
    });
    if (invalid != null) return;
    final messenger = ScaffoldMessenger.of(context);
    final auth = ref.read(syncAuthProvider);
    final email = _email.text.trim();
    await _run(
      () async {
        final signedIn = _signUp
            ? await auth.signUp(email, _password.text)
            : await auth.signIn(email, _password.text).then((_) => true);
        TextInput.finishAutofillContext();
        if (signedIn) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.signInDone)));
          if (mounted) context.pop();
        } else if (mounted) {
          // Email confirmation required: the code of the email signs in.
          setState(() {
            _signUp = false;
            _codeFor = email;
            _info = l10n.confirmEmailSent(email);
          });
        }
      },
      onError: (e) {
        if (e case SignInException(failure: SignInFailure.emailNotConfirmed)) {
          _codeFor = email;
        }
      },
    );
  }

  /// The account is confirmed with the code of the email, then signed in.
  Future<void> _confirmCode() async {
    final l10n = AppLocalizations.of(context);
    final email = _codeFor;
    if (email == null) return;
    if (_code.text.trim().length < 6) {
      setState(() => _error = l10n.emailCodeMissing);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    await _run(() async {
      await ref.read(syncAuthProvider).confirmSignUp(email, _code.text);
      messenger.showSnackBar(SnackBar(content: Text(l10n.signInDone)));
      if (mounted) context.pop();
    });
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final email = _codeFor;
    if (email == null) return;
    await _run(() async {
      await ref.read(syncAuthProvider).resendConfirmation(email);
      if (mounted) setState(() => _info = l10n.confirmEmailSent(email));
    });
  }

  Future<void> _forgot() async {
    final done = await context.push<bool>(
      AppRoutes.resetPassword(_email.text.trim()),
    );
    if ((done ?? false) && mounted) context.pop();
  }

  void _toggleMode() => setState(() {
    _signUp = !_signUp;
    _error = null;
    _info = null;
    _confirm.clear();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_signUp ? l10n.signUpTitle : l10n.signInTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: AutofillGroup(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Text(l10n.signInHelp),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('emailField'),
                  controller: _email,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                PasswordField(
                  key: const Key('passwordField'),
                  controller: _password,
                  label: l10n.passwordLabel,
                  isNew: _signUp,
                  onSubmitted: _signUp ? null : (_) => _submit(),
                ),
                if (_signUp) ...[
                  const SizedBox(height: 16),
                  PasswordField(
                    key: const Key('passwordConfirmField'),
                    controller: _confirm,
                    label: l10n.passwordConfirmLabel,
                    isNew: true,
                    onSubmitted: (_) => _submit(),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('submitButton'),
                  onPressed: _busy ? null : _submit,
                  child: Text(_signUp ? l10n.signUp : l10n.signIn),
                ),
                TextButton(
                  key: const Key('toggleModeButton'),
                  onPressed: _busy ? null : _toggleMode,
                  child: Text(
                    _signUp ? l10n.alreadyHaveAccount : l10n.noAccountYet,
                  ),
                ),
                if (_info case final info?)
                  Text(info, key: const Key('signInInfo')),
                if (_codeFor != null && !_signUp) ...[
                  const SizedBox(height: 16),
                  EmailCodeField(
                    key: const Key('confirmCodeField'),
                    controller: _code,
                    onSubmitted: (_) => _confirmCode(),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    key: const Key('confirmCodeButton'),
                    onPressed: _busy ? null : _confirmCode,
                    child: Text(l10n.confirmCodeAction),
                  ),
                  TextButton(
                    key: const Key('resendCodeButton'),
                    onPressed: _busy ? null : _resend,
                    child: Text(l10n.resendCode),
                  ),
                ],
                if (_error case final error?)
                  Text(
                    error,
                    key: const Key('signInError'),
                    style: TextStyle(color: colors.error),
                  ),
                if (!_signUp)
                  TextButton(
                    key: const Key('forgotPasswordButton'),
                    onPressed: _busy ? null : _forgot,
                    child: Text(l10n.forgotPassword),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
