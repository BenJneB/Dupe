/// Minimal RFC 4180 CSV: quoted fields, doubled quotes, line breaks inside
/// quotes. The separator is detected (`;` from French Excel, `,`, tab).
abstract final class Csv {
  static List<List<String>> parse(String input) {
    var text = input.startsWith('﻿') ? input.substring(1) : input;
    text = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final sep = _separator(text);
    final rows = <List<String>>[];
    var row = <String>[];
    final field = StringBuffer();
    var quoted = false;
    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (quoted) {
        if (c == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            quoted = false;
          }
        } else {
          field.write(c);
        }
      } else if (c == '"') {
        quoted = true;
      } else if (c == sep) {
        row.add(field.toString());
        field.clear();
      } else if (c == '\n') {
        row.add(field.toString());
        field.clear();
        rows.add(row);
        row = <String>[];
      } else {
        field.write(c);
      }
    }
    if (field.isNotEmpty || row.isNotEmpty) {
      row.add(field.toString());
      rows.add(row);
    }
    // Blank lines are kept (line numbers in reports) except at the end.
    while (rows.isNotEmpty && _blank(rows.last)) {
      rows.removeLast();
    }
    return rows;
  }

  /// Whether a parsed row has no content (skipped by the import).
  static bool isBlank(List<String> row) => _blank(row);

  static bool _blank(List<String> row) => row.every((f) => f.trim().isEmpty);

  /// Most frequent candidate in the first line (outside quotes).
  static String _separator(String text) {
    final end = text.indexOf('\n');
    final header = end < 0 ? text : text.substring(0, end);
    var best = ',';
    var bestCount = 0;
    for (final candidate in const [';', ',', '\t']) {
      final count = candidate.allMatches(header).length;
      if (count > bestCount) (best, bestCount) = (candidate, count);
    }
    return best;
  }

  /// Writes rows with `;` (opens directly in French Excel/LibreOffice) and a
  /// UTF-8 BOM so that accents are read correctly.
  static String write(List<List<Object?>> rows) {
    String cell(Object? v) {
      final s = v?.toString() ?? '';
      return s.contains(RegExp('[;"\n\r]'))
          ? '"${s.replaceAll('"', '""')}"'
          : s;
    }

    return '﻿${rows.map((r) => r.map(cell).join(';')).join('\r\n')}\r\n';
  }
}
