import 'dart:async';

import 'package:dupe/features/collection/data/volume_title_fill.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Settings → Sources: fills the own titles of the volumes already in the
/// collection (added before the field existed), without rescanning them.
class VolumeTitlesTile extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final fill = ref.watch(volumeTitleFillProvider);
    return ListTile(
      key: const Key('volumeTitlesTile'),
      leading: fill.running
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.title),
      title: Text(l10n.volumeTitlesTile),
      subtitle: Text(switch (fill) {
        TitleFillState(running: true) => l10n.volumeTitlesProgress(
          fill.done,
          fill.total,
          fill.found,
        ),
        TitleFillState(finished: true) => l10n.volumeTitlesDone(
          fill.found,
          fill.total,
        ),
        _ => l10n.volumeTitlesHelp,
      }),
      onTap: fill.running
          ? null
          : () => unawaited(ref.read(volumeTitleFillProvider.notifier).run()),
    );
  }
}
