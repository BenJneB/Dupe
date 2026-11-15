import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
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
  });

  final Series series;

  /// Cover of the first volume that has one (series without own cover).
  final String? firstVolumeCover;

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
}

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

enum CompletionFilter { all, complete, incomplete }
