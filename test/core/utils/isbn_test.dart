import 'package:dupe/core/utils/isbn.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalize strips separators and uppercases x', () {
    expect(Isbn.normalize(' 978-2-266 32048.1 '), '9782266320481');
    expect(Isbn.normalize('2-266-32048-x'), '226632048X');
  });

  test('validates ISBN-13 checksum and prefix', () {
    expect(Isbn.isValidIsbn13('978-2-266-32048-1'), isTrue);
    expect(Isbn.isValidIsbn13('9782266320482'), isFalse);
    // Valid EAN-13 but not a book (prefix 300).
    expect(Isbn.isValidIsbn13('3006016000000'), isFalse);
  });

  test('validates ISBN-10 including X check digit', () {
    expect(Isbn.isValidIsbn10('2266320483'), isTrue);
    expect(Isbn.isValidIsbn10('080442957X'), isTrue);
    expect(Isbn.isValidIsbn10('2266320484'), isFalse);
  });

  test('converts between ISBN-10 and ISBN-13', () {
    expect(Isbn.toIsbn13('2-266-32048-3'), '9782266320481');
    expect(Isbn.toIsbn13('080442957X'), '9780804429573');
    expect(Isbn.toIsbn13('9782266320481'), '9782266320481');
    expect(Isbn.toIsbn13('1234'), isNull);
  });

  test('classifies codes', () {
    expect(Isbn.classify('9782266320481'), CodeKind.isbn13);
    expect(Isbn.classify('2266320483'), CodeKind.isbn10);
    // UPC-A, and UPC-A + 5-digit add-on (US single issues).
    expect(Isbn.classify('761941200019'), CodeKind.upc);
    expect(Isbn.classify('76194120001900111'), CodeKind.upc);
    expect(Isbn.classify('3006016000000'), CodeKind.otherEan);
    expect(Isbn.classify('hello'), CodeKind.invalid);
  });
}
