import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/item/bought_action.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/wishlist/data/wishlist_repository.dart';
import 'package:dupe/features/wishlist/presentation/next_volumes_section.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Global wishlist (all types) by priority, then the next volumes to buy.
class WishlistScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wishes = ref.watch(wishesProvider).value ?? const [];
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreWishlist)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          _Header('${l10n.wishlistItems} (${wishes.length})', text),
          if (wishes.isEmpty)
            ListTile(title: Text(l10n.wishlistEmpty))
          else
            for (final item in wishes) _WishTile(item: item),
          _Header(l10n.nextVolumes, text),
          const NextVolumesSection(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const new(this.title, this.text);

  final String title;
  final TextTheme text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(title, style: text.titleMedium),
  );
}

class _WishTile extends ConsumerWidget {
  const new({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final priority = item.wishlistPriority;
    final maxPrice = item.wishlistMaxPrice;
    return ListTile(
      key: ValueKey('wish-${item.id}'),
      leading: CoverImage(url: item.coverUrl, width: 40, height: 60),
      title: Text(
        item.volumeNumber == null
            ? item.title
            : l10n.volumeTitle(item.title, item.volumeNumber!),
      ),
      subtitle: Text(
        [
          item.type.label(l10n),
          if (priority != null) l10n.priorityShort(priority),
          if (maxPrice != null)
            l10n.storeMaxPrice(
              Formatters.price(maxPrice, item.currency, l10n.localeName),
            ),
        ].join(' · '),
      ),
      trailing: IconButton(
        key: ValueKey('bought-${item.id}'),
        tooltip: l10n.markOwned,
        icon: const Icon(Icons.shopping_bag_outlined),
        onPressed: () => confirmBought(context, ref, item),
      ),
      onTap: () => context.push(AppRoutes.item(item.type, item.id)),
    );
  }
}
