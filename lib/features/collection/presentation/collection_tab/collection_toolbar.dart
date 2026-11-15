import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Sort, completion filters and list/grid toggle of a tab.
class CollectionToolbar extends StatelessWidget {
  const new({
    super.key,
    required this.sort,
    required this.filter,
    required this.grid,
    required this.toReadOnly,
    required this.onSort,
    required this.onFilter,
    required this.onToggleGrid,
    required this.onToggleToRead,
    required this.byAuthor,
    required this.onToggleByAuthor,
  });

  final CollectionSort sort;
  final CompletionFilter filter;
  final bool grid;
  final ValueChanged<CollectionSort> onSort;
  final ValueChanged<CompletionFilter> onFilter;
  final VoidCallback onToggleGrid;
  final bool toReadOnly;
  final VoidCallback onToggleToRead;
  final bool byAuthor;
  final VoidCallback onToggleByAuthor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          if (!byAuthor) ...[
            PopupMenuButton<CollectionSort>(
              tooltip: l10n.sortBy,
              initialValue: sort,
              onSelected: onSort,
              itemBuilder: (context) => [
                for (final s in CollectionSort.values)
                  PopupMenuItem(value: s, child: Text(s.label(l10n))),
              ],
              child: Chip(
                avatar: const Icon(Icons.sort, size: 18),
                label: Text(sort.label(l10n)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          FilterChip(
            key: const Key('toReadFilter'),
            avatar: const Icon(Icons.auto_stories_outlined, size: 18),
            label: Text(l10n.filterToRead),
            selected: toReadOnly,
            onSelected: (_) => onToggleToRead(),
          ),
          const SizedBox(width: 8),
          FilterChip(
            key: const Key('byAuthorToggle'),
            avatar: const Icon(Icons.person_outline, size: 18),
            label: Text(l10n.byAuthor),
            selected: byAuthor,
            onSelected: (_) => onToggleByAuthor(),
          ),
          const SizedBox(width: 8),
          for (final f in CompletionFilter.values) ...[
            ChoiceChip(
              label: Text(f.label(l10n)),
              selected: filter == f,
              onSelected: (_) => onFilter(f),
            ),
            const SizedBox(width: 8),
          ],
          if (!byAuthor)
            IconButton(
              tooltip: grid ? l10n.viewList : l10n.viewGrid,
              icon: Icon(grid ? Icons.view_list : Icons.grid_view),
              onPressed: onToggleGrid,
            ),
        ],
      ),
    );
  }
}
