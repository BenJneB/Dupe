import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/collection_tab/entry_display.dart';
import 'package:dupe/features/collection/presentation/collection_tab/series_progress_bar.dart';
import 'package:dupe/features/collection/presentation/signed_mark.dart';
import 'package:dupe/features/quality/presentation/missing_isbn_mark.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class EntriesList extends StatelessWidget {
  const new({super.key, required this.type, required this.entries});

  final CollectionType type;
  final List<CollectionEntry> entries;

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: entries.length,
    itemBuilder: (context, index) =>
        EntryTile(type: type, entry: entries[index]),
  );
}

/// One series or standalone book of a list (tab, author page).
class EntryTile extends StatelessWidget {
  const new({required this.type, required this.entry, super.key});

  final CollectionType type;
  final CollectionEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entry = this.entry;
    return ListTile(
      leading: CoverImage(url: entryCover(entry), width: 40, height: 60),
      title: Text(entry.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entrySubtitle(l10n, entry)),
          if (SeriesProgressBar.shows(entry))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SeriesProgressBar(entry: entry),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SignedMark(count: entry.signedCount),
          MissingIsbnMark(count: entry.missingIsbnCount),
          if (entry is SeriesEntry && entry.isComplete)
            Icon(Icons.check_circle, color: Colors.green.shade600),
        ],
      ),
      onTap: () => context.push(entryRoute(type, entry)),
    );
  }
}
