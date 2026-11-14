import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/item/bought_action.dart';
import 'package:dupe/features/scan/data/store_checker.dart';
import 'package:dupe/features/scan/domain/store_check.dart';
import 'package:dupe/features/scan/presentation/store/store_banner_lines.dart';
import 'package:dupe/features/scan/presentation/store/store_style.dart';
import 'package:dupe/features/search/presentation/online_search/add_from_result.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Store mode: big coloured verdict for a scanned ISBN (PLAN.md §3).
class StoreResultBanner extends ConsumerWidget {
  const new({required this.isbn13, required this.type, super.key});

  final String isbn13;
  final CollectionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final check = switch (ref.watch(storeCheckProvider(isbn13, type))) {
      AsyncData(:final value) => value,
      // Online lookup failure: the local check already answered "unknown".
      AsyncError() => const StoreCheck(
        verdict: StoreVerdict.unknown,
        offline: true,
      ),
      _ => null,
    };
    if (check == null) return const SizedBox(height: 120);
    final style = storeStyle(
      check.verdict,
      Theme.of(context).colorScheme,
      l10n,
    );
    final text = Theme.of(context).textTheme;
    final fg = style.foreground;
    final headline = storeHeadline(check, l10n);

    return Card(
      key: Key('store_${check.verdict.name}'),
      color: style.background,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(style.icon, color: fg, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    style.title,
                    style: text.headlineSmall?.copyWith(color: fg),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (headline != null)
              Text(headline, style: text.titleMedium?.copyWith(color: fg)),
            for (final line in storeDetails(check, l10n))
              Text(line, style: TextStyle(color: fg)),
            Text('ISBN $isbn13', style: text.bodySmall?.copyWith(color: fg)),
            if (check.searching) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.storeSearching, style: TextStyle(color: fg)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            _Actions(
              check: check,
              isbn13: isbn13,
              type: type,
              color: fg,
              background: style.background,
            ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const new({
    required this.check,
    required this.isbn13,
    required this.type,
    required this.color,
    required this.background,
  });

  final StoreCheck check;
  final String isbn13;
  final CollectionType type;
  final Color color;

  /// Banner colour: text of the filled buttons (readable in both themes).
  final Color background;

  Future<void> _bought(BuildContext context, WidgetRef ref, Item item) async {
    if (await confirmBought(context, ref, item)) {
      // Re-check: the banner turns green.
      ref.invalidate(storeCheckProvider(isbn13, type));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final item = check.item;
    final metadata = check.metadata;
    final targetType = check.series?.type ?? type;
    final outlined = OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color),
    );
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (item != null) ...[
          if (item.ownership == Ownership.envie)
            FilledButton.icon(
              key: const Key('storeBought'),
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: background,
              ),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: Text(l10n.markOwned),
              onPressed: () => _bought(context, ref, item),
            ),
          OutlinedButton(
            key: const Key('storeDetails'),
            style: outlined,
            onPressed: () => context.go(AppRoutes.item(item.type, item.id)),
            child: Text(l10n.storeDetails),
          ),
          if (check.otherEdition && metadata != null)
            OutlinedButton.icon(
              key: const Key('addThisCopy'),
              style: outlined,
              icon: const Icon(Icons.library_add_outlined),
              label: Text(l10n.addThisCopy),
              onPressed: () => addFromResult(context, metadata, item.type),
            ),
        ] else if (metadata != null) ...[
          FilledButton.icon(
            key: const Key('addOwned'),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: background,
            ),
            icon: const Icon(Icons.add),
            label: Text(l10n.addToCollection),
            onPressed: () => addFromResult(context, metadata, targetType),
          ),
          OutlinedButton.icon(
            key: const Key('addWished'),
            style: outlined,
            icon: const Icon(Icons.favorite_border),
            label: Text(l10n.addToWishlist),
            onPressed: () => addFromResult(
              context,
              metadata,
              targetType,
              ownership: Ownership.envie,
            ),
          ),
        ] else if (!check.searching)
          OutlinedButton.icon(
            key: const Key('storeOnlineSearch'),
            style: outlined,
            icon: const Icon(Icons.travel_explore),
            label: Text(l10n.onlineSearchTitle),
            onPressed: () =>
                context.push(AppRoutes.onlineSearch(query: isbn13, type: type)),
          ),
      ],
    );
  }
}
