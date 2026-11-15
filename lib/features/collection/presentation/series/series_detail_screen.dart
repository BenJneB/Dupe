import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/providers/detail_providers.dart';
import 'package:dupe/features/collection/presentation/series/series_menu.dart';
import 'package:dupe/features/collection/presentation/series/volume_copies_sheet.dart';
import 'package:dupe/features/collection/presentation/series/volume_grid_view.dart';
import 'package:dupe/features/collection/presentation/series/volume_range_dialog.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Series sheet: info + Mangacollec-like volume grid.
class SeriesDetailScreen extends ConsumerWidget {
  const new({required this.seriesId, super.key});

  final String seriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detail = ref.watch(seriesDetailProvider(seriesId));

    return switch (detail) {
      AsyncData(value: final d?) => _SeriesDetailView(
        series: d.series,
        grid: d.grid,
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: PlaceholderBody(icon: Icons.search_off, title: l10n.notFound),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.loadError('$error'))),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _SeriesDetailView extends ConsumerWidget {
  const new({required this.series, required this.grid});

  final Series series;
  final VolumeGrid grid;

  Future<void> _addRange(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final range = await askVolumeRange(
      context,
      suggestedTo: series.totalVolumes ?? (grid.slots.length + 1),
    );
    if (range == null) return;
    final created = await ref
        .read(collectionRepositoryProvider)
        .addVolumeRange(
          series,
          from: range.from,
          to: range.to,
          ownership: range.ownership,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.volumesAdded(created))));
    }
  }

  void _onTap(BuildContext context, VolumeSlot slot) {
    if (slot.copies.length > 1) {
      unawaited(showVolumeCopies(context, series.type, slot));
      return;
    }
    final item = slot.item;
    unawaited(
      context.push(
        item != null
            ? AppRoutes.item(series.type, item.id)
            : AppRoutes.newItem(
                series.type,
                seriesId: series.id,
                volume: slot.label,
              ),
      ),
    );
  }

  /// Quick add: missing -> owned item, wished -> owned.
  Future<void> _onLongPress(
    BuildContext context,
    WidgetRef ref,
    VolumeSlot slot,
  ) async {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(collectionRepositoryProvider);
    final item = slot.item;
    if (item == null) {
      await repo.saveItem(
        repo.newItem(series.type, series: series, volumeNumber: slot.label),
      );
    } else if (item.ownership == Ownership.envie) {
      await repo.saveItem(item.copyWith(ownership: Ownership.possede));
    } else {
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.volumeMarkedOwned(slot.label))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final subtitleParts = [
      if (series.authors.isNotEmpty) series.authors.join(', '),
      ?series.publisher,
      ?series.collection,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(series.title),
        actions: [
          IconButton(
            key: const Key('addVolumes'),
            tooltip: l10n.addVolumes,
            icon: const Icon(Icons.library_add_outlined),
            onPressed: () => _addRange(context, ref),
          ),
          SeriesMenu(series: series, grid: grid),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoverImage(url: series.coverUrl, width: 96, height: 144),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(series.title, style: theme.textTheme.titleLarge),
                    if (series.originalTitle case final original?)
                      Text(original, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    if (subtitleParts.isNotEmpty)
                      Text(subtitleParts.join(' · ')),
                    const SizedBox(height: 4),
                    Text(
                      series.statusPublication.label(l10n),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _summary(l10n),
            key: const Key('seriesSummary'),
            style: theme.textTheme.titleMedium,
          ),
          if (grid.toReadCount > 0)
            Text(
              l10n.volumesToRead(grid.toReadCount),
              key: const Key('seriesToRead'),
            ),
          const SizedBox(height: 12),
          if (grid.slots.isEmpty)
            Text(l10n.noVolumesYet)
          else
            VolumeGridView(
              grid: grid,
              onTap: (slot) => _onTap(context, slot),
              onLongPress: (slot) => _onLongPress(context, ref, slot),
            ),
          if (series.description case final description?) ...[
            const SizedBox(height: 24),
            Text(description),
          ],
          if (series.notes case final notes?) ...[
            const SizedBox(height: 16),
            Text(l10n.fieldNotes, style: theme.textTheme.titleSmall),
            Text(notes),
          ],
        ],
      ),
    );
  }

  String _summary(AppLocalizations l10n) {
    final total = grid.totalVolumes;
    final owned = total == null
        ? l10n.volumesOwned(grid.ownedCount)
        : l10n.volumesOwnedOfTotal(grid.ownedCount, total);
    if (grid.isComplete) return '$owned · ${l10n.seriesComplete}';
    if (grid.missingNumbers.isEmpty) return owned;
    final list = Formatters.numberList(grid.missingNumbers, l10n.rangeWord);
    return '$owned, ${l10n.missingVolumes(list)}';
  }
}
