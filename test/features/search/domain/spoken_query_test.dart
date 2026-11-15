import 'package:dupe/features/search/domain/french_numbers.dart';
import 'package:dupe/features/search/domain/spoken_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('French number words, up to a hundred and beyond', () {
    const cases = {
      'un': 1,
      'douze': 12,
      'dix-sept': 17,
      'vingt et un': 21,
      'trente-deux': 32,
      'soixante-dix': 70,
      'soixante et onze': 71,
      'soixante-dix-sept': 77,
      'quatre-vingts': 80,
      'quatre-vingt-un': 81,
      'quatre-vingt-dix-neuf': 99,
      'cent': 100,
      'cent sept': 107,
      'deux cents': 200,
      'deux cent trois': 203,
      'mille deux': 1002,
      'Douze': 12,
      'zéro': 0,
    };
    for (final MapEntry(key: words, value: n) in cases.entries) {
      expect(parseFrenchNumber(words), n, reason: words);
    }
    expect(parseFrenchNumber('mousquetaires'), isNull);
    expect(parseFrenchNumber('premier'), isNull);
    expect(parseFrenchNumber(''), isNull);
  });

  test('series and volume from the usual phrasings', () {
    const cases = {
      'One Piece tome 107': SpokenQuery('One Piece', volume: '107'),
      'Astérix numéro 12': SpokenQuery('Astérix', volume: '12'),
      'Astérix n° 12': SpokenQuery('Astérix', volume: '12'),
      'Naruto volume douze': SpokenQuery('Naruto', volume: '12'),
      'tome 3 de Blacksad': SpokenQuery('Blacksad', volume: '3'),
      "le tome trois d'Astérix": SpokenQuery('Astérix', volume: '3'),
      'tome quatre-vingt-dix-sept de One Piece': SpokenQuery(
        'One Piece',
        volume: '97',
      ),
      'One Piece Tome Cent Sept.': SpokenQuery('One Piece', volume: '107'),
      'Blacksad 3': SpokenQuery('Blacksad', volume: '3'),
      'Dreamland tome 07': SpokenQuery('Dreamland', volume: '7'),
    };
    for (final MapEntry(key: phrase, value: query) in cases.entries) {
      expect(parseSpokenQuery(phrase), query, reason: phrase);
    }
  });

  test('without a volume, the phrase is a plain search', () {
    expect(
      parseSpokenQuery('Les Trois Mousquetaires'),
      const SpokenQuery('Les Trois Mousquetaires'),
    );
    expect(parseSpokenQuery('  Dune  '), const SpokenQuery('Dune'));
    // A volume word followed by something that is not a number.
    expect(
      parseSpokenQuery('Le tome magique'),
      const SpokenQuery('Le tome magique'),
    );
  });
}
