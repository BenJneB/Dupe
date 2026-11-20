import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/series.dart';

/// One row of a collection tab: a series or a standalone item.
sealed class CollectionEntry {
  const new();

  String get title;
  DateTime get createdAt;
}

class SeriesEntry extends CollectionEntry {
  const new({
    required this.series,
    required this.ownedCount,
    required this.itemCount,
    this.unreadCount = 0,
    this.firstVolumeCover,
    this.highestVolume,
    this.missingIsbnCount = 0,
    this.signedCount = 0,
  });

  final Series series;

  /// Cover of the first volume that has one (series without own cover).
  final String? firstVolumeCover;

  /// Highest plain volume number among the items (owned or wished).
  final int? highestVolume;

  /// Owned volumes without ISBN (quality marker).
  final int missingIsbnCount;

  /// Signed volumes (phase 31).
  final int signedCount;

  /// Owned volumes (distinct numbers) not deleted.
  final int ownedCount;

  /// Owned volumes not read yet (unread or in progress).
  final int unreadCount;

  /// All items (owned + wished) not deleted.
  final int itemCount;

  @override
  String get title => series.title;

  @override
  DateTime get createdAt => series.createdAt;

  /// 0..1 when the total is known, otherwise null.
  double? get progress {
    final total = series.totalVolumes;
    if (total == null || total <= 0) return null;
    return (ownedCount / total).clamp(0, 1).toDouble();
  }

  bool get isComplete => progress != null && progress! >= 1;

  /// Only when the total is unknown (series created by a scan or an
  /// import): owned volumes over the highest known number. A hint, shown
  /// differently from [progress].
  double? get indicativeProgress {
    final highest = highestVolume;
    if (progress != null || highest == null || highest <= 0) return null;
    return (ownedCount / highest).clamp(0, 1).toDouble();
  }
}

/// Owned volumes among [entries]: series volumes (as counted in the list)
/// plus owned standalone books.
int ownedVolumes(Iterable<CollectionEntry> entries) => entries.fold(
  0,
  (sum, e) =>
      sum +
      switch (e) {
        SeriesEntry(:final ownedCount) => ownedCount,
        ItemEntry(:final item) => item.ownership == Ownership.possede ? 1 : 0,
      },
);

extension EntryReading on CollectionEntry {
  /// In "Ma pile à lire": owned and not read yet.
  bool get isToRead => switch (this) {
    SeriesEntry(:final unreadCount) => unreadCount > 0,
    ItemEntry(:final item) =>
      item.ownership == Ownership.possede &&
          toReadStatuses.contains(item.readingStatus),
  };
}

class ItemEntry extends CollectionEntry {
  const new(this.item);

  final Item item;

  @override
  String get title => item.title;

  @override
  DateTime get createdAt => item.createdAt;
}

enum CollectionSort { title, recent, progress }

enum CompletionFilter { all, complete, incomplete, signed }

extension EntryMissingIsbn on CollectionEntry {
  /// Owned books without ISBN in this row: a series' volumes, or the book.
  int get missingIsbnCount => switch (this) {
    SeriesEntry(:final missingIsbnCount) => missingIsbnCount,
    ItemEntry(:final item) => item.lacksIsbn ? 1 : 0,
  };

  /// Signed books in this row (phase 31).
  int get signedCount => switch (this) {
    SeriesEntry(:final signedCount) => signedCount,
    ItemEntry(:final item) => item.isSigned ? 1 : 0,
  };
}
