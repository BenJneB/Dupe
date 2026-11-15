import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';

/// Wishes kept in a shared list: chosen types, and priorities up to
/// [maxPriority] (null = every wish, with or without a priority).
class WishFilter {
  const new({this.types = const {}, this.maxPriority});

  /// Empty = every type.
  final Set<CollectionType> types;
  final int? maxPriority;

  bool accepts(Item item) {
    if (types.isNotEmpty && !types.contains(item.type)) return false;
    final max = maxPriority;
    if (max == null) return true;
    final priority = item.wishlistPriority;
    return priority != null && priority <= max;
  }

  /// [wishes] kept, in their order.
  List<Item> apply(List<Item> wishes) => wishes.where(accepts).toList();
}
