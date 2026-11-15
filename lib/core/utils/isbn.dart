/// Kind of code read from a barcode or typed by the user.
enum CodeKind { isbn13, isbn10, upc, otherEan, invalid }

/// ISBN / UPC helpers: normalization, validation, conversion.
abstract final class Isbn {
  /// Removes spaces, dashes and dots; uppercases the ISBN-10 "X" check digit.
  static String normalize(String raw) =>
      raw.replaceAll(RegExp(r'[\s\-.]'), '').toUpperCase();

  static bool isValidIsbn10(String raw) {
    final s = normalize(raw);
    if (!RegExp(r'^\d{9}[\dX]$').hasMatch(s)) return false;
    var sum = 0;
    for (var i = 0; i < 10; i++) {
      final digit = s[i] == 'X' ? 10 : int.parse(s[i]);
      sum += digit * (10 - i);
    }
    return sum % 11 == 0;
  }

  /// Valid EAN-13 starting with 978 or 979.
  static bool isValidIsbn13(String raw) {
    final s = normalize(raw);
    return RegExp(r'^97[89]\d{10}$').hasMatch(s) && _validEan(s);
  }

  /// ISBN-13 from an ISBN-10 or ISBN-13; null when invalid.
  static String? toIsbn13(String raw) {
    final s = normalize(raw);
    if (isValidIsbn13(s)) return s;
    if (!isValidIsbn10(s)) return null;
    final body = '978${s.substring(0, 9)}';
    return '$body${_eanCheckDigit(body)}';
  }

  /// ISBN-10 from a 978 ISBN-13 (979 ones have no ISBN-10); null otherwise.
  static String? toIsbn10(String raw) {
    final s = normalize(raw);
    if (!isValidIsbn13(s) || !s.startsWith('978')) return null;
    final body = s.substring(3, 12);
    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(body[i]) * (10 - i);
    }
    final check = (11 - sum % 11) % 11;
    return '$body${check == 10 ? 'X' : check}';
  }

  /// Classifies a scanned/typed code. UPC-A (12 digits) and UPC-A + 5-digit
  /// add-on (17 digits, US comics single issues) are [CodeKind.upc].
  static CodeKind classify(String raw) {
    final s = normalize(raw);
    if (isValidIsbn13(s)) return CodeKind.isbn13;
    if (isValidIsbn10(s)) return CodeKind.isbn10;
    if (RegExp(r'^\d{12}(\d{5})?$').hasMatch(s) &&
        _validEan('0${s.substring(0, 12)}')) {
      return CodeKind.upc;
    }
    if (RegExp(r'^\d{13}$').hasMatch(s) && _validEan(s)) {
      return CodeKind.otherEan;
    }
    return CodeKind.invalid;
  }

  static bool _validEan(String s13) =>
      _eanCheckDigit(s13.substring(0, 12)) == int.parse(s13[12]);

  static int _eanCheckDigit(String first12) {
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      sum += int.parse(first12[i]) * (i.isEven ? 1 : 3);
    }
    return (10 - sum % 10) % 10;
  }
}
