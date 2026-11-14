import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_metadata.dart';

MetadataResult r(
  MetadataSource source, {
  String title = 'T',
  String? publisher,
  String? cover,
  String? isbn,
  double? price,
}) => MetadataResult(
  source: source,
  sourceId: source.name,
  title: title,
  publisher: publisher,
  coverUrl: cover,
  isbn13: isbn,
  coverPrice: price,
  currency: price == null ? null : 'EUR',
);

const isbn = '9782266320481';

void main() {
  test('merges fields by priority: BnF title, Google cover', () async {
    final agg = MetadataAggregator(
      providers: [
        FakeProvider(
          MetadataSource.googleBooks,
          isbnResult: r(
            MetadataSource.googleBooks,
            title: 'Google',
            cover: 'g.jpg',
          ),
        ),
        FakeProvider(
          MetadataSource.bnf,
          isbnResult: r(
            MetadataSource.bnf,
            title: 'Dune',
            publisher: 'Pocket',
            price: 11.95,
          ),
        ),
      ],
    );

    final lookup = await agg.lookupIsbn(isbn, CollectionType.livre);

    expect(lookup.merged!.title, 'Dune');
    expect(lookup.merged!.source, MetadataSource.bnf);
    expect(lookup.merged!.publisher, 'Pocket');
    expect(lookup.merged!.coverUrl, 'g.jpg');
    expect(lookup.merged!.coverPrice, 11.95);
    expect(lookup.merged!.isbn13, isbn);
    expect(lookup.failed, isEmpty);
  });

  test('a failing or slow source does not block the others', () async {
    final agg = MetadataAggregator(
      timeout: const Duration(milliseconds: 50),
      providers: [
        FakeProvider(MetadataSource.bnf, error: Exception('down')),
        FakeProvider(
          MetadataSource.googleBooks,
          isbnResult: r(MetadataSource.googleBooks),
          delay: const Duration(seconds: 1),
        ),
        FakeProvider(
          MetadataSource.openLibrary,
          isbnResult: r(MetadataSource.openLibrary, title: 'OL'),
        ),
      ],
    );

    final lookup = await agg.lookupIsbn(isbn, CollectionType.livre);

    expect(lookup.merged!.title, 'OL');
    expect(lookup.failed, [MetadataSource.bnf, MetadataSource.googleBooks]);
  });

  test('falls back to the Open Library cover-by-ISBN URL', () async {
    final agg = MetadataAggregator(
      providers: [
        FakeProvider(MetadataSource.bnf, isbnResult: r(MetadataSource.bnf)),
      ],
    );
    final lookup = await agg.lookupIsbn(isbn, CollectionType.livre);
    expect(
      lookup.merged!.coverUrl,
      'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg?default=false',
    );
  });

  test('unknown everywhere gives no merged result', () async {
    final agg = MetadataAggregator(
      providers: [FakeProvider(MetadataSource.bnf)],
    );
    final lookup = await agg.lookupIsbn(isbn, CollectionType.livre);
    expect(lookup.merged, isNull);
    expect(lookup.failed, isEmpty);
  });

  test('only queries the sources configured for the type', () async {
    final ol = FakeProvider(MetadataSource.openLibrary);
    final agg = MetadataAggregator(providers: [ol]);
    await agg.lookupIsbn(isbn, CollectionType.manga);
    expect(ol.calls, 0);
  });

  test('caches lookups per source', () async {
    final bnf = FakeProvider(
      MetadataSource.bnf,
      isbnResult: r(MetadataSource.bnf),
    );
    final agg = MetadataAggregator(providers: [bnf]);
    await agg.lookupIsbn(isbn, CollectionType.livre);
    await agg.lookupIsbn(isbn, CollectionType.livre);
    expect(bnf.calls, 1);
  });

  test('text search keeps priority order and dedupes by ISBN', () async {
    final agg = MetadataAggregator(
      providers: [
        FakeProvider(
          MetadataSource.googleBooks,
          textResults: [
            r(MetadataSource.googleBooks, title: 'G1', isbn: isbn),
            r(MetadataSource.googleBooks, title: 'G2'),
          ],
        ),
        FakeProvider(
          MetadataSource.bnf,
          textResults: [r(MetadataSource.bnf, title: 'B1', isbn: isbn)],
        ),
      ],
    );

    final search = await agg.searchText('dune', CollectionType.livre);

    expect(search.results.map((e) => e.title), ['B1', 'G2']);
  });
}
