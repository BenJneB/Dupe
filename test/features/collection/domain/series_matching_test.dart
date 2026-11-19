import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_http.dart';

final _t = DateTime.utc(2026);

Series series(
  String id,
  String title, {
  String? publisher,
  CollectionType type = CollectionType.manga,
}) => Series(
  id: id,
  createdAt: _t,
  updatedAt: _t,
  type: type,
  title: title,
  publisher: publisher,
);

MetadataResult volume({
  String title = 'One Piece',
  String? seriesTitle,
  String? volumeNumber = '3',
  String? publisher = 'Glénat',
}) => MetadataResult(
  source: MetadataSource.bnf,
  sourceId: 'x',
  title: title,
  seriesTitle: seriesTitle,
  volumeNumber: volumeNumber,
  publisher: publisher,
);

void main() {
  test('normalizeTitle folds case, accents and punctuation', () {
    expect(normalizeTitle("L'Épée, de cristal !"), 'l epee de cristal');
    expect(normalizeTitle('ONE PIECE'), 'one piece');
  });

  test('parenthesized qualifiers are ignored', () {
    final batman = series(
      'b',
      'Batman (DC Renaissance)',
      publisher: 'Urban Comics',
      type: CollectionType.comic,
    );
    // Real BnF record of "La Nuit des Hiboux" (9782365772068).
    final t2 = volume(
      title: 'La nuit des hiboux',
      seriesTitle: 'Batman',
      volumeNumber: '2',
      publisher: 'Urban comics',
    );
    expect(findMatchingSeries(t2, [batman]), batman);
  });

  test('publishers match on inclusion, unknown matches', () {
    expect(publishersMatch('Glénat', 'Glénat Manga'), isTrue);
    expect(publishersMatch('Éditions Glénat', 'glenat'), isTrue);
    expect(publishersMatch('Glénat', 'Kana'), isFalse);
    expect(publishersMatch(null, 'Kana'), isTrue);
  });

  test('a numbered volume matches its series by title and publisher', () {
    final onePiece = series('op', 'One Piece', publisher: 'Glénat');
    final other = series('n', 'Naruto', publisher: 'Kana');

    expect(findMatchingSeries(volume(), [other, onePiece]), onePiece);
  });

  test('BnF series field (461) is used before the volume title', () {
    final cycle = series('d', 'Le cycle de Dune', type: CollectionType.livre);
    final r = volume(
      title: 'Dune',
      seriesTitle: 'Le cycle de Dune',
      volumeNumber: '1',
      publisher: 'Pocket',
    );
    expect(findMatchingSeries(r, [cycle]), cycle);
  });

  test('another edition (other publisher) goes into the same series', () {
    // Recette 2026-11-19: other editions must not create a new series.
    final other = series('p', 'One Piece', publisher: 'Kana');
    expect(findMatchingSeries(volume(), [other]), other);
  });

  test('a compatible publisher wins among same-title series', () {
    final kana = series('k', 'One Piece', publisher: 'Kana');
    final glenat = series('g', 'One Piece', publisher: 'Glénat');
    expect(findMatchingSeries(volume(), [kana, glenat]), glenat);
  });

  test('publishers sharing their first word match', () {
    expect(publishersMatch('Panini France', 'Panini comics'), isTrue);
    expect(publishersMatch('Éditions Delcourt', 'Delcourt Tonkam'), isTrue);
    expect(publishersMatch('Le Lombard', 'Le Livre de poche'), isFalse);
  });

  test('The Magic Order 4 (Panini comics) joins its series', () {
    final magic = series(
      'm',
      'The magic order',
      publisher: 'Panini France',
      type: CollectionType.comic,
    );
    final t4 = parseUnimarcResponse(fixture('bnf/isbn_9791039124744.xml'))
        .single;
    expect(t4.publisher, 'Panini comics');
    expect(findMatchingSeries(t4, [magic]), magic);
  });

  test("Jupiter's Legacy T. 04 joins its series through its 200 subtitle", () {
    final jupiter = series(
      'j',
      "Jupiter's legacy",
      publisher: 'Panini comics',
      type: CollectionType.comic,
    );
    final t4 = parseUnimarcResponse(fixture('bnf/isbn_9791039142922.xml'))
        .single;
    expect(findMatchingSeries(t4, [jupiter]), jupiter);
  });

  test('unnumbered standalone book never matches by its own title', () {
    final s = series('s', 'Dune', type: CollectionType.livre);
    expect(
      findMatchingSeries(volume(title: 'Dune', volumeNumber: null), [s]),
      isNull,
    );
  });

  test('preferred type wins when several series match', () {
    final asBd = series('b', 'One Piece', type: CollectionType.bd);
    final asManga = series('m', 'One Piece');
    expect(
      findMatchingSeries(volume(), [
        asBd,
        asManga,
      ], preferredType: CollectionType.manga),
      asManga,
    );
  });
}
