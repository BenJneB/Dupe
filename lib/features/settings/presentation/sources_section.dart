import 'package:dupe/app/router.dart';
import 'package:dupe/core/metadata/api_keys.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:dupe/features/collection/presentation/volume_titles/volume_titles_tile.dart';
import 'package:dupe/features/settings/presentation/api_key_dialog.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            l10n.settingsSources,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
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
        ListTile(
          key: const Key('volumeCountsTile'),
          leading: const Icon(Icons.fact_check_outlined),
          title: Text(l10n.volumeCountsTile),
          subtitle: Text(l10n.volumeCountsTileHelp),
          onTap: () => context.push(AppRoutes.volumeCounts),
        ),
        const VolumeTitlesTile(),
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
  };

  static String _help(SourceId id, AppLocalizations l10n) => switch (id) {
    SourceId.bnf => l10n.sourceBnfHelp,
    SourceId.googleBooks => l10n.sourceGoogleBooksHelp,
    SourceId.openLibrary => l10n.sourceOpenLibraryHelp,
    SourceId.comicVine => l10n.sourceComicVineHelp,
    SourceId.anilist => l10n.sourceAnilistHelp,
  };
}
