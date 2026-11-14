import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/search/presentation/online_search/add_from_result.dart';
import 'package:dupe/features/search/presentation/online_search/online_search_providers.dart';
import 'package:dupe/features/search/presentation/online_search/result_summary.dart';
import 'package:dupe/features/search/presentation/online_search/source_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Merged result of an ISBN lookup, with add actions.
class IsbnResultView extends ConsumerWidget {
  const new({required this.isbn13, required this.type, super.key});

  final String isbn13;
  final CollectionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final local = ref.watch(localItemByIsbnProvider(isbn13)).value;
    final lookup = ref.watch(isbnLookupProvider(isbn13, type));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      children: [
        if (local != null)
          Card(
            key: const Key('alreadyOwned'),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ListTile(
              leading: Icon(
                local.ownership == Ownership.possede
                    ? Icons.check_circle
                    : Icons.favorite,
              ),
              title: Text(
                local.ownership == Ownership.possede
                    ? l10n.alreadyOwned
                    : l10n.alreadyWished,
              ),
              subtitle: Text(local.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(AppRoutes.item(local.type, local.id)),
            ),
          ),
        switch (lookup) {
          AsyncData(:final value) => _LookupBody(
            lookup: value,
            type: type,
            isbn13: isbn13,
          ),
          AsyncError(:final error) => Text(l10n.loadError('$error')),
          _ => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ],
    );
  }
}

class _LookupBody extends StatelessWidget {
  const new({required this.lookup, required this.type, required this.isbn13});

  final IsbnLookup lookup;
  final CollectionType type;
  final String isbn13;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final merged = lookup.merged;
    final failedNote = lookup.failed.isEmpty
        ? null
        : l10n.sourcesUnavailable(lookup.failed.map((s) => s.label).join(', '));

    if (merged == null) {
      return PlaceholderBody(
        icon: Icons.search_off,
        title: l10n.isbnNotFound(isbn13),
        message: [l10n.isbnNotFoundHint, ?failedNote].join('\n'),
      );
    }
    final price = merged.coverPrice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverImage(url: merged.coverUrl, width: 110, height: 165),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resultTitle(l10n, merged),
                    key: const Key('isbnResultTitle'),
                    style: theme.textTheme.titleLarge,
                  ),
                  if (merged.subtitle case final subtitle?) Text(subtitle),
                  const SizedBox(height: 4),
                  Text(resultSubtitle(merged, withSource: false)),
                  Text('ISBN $isbn13', style: theme.textTheme.bodySmall),
                  if (price != null)
                    Text(
                      Formatters.price(
                        price,
                        merged.currency ?? 'EUR',
                        l10n.localeName,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              key: const Key('addOwned'),
              icon: const Icon(Icons.add),
              label: Text(l10n.addToCollection),
              onPressed: () => addFromResult(context, merged, type),
            ),
            OutlinedButton.icon(
              key: const Key('addWished'),
              icon: const Icon(Icons.favorite_border),
              label: Text(l10n.addToWishlist),
              onPressed: () => addFromResult(
                context,
                merged,
                type,
                ownership: Ownership.envie,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.sourcesUsed(
            lookup.results.map((r) => r.source.label).join(', '),
          ),
          style: theme.textTheme.bodySmall,
        ),
        if (failedNote != null)
          Text(failedNote, style: theme.textTheme.bodySmall),
        if (merged.description case final description?) ...[
          const SizedBox(height: 16),
          Text(description),
        ],
      ],
    );
  }
}
