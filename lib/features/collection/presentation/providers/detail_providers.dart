import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_providers.g.dart';

@riverpod
Stream<Series?> seriesById(Ref ref, String id) =>
    ref.watch(collectionRepositoryProvider).watchSeries(id);

@riverpod
Stream<Item?> itemById(Ref ref, String id) =>
    ref.watch(collectionRepositoryProvider).watchItem(id);

@riverpod
Stream<List<Item>> seriesItems(Ref ref, String seriesId) =>
    ref.watch(collectionRepositoryProvider).watchSeriesItems(seriesId);

@riverpod
Stream<Set<String>> loanedItemIds(Ref ref) =>
    ref.watch(loansRepositoryProvider).watchLoanedItemIds();

typedef SeriesDetail = ({Series series, List<Item> items, VolumeGrid grid});

/// A series with its items and computed volume grid; data is null when the
/// series does not exist (or was deleted).
@riverpod
AsyncValue<SeriesDetail?> seriesDetail(Ref ref, String id) {
  final series = ref.watch(seriesByIdProvider(id));
  final items = ref.watch(seriesItemsProvider(id));
  final loaned = ref.watch(loanedItemIdsProvider);

  for (final value in [series, items, loaned]) {
    if (value case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  if (!series.hasValue || !items.hasValue || !loaned.hasValue) {
    return const AsyncLoading();
  }
  final s = series.requireValue;
  if (s == null) return const AsyncData(null);
  return AsyncData((
    series: s,
    items: items.requireValue,
    grid: VolumeGrid.compute(
      items: items.requireValue,
      totalVolumes: s.totalVolumes,
      followed: s.followed,
      loanedItemIds: loaned.requireValue,
    ),
  ));
}
