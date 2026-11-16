import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/core/utils/text_fold.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';

/// Lenient interpretation of CSV cells (French and English words).
abstract final class ImportValues {
  static String _f(String v) => foldForSearch(v).trim();

  static CollectionType? type(String? v) => switch (v == null ? '' : _f(v)) {
    'manga' || 'mangas' => CollectionType.manga,
    'bd' ||
    'bande dessinee' ||
    'bandes dessinees' ||
    'comic book' => CollectionType.bd,
    'comic' || 'comics' => CollectionType.comic,
    'livre' ||
    'livres' ||
    'book' ||
    'books' ||
    'roman' ||
    'novel' => CollectionType.livre,
    _ => null,
  };

  static Ownership? ownership(String? v) => switch (v == null ? '' : _f(v)) {
    'possede' ||
    'owned' ||
    'oui' ||
    'yes' ||
    'in collection' ||
    'collection' => Ownership.possede,
    'envie' ||
    'wishlist' ||
    'wish' ||
    'souhait' ||
    'a acheter' => Ownership.envie,
    _ => null,
  };

  static ReadingStatus? reading(String? v) => switch (v == null ? '' : _f(v)) {
    'lu' ||
    'read' ||
    'oui' ||
    'yes' ||
    'true' ||
    '1' ||
    'x' => ReadingStatus.lu,
    'en cours' || 'reading' || 'in progress' => ReadingStatus.enCours,
    'abandonne' || 'abandoned' || 'dropped' => ReadingStatus.abandonne,
    'non lu' ||
    'unread' ||
    'non' ||
    'no' ||
    'false' ||
    '0' => ReadingStatus.nonLu,
    _ => null,
  };

  /// "7,20 €", "7.20", "$4.99" -> 7.2.
  static double? price(String? v) => v == null
      ? null
      : Formatters.parseDecimal(v.replaceAll(RegExp(r'[^\d,.\-]'), ''));

  /// 2026-11-14, 14/11/2026, 14-11-2026, 14.11.2026 (day first).
  static DateTime? date(String? v) {
    final s = v?.trim() ?? '';
    final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(s);
    if (iso != null) {
      return _date(iso.group(1)!, iso.group(2)!, iso.group(3)!);
    }
    final dmy = RegExp(r'^(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{4})').firstMatch(s);
    return dmy == null
        ? null
        : _date(dmy.group(3)!, dmy.group(2)!, dmy.group(1)!);
  }

  static DateTime? _date(String y, String m, String d) {
    final month = int.parse(m);
    final day = int.parse(d);
    final date = DateTime(int.parse(y), month, day);
    // DateTime rolls over (31/02 -> 3 March): such a date is invalid.
    return date.month == month && date.day == day ? date : null;
  }

  /// "A, B", "A; B", "A / B", "A & B".
  static List<String> people(String? v) => v == null
      ? const []
      : [
          for (final p in v.split(RegExp(r'\s*[,;/&]\s*')))
            if (p.trim().isNotEmpty) p.trim(),
        ];
}
