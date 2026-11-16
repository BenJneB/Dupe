import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

/// Number of volumes proposed for [series] by a series source.
class VolumeCountProposal {
  const new({required this.series, required this.match});

  final Series series;

  /// Source result describing the series (title, source, total).
  final SeriesMetadata match;

  int get total => match.totalVolumes!;
}

/// The result of [results] that is [series] (same normalized title or
/// original title) and gives a volume count. Only exact titles: a wrong total
/// would draw false missing volumes.
SeriesMetadata? matchSeriesTotal(Series series, List<SeriesMetadata> results) {
  final wanted = normalizeTitle(series.title);
  if (wanted.isEmpty) return null;
  for (final r in results) {
    final total = r.totalVolumes;
    if (total == null || total <= 0) continue;
    final titles = [r.title, ?r.originalTitle].map(normalizeTitle);
    if (titles.contains(wanted)) return r;
  }
  return null;
}
