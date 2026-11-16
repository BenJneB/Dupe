import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';

extension ItemChecks on Item {
  /// No ISBN (null, empty or blank).
  bool get hasNoIsbn => (isbn13 ?? '').trim().isEmpty;

  /// Owned book without ISBN (quality marker, phase 22). The list of series
  /// counts them in SQL with the same rule (`collection_entries_query.dart`).
  bool get lacksIsbn => ownership == Ownership.possede && hasNoIsbn;
}
