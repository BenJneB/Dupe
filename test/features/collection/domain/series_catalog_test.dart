import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

void main() {
  test('volume numbers as the BnF writes them', () {
    expect(
      ['7', '01', 'T07', '. 31', 'Tome 3', 'HS 1', null].map(catalogNumber),
      [7, 1, 7, 31, 3, null, null],
    );
  });

  test('Blue lock: editions by publisher, one volume per number', () {
    final records = [
      ...parseUnimarcResponse(fixture('bnf/series_blue_lock_p1.xml')),
      ...parseUnimarcResponse(fixture('bnf/series_blue_lock_p2.xml')),
    ];

    final editions = buildCatalog('Blue Lock', records);

    // "Pika édition", "Pika éditions" and "Pika Edition" are one publisher;
    // "Blue Lock épisode Nagi" is another series.
    expect(editions.map((e) => e.publisher?.split(' ').first), ['Pika', 'The']);
    final pika = editions.first;
    expect(pika.volumes.map((v) => v.number), [
      for (var n = 1; n <= 35; n++) n,
    ]);
    final first = pika.volumes.first;
    // Three printings of volume 1: the lowest ISBN is the first one.
    expect(first.records, hasLength(3));
    expect(first.preferred.isbn13, '9782811650254');
  });

  test('Everdark: seven volumes, the other title left out', () {
    final editions = buildCatalog(
      'Everdark',
      parseUnimarcResponse(fixture('bnf/series_everdark.xml')),
    );
    expect(
      editions.single.volumes.map((v) => v.preferred.isbn13).first,
      '9782811619428',
    );
    expect(editions.single.volumes, hasLength(7));
  });
}
