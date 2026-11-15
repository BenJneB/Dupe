final _leadingNumber = RegExp(r'^\d+(?:[.,]\d+)?');
final _anyNumber = RegExp(r'\d+(?:[.,]\d+)?');

/// Helpers for free-text volume numbers ("12", "1.5", "HS 2", "Annual 1").
abstract final class VolumeNumber {
  /// Integer value when the volume number is a plain integer ("07" -> 7).
  static int? asInt(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    return RegExp(r'^\d+$').hasMatch(value) ? int.parse(value) : null;
  }

  /// Natural order: plain/decimal numbers first by value, then special
  /// volumes ("HS 2", "Annual 1") by prefix and number, then empty ones.
  static int compare(String? a, String? b) {
    final ka = _key(a);
    final kb = _key(b);
    final byGroup = ka.group.compareTo(kb.group);
    if (byGroup != 0) return byGroup;
    final byPrefix = ka.prefix.compareTo(kb.prefix);
    if (byPrefix != 0) return byPrefix;
    return ka.number.compareTo(kb.number);
  }

  static ({int group, String prefix, double number}) _key(String? raw) {
    final value = raw?.trim().toLowerCase() ?? '';
    if (value.isEmpty) return (group: 2, prefix: '', number: 0);
    final leading = _leadingNumber.firstMatch(value);
    if (leading != null && leading.end == value.length) {
      return (group: 0, prefix: '', number: _parse(leading.group(0)!));
    }
    final any = _anyNumber.firstMatch(value);
    return (
      group: 1,
      prefix: any == null ? value : value.substring(0, any.start).trim(),
      number: any == null ? 0 : _parse(any.group(0)!),
    );
  }

  static double _parse(String s) => double.parse(s.replaceAll(',', '.'));
}
