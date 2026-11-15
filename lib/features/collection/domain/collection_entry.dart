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
  });

  final Series series;

  /// Owned items (any volume number) not deleted.
  final int ownedCount;

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
