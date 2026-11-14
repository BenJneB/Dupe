import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/comic_vine/comic_vine_parser.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// Comic Vine (API key required, non-commercial use). Limits: 200 requests
/// per resource per hour, temporary blocks when too fast: 1 req/s here.
/// Docs: https://comicvine.gamespot.com/api/documentation
class ComicVineProvider implements MetadataProvider, SeriesMetadataProvider {
  new(this._dio, {required this.apiKey, RateLimiter? limiter})
    : _limiter = limiter ?? RateLimiter(const Duration(seconds: 1));

  static const _search = 'https://comicvine.gamespot.com/api/search/';

  final Dio _dio;
  final String apiKey;
  final RateLimiter _limiter;

  @override
  MetadataSource get source => MetadataSource.comicVine;

  @override
  SeriesSource get seriesSource => SeriesSource.comicVine;

  @override
  Set<CollectionType> get supportedTypes => {CollectionType.comic};

  /// Comic Vine has no ISBN index.
  @override
  Future<MetadataResult?> searchByIsbn(String isbn13) async => null;

  /// Issue search, e.g. "Batman 3".
  @override
  Future<List<MetadataResult>> searchByText(String query) async {
    try {
      return parseComicVineIssues(
        await _get(
          'issue',
          query,
          'id,name,issue_number,volume,cover_date,image',
        ),
      );
    } on _ComicVineError catch (e) {
      throw MetadataException(source, e.message);
    }
  }

  @override
  Future<List<SeriesMetadata>> searchSeries(String query) async {
    try {
      return parseComicVineVolumes(
        await _get(
          'volume',
          query,
          'id,name,publisher,start_year,count_of_issues,image,deck,'
              'site_detail_url',
        ),
      );
    } on _ComicVineError catch (e) {
      throw SeriesLookupException(seriesSource, e.message);
    }
  }

  Future<Map<String, dynamic>> _get(
    String resource,
    String query,
    String fields,
  ) async {
    try {
      final response = await _limiter.run(
        () => _dio.get<Map<String, dynamic>>(
          _search,
          queryParameters: {
            'api_key': apiKey,
            'format': 'json',
            'resources': resource,
            'query': query,
            'field_list': fields,
            'limit': '10',
          },
        ),
      );
      final data = response.data ?? const {};
      // Error envelope, e.g. status_code 100 = invalid API key.
      if (data['status_code'] != 1) {
        throw _ComicVineError(
          'status ${data['status_code']}: ${data['error']}',
        );
      }
      return data;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw _ComicVineError(
        status == null ? (e.message ?? e.type.name) : 'HTTP $status',
      );
    }
  }
}

class _ComicVineError implements Exception {
  const new(this.message);

  final String message;
}
