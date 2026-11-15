import 'package:intl/intl.dart';

/// Locale-aware display helpers (French UI).
abstract final class Formatters {
  static String price(double value, String currency, String locale) =>
      NumberFormat.simpleCurrency(locale: locale, name: currency).format(value);

  static String date(DateTime value, String locale) =>
      DateFormat.yMMMd(locale).format(value);

  /// Parses "12,5" or "12.5"; null when empty or invalid.
  static double? parseDecimal(String input) {
    final value = input.trim().replaceAll(' ', '').replaceAll(',', '.');
    return value.isEmpty ? null : double.tryParse(value);
  }

  /// Comma-separated list ("A, B") to a clean list.
  static List<String> splitList(String input) => [
    for (final part in input.split(','))
      if (part.trim().isNotEmpty) part.trim(),
  ];

  /// "3, 8 à 12": runs of 4+ consecutive numbers are compressed.
  static String numberList(List<int> numbers, String rangeWord) {
    final parts = <String>[];
    var i = 0;
    while (i < numbers.length) {
      var j = i;
      while (j + 1 < numbers.length && numbers[j + 1] == numbers[j] + 1) {
        j++;
      }
      if (j - i >= 3) {
        parts.add('${numbers[i]} $rangeWord ${numbers[j]}');
      } else {
        parts.addAll([for (var k = i; k <= j; k++) '${numbers[k]}']);
      }
      i = j + 1;
    }
    return parts.join(', ');
  }
}
