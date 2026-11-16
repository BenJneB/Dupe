import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/collection_tab/entry_display.dart';
import 'package:dupe/features/collection/presentation/collection_tab/series_progress_bar.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class EntriesGrid extends StatelessWidget {
  const new({super.key, required this.type, required this.entries});

  final CollectionType type;
  final List<CollectionEntry> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.push(entryRoute(type, entry)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => CoverImage(
                    url: entryCover(entry),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                  ),
                ),
              ),
              if (SeriesProgressBar.shows(entry))
                SeriesProgressBar(entry: entry),
              const SizedBox(height: 4),
              Text(
                entry.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                entrySubtitle(l10n, entry),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
