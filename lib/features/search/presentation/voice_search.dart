import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/search/data/search_repository.dart';
import 'package:dupe/features/search/data/spoken_lookup.dart';
import 'package:dupe/features/search/data/voice_input.dart';
import 'package:dupe/features/search/domain/spoken_query.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

const _explainedKey = 'voice_search_explained';

/// Like the typed search, results are opened with `go` (tab routes cannot be
/// pushed over this root-level screen).
///
/// Dictated search (PLAN_V3 phase 19): explains the microphone once, listens,
/// then opens the volume said (« One Piece tome 107 »), or its series with
/// « absent », or shows the phrase as an ordinary search ([onText]).
Future<void> dictateSearch(
  BuildContext context,
  WidgetRef ref, {
  required ValueChanged<String> onText,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final voice = ref.read(voiceInputProvider);
  final settings = ref.read(appSettingsStoreProvider);
  if (await settings.get(_explainedKey) != '1') {
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.voiceSearchTitle),
        content: Text(l10n.voiceSearchExplain),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const Key('voiceExplainOk'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.voiceSearchContinue),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await settings.set(_explainedKey, '1');
  }
  if (!context.mounted) return;

  final listening = voice.listenOnce();
  var sheetOpen = true;
  // Closing the sheet (gesture, back) stops listening.
  final sheet =
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) => _ListeningSheet(onStop: voice.stop),
      ).whenComplete(() {
        sheetOpen = false;
        unawaited(voice.stop());
      });
  final phrase = await listening;
  if (sheetOpen && context.mounted) Navigator.of(context).pop();
  await sheet;
  if (phrase == null) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.voiceSearchNothing)));
    return;
  }

  final lookup = await lookUpSpoken(
    ref.read(searchRepositoryProvider),
    ref.read(collectionRepositoryProvider),
    parseSpokenQuery(phrase),
  );
  if (!context.mounted) return;
  switch (lookup) {
    case SpokenVolumeFound(:final item):
      context.go(AppRoutes.item(item.type, item.id));
    case SpokenVolumeMissing(:final series, :final volume):
      context.go(AppRoutes.series(series.type, series.id));
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.voiceVolumeMissing(volume, series.title))),
      );
    case SpokenText(:final text):
      onText(text);
  }
}

class _ListeningSheet extends StatelessWidget {
  const new({required this.onStop});

  final Future<void> Function() onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.voiceSearchListening,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(l10n.voiceSearchExample, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(
              key: const Key('voiceStop'),
              onPressed: () => unawaited(onStop()),
              child: Text(l10n.voiceSearchStop),
            ),
          ],
        ),
      ),
    );
  }
}
