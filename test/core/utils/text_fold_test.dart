import 'package:dupe/core/utils/text_fold.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('foldForSearch lowercases and strips French diacritics', () {
    expect(
      foldForSearch("L'Étoile Ç ŒUVRE à Noël"),
      "l'etoile c oeuvre a noel",
    );
    expect(foldForSearch('Shōnen'), 'shonen');
  });
}
