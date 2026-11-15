import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';

/// Title of a wish: "One Piece — tome 107", or the book title.
String wishTitle(AppLocalizations l10n, Item item) => item.volumeNumber == null
    ? item.title
    : l10n.volumeTitle(item.title, item.volumeNumber!);

/// Text version of the shared wishlist, grouped by type in the app order.
String wishlistText(
  AppLocalizations l10n,
  List<Item> wishes, {
  required bool showPrice,
}) {
  final lines = [l10n.shareWishlistHeading(wishes.length)];
  for (final type in CollectionType.values) {
    final ofType = wishes.where((w) => w.type == type).toList();
    if (ofType.isEmpty) continue;
    lines
      ..add('')
      ..add(type.label(l10n));
    for (final w in ofType) {
      final price = w.wishlistMaxPrice;
      final max = showPrice && price != null
          ? Formatters.price(price, w.currency, l10n.localeName)
          : null;
      final suffix = max == null ? '' : ' (${l10n.storeMaxPrice(max)})';
      lines.add('• ${wishTitle(l10n, w)}$suffix');
    }
  }
  return lines.join('\n');
}
