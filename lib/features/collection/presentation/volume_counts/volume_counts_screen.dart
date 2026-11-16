import 'dart:async';

import 'package:dupe/features/collection/data/volume_count_scan.dart';
import 'package:dupe/features/collection/domain/volume_count.dart';
import 'package:dupe/features/collection/presentation/series/series_total_dialog.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Settings → "Vérifier le nombre de tomes": totals found for the series
/// without one, applied only once checked by the user.
class VolumeCountsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<VolumeCountsScreen> createState() => _State();
}

class _State extends ConsumerState<VolumeCountsScreen> {
  /// Proposals the user unchecked (by series id).
  final _skipped = <String>{};

  Future<void> _apply(List<VolumeCountProposal> proposals) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final changed = await ref
        .read(volumeCountScanProvider.notifier)
        .apply(proposals.where((p) => !_skipped.contains(p.series.id)));
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.volumeCountsApplied(changed))),
    );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scan = ref.watch(volumeCountScanProvider);
    final proposals = scan.proposals;
    final selected = proposals
        .where((p) => !_skipped.contains(p.series.id))
        .length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.volumeCountsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          ListTile(
            key: const Key('volumeCountsStatus'),
            leading: scan.running
                ? const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.fact_check_outlined),
            title: Text(switch (scan) {
              VolumeCountScanState(running: true) => l10n.volumeCountsProgress(
                scan.done,
                scan.total,
              ),
              VolumeCountScanState(finished: true) => l10n.volumeCountsDone(
                scan.total,
                proposals.length,
              ),
              _ => l10n.volumeCountsHelp,
            }),
            subtitle: scan.failed > 0
                ? Text(l10n.volumeCountsFailed(scan.failed))
                : null,
            trailing: scan.running
                ? null
                : FilledButton.tonal(
                    key: const Key('volumeCountsRun'),
                    onPressed: () => unawaited(
                      ref.read(volumeCountScanProvider.notifier).run(),
                    ),
                    child: Text(l10n.volumeCountsRun),
                  ),
          ),
          for (final p in proposals)
            CheckboxListTile(
              key: ValueKey('volumeCount-${p.series.id}'),
              value: !_skipped.contains(p.series.id),
              onChanged: (on) => setState(() {
                if (on ?? false) {
                  _skipped.remove(p.series.id);
                } else {
                  _skipped.add(p.series.id);
                }
              }),
              title: Text(l10n.checkTotalSaved(p.series.title, p.total)),
              subtitle: Text(volumeCountHint(l10n, p)),
            ),
        ],
      ),
      floatingActionButton: proposals.isEmpty || scan.running
          ? null
          : FloatingActionButton.extended(
              key: const Key('volumeCountsApply'),
              onPressed: selected == 0 ? null : () => _apply(proposals),
              icon: const Icon(Icons.check),
              label: Text(l10n.volumeCountsApply(selected)),
            ),
    );
  }
}
