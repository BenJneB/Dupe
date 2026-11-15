import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Switches to turn each metadata source on or off.
class SourcesSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final disabled = ref.watch(disabledSourcesProvider).value ?? const {};
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
        for (final id in SourceId.values)
          SwitchListTile(
            key: Key('source_${id.name}'),
            title: Text(_name(id)),
            subtitle: Text(
              sourceHasKey(id) ? _help(id, l10n) : l10n.sourceNeedsKey,
            ),
            value: sourceHasKey(id) && !disabled.contains(id),
            onChanged: sourceHasKey(id)
                ? (on) => ref
                      .read(disabledSourcesProvider.notifier)
                      .setEnabled(id, enabled: on)
                : null,
          ),
      ],
    );
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
