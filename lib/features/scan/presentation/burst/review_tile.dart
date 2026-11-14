import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/scan/domain/scan_queue_entry.dart';
import 'package:dupe/features/scan/presentation/burst/review_rows.dart';
import 'package:dupe/features/search/presentation/online_search/result_summary.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// One queued scan; tap to correct it (found) or search it (not found).
class ReviewTile extends StatelessWidget {
  const new({required this.row, required this.onDismissed, super.key});

  final ReviewRow row;
  final VoidCallback onDismissed;

  String _subtitle(AppLocalizations l10n) {
    final entry = row.entry;
    final result = entry.result;
    final series = row.seriesTitle;
    return switch (entry.status) {
      ScanStatus.pending => l10n.reviewPending,
      ScanStatus.notFound => l10n.reviewNotFound,
      ScanStatus.failed => l10n.reviewFailed,
      ScanStatus.found when row.inCollection => l10n.reviewInCollection,
      ScanStatus.found when series != null =>
        row.newSeries
            ? l10n.reviewNewSeries(series)
            : l10n.attachedToSeries(series),
      ScanStatus.found => resultSubtitle(result!, withSource: false),
    };
  }

  void _open(BuildContext context) {
    final entry = row.entry;
    final result = entry.result;
    if (row.inCollection || entry.status == ScanStatus.pending) return;
    final route = result != null
        ? AppRoutes.scanReviewItem(entry.type)
        : AppRoutes.onlineSearch(query: entry.isbn13, type: entry.type);
    unawaited(
      context.push(
        route,
        extra: result == null
            ? null
            : (metadata: result, ownership: Ownership.possede),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = row.entry;
    final result = entry.result;
    final scheme = Theme.of(context).colorScheme;
    final icon = switch (entry.status) {
      ScanStatus.pending => const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      ScanStatus.found when row.inCollection => Icon(
        Icons.check_circle,
        color: scheme.primary,
      ),
      ScanStatus.found => const Icon(Icons.edit_outlined),
      ScanStatus.notFound ||
      ScanStatus.failed => Icon(Icons.error_outline, color: scheme.error),
    };
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: ColoredBox(
        color: scheme.errorContainer,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 24),
            child: Icon(Icons.delete_outline),
          ),
        ),
      ),
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        leading: CoverImage(url: result?.coverUrl, width: 40, height: 60),
        title: Text(
          result == null ? 'ISBN ${entry.isbn13}' : resultTitle(l10n, result),
        ),
        subtitle: Text(_subtitle(l10n)),
        trailing: icon,
        onTap: () => _open(context),
      ),
    );
  }
}
