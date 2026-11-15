import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/source_settings.dart';

enum ApiKeyCheck {
  valid,

  /// Refused: wrong key, or (Google) Books API not allowed for this key.
  invalid,

  /// Valid but over its quota for now.
  quota,
  offline,

  /// Unexpected answer (logged by the caller).
  failed,
}

/// "Test the key" (PLAN_V3 phase 15): one real, minimal request.
/// Answers recorded in `test/fixtures/{google_books,comic_vine}/`.
Future<ApiKeyCheck> checkApiKey(Dio dio, SourceId id, String key) async {
  final options = Options(validateStatus: (_) => true);
  try {
    switch (id) {
      case SourceId.googleBooks:
        final r = await dio.get<Object?>(
          'https://www.googleapis.com/books/v1/volumes',
          queryParameters: {
            'q': 'isbn:9782266320481',
            'maxResults': '1',
            'printType': 'books',
            'key': key,
          },
          options: options,
        );
        return switch (r.statusCode) {
          200 => ApiKeyCheck.valid,
          400 || 401 || 403 => ApiKeyCheck.invalid,
          429 => ApiKeyCheck.quota,
          _ => ApiKeyCheck.failed,
        };
      case SourceId.comicVine:
        final r = await dio.get<Object?>(
          'https://comicvine.gamespot.com/api/search/',
          queryParameters: {
            'api_key': key,
            'format': 'json',
            'resources': 'volume',
            'query': 'batman',
            'limit': '1',
            'field_list': 'id',
          },
          options: options,
        );
        // Status codes of the API: 1 OK, 100 invalid key, 107 rate limit.
        final code = switch (r.data) {
          {'status_code': final int c} => c,
          _ => null,
        };
        return switch ((r.statusCode, code)) {
          (_, 1) => ApiKeyCheck.valid,
          (_, 100) || (401, _) => ApiKeyCheck.invalid,
          (_, 107) || (420 || 429, _) => ApiKeyCheck.quota,
          _ => ApiKeyCheck.failed,
        };
      case SourceId.bnf || SourceId.openLibrary || SourceId.anilist:
        return ApiKeyCheck.valid;
    }
  } on DioException catch (e) {
    return switch (e.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => ApiKeyCheck.offline,
      _ => ApiKeyCheck.failed,
    };
  }
}
