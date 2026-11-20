import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/stats/domain/collection_stats.dart';

/// Reading statistics (PLAN_V3 phase 20), on owned volumes counted once
/// even with several copies. A volume is read when one of its copies is.
class ReadingStats {
  const new({
    required this.readByMonth,
    required this.byType,
    required this.averageDaysToRead,
    required this.delaySamples,
    required this.toRead,
    required this.oldestToRead,
    required this.oldestToReadSince,
    required this.abandonedSeries,
    required this.readWithoutDate,
  });

  /// Volumes read per month over the last 12 months, oldest first.
  final List<({DateTime month, int count})> readByMonth;

  /// Read and owned volumes per type.
  final Map<CollectionType, ({int read, int owned})> byType;

  /// Average days between purchase and reading, over the [delaySamples]
  /// volumes with both dates; null without any.
  final double? averageDaysToRead;
  final int delaySamples;

  /// Volumes to read (not read, not abandoned).
  final int toRead;

  /// Oldest volume of the pile: bought (or added) the earliest.
  final Item? oldestToRead;
  final DateTime? oldestToReadSince;

  /// Titles of the series with an abandoned volume, sorted.
  final List<String> abandonedSeries;

  /// Read volumes without a read date (read before the app recorded it).
  final int readWithoutDate;

  bool get hasReadByMonth => readByMonth.any((m) => m.count > 0);
}

// UTC: a day count across a daylight-saving change stays whole.
DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// Computes the reading statistics of [items] and [series].
ReadingStats computeReadingStats(
  List<Item> items,
  List<Series> series, {
  required DateTime now,
}) {
  final owned = items.where((i) => i.ownership == Ownership.possede);
  final firstMonth = DateTime(now.year, now.month - 11);
  final byMonth = {
    for (var m = 0; m < 12; m++) DateTime(now.year, now.month - 11 + m): 0,
  };
  final byType = <CollectionType, ({int read, int owned})>{};
  var delaySum = 0;
  var delaySamples = 0;
  var toRead = 0;
  var withoutDate = 0;
  Item? oldest;
  DateTime? oldestSince;

  for (final copies in volumesOf(owned).values) {
    final readCopies = copies
        .where((c) => c.readingStatus == ReadingStatus.lu)
        .toList();
    final type = copies.first.type;
    final counts = byType[type] ?? (read: 0, owned: 0);
    byType[type] = (
      read: counts.read + (readCopies.isEmpty ? 0 : 1),
      owned: counts.owned + 1,
    );

    if (readCopies.isNotEmpty) {
      final dates = [for (final c in readCopies) ?c.readDate]..sort();
      if (dates.isEmpty) {
        withoutDate++;
        continue;
      }
      final read = dates.first;
      final month = DateTime(read.year, read.month);
      if (!read.isBefore(firstMonth) && byMonth.containsKey(month)) {
        byMonth[month] = byMonth[month]! + 1;
      }
      final bought = [for (final c in copies) ?c.purchaseDate]..sort();
      if (bought.isNotEmpty) {
        final days = _day(read).difference(_day(bought.first)).inDays;
        // Read before buying (borrowed, read in store): not a delay.
        if (days >= 0) {
          delaySum += days;
          delaySamples++;
        }
      }
      continue;
    }

    if (copies.any((c) => toReadStatuses.contains(c.readingStatus))) {
      toRead++;
      for (final c in copies) {
        final since = c.purchaseDate ?? c.createdAt;
        if (oldestSince == null || since.isBefore(oldestSince)) {
          oldest = c;
          oldestSince = since;
        }
      }
    }
  }

  final abandonedIds = {
    for (final i in owned)
      if (i.readingStatus == ReadingStatus.abandonne) ?i.seriesId,
  };
  return ReadingStats(
    readByMonth: [
      for (final MapEntry(:key, :value) in byMonth.entries)
        (month: key, count: value),
    ],
    byType: byType,
    averageDaysToRead: delaySamples == 0 ? null : delaySum / delaySamples,
    delaySamples: delaySamples,
    toRead: toRead,
    oldestToRead: oldest,
    oldestToReadSince: oldestSince,
    abandonedSeries: [
      for (final s in series)
        if (abandonedIds.contains(s.id) && s.deletedAt == null) s.title,
    ]..sort(),
    readWithoutDate: withoutDate,
  );
}
