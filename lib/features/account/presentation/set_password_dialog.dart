import 'package:dupe/app/error_text.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/features/account/presentation/password_field.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Sets or changes the password of the signed-in account. Returns true when
/// saved.
Future<bool?> showSetPasswordDialog(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (context) => const _SetPasswordDialog(),
);

class _SetPasswordDialog extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_SetPasswordDialog> createState() => _SetPasswordDialogState();
}

class _SetPasswordDialogState extends ConsumerState<_SetPasswordDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final invalid = _password.text.isEmpty
        ? l10n.passwordEmpty
        : _confirm.text != _password.text
        ? l10n.passwordsDontMatch
        : null;
    setState(() => _error = invalid);
    if (invalid != null) return;
    setState(() => _busy = true);
    try {
      await ref.read(syncAuthProvider).setPassword(_password.text);
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (e, stack) {
      if (mounted) {
        setState(() => _error = reportError(l10n, 'auth', e, stack));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.setPasswordTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PasswordField(
              key: const Key('newPasswordField'),
              controller: _password,
              label: l10n.passwordLabel,
              isNew: true,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            PasswordField(
              key: const Key('newPasswordConfirmField'),
              controller: _confirm,
              label: l10n.passwordConfirmLabel,
              isNew: true,
              onSubmitted: (_) => _save(),
            ),
            if (_error case final error?) ...[
              const SizedBox(height: 12),
              Text(
                error,
                key: const Key('setPasswordError'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('savePasswordButton'),
          onPressed: _busy ? null : _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
