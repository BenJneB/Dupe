import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';

/// Adds [s] to the wishlist: volume 1 of its series (an existing series of
/// the same title, else a new one, not followed) or the standalone book.
Future<Item> addSuggestionToWishes(
  CollectionRepository repo,
  Suggestion s,
) async {
  var item = repo.newItem(s.type);
  if (s.seriesTitle case final title?) {
    final existing = await repo.findSeries(s.type, title);
    final series =
        existing ??
        repo
            .newSeries(s.type)
            .copyWith(
              title: title,
              authors: s.authors,
              publisher: s.publisher,
              coverUrl: s.coverUrl,
              followed: false,
              externalIds: {'anilist_id': ?s.anilistId},
            );
    if (existing == null) await repo.saveSeries(series);
    item = repo.newItem(s.type, series: series, volumeNumber: '1');
  }
  item = item.copyWith(
    title: s.seriesTitle ?? s.title,
    authors: s.authors,
    publisher: s.publisher,
    isbn13: s.isbn13,
    coverUrl: s.coverUrl,
    ownership: Ownership.envie,
  );
  await repo.saveItem(item);
  return item;
}
