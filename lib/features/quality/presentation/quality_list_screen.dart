import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/quality/data/quality_providers.dart';
import 'package:dupe/features/quality/domain/collection_quality.dart';
import 'package:dupe/features/quality/presentation/quality_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The books (or series) concerned by one [QualityIssue]; each opens its
/// sheet to be fixed. Books without ISBN can be completed by scanning.
class QualityListScreen extends ConsumerWidget {
  const new({required this.issue, super.key});

  final QualityIssue issue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quality = ref.watch(collectionQualityProvider).value;
    final items = quality?.items[issue] ?? const <Item>[];
    final series = issue == QualityIssue.seriesWithoutTotal
        ? quality?.series ?? const <Series>[]
        : const <Series>[];
    return Scaffold(
      appBar: AppBar(title: Text(issue.label(l10n))),
      body: ListView(
        key: const Key('qualityList'),
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          for (final s in series)
            ListTile(
              title: Text(s.title),
              subtitle: Text(s.type.label(l10n)),
              onTap: () => context.push(AppRoutes.series(s.type, s.id)),
            ),
          for (final i in items)
            ListTile(
              key: ValueKey('qualityItem-${i.id}'),
              leading: CoverImage(url: i.coverUrl, width: 32, height: 48),
              title: Text(i.displayTitle(l10n)),
              subtitle: Text(
                [i.type.label(l10n), i.ownership.label(l10n)].join(' · '),
              ),
              onTap: () => context.push(AppRoutes.item(i.type, i.id)),
            ),
        ],
      ),
      floatingActionButton: issue == QualityIssue.noIsbn && items.isNotEmpty
          ? FloatingActionButton.extended(
              key: const Key('completeIsbnFab'),
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(l10n.isbnCompletionStart),
              onPressed: () => context.push(AppRoutes.isbnCompletion()),
            )
          : null,
    );
  }
}
