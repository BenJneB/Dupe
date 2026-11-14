import 'package:dupe/app/error_text.dart';
import 'package:dupe/core/sync/email_sign_in.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Email + 6-digit code sign-in (no magic link: awkward on desktop).
class SignInScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  String? _sentTo;
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on Object catch (e, stack) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        final text = reportError(l10n, 'auth', e, stack);
        setState(() => _error = l10n.signInError(text));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final email = _email.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      setState(() => _error = l10n.invalidEmail);
      return;
    }
    await _run(() async {
      await ref.read(syncAuthProvider).sendCode(email);
      if (mounted) setState(() => _sentTo = email);
    });
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context);
    final credential = EmailCredential.parse(_code.text);
    if (credential == null) {
      setState(() => _error = l10n.invalidOtp);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    await _run(() async {
      await ref.read(syncAuthProvider).verify(_sentTo!, credential);
      messenger.showSnackBar(SnackBar(content: Text(l10n.signInDone)));
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sentTo = _sentTo;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signInTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              Text(l10n.signInHelp),
              const SizedBox(height: 16),
              if (sentTo == null) ...[
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
                  onSubmitted: (_) => _sendCode(),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('sendCodeButton'),
                  onPressed: _busy ? null : _sendCode,
                  child: Text(l10n.sendCode),
                ),
              ] else ...[
                Text(l10n.codeSent(sentTo)),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('codeField'),
                  controller: _code,
                  autofocus: true,
                  keyboardType: TextInputType.url,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: l10n.codeLabel,
                    helperText: l10n.codeHelper,
                    helperMaxLines: 3,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _verify(),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('verifyCodeButton'),
                  onPressed: _busy ? null : _verify,
                  child: Text(l10n.verifyCode),
                ),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                          _sentTo = null;
                          _code.clear();
                        }),
                  child: Text(l10n.changeEmail),
                ),
              ],
              if (_error case final error?) ...[
                const SizedBox(height: 12),
                Text(
                  error,
                  key: const Key('signInError'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
