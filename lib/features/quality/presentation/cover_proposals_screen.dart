import 'dart:async';

import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/covers/data/cover_proposals.dart';
import 'package:dupe/features/search/presentation/online_search/source_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Qualité → "Couvertures proposées": covers of other editions found by
/// text search, applied only when kept (phase 25). Refusals are remembered
/// on this device; a proposal left alone just stays.
class CoverProposalsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final proposals = ref.watch(coverProposalsProvider);
    final notifier = ref.read(coverProposalsProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.coverProposalsTitle),
        actions: [
          if (proposals.length > 1)
            TextButton(
              key: const Key('keepAllCovers'),
              onPressed: () => unawaited(notifier.keepAll()),
              child: Text(l10n.coverProposalsKeepAll),
            ),
        ],
      ),
      body: proposals.isEmpty
          ? Center(child: Text(l10n.coverProposalsNone))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l10n.coverProposalsHelp),
                for (final p in proposals)
                  Card(
                    key: ValueKey('coverProposal-${p.item.id}'),
                    margin: const EdgeInsets.only(top: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CoverImage(url: p.url, width: 96, height: 144),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.item.displayTitle(l10n),
                                  style: text.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.coverProposalFrom(
                                    p.from.source.label,
                                    p.from.title,
                                  ),
                                  style: text.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    FilledButton(
                                      key: ValueKey('keepCover-${p.item.id}'),
                                      onPressed: () =>
                                          unawaited(notifier.keep(p)),
                                      child: Text(l10n.coverProposalKeep),
                                    ),
                                    OutlinedButton(
                                      key: ValueKey('refuseCover-${p.item.id}'),
                                      onPressed: () =>
                                          unawaited(notifier.refuse(p)),
                                      child: Text(l10n.coverProposalRefuse),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
