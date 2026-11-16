import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/presentation/volume_titles/volume_titles_tile.dart';
import 'package:dupe/features/covers/data/cover_proposals.dart';
import 'package:dupe/features/covers/presentation/missing_covers_tile.dart';
import 'package:dupe/features/quality/data/quality_providers.dart';
import 'package:dupe/features/quality/domain/collection_quality.dart';
import 'package:dupe/features/quality/presentation/quality_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Plus → "Qualité de la collection": what is missing, and how to fill it.
class QualityScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final quality = ref.watch(collectionQualityProvider).value;
    final markIsbn = ref.watch(missingIsbnInGridProvider).value ?? false;
    final proposals = ref.watch(coverProposalsProvider).length;
    Widget header(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: text.titleSmall),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.qualityTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(l10n.qualityHelp),
          ),
          for (final issue in QualityIssue.values)
            ListTile(
              key: Key('quality-${issue.name}'),
              leading: Icon(issue.icon),
              title: Text(issue.label(l10n)),
              trailing: Text(
                '${quality?.count(issue) ?? '…'}',
                style: text.titleMedium,
              ),
              onTap: (quality?.count(issue) ?? 0) == 0
                  ? null
                  : () => context.push(AppRoutes.qualityList(issue.name)),
            ),
          if (proposals > 0)
            ListTile(
              key: const Key('qualityCoverProposals'),
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.coverProposalsTitle),
              subtitle: Text(l10n.coverProposalsTileHelp),
              trailing: Text('$proposals', style: text.titleMedium),
              onTap: () => context.push(AppRoutes.coverProposals),
            ),
          if ((quality?.count(QualityIssue.noIsbn) ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton.icon(
                key: const Key('startIsbnCompletion'),
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l10n.isbnCompletionStart),
                onPressed: () => context.push(AppRoutes.isbnCompletion()),
              ),
            ),
          SwitchListTile(
            key: const Key('missingIsbnGridSwitch'),
            secondary: const Icon(Icons.grid_view),
            title: Text(l10n.missingIsbnInGrid),
            subtitle: Text(l10n.missingIsbnInGridHelp),
            value: markIsbn,
            onChanged: (on) => unawaited(
              ref.read(missingIsbnInGridProvider.notifier).set(on: on),
            ),
          ),
          header(l10n.qualityAutomatic),
          const MissingCoversTile(),
          const VolumeTitlesTile(),
          ListTile(
            leading: const Icon(Icons.functions),
            title: Text(l10n.volumeCountsTile),
            subtitle: Text(l10n.volumeCountsTileHelp),
            onTap: () => context.push(AppRoutes.volumeCounts),
          ),
        ],
      ),
    );
  }
}
