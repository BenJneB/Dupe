import 'package:dupe/app/theme.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The shared wishlist picture: a grid of covers with their titles. Always
/// light, whatever the app theme: it is seen in other apps.
class WishlistImage extends StatelessWidget {
  const new({
    required this.wishes,
    required this.covers,
    required this.showPrice,
    required this.date,
    super.key,
  });

  /// Logical width; the picture is captured at a higher pixel ratio.
  static const width = 400.0;
  static const _columns = 3;
  static const _gap = 12.0;
  static const _padding = 16.0;

  final List<Item> wishes;

  /// Loaded covers by item id; a missing one shows a plain vignette.
  final Map<String, ImageProvider> covers;
  final bool showPrice;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = AppTheme.light();
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    const cell = (width - 2 * _padding - (_columns - 1) * _gap) / _columns;
    return Theme(
      data: theme,
      child: Container(
        width: width,
        color: scheme.surface,
        padding: const EdgeInsets.all(_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.moreWishlist,
              style: text.titleLarge?.copyWith(color: scheme.onSurface),
            ),
            Text(
              l10n.shareWishlistCaption(
                wishes.length,
                Formatters.date(date, l10n.localeName),
              ),
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: _gap),
            Wrap(
              spacing: _gap,
              runSpacing: _gap,
              children: [
                for (final w in wishes)
                  SizedBox(
                    width: cell,
                    child: _Wish(
                      item: w,
                      cover: covers[w.id],
                      showPrice: showPrice,
                      cell: cell,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Wish extends StatelessWidget {
  const new({
    required this.item,
    required this.cover,
    required this.showPrice,
    required this.cell,
  });

  final Item item;
  final ImageProvider? cover;
  final bool showPrice;
  final double cell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final small = theme.textTheme.bodySmall;
    final price = item.wishlistMaxPrice;
    final image = cover;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            width: cell,
            height: cell * 1.5,
            child: image == null
                ? ColoredBox(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.menu_book_outlined,
                      color: scheme.outline,
                      size: cell / 3,
                    ),
                  )
                : Image(image: image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.displayTitle(l10n),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: small?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (showPrice && price != null)
          Text(
            l10n.storeMaxPrice(
              Formatters.price(price, item.currency, l10n.localeName),
            ),
            style: small?.copyWith(color: scheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
