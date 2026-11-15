import 'package:dupe/app/router.dart';
import 'package:dupe/features/scan/data/scan_queue_repository.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Burst mode: queue progress and access to the review screen.
class BurstPanel extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(scanQueueProvider).value ?? const [];
    final done = entries.where((e) => e.status != ScanStatus.pending).length;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.burstHint),
            const SizedBox(height: 12),
            Row(
              children: [
                if (entries.isNotEmpty)
                  Expanded(
                    child: Text(
                      l10n.burstProgress(done, entries.length),
                      key: const Key('burstProgress'),
                    ),
                  )
                else
                  const Spacer(),
                FilledButton.icon(
                  key: const Key('burstReviewButton'),
                  icon: const Icon(Icons.checklist),
                  label: Text(l10n.burstReview(entries.length)),
                  onPressed: () => context.push(AppRoutes.scanReview),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
