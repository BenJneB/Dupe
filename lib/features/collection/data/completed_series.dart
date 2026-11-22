import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'completed_series.g.dart';

/// A complete series (every volume up to its known total owned); `local`:
/// one of its items was written on this device and not synced yet.
typedef CompleteSeries = ({String title, bool local});

/// Complete series by id, with the same rule as the tabs (`VolumeGrid`).
Map<String, CompleteSeries> completeSeries(
  List<Series> series,
  List<Item> items,
) {
  final bySeries = <String, List<Item>>{};
  for (final i in items) {
    if (i.seriesId case final id?) (bySeries[id] ??= []).add(i);
  }
  return {
    for (final s in series)
      if (bySeries[s.id] case final own?
          when VolumeGrid.compute(
            items: own,
            totalVolumes: s.totalVolumes,
            followed: false,
          ).isComplete)
        s.id: (title: s.title, local: own.any((i) => i.syncPending)),
  };
}

/// Series that became complete between [before] and [now] through a change
/// made here (an addition, a scan): not a sync from another device. More
/// than [bulk] at once (restore, import) is not news: none.
List<String> newlyCompleted(
  Map<String, CompleteSeries> before,
  Map<String, CompleteSeries> now, {
  int bulk = 5,
}) {
  final titles = [
    for (final MapEntry(:key, :value) in now.entries)
      if (!before.containsKey(key) && value.local) value.title,
  ];
  return titles.length > bulk ? const [] : titles;
}

/// Titles of the series just completed on this device, for "Série
/// complète !" (listened to by the app).
@Riverpod(keepAlive: true)
Stream<List<String>> completedSeriesNews(Ref ref) async* {
  final db = ref.watch(appDatabaseProvider);
  Map<String, CompleteSeries>? before;
  await for (final now in _watch(db)) {
    final titles = before == null
        ? const <String>[]
        : newlyCompleted(before, now);
    before = now;
    if (titles.isNotEmpty) yield titles;
  }
}

Stream<Map<String, CompleteSeries>> _watch(AppDatabase db) => combineLatest(
  (db.select(db.seriesTable)..where((t) => t.deletedAt.isNull())).watch(),
  (db.select(db.itemsTable)..where((t) => t.deletedAt.isNull())).watch(),
  completeSeries,
);
