import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

/// MangaUpdates public API v1 (no key): series info, including the French
/// manga AniList ignores (Dreamland, Everdark), for the number of volumes
/// (PLAN_V4 phase 32). Docs: https://api.mangaupdates.com/
class MangaUpdatesProvider implements SeriesMetadataProvider {
  new(this._dio, {RateLimiter? limiter})
    : _limiter = limiter ?? RateLimiter(const Duration(seconds: 1));

  static const _api = 'https://api.mangaupdates.com/v1';

  final Dio _dio;
  final RateLimiter _limiter;

  @override
  SeriesSource get seriesSource => SeriesSource.mangaUpdates;

  /// Results of the search; the ones titled exactly [query] are fetched in
  /// full (volume count, status), the others keep their title only.
  @override
  Future<List<SeriesMetadata>> searchSeries(String query) async {
    try {
      final search = await _limiter.run(
        () => _dio.post<Map<String, dynamic>>(
          '$_api/series/search',
          data: {'search': query, 'perpage': 5},
        ),
      );
      final wanted = normalizeTitle(query);
      final results = <SeriesMetadata>[];
      for (final r in (search.data?['results'] as List<dynamic>? ?? const [])) {
        final hit = r as Map<String, dynamic>;
        final record = hit['record'] as Map<String, dynamic>;
        final exact = {
          normalizeTitle('${record['title']}'),
          normalizeTitle('${hit['hit_title'] ?? ''}'),
        }.contains(wanted);
        if (exact) {
          final full = await _limiter.run(
            () => _dio.get<Map<String, dynamic>>(
              '$_api/series/${record['series_id']}',
            ),
          );
          results.add(parseMangaUpdatesSeries(full.data ?? record));
        } else {
          results.add(parseMangaUpdatesSeries(record));
        }
      }
      return results;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw SeriesLookupException(
        seriesSource,
        status == null ? e.type.name : 'HTTP $status',
      );
    }
  }
}

/// "203 Chapters (Ongoing)\n22 Volumes (Ongoing)": the first volume count
/// and whether that edition is complete.
({int? volumes, PublicationStatus status}) parseMangaUpdatesStatus(
  String? raw,
) {
  final m = RegExp(
    r'(\d+)\s+Volumes?\s*(?:\(([^)]*)\))?',
    caseSensitive: false,
  ).firstMatch(raw ?? '');
  if (m == null) return (volumes: null, status: PublicationStatus.inconnue);
  final state = (m.group(2) ?? '').toLowerCase();
  return (
    volumes: int.parse(m.group(1)!),
    status: state.contains('ongoing')
        ? PublicationStatus.enCours
        : state.contains('complete')
        ? PublicationStatus.terminee
        : PublicationStatus.inconnue,
  );
}

SeriesMetadata parseMangaUpdatesSeries(Map<String, dynamic> json) {
  final (:volumes, :status) = parseMangaUpdatesStatus(
    json['status'] as String?,
  );
  // Ongoing: the count of the volumes out so far (a missing volume shows),
  // AniList gives none then.
  final complete = json['completed'] == true;
  final image =
      ((json['image'] as Map<String, dynamic>?)?['url']
              as Map<String, dynamic>?)?['original']
          as String?;
  return SeriesMetadata(
    source: SeriesSource.mangaUpdates,
    sourceId: '${json['series_id']}',
    title: '${json['title']}',
    authors: {
      for (final a in json['authors'] as List<dynamic>? ?? const [])
        if ((a as Map<String, dynamic>)['name'] case final String name) name,
    }.toList(),
    totalVolumes: volumes,
    status: complete ? PublicationStatus.terminee : status,
    startYear: int.tryParse('${json['year'] ?? ''}'),
    coverUrl: image,
    description: plainText(json['description'] as String?),
    siteUrl: json['url'] as String?,
  );
}
