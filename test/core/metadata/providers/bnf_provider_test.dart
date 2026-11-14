import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/bnf/bnf_provider.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/core/network/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  late FakeHttpAdapter http;
  late BnfProvider provider;

  setUp(() {
    http = FakeHttpAdapter();
    provider = BnfProvider(fakeDio(http), limiter: RateLimiter(Duration.zero));
  });

  test('ISBN lookup parses a UNIMARC record', () async {
    http.on((u) => true, fixture('bnf/isbn_9782266320481.xml'));

    final r = (await provider.searchByIsbn('9782266320481'))!;

    expect(
      http.requests.single.queryParameters['query'],
      'bib.isbn adj "9782266320481"',
    );
    expect(r.source, MetadataSource.bnf);
    expect(r.sourceId, 'ark:/12148/cb47180638m');
    expect(r.title, 'Dune');
    // Translator (702 $4=730) is not an author.
    expect(r.authors, ['Frank Herbert']);
    expect(r.publisher, 'Pocket');
    expect(r.publishDate, '2022');
    expect(r.pageCount, 917);
    expect(r.language, 'fr');
    expect(r.isbn13, '9782266320481');
    expect(r.coverPrice, 11.95);
    expect(r.currency, 'EUR');
    expect(r.seriesTitle, 'Le cycle de Dune');
    expect(r.volumeNumber, '1');
  });

  test('manga records give volume numbers and dotted prices', () async {
    http.on((u) => true, fixture('bnf/search_one_piece.xml'));

    final results = await provider.searchByText('one piece');

    final t56 = results.firstWhere((r) => r.volumeNumber == '56');
    expect(t56.isbn13, '9782723478991');
    expect(t56.coverPrice, 6.90);
    expect(t56.authors, ['Eiichirō Oda']);
    final t112 = results.firstWhere((r) => r.volumeNumber == '112');
    // 702 without relator code is kept as author.
    expect(t112.authors, ['Eiichirō Oda']);
    expect(t112.publisher, 'Glénat');
    // 225 without \$v is a publisher collection, not a series.
    expect(t112.seriesTitle, isNull);
  });

  test('text search sends an anywhere + doctype query', () async {
    http.on((u) => true, fixture('bnf/search_dune.xml'));

    final results = await provider.searchByText('dune "herbert"');

    expect(
      http.requests.single.queryParameters['query'],
      'bib.anywhere all "dune  herbert" and bib.doctype any "a"',
    );
    expect(results, hasLength(20));
    expect(results.every((r) => r.title.isNotEmpty), isTrue);
  });

  test('volume labels are cleaned', () {
    expect(cleanVolumeNumber('Tome 2'), '2');
    expect(cleanVolumeNumber('T. 12'), '12');
    expect(cleanVolumeNumber('vol. 3'), '3');
    expect(cleanVolumeNumber('Saison 1'), 'Saison 1');
    expect(cleanVolumeNumber('HS 2'), 'HS 2');
    expect(cleanVolumeNumber('  '), isNull);
  });

  test('unknown ISBN returns null', () async {
    http.on(
      (u) => true,
      fixture(
        'bnf/isbn_9782266320481.xml',
      ).replaceAll(RegExp('<srw:records>.*</srw:records>', dotAll: true), ''),
    );
    expect(await provider.searchByIsbn('9782266320481'), isNull);
  });

  test('HTTP errors become MetadataException', () async {
    http.on((u) => true, 'oops', status: 503);
    expect(
      provider.searchByIsbn('9782266320481'),
      throwsA(isA<MetadataException>()),
    );
  });
}
