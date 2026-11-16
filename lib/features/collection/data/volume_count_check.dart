import 'package:dupe/core/metadata/series_lookup.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_count.dart';

/// Looks the total number of volumes of [series] up (AniList for manga,
/// Comic Vine for comics). Null when the type has no source, nothing
/// matches, or the known total is already the same. Source errors are
/// thrown (`SeriesLookupException`).
Future<VolumeCountProposal?> checkVolumeCount(
  SeriesLookup lookup,
  Series series,
) async {
  if (lookup.providerFor(series.type) == null) return null;
  final match = matchSeriesTotal(
    series,
    await lookup.search(series.title, series.type),
  );
  if (match == null || match.totalVolumes == series.totalVolumes) return null;
  return VolumeCountProposal(series: series, match: match);
}
