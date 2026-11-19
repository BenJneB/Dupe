import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/metadata/api_keys.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:dupe/features/settings/presentation/api_key_dialog.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Switches to turn each metadata source on or off, and the API keys of the
/// sources that need one.
class SourcesSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final disabled = ref.watch(disabledSourcesProvider).value ?? const {};
    final keys = ref.watch(apiKeysProvider);
    final saved = ref.watch(savedApiKeysProvider).value ?? const {};
    bool hasKey(SourceId id) => sourceHasKey(id, keys);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListSectionHeader(l10n.settingsSources),
        for (final id in SourceId.values) ...[
          SwitchListTile(
            key: Key('source_${id.name}'),
            title: Text(_name(id)),
            subtitle: Text(hasKey(id) ? _help(id, l10n) : l10n.sourceNeedsKey),
            value: hasKey(id) && !disabled.contains(id),
            onChanged: hasKey(id)
                ? (on) => ref
                      .read(disabledSourcesProvider.notifier)
                      .setEnabled(id, enabled: on)
                : null,
          ),
          if (keyedSources.contains(id))
            ListTile(
              key: Key('apiKey_${id.name}'),
              contentPadding: const EdgeInsets.only(left: 32, right: 16),
              leading: const Icon(Icons.key),
              title: Text(l10n.apiKeyTile),
              subtitle: Text(
                (saved[id] ?? '').isNotEmpty
                    ? l10n.apiKeySaved
                    : hasKey(id)
                    ? l10n.apiKeyBuiltIn
                    : l10n.apiKeyMissing,
              ),
              onTap: () => _editKey(context, id),
            ),
        ],
      ],
    );
  }

  Future<void> _editKey(BuildContext context, SourceId id) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = await showApiKeyDialog(context, id, _name(id));
    if (message != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Proper nouns, not translated.
  static String _name(SourceId id) => switch (id) {
    SourceId.bnf => 'BnF',
    SourceId.googleBooks => 'Google Books',
    SourceId.openLibrary => 'Open Library',
    SourceId.comicVine => 'Comic Vine',
    SourceId.anilist => 'AniList',
    SourceId.mangaUpdates => 'MangaUpdates',
    SourceId.mangadex => 'MangaDex',
  };

  static String _help(SourceId id, AppLocalizations l10n) => switch (id) {
    SourceId.bnf => l10n.sourceBnfHelp,
    SourceId.googleBooks => l10n.sourceGoogleBooksHelp,
    SourceId.openLibrary => l10n.sourceOpenLibraryHelp,
    SourceId.comicVine => l10n.sourceComicVineHelp,
    SourceId.anilist => l10n.sourceAnilistHelp,
    SourceId.mangaUpdates => l10n.sourceMangaUpdatesHelp,
    SourceId.mangadex => l10n.sourceMangaDexHelp,
  };
}
