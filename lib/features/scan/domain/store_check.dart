import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';

/// Colour of the store-mode banner (PLAN.md §3).
enum StoreVerdict {
  /// Green: already owned.
  owned,

  /// Yellow: in the wishlist.
  wished,

  /// Blue: not owned, but a series of the collection.
  seriesNotOwned,

  /// Grey: not in the collection.
  unknown,
}

/// Answer to "do I have this ISBN?" in store mode.
class StoreCheck {
  const new({
    required this.verdict,
    this.item,
    this.series,
    this.ownedNumbers = const [],
    this.metadata,
    this.searching = false,
    this.offline = false,
    this.isbnRemembered = false,
    this.otherEdition = false,
  });

  final StoreVerdict verdict;

  /// Owned or wished copy.
  final Item? item;

  /// Series of [item], or series the scanned volume belongs to.
  final Series? series;

  /// Owned volume numbers of [series] ("tu as 1 à 12").
  final List<int> ownedNumbers;

  /// Online metadata, when the ISBN is not in the collection.
  final MetadataResult? metadata;

  /// Not found locally, online lookup in progress.
  final bool searching;

  /// Not found locally and every source failed.
  final bool offline;

  /// The volume was matched by series + number and had no ISBN: the scanned
  /// ISBN was saved on it, so the next check is instant and offline.
  final bool isbnRemembered;

  /// The volume is owned, but the scanned ISBN is another edition
  /// ([metadata] describes it, to add this copy).
  final bool otherEdition;
}
