import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/series_completion_service.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/collection/domain/series_completion.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'series_isbn_fill.g.dart';

/// Progress of "Compléter les ISBN des séries".
@immutable
class SeriesIsbnFillState {
  const new({
    this.running = false,
    this.done = 0,
    this.total = 0,
    this.found = 0,
    this.ambiguous = 0,
  });

  final bool running;

  /// Series looked up, out of [total].
  final int done;
  final int total;

  /// ISBNs given to volumes.
  final int found;

  /// Series skipped: several editions and no publisher to choose.
  final int ambiguous;

  bool get finished => !running && done == total && done > 0;
}

/// Qualité (PLAN_V4 phase 37, every series at once): the volumes owned
/// without ISBN get the one of the BnF, edition chosen by the publisher of
/// the series. Nothing is created; a series whose edition is unclear is
/// skipped (to complete from its own menu).
@Riverpod(keepAlive: true)
class SeriesIsbnFill extends _$SeriesIsbnFill {
  @override
  SeriesIsbnFillState build() => const SeriesIsbnFillState();

  Future<void> run() async {
    if (state.running) return;
    state = const SeriesIsbnFillState(running: true);
    final repo = ref.read(collectionRepositoryProvider);
    final source = ref.read(seriesCatalogSourceProvider);
    final todo = <(String, List<Item>)>[];
    for (final s in await repo.listSeries()) {
      final items = await repo.listSeriesItems(s.id);
      if (items.any((i) => i.ownership == Ownership.possede && i.hasNoIsbn)) {
        todo.add((s.id, items));
      }
    }
    var (found, ambiguous) = (0, 0);
    state = SeriesIsbnFillState(running: todo.isNotEmpty, total: todo.length);
    for (final (i, (id, items)) in todo.indexed) {
      try {
        final series = await repo.getSeries(id);
        if (series != null) {
          final publisher =
              series.publisher ??
              items.map((x) => x.publisher).nonNulls.firstOrNull;
          final editions = buildCatalog(
            series.title,
            await source.volumesOf(series.title),
          ).where((e) => publishersMatch(publisher, e.publisher)).toList();
          if (editions.length == 1) {
            final plan = planCompletion(
              existing: items,
              chosen: {
                for (final v in editions.single.volumes)
                  if (volumeState(items, v.number) == VolumeState.missingIsbn)
                    v.number: (record: v.preferred, choice: VolumeChoice.owned),
              },
              seriesTitle: series.title,
              newItem: (_) => throw StateError('nothing is created'),
            );
            for (final item in plan.updates) {
              await repo.saveItem(item);
            }
            found += plan.updates.length;
          } else if (editions.length > 1) {
            ambiguous++;
          }
        }
      } on Object catch (e) {
        appLog.warning('series', e);
      }
      state = SeriesIsbnFillState(
        running: i + 1 < todo.length,
        done: i + 1,
        total: todo.length,
        found: found,
        ambiguous: ambiguous,
      );
    }
  }
}
