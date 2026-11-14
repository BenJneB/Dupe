import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/google_books/google_books_parser.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// Google Books API v1. An API key is effectively required: the anonymous
/// quota is shared by everyone and usually exhausted (HTTP 429).
/// Docs: https://developers.google.com/books/docs/v1/using
class GoogleBooksProvider implements MetadataProvider {
  new(this._dio, {required this.apiKey, RateLimiter? limiter})
    : _limiter = limiter ?? RateLimiter(const Duration(milliseconds: 300));

  static const _endpoint = 'https://www.googleapis.com/books/v1/volumes';

  final Dio _dio;
  final String apiKey;
  final RateLimiter _limiter;

  @override
  MetadataSource get source => MetadataSource.googleBooks;

  @override
  Set<CollectionType> get supportedTypes => CollectionType.values.toSet();

  @override
  Future<MetadataResult?> searchByIsbn(String isbn13) async =>
      (await _search('isbn:$isbn13', max: 1)).firstOrNull;

  @override
  Future<List<MetadataResult>> searchByText(String query) =>
      _search(query, max: 20);

  Future<List<MetadataResult>> _search(String q, {required int max}) async {
    try {
      final response = await _limiter.run(
        () => _dio.get<Map<String, dynamic>>(
          _endpoint,
          queryParameters: {
            'q': q,
            'maxResults': '$max',
            'printType': 'books',
            if (apiKey.isNotEmpty) 'key': apiKey,
          },
        ),
      );
      return parseGoogleBooksVolumes(response.data ?? const {});
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw MetadataException(
        source,
        status == null ? (e.message ?? e.type.name) : 'HTTP $status',
      );
    }
  }
}
