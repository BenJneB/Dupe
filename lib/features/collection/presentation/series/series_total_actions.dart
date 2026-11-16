import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/volume_count_check.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_count.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';
import 'package:dupe/features/collection/presentation/series/series_total_dialog.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Series menu → "Nombre total de tomes…", for every series: manga and
/// comics are looked up first (AniList, Comic Vine); otherwise, or when
/// nothing is found, the total is typed by hand (recette U-01).
Future<void> checkSeriesTotal(
  BuildContext context,
  WidgetRef ref,
  Series series,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final lookup = ref.read(seriesLookupProvider);
  VolumeCountProposal? proposal;
  String? hint;
  if (lookup.providerFor(series.type) == null) {
    hint = l10n.totalNoSource;
  } else {
    try {
      proposal = await checkVolumeCount(lookup, series);
      hint = proposal == null
          ? l10n.checkTotalNone(series.title)
          : volumeCountHint(l10n, proposal);
    } on Object catch (e, stack) {
      hint = reportError(l10n, 'series', e, stack);
    }
  }
  if (!context.mounted) return;
  final total = await askSeriesTotal(
    context,
    title: l10n.checkTotalTitle,
    suggested: proposal?.total ?? series.totalVolumes,
    hint: hint,
  );
  if (total == null) return;
  await _saveTotal(ref, series, total);
  messenger.showSnackBar(
    SnackBar(content: Text(l10n.checkTotalSaved(series.title, total))),
  );
}

/// After adding the first numbered volume of a series whose total is
/// unknown: asks how many volumes it has (prefilled by AniList / Comic Vine
/// when they know), so that the missing ones show in the grid.
Future<void> offerSeriesTotal(
  BuildContext context,
  WidgetRef ref,
  Item item,
) async {
  final seriesId = item.seriesId;
  if (seriesId == null || VolumeNumber.asInt(item.volumeNumber) == null) {
    return;
  }
  final repo = ref.read(collectionRepositoryProvider);
  final series = await repo.getSeries(seriesId);
  if (series == null || series.totalVolumes != null) return;
  final numbered = (await repo.listSeriesItems(seriesId))
      .where((i) => VolumeNumber.asInt(i.volumeNumber) != null);
  if (numbered.length != 1) return;
  VolumeCountProposal? proposal;
  try {
    proposal = await checkVolumeCount(
      ref.read(seriesLookupProvider),
      series,
    ).timeout(const Duration(seconds: 5));
  } on Object {
    proposal = null; // Offline or slow: asked without a suggestion.
  }
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  final total = await askSeriesTotal(
    context,
    title: l10n.nextVolumesTitle,
    suggested: proposal?.total,
    hint: proposal == null ? null : volumeCountHint(l10n, proposal),
  );
  if (total != null) await _saveTotal(ref, series, total);
}

Future<void> _saveTotal(WidgetRef ref, Series series, int total) async {
  final repo = ref.read(collectionRepositoryProvider);
  // Re-read: the series may have changed (or been deleted) meanwhile.
  final fresh = await repo.getSeries(series.id);
  if (fresh != null) await repo.saveSeries(fresh.copyWith(totalVolumes: total));
}
