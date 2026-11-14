import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/confirm_delete_dialog.dart';
import 'package:dupe/features/collection/presentation/item/item_reading_bar.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/providers/detail_providers.dart';
import 'package:dupe/features/loans/presentation/item_loan_section.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Volume / issue / book sheet.
class ItemDetailScreen extends ConsumerWidget {
  const new({required this.itemId, super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(itemByIdProvider(itemId))) {
      AsyncData(value: final item?) => _ItemDetailView(item: item),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: PlaceholderBody(icon: Icons.search_off, title: l10n.notFound),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.loadError('$error'))),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _ItemDetailView extends ConsumerWidget {
  const new({required this.item});

  final Item item;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await confirmDelete(context, l10n.deleteItemMessage(item.title));
    if (!ok || !context.mounted) return;
    await ref.read(collectionRepositoryProvider).deleteItem(item.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = l10n.localeName;
    final seriesId = item.seriesId;
    final series = seriesId == null
        ? null
        : ref.watch(seriesByIdProvider(seriesId)).value;
    String? price(double? v) =>
        v == null ? null : Formatters.price(v, item.currency, locale);
    String? date(DateTime? v) => v == null ? null : Formatters.date(v, locale);

    final title = item.volumeNumber == null
        ? item.title
        : l10n.volumeTitle(item.title, item.volumeNumber!);

    final rows = <(String, String?)>[
      (
        l10n.fieldAuthors,
        item.authors.isEmpty ? null : item.authors.join(', '),
      ),
      (l10n.fieldPublisher, item.publisher),
      (l10n.fieldEdition, item.edition),
      (l10n.fieldFormat, item.format),
      (l10n.fieldPublishDate, item.publishDate),
      (l10n.fieldPageCount, item.pageCount?.toString()),
      (l10n.fieldLanguage, item.language),
      (l10n.fieldIsbn, item.isbn13),
      (l10n.fieldUpc, item.upc),
      (l10n.fieldReadingStatus, item.readingStatus.label(l10n)),
      (l10n.fieldReadDate, date(item.readDate)),
      (l10n.fieldRating, item.rating == null ? null : '${item.rating}/5'),
      (l10n.fieldFirstEdition, item.isFirstEdition ? l10n.yes : null),
      (l10n.fieldVariant, item.isVariant ? l10n.yes : null),
      (l10n.fieldCondition, item.condition),
      (l10n.fieldPurchasePrice, price(item.purchasePrice)),
      (l10n.fieldPurchaseDate, date(item.purchaseDate)),
      (l10n.fieldCoverPrice, price(item.coverPrice)),
      (l10n.fieldEstimatedValue, price(item.estimatedValue)),
      if (item.ownership == Ownership.envie) ...[
        (l10n.fieldWishlistPriority, item.wishlistPriority?.toString()),
        (l10n.fieldWishlistMaxPrice, price(item.wishlistMaxPrice)),
      ],
      (l10n.fieldLocation, item.location),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            key: const Key('addCopy'),
            tooltip: l10n.addCopy,
            icon: const Icon(Icons.library_add_outlined),
            onPressed: () => context.push(
              AppRoutes.newItem(
                item.type,
                seriesId: item.seriesId,
                volume: item.volumeNumber,
                copyOf: item.id,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.edit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                context.push(AppRoutes.itemEdit(item.type, item.id)),
          ),
          IconButton(
            tooltip: l10n.delete,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoverImage(url: item.coverUrl, width: 96, height: 144),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Chip(
                      avatar: Icon(
                        item.ownership == Ownership.possede
                            ? Icons.check_circle_outline
                            : Icons.favorite_border,
                        size: 18,
                      ),
                      label: Text(item.ownership.label(l10n)),
                    ),
                    if (item.ownership == Ownership.envie)
                      TextButton.icon(
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: Text(l10n.markOwned),
                        onPressed: () => ref
                            .read(collectionRepositoryProvider)
                            .saveItem(
                              item.copyWith(ownership: Ownership.possede),
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (series != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.collections_bookmark_outlined),
              title: Text(series.title),
              subtitle: Text(l10n.seeSeries),
              onTap: () =>
                  context.push(AppRoutes.series(series.type, series.id)),
            ),
          if (item.ownership == Ownership.possede) ...[
            const SizedBox(height: 8),
            ItemReadingBar(item: item),
            const SizedBox(height: 8),
            ItemLoanSection(item: item),
          ],
          const SizedBox(height: 8),
          for (final (label, value) in rows)
            if (value != null && value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(label, style: theme.textTheme.bodySmall),
                    ),
                    Expanded(child: Text(value)),
                  ],
                ),
              ),
          if (item.description case final description?) ...[
            const SizedBox(height: 16),
            Text(description),
          ],
          if (item.notes case final notes?) ...[
            const SizedBox(height: 16),
            Text(l10n.fieldNotes, style: theme.textTheme.titleSmall),
            Text(notes),
          ],
        ],
      ),
    );
  }
}
