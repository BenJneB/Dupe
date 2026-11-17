import 'package:dupe/app/error_text.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/features/account/presentation/email_code_field.dart';
import 'package:dupe/features/account/presentation/password_field.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// "Mot de passe oublié" while signed out (PLAN_V4 phase 34): a code by
/// email, then a new password, and signed in.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const new({this.email, super.key});

  final String? email;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _State();
}

class _State extends ConsumerState<ResetPasswordScreen> {
  late final _email = TextEditingController(text: widget.email);
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _sent = false;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _run(String? invalid, Future<void> Function() action) async {
    setState(() => _error = invalid);
    if (invalid != null) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await action();
    } on Object catch (e, stack) {
      if (mounted) setState(() => _error = reportError(l10n, 'auth', e, stack));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _send() {
    final l10n = AppLocalizations.of(context);
    final email = _email.text.trim();
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    return _run(valid ? null : l10n.invalidEmail, () async {
      await ref.read(syncAuthProvider).sendPasswordReset(email);
      if (mounted) setState(() => _sent = true);
    });
  }

  Future<void> _reset() {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final invalid = _code.text.trim().length < 6
        ? l10n.emailCodeMissing
        : _password.text.isEmpty
        ? l10n.passwordEmpty
        : _confirm.text != _password.text
        ? l10n.passwordsDontMatch
        : null;
    return _run(invalid, () async {
      await ref
          .read(syncAuthProvider)
          .resetPassword(_email.text.trim(), _code.text, _password.text);
      TextInput.finishAutofillContext();
      messenger.showSnackBar(SnackBar(content: Text(l10n.passwordResetDone)));
      // Back to where the sign-in screen was opened from.
      if (mounted) context.pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPassword)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: AutofillGroup(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  _sent
                      ? l10n.resetCodeSent(_email.text.trim())
                      : l10n.resetHelp,
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('resetEmailField'),
                  controller: _email,
                  enabled: !_sent,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _send(),
                ),
                const SizedBox(height: 16),
                if (!_sent)
                  FilledButton(
                    key: const Key('sendResetButton'),
                    onPressed: _busy ? null : _send,
                    child: Text(l10n.sendResetCode),
                  )
                else ...[
                  EmailCodeField(
                    key: const Key('resetCodeField'),
                    controller: _code,
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    key: const Key('newPasswordField'),
                    controller: _password,
                    label: l10n.newPasswordLabel,
                    isNew: true,
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    key: const Key('newPasswordConfirmField'),
                    controller: _confirm,
                    label: l10n.passwordConfirmLabel,
                    isNew: true,
                    onSubmitted: (_) => _reset(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('resetPasswordButton'),
                    onPressed: _busy ? null : _reset,
                    child: Text(l10n.resetPasswordAction),
                  ),
                  TextButton(
                    onPressed: _busy ? null : _send,
                    child: Text(l10n.resendCode),
                  ),
                ],
                if (_error case final error?)
                  Text(
                    error,
                    key: const Key('resetError'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
