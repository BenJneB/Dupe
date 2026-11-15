import 'package:dio/dio.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/open_library/open_library_provider.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  late FakeHttpAdapter http;
  late OpenLibraryProvider provider;

  setUp(() {
    http = FakeHttpAdapter();
    provider = OpenLibraryProvider(
      fakeDio(http),
      contact: '',
      limiter: RateLimiter(Duration.zero),
    );
  });

  test('ISBN lookup uses the Books API (jscmd=data)', () async {
    http.on(
      (u) => u.path == '/api/books',
      fixture('open_library/isbn_9782266320481.json'),
    );

    final r = (await provider.searchByIsbn('9782266320481'))!;

    final params = http.requests.single.queryParameters;
    expect(params['bibkeys'], 'ISBN:9782266320481');
    expect(params['jscmd'], 'data');
    expect(r.source, MetadataSource.openLibrary);
    expect(r.title, 'Dune - tome 1');
    expect(r.authors, ['Frank Herbert']);
    expect(r.publisher, 'POCKET');
    expect(r.pageCount, 928);
    expect(r.isbn13, '9782266320481');
  });

  test('sends the contact email in the User-Agent when configured', () async {
    late Map<String, dynamic> headers;
    final dio = fakeDio(http)
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            headers = options.headers;
            handler.next(options);
          },
        ),
      );
    http.on((u) => true, '{}');

    await OpenLibraryProvider(
      dio,
      contact: 'me@example.org',
      limiter: RateLimiter(Duration.zero),
    ).searchByIsbn('9782266320481');

    expect(headers['User-Agent'], 'Dupe/0.2 (me@example.org)');
  });

  test('unknown ISBN (empty object) returns null', () async {
    http.on((u) => true, '{}');
    expect(await provider.searchByIsbn('9782266320481'), isNull);
  });

  test('text search maps works with cover ids', () async {
    http.on(
      (u) => u.path == '/search.json',
      fixture('open_library/search_dune.json'),
    );

    final results = await provider.searchByText('dune herbert');

    expect(results, isNotEmpty);
    final first = results.first;
    expect(first.authors, contains('Frank Herbert'));
    expect(
      first.coverUrl,
      'https://covers.openlibrary.org/b/id/11481354-L.jpg',
    );
    expect(first.publishDate, '1965');
  });
}
