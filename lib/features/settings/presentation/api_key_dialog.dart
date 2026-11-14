import 'package:dupe/core/metadata/api_key_check.dart';
import 'package:dupe/core/metadata/api_keys.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:dupe/features/account/presentation/password_field.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Enter, test or remove the API key of [source] ([name]: its display name).
/// Returns a message for a snackbar when the key changed.
Future<String?> showApiKeyDialog(
  BuildContext context,
  SourceId source,
  String name,
) => showDialog<String>(
  context: context,
  builder: (context) => _ApiKeyDialog(source, name),
);

class _ApiKeyDialog extends ConsumerStatefulWidget {
  const new(this.source, this.name);

  final SourceId source;
  final String name;

  @override
  ConsumerState<_ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends ConsumerState<_ApiKeyDialog> {
  late final _key = TextEditingController(
    text: ref.read(savedApiKeysProvider).value?[widget.source] ?? '',
  );
  ApiKeyCheck? _check;
  var _testing = false;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    setState(() {
      _testing = true;
      _check = null;
    });
    final check = await checkApiKey(
      ref.read(httpClientProvider),
      widget.source,
      _key.text.trim(),
    );
    if (mounted) {
      setState(() {
        _testing = false;
        _check = check;
      });
    }
  }

  Future<void> _save(String key, String message) async {
    await ref.read(savedApiKeysProvider.notifier).save(widget.source, key);
    if (mounted) Navigator.of(context).pop(message);
  }

  String _checkText(AppLocalizations l10n, ApiKeyCheck check) =>
      switch (check) {
        ApiKeyCheck.valid => l10n.apiKeyValid,
        ApiKeyCheck.invalid => l10n.apiKeyInvalid,
        ApiKeyCheck.quota => l10n.apiKeyQuota,
        ApiKeyCheck.offline => l10n.apiKeyOffline,
        ApiKeyCheck.failed => l10n.apiKeyFailed,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final hasSaved =
        (ref.watch(savedApiKeysProvider).value?[widget.source] ?? '')
            .isNotEmpty;
    final check = _check;
    return AlertDialog(
      title: Text(l10n.apiKeyTitle(widget.name)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(switch (widget.source) {
              SourceId.googleBooks => l10n.apiKeyHelpGoogleBooks,
              _ => l10n.apiKeyHelpComicVine,
            }),
            const SizedBox(height: 16),
            PasswordField(
              key: const Key('apiKeyField'),
              controller: _key,
              label: l10n.apiKeyTile,
              autofill: false,
              autofocus: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                  key: const Key('apiKeyTest'),
                  onPressed: _testing ? null : _test,
                  child: Text(l10n.apiKeyTest),
                ),
                const SizedBox(width: 12),
                if (_testing)
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            if (check != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _checkText(l10n, check),
                  key: const Key('apiKeyCheck'),
                  style: TextStyle(
                    color: check == ApiKeyCheck.valid
                        ? colors.primary
                        : colors.error,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              l10n.apiKeyPrivacy,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        if (hasSaved)
          TextButton(
            key: const Key('apiKeyRemove'),
            onPressed: () => _save('', l10n.apiKeyRemoved),
            child: Text(l10n.apiKeyRemove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('apiKeySave'),
          onPressed: () => _save(_key.text, l10n.apiKeyStored),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
