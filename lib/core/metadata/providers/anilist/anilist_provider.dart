import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_parser.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/core/network/rate_limiter.dart';

/// AniList GraphQL API (no key). Series-level info for manga only.
/// Rate limit: 90 req/min, currently 30 (degraded mode, observed in the
/// X-RateLimit-Limit header on 2026-11-14), hence one request every 2 s.
/// Docs: https://github.com/AniList/docs
class AniListProvider implements SeriesMetadataProvider {
  new(this._dio, {RateLimiter? limiter})
    : _limiter = limiter ?? RateLimiter(const Duration(seconds: 2));

  static const _endpoint = 'https://graphql.anilist.co';

  static const searchQuery = r'''
query ($search: String) {
  Page(perPage: 10) {
    media(search: $search, type: MANGA, format_in: [MANGA, ONE_SHOT], sort: SEARCH_MATCH) {
      id title { romaji english native } description(asHtml: false) volumes
      status coverImage { large } startDate { year } siteUrl
      staff(perPage: 6, sort: RELEVANCE) { edges { role node { name { full } } } }
    }
  }
}''';

  final Dio _dio;
  final RateLimiter _limiter;

  @override
  SeriesSource get seriesSource => SeriesSource.anilist;

  @override
  Future<List<SeriesMetadata>> searchSeries(String query) async {
    try {
      final response = await _limiter.run(
        () => _dio.post<Map<String, dynamic>>(
          _endpoint,
          data: {
            'query': searchQuery,
            'variables': {'search': query},
          },
          options: Options(headers: {'Accept': 'application/json'}),
        ),
      );
      return parseAniListSearch(response.data ?? const {});
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw SeriesLookupException(
        seriesSource,
        status == null ? e.type.name : 'HTTP $status',
      );
    }
  }
}
