import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';

/// Statistics of the collection (PLAN.md §5: prices and statistics).
///
/// Volumes are counted once even with several copies (editions); money
/// counts every copy. Amounts are in [currency] (the most used one); other
/// currencies are kept apart in [otherCurrencies], never converted.
class CollectionStats {
  const new({
    required this.currency,
    required this.spent,
    required this.value,
    required this.otherCurrencies,
    required this.ownedVolumes,
    required this.readVolumes,
    required this.pricedCopies,
    required this.ownedCopies,
    required this.volumesByType,
    required this.spentByType,
    required this.spentByMonth,
    required this.completeSeries,
    required this.seriesWithTotal,
  });

  final String currency;

  /// Sum of the prices paid.
  final double spent;

  /// Estimated value, else cover price, else price paid.
  final double value;

  /// Spent amounts in other currencies.
  final Map<String, double> otherCurrencies;

  final int ownedVolumes;
  final int readVolumes;

  /// Owned copies with a price paid, out of [ownedCopies].
  final int pricedCopies;
  final int ownedCopies;

  final Map<CollectionType, int> volumesByType;
  final Map<CollectionType, double> spentByType;

  /// Last 12 months, oldest first (months without purchase at 0).
  final List<({DateTime month, double amount})> spentByMonth;

  /// Series with a known number of volumes, and how many are complete.
  final int completeSeries;
  final int seriesWithTotal;

  double get readShare => ownedVolumes == 0 ? 0 : readVolumes / ownedVolumes;

  /// Most used currency of [owned] (EUR when empty).
  static String mainCurrency(Iterable<Item> owned) {
    final counts = <String, int>{};
    for (final i in owned) {
      counts[i.currency] = (counts[i.currency] ?? 0) + 1;
    }
    if (counts.isEmpty) return 'EUR';
    return counts.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  }
}

/// Copies of each volume: one entry per series + number, or per item for
/// books outside a series.
Map<String, List<Item>> volumesOf(Iterable<Item> owned) {
  final volumes = <String, List<Item>>{};
  for (final i in owned) {
    final key = i.seriesId != null && i.volumeNumber != null
        ? '${i.seriesId}#${i.volumeNumber!.trim()}'
        : i.id;
    (volumes[key] ??= []).add(i);
  }
  return volumes;
}

/// Computes the statistics of [items] and [series].
CollectionStats computeCollectionStats(
  List<Item> items,
  List<Series> series, {
  required DateTime now,
}) {
  final owned = items.where((i) => i.ownership == Ownership.possede);
  final currency = CollectionStats.mainCurrency(owned);

  final volumes = volumesOf(owned);
  final volumesByType = <CollectionType, int>{};
  var read = 0;
  for (final copies in volumes.values) {
    final type = copies.first.type;
    volumesByType[type] = (volumesByType[type] ?? 0) + 1;
    if (copies.any((c) => c.readingStatus == ReadingStatus.lu)) read++;
  }

  var spent = 0.0;
  var value = 0.0;
  var priced = 0;
  final others = <String, double>{};
  final spentByType = <CollectionType, double>{};
  final firstMonth = DateTime(now.year, now.month - 11);
  final byMonth = {
    for (var m = 0; m < 12; m++) DateTime(now.year, now.month - 11 + m): 0.0,
  };
  for (final i in owned) {
    final paid = i.purchasePrice;
    if (paid != null) priced++;
    if (i.currency != currency) {
      if (paid != null) others[i.currency] = (others[i.currency] ?? 0) + paid;
      continue;
    }
    value += i.estimatedValue ?? i.coverPrice ?? i.purchasePrice ?? 0;
    if (paid == null) continue;
    spent += paid;
    spentByType[i.type] = (spentByType[i.type] ?? 0) + paid;
    final date = i.purchaseDate;
    if (date != null && !date.isBefore(firstMonth)) {
      final month = DateTime(date.year, date.month);
      if (byMonth.containsKey(month)) byMonth[month] = byMonth[month]! + paid;
    }
  }

  final bySeries = <String, List<Item>>{};
  for (final i in items) {
    if (i.seriesId case final id?) (bySeries[id] ??= []).add(i);
  }
  final withTotal = series.where((s) => (s.totalVolumes ?? 0) > 0).toList();
  final complete = withTotal
      .where(
        (s) => VolumeGrid.compute(
          items: bySeries[s.id] ?? const [],
          totalVolumes: s.totalVolumes,
          followed: s.followed,
        ).isComplete,
      )
      .length;

  return CollectionStats(
    currency: currency,
    spent: spent,
    value: value,
    otherCurrencies: others,
    ownedVolumes: volumes.length,
    readVolumes: read,
    pricedCopies: priced,
    ownedCopies: owned.length,
    volumesByType: volumesByType,
    spentByType: spentByType,
    spentByMonth: [
      for (final MapEntry(:key, :value) in byMonth.entries)
        (month: key, amount: value),
    ],
    completeSeries: complete,
    seriesWithTotal: withTotal.length,
  );
}
