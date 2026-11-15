import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';

extension PurchaseActions on CollectionRepository {
  /// "Je l'ai acheté": a wish becomes owned, bought [today] for [price]
  /// (optional). The wishlist priority no longer applies.
  Future<Item> markBought(
    Item item, {
    required DateTime today,
    double? price,
  }) async {
    final bought = item.copyWith(
      ownership: Ownership.possede,
      purchasePrice: price ?? item.purchasePrice,
      purchaseDate: DateTime(today.year, today.month, today.day),
      wishlistPriority: null,
    );
    await saveItem(bought);
    return bought;
  }
}
