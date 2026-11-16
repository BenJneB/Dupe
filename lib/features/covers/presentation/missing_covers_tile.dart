import 'dart:async';

import 'package:dupe/features/covers/data/missing_covers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// « Compléter les couvertures manquantes » (Paramètres, Qualité).
class MissingCoversTile extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final fill = ref.watch(missingCoversFillProvider);
    return ListTile(
      key: const Key('fillMissingCovers'),
      leading: fill.running
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.image_search_outlined),
      title: Text(l10n.missingCovers),
      subtitle: Text(switch (fill) {
        CoverFillState(running: true) => l10n.missingCoversProgress(
          fill.done,
          fill.total,
          fill.found,
        ),
        CoverFillState(finished: true) => l10n.missingCoversDone(
          fill.found,
          fill.total,
        ),
        _ => l10n.missingCoversHelp,
      }),
      onTap: fill.running
          ? null
          : () => unawaited(ref.read(missingCoversFillProvider.notifier).run()),
    );
  }
}
