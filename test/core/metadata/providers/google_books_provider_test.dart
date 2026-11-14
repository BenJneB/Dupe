import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/google_books/google_books_provider.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  late FakeHttpAdapter http;

  GoogleBooksProvider provider({String apiKey = ''}) => GoogleBooksProvider(
    fakeDio(http),
    apiKey: apiKey,
    limiter: RateLimiter(Duration.zero),
  );

  setUp(() => http = FakeHttpAdapter());

  test(
    'quota exhausted (real 429 without key) is a MetadataException',
    () async {
      http.on(
        (u) => true,
        fixture('google_books/isbn_9782266320481.json'),
        status: 429,
      );
      await expectLater(
        provider().searchByIsbn('9782266320481'),
        throwsA(
          isA<MetadataException>().having(
            (e) => e.message,
            'message',
            'HTTP 429',
          ),
        ),
      );
      expect(http.requests.single.queryParameters['q'], 'isbn:9782266320481');
      expect(http.requests.single.queryParameters.containsKey('key'), isFalse);
    },
  );

  test('parses a real volume (fetched with an API key)', () async {
    http.on((u) => true, fixture('google_books/isbn_9782266320481_ok.json'));

    final r = (await provider(apiKey: 'k').searchByIsbn('9782266320481'))!;

    expect(r.source, MetadataSource.googleBooks);
    expect(r.sourceId, 'EVehzgEACAAJ');
    expect(r.title, 'Dune');
    expect(r.authors, ['Frank Herbert']);
    expect(r.publishDate, '2021-08-26');
    expect(r.pageCount, 928);
    expect(r.language, 'fr');
    // ISBN_13 preferred over ISBN_10.
    expect(r.isbn13, '9782266320481');
    // This edition has no cover, publisher nor price on Google Books.
    expect(r.coverUrl, isNull);
    expect(r.publisher, isNull);
    expect(r.coverPrice, isNull);
  });

  test('sends the API key when configured', () async {
    http.on((u) => true, '{"kind":"books#volumes","totalItems":0}');
    expect(await provider(apiKey: 'k').searchByIsbn('9782266320481'), isNull);
    expect(http.requests.single.queryParameters['key'], 'k');
  });
}
