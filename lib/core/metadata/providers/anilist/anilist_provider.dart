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

  static const _fields = '''
id type format title { romaji english native } synonyms volumes status
coverImage { large } startDate { year } siteUrl
staff(perPage: 6, sort: RELEVANCE) { edges { role node { name { full } } } }''';

  /// One manga (by id, else by title) with its community recommendations
  /// and related works (PLAN_V4 phase 30).
  static const neighboursQuery =
      '''
query (\$id: Int, \$search: String) {
  Media(id: \$id, search: \$search, type: MANGA) {
    $_fields
    recommendations(sort: RATING_DESC, perPage: 15) {
      nodes { rating mediaRecommendation { $_fields } }
    }
    relations { edges { relationType node { $_fields } } }
  }
}''';

  final Dio _dio;
  final RateLimiter _limiter;

  @override
  SeriesSource get seriesSource => SeriesSource.anilist;

  @override
  Future<List<SeriesMetadata>> searchSeries(String query) async =>
      parseAniListSearch(await _post(searchQuery, {'search': query}));

  /// Null when AniList does not know the manga (HTTP 404).
  Future<AniListNeighbours?> neighbours({int? id, String? title}) async {
    try {
      return parseAniListNeighbours(
        await _post(neighboursQuery, {'id': ?id, 'search': ?title}),
      );
    } on SeriesLookupException catch (e) {
      if (e.message == 'HTTP 404') return null;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _post(
    String query,
    Map<String, Object> variables,
  ) async {
    try {
      final response = await _limiter.run(
        () => _dio.post<Map<String, dynamic>>(
          _endpoint,
          data: {'query': query, 'variables': variables},
          options: Options(headers: {'Accept': 'application/json'}),
        ),
      );
      return response.data ?? const {};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw SeriesLookupException(
        seriesSource,
        status == null ? e.type.name : 'HTTP $status',
      );
    }
  }
}
