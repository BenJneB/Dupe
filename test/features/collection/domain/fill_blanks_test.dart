import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

const record = MetadataResult(
  source: MetadataSource.bnf,
  sourceId: 'ark',
  title: 'Les renforts maléfiques',
  authors: ['Alexandre Astier'],
  publisher: 'Casterman',
  coverUrl: 'https://c/k9.jpg',
  coverPrice: 12.5,
  currency: 'EUR',
  isbn13: '9782203085053',
);

void main() {
  test('an empty volume is completed, typed values are kept', () {
    // Created by "Ajouter des tomes": series title, nothing else.
    final empty = testItem('k9', volume: '9').copyWith(title: 'Kaamelott');
    final filled = fillBlanks(empty, record, seriesTitle: 'Kaamelott');
    expect(filled.title, 'Les renforts maléfiques');
    expect(filled.authors, ['Alexandre Astier']);
    expect(filled.publisher, 'Casterman');
    expect(filled.coverUrl, 'https://c/k9.jpg');
    expect((filled.coverPrice, filled.currency), (12.5, 'EUR'));
    expect(filled.isbn13, '9782203085053');

    final typed = testItem('k9', volume: '9').copyWith(
      title: 'Mon titre',
      publisher: 'Mon éditeur',
      coverPrice: 10,
      currency: 'CHF',
      coverUrl: 'dupe-cover:photo.jpg',
    );
    final kept = fillBlanks(typed, record, seriesTitle: 'Kaamelott');
    expect(kept.title, 'Mon titre');
    expect(kept.publisher, 'Mon éditeur');
    expect((kept.coverPrice, kept.currency), (10, 'CHF'));
    expect(kept.coverUrl, 'dupe-cover:photo.jpg');
    expect(kept.authors, ['Alexandre Astier']);
  });
}
