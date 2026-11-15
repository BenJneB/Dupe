import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/api_key_check.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http.dart';

/// No network: the connection itself fails.
class _OfflineAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => throw DioException.connectionError(
    requestOptions: options,
    reason: 'offline',
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  /// Real answers (`test/fixtures/`); the invalid ones were recorded with a
  /// made-up key.
  Future<ApiKeyCheck> check(
    SourceId id,
    String fixturePath, {
    int status = 200,
  }) {
    final http = FakeHttpAdapter()
      ..on((_) => true, fixture(fixturePath), status: status);
    return checkApiKey(fakeDio(http), id, 'some-key');
  }

  test('Google Books', () async {
    expect(
      await check(
        SourceId.googleBooks,
        'google_books/isbn_9782266320481_ok.json',
      ),
      ApiKeyCheck.valid,
    );
    expect(
      await check(
        SourceId.googleBooks,
        'google_books/invalid_key.json',
        status: 400,
      ),
      ApiKeyCheck.invalid,
    );
    expect(
      await check(
        SourceId.googleBooks,
        'google_books/isbn_9782266320481.json',
        status: 429,
      ),
      ApiKeyCheck.quota,
    );
  });

  test('Comic Vine', () async {
    expect(
      await check(SourceId.comicVine, 'comic_vine/search_volume_batman.json'),
      ApiKeyCheck.valid,
    );
    expect(
      await check(
        SourceId.comicVine,
        'comic_vine/invalid_key.json',
        status: 401,
      ),
      ApiKeyCheck.invalid,
    );
  });

  test('offline', () async {
    final dio = Dio()..httpClientAdapter = _OfflineAdapter();
    expect(
      await checkApiKey(dio, SourceId.comicVine, 'k'),
      ApiKeyCheck.offline,
    );
  });
}
