import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/open_library/open_library_parser.dart';
import 'package:dupe/core/network/http_client.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// Open Library (no key). Policy: identify with a User-Agent; 1 req/s
/// without contact info, 3 req/s with a contact email; cache responses.
/// Docs: https://openlibrary.org/developers/api
class OpenLibraryProvider implements MetadataProvider {
  new(this._dio, {required String contact, RateLimiter? limiter})
    : _userAgent = contact.isEmpty ? userAgent : '$appName ($contact)',
      _limiter =
          limiter ??
          RateLimiter(
            contact.isEmpty
                ? const Duration(seconds: 1)
                : const Duration(milliseconds: 350),
          );

  static const _base = 'https://openlibrary.org';

  final Dio _dio;
  final String _userAgent;
  final RateLimiter _limiter;

  @override
  MetadataSource get source => MetadataSource.openLibrary;

  @override
  Set<CollectionType> get supportedTypes => {
    CollectionType.livre,
    CollectionType.comic,
  };

  /// Uses the legacy-but-documented Books API (`jscmd=data`): one call gives
  /// author names and covers, unlike `/isbn/{isbn}.json`.
  @override
  Future<MetadataResult?> searchByIsbn(String isbn13) async {
    final json = await _get('/api/books', {
      'bibkeys': 'ISBN:$isbn13',
      'format': 'json',
      'jscmd': 'data',
    });
    return parseOpenLibraryBook(json, isbn13);
  }

  @override
  Future<List<MetadataResult>> searchByText(String query) async {
    final json = await _get('/search.json', {
      'q': query,
      'fields':
          'key,title,author_name,first_publish_year,cover_i,'
          'number_of_pages_median',
      'limit': '20',
    });
    return parseOpenLibrarySearch(json);
  }

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, String> params,
  ) async {
    try {
      final response = await _limiter.run(
        () => _dio.get<Map<String, dynamic>>(
          '$_base$path',
          queryParameters: params,
          options: Options(headers: {'User-Agent': _userAgent}),
        ),
      );
      return response.data ?? const {};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw MetadataException(
        source,
        status == null ? (e.message ?? e.type.name) : 'HTTP $status',
      );
    }
  }
}
