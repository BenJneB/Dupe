import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/scan/data/burst_import.dart';
import 'package:dupe/features/scan/data/scan_queue_repository.dart';
import 'package:dupe/features/scan/data/scan_queue_worker.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';
import 'package:dupe/features/scan/presentation/burst/review_rows.dart';
import 'package:dupe/features/scan/presentation/burst/review_tile.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Burst mode review: correct entries one by one, then add them all.
class ScanReviewScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ScanReviewScreen> createState() => _ScanReviewScreenState();
}

class _ScanReviewScreenState extends ConsumerState<ScanReviewScreen> {
  var _importing = false;

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(scanQueueWorkerProvider).run());
  }

  Future<void> _addAll(List<ReviewRow> rows) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _importing = true);
    final int added;
    try {
      added = await importScanQueue(
        ref.read(collectionRepositoryProvider),
        ref.read(scanQueueRepositoryProvider),
        [for (final r in rows) r.entry],
      );
    } on Object catch (e, stack) {
      if (mounted) {
        showError(context, 'scan', e, stack);
        setState(() => _importing = false);
      }
      return;
    }
    if (!mounted) return;
    setState(() => _importing = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.reviewAdded(added))));
  }

  Future<void> _retry() async {
    await ref.read(scanQueueRepositoryProvider).retryFailed();
    unawaited(ref.read(scanQueueWorkerProvider).run());
  }

  void _remove(ScanQueueEntry entry) {
    unawaited(ref.read(scanQueueRepositoryProvider).remove(entry.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).reviewRemoved)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = ref.watch(reviewRowsProvider).value ?? const [];
    final toAdd = rows
        .where((r) => r.entry.status == ScanStatus.found && !r.inCollection)
        .length;
    final hasFailed = rows.any((r) => r.entry.status == ScanStatus.failed);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanReviewTitle),
        actions: [
          if (hasFailed)
            IconButton(
              key: const Key('burstRetry'),
              tooltip: l10n.reviewRetry,
              icon: const Icon(Icons.refresh),
              onPressed: _retry,
            ),
        ],
      ),
      body: rows.isEmpty
          ? PlaceholderBody(
              icon: Icons.burst_mode_outlined,
              title: l10n.reviewEmpty,
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(l10n.reviewEditHint),
                ),
                for (final row in rows)
                  ReviewTile(row: row, onDismissed: () => _remove(row.entry)),
              ],
            ),
      bottomNavigationBar: rows.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  key: const Key('burstAddAll'),
                  icon: const Icon(Icons.library_add),
                  label: Text(l10n.reviewAddAll(toAdd)),
                  onPressed: _importing || rows.every(_done)
                      ? null
                      : () => _addAll(rows),
                ),
              ),
            ),
    );
  }

  /// Nothing to import nor to clean up for this row.
  static bool _done(ReviewRow r) => r.entry.status != ScanStatus.found;
}
