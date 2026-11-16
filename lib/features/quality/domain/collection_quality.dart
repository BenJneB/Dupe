import 'package:dupe/core/metadata/metadata_merge.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

/// Gaps of the collection shown in "Qualité de la collection" (phase 22).
enum QualityIssue {
  /// Owned book without ISBN: not recognised by a store scan.
  noIsbn,
  noCover,

  /// Volume filed in a series but without number: not in the grid order.
  noVolumeNumber,

  /// Standalone book that looks like a volume ("Tome 3", or a series title).
  looksLikeVolume,
  seriesWithoutTotal,
}

/// Counts and lists of [QualityIssue] for the live collection.
class CollectionQuality {
  const new({required this.items, required this.series});

  /// Items per issue (every issue but [QualityIssue.seriesWithoutTotal]).
  final Map<QualityIssue, List<Item>> items;
  final List<Series> series;

  int count(QualityIssue issue) => issue == QualityIssue.seriesWithoutTotal
      ? series.length
      : items[issue]?.length ?? 0;
}

bool _blank(String? v) => v == null || v.trim().isEmpty;

/// Gaps among the live [items] and [allSeries] (deleted rows excluded).
CollectionQuality computeQuality(List<Item> items, List<Series> allSeries) {
  final seriesTitles = {
    for (final s in allSeries) (s.type, normalizeTitle(s.title)),
  };
  final byIssue = {
    for (final issue in QualityIssue.values)
      if (issue != QualityIssue.seriesWithoutTotal) issue: <Item>[],
  };
  for (final item in items) {
    if (item.lacksIsbn) {
      byIssue[QualityIssue.noIsbn]!.add(item);
    }
    if (_blank(item.coverUrl)) byIssue[QualityIssue.noCover]!.add(item);
    if (item.seriesId != null && _blank(item.volumeNumber)) {
      byIssue[QualityIssue.noVolumeNumber]!.add(item);
    }
    if (item.seriesId == null &&
        (titleHasVolume(item.title) ||
            seriesTitles.contains((item.type, normalizeTitle(item.title))))) {
      byIssue[QualityIssue.looksLikeVolume]!.add(item);
    }
  }
  return CollectionQuality(
    items: byIssue,
    series: [
      for (final s in allSeries)
        if (s.totalVolumes == null) s,
    ],
  );
}
