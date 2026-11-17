import 'dart:async';

import 'package:dupe/features/collection/data/series_isbn_fill.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Qualité: gives the volumes of every series their ISBN from the BnF.
class SeriesIsbnTile extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final fill = ref.watch(seriesIsbnFillProvider);
    return ListTile(
      key: const Key('seriesIsbnTile'),
      leading: fill.running
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.library_books_outlined),
      title: Text(l10n.seriesIsbnTile),
      subtitle: Text(switch (fill) {
        SeriesIsbnFillState(running: true) => l10n.seriesIsbnProgress(
          fill.done,
          fill.total,
          fill.found,
        ),
        SeriesIsbnFillState(finished: true) => l10n.seriesIsbnDone(
          fill.found,
          fill.ambiguous,
        ),
        _ => l10n.seriesIsbnHelp,
      }),
      onTap: fill.running
          ? null
          : () => unawaited(ref.read(seriesIsbnFillProvider.notifier).run()),
    );
  }
}
