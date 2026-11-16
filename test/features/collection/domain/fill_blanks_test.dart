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
    expect(filled.title, 'Kaamelott');
    expect(filled.volumeTitle, 'Les renforts maléfiques');
    expect(filled.authors, ['Alexandre Astier']);
    expect(filled.publisher, 'Casterman');
    expect(filled.coverUrl, 'https://c/k9.jpg');
    expect((filled.coverPrice, filled.currency), (12.5, 'EUR'));
    expect(filled.isbn13, '9782203085053');

    final typed = testItem('k9', volume: '9').copyWith(
      title: 'Mon titre',
      volumeTitle: 'Mon tome',
      publisher: 'Mon éditeur',
      coverPrice: 10,
      currency: 'CHF',
      coverUrl: 'dupe-cover:photo.jpg',
    );
    final kept = fillBlanks(typed, record, seriesTitle: 'Kaamelott');
    expect(kept.title, 'Mon titre');
    expect(kept.volumeTitle, 'Mon tome');
    expect(kept.publisher, 'Mon éditeur');
    expect((kept.coverPrice, kept.currency), (10, 'CHF'));
    expect(kept.coverUrl, 'dupe-cover:photo.jpg');
    expect(kept.authors, ['Alexandre Astier']);
  });

  test('the volume title: own title, subtitle, or nothing', () {
    MetadataResult r(String title, {String? subtitle, String? volume}) =>
        MetadataResult(
          source: MetadataSource.bnf,
          sourceId: title,
          title: title,
          subtitle: subtitle,
          volumeNumber: volume,
        );

    // BnF: the record's title is the volume's own title.
    expect(
      volumeTitleOf(r('Les renforts maléfiques'), seriesTitle: 'Kaamelott'),
      'Les renforts maléfiques',
    );
    // Comic Vine: series name as title, issue name as subtitle.
    expect(
      volumeTitleOf(
        r('Batman', subtitle: 'La Cour des Hiboux', volume: '1'),
        seriesTitle: 'Batman',
      ),
      'La Cour des Hiboux',
    );
    // Both, kept together.
    expect(
      volumeTitleOf(
        r('Kaamelott', subtitle: 'Épisodes 1 à 49', volume: '4'),
        seriesTitle: 'Kaamelott',
      ),
      'Épisodes 1 à 49',
    );
    // Only the series title and a number: no volume title.
    expect(volumeTitleOf(r('One Piece', volume: '56')), isNull);
    // Standalone book without subtitle: nothing either.
    expect(volumeTitleOf(r('Dune')), isNull);
  });
}
