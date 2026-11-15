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
    // 200\$h "[Livre 1]" (real record): only the number is kept.
    expect(results.map((r) => r.volumeNumber), isNot(contains('[Livre 1]')));
    expect(results.map((r) => r.volumeNumber), contains('1'));
  });

  test('a publisher collection number is not a series volume', () async {
    http.on((u) => true, fixture('bnf/search_jumeaux_fowl.xml'));

    final results = await provider.searchByText('jumeaux fowl');
    MetadataResult byIsbn(String isbn) =>
        results.firstWhere((r) => r.isbn13 == isbn);

    // 200 "Les jumeaux Fowl" \$h 3, 225 "Folio junior" \$v 1987, no 461:
    // the title is the series (was "Folio junior").
    final t3 = byIsbn('9782075215091');
    expect(t3.title, 'Les jumeaux Fowl');
    expect(t3.volumeNumber, '3');
    expect(t3.seriesTitle, isNull);
    // 461 "Les jumeaux Fowl" without number, 225 "Folio junior" \$v 1940.
    final t1 = byIsbn('9782075173827');
    expect(t1.seriesTitle, 'Les jumeaux Fowl');
    expect(t1.volumeNumber, isNull);
    // 225 of the series (\$v 2) and of the collection (\$v 1962).
    final t2 = byIsbn('9782075198134');
    expect(t2.seriesTitle, 'Les jumeaux Fowl');
    expect(t2.volumeNumber, '2');
  });

  test('volume labels are cleaned', () {
    expect(cleanVolumeNumber('Tome 2'), '2');
    expect(cleanVolumeNumber('T. 12'), '12');
    expect(cleanVolumeNumber('vol. 3'), '3');
    expect(cleanVolumeNumber('Saison 1'), 'Saison 1');
    expect(cleanVolumeNumber('HS 2'), 'HS 2');
    expect(cleanVolumeNumber('[Livre 1]'), '1');
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
