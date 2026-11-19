import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/global_search_bar.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/features/authors/presentation/authors_list.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/collection_tab/collection_toolbar.dart';
import 'package:dupe/features/collection/presentation/collection_tab/entries_grid.dart';
import 'package:dupe/features/collection/presentation/collection_tab/entries_list.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/providers/entries_providers.dart';
import 'package:dupe/features/collection/presentation/providers/view_settings_provider.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Series and standalone items of one collection type.
class CollectionTabScreen extends ConsumerWidget {
  const new({required this.type, super.key});

  final CollectionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(collectionViewSettingsProvider(type));
    final notifier = ref.read(collectionViewSettingsProvider(type).notifier);
    final entries = ref.watch(visibleEntriesProvider(type));
    final allEntries = ref.watch(collectionEntriesProvider(type));

    return Scaffold(
      key: ValueKey('collectionTab-${type.name}'),
      appBar: AppBar(
        title: const GlobalSearchBar(),
        actions: [
          PopupMenuButton<String>(
            key: const Key('addMenu'),
            icon: const Icon(Icons.add),
            tooltip: l10n.add,
            onSelected: (route) => context.push(route),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: AppRoutes.onlineSearch(type: type),
                child: Text(l10n.onlineSearchTitle),
              ),
              PopupMenuItem(
                key: const Key('addWholeSeries'),
                value: AppRoutes.seriesCompletion(type),
                child: Text(l10n.addWholeSeries),
              ),
              PopupMenuItem(
                value: AppRoutes.newSeries(type),
                child: Text(type.newSeriesLabel(l10n)),
              ),
              PopupMenuItem(
                value: AppRoutes.newItem(type),
                child: Text(type.newItemLabel(l10n)),
              ),
            ],
          ),
        ],
      ),
      body: switch (allEntries) {
        AsyncData(:final value) when value.isEmpty => PlaceholderBody(
          icon: Icons.collections_bookmark_outlined,
          title: l10n.emptyCollectionTitle,
          message: l10n.emptyCollectionBody,
        ),
        _ => Column(
          children: [
            CollectionToolbar(
              sort: settings.sort,
              filter: settings.filter,
              grid: settings.grid,
              onSort: notifier.setSort,
              onFilter: notifier.setFilter,
              onToggleGrid: notifier.toggleGrid,
              toReadOnly: settings.toReadOnly,
              onToggleToRead: notifier.toggleToRead,
              byAuthor: settings.byAuthor,
              onToggleByAuthor: notifier.toggleByAuthor,
            ),
            if (entries case AsyncData(:final value) when value.isNotEmpty)
              _TabSummary(value),
            Expanded(
              child: switch (entries) {
                AsyncData(:final value) when value.isEmpty => PlaceholderBody(
                  icon: Icons.filter_alt_off_outlined,
                  title: l10n.noFilterResults,
                ),
                AsyncData() when settings.byAuthor => AuthorsList(type: type),
                AsyncData(:final value) =>
                  settings.grid
                      ? EntriesGrid(type: type, entries: value)
                      : EntriesList(type: type, entries: value),
                AsyncError(:final error) => Center(
                  child: Text(l10n.loadError(errorText(l10n, error))),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      },
    );
  }
}

/// Totals of the visible entries (they follow the filters).
class _TabSummary extends StatelessWidget {
  const new(this.entries);

  final List<CollectionEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final series = entries.whereType<SeriesEntry>().length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          l10n.authorSummary(
            series,
            entries.length - series,
            ownedVolumes(entries),
          ),
          key: const Key('tabSummary'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
