import 'package:dupe/core/utils/text_fold.dart';

/// French number words to an integer, 0 to 999 999: « douze », « vingt et
/// un », « soixante-dix-sept », « quatre-vingt-dix-neuf », « cent sept »,
/// « deux cents ». Null when a word is not a number word (ordinals and
/// fractions are not handled).
int? parseFrenchNumber(String words) {
  final tokens = foldForSearch(words)
      .split(RegExp(r'[\s-]+'))
      .where((t) => t.isNotEmpty && t != 'et')
      .toList();
  if (tokens.isEmpty) return null;
  var total = 0;
  var current = 0;
  String? previous;
  for (final token in tokens) {
    switch (token) {
      case 'vingt' || 'vingts':
        // « quatre-vingt » is 4 × 20.
        current += previous == 'quatre' ? 80 - 4 : 20;
      case 'cent' || 'cents':
        current = (current == 0 ? 1 : current) * 100;
      case 'mille':
        total += (current == 0 ? 1 : current) * 1000;
        current = 0;
      default:
        final value = _units[token];
        if (value == null) return null;
        current += value;
    }
    previous = token;
  }
  return total + current;
}

const _units = {
  'zero': 0, 'un': 1, 'une': 1, 'deux': 2, 'trois': 3, 'quatre': 4, //
  'cinq': 5, 'six': 6, 'sept': 7, 'huit': 8, 'neuf': 9, 'dix': 10,
  'onze': 11, 'douze': 12, 'treize': 13, 'quatorze': 14, 'quinze': 15,
  'seize': 16, 'trente': 30, 'quarante': 40, 'cinquante': 50,
  'soixante': 60,
};
