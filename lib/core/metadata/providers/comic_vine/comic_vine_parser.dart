import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/series_metadata.dart';

/// Comic Vine envelope: status_code 1 = OK (100 invalid key, 101 not found…).
List<Map<String, dynamic>> comicVineResults(Map<String, dynamic> json) {
  final status = json['status_code'];
  if (status != 1) {
    throw FormatException('Comic Vine status $status: ${json['error']}');
  }
  return switch (json['results']) {
    final List<dynamic> list => list.cast<Map<String, dynamic>>(),
    final Map<String, dynamic> single => [single],
    _ => const [],
  };
}

String? _image(Map<String, dynamic> r) {
  final image = r['image'] as Map<String, dynamic>?;
  return (image?['medium_url'] ?? image?['original_url']) as String?;
}

String? _name(Object? nested) =>
    (nested as Map<String, dynamic>?)?['name'] as String?;

/// Volumes (= series) from /search?resources=volume.
List<SeriesMetadata> parseComicVineVolumes(Map<String, dynamic> json) => [
  for (final r in comicVineResults(json))
    if (r['name'] case final String name)
      SeriesMetadata(
        source: SeriesSource.comicVine,
        sourceId: '${r['id']}',
        title: name,
        publisher: _name(r['publisher']),
        totalVolumes: r['count_of_issues'] as int?,
        startYear: int.tryParse('${r['start_year']}'),
        coverUrl: _image(r),
        description: plainText(r['deck'] as String?),
        siteUrl: r['site_detail_url'] as String?,
      ),
];

/// Issues from /search?resources=issue (US single issues have no ISBN).
List<MetadataResult> parseComicVineIssues(Map<String, dynamic> json) => [
  for (final r in comicVineResults(json))
    if (_name(r['volume']) case final String series)
      MetadataResult(
        source: MetadataSource.comicVine,
        sourceId: '${r['id']}',
        title: series,
        subtitle: r['name'] as String?,
        seriesTitle: series,
        volumeNumber: r['issue_number'] as String?,
        publishDate: r['cover_date'] as String?,
        coverUrl: _image(r),
      ),
];
