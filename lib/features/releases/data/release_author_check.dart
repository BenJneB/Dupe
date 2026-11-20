import 'dart:convert';

import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/covers/domain/edition_match.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:dupe/features/releases/domain/release_detection.dart';

/// What was seen of [author] at the previous check: ISBNs and works.
// Word order kept (authorNameKey): the key existed before authorKey sorted
// the words (recette 2026-11-19).
String seenKeyOf(String author) => 'releases_seen_${authorNameKey(author)}';

/// New books of the followed [authors] (BnF records), returns the number
/// of new alerts. First check of an author: only their recent books (this
/// year or last year) not owned, then the reference; later checks: books
/// of a work not seen before (a re-edition of an old book is not news).
Future<int> checkFollowedAuthors(
  List<FollowedAuthor> authors,
  List<Item> items, {
  required AppSettingsStore store,
  required ReleasesRepository alerts,
  required SuggestionSources sources,
  required DateTime now,
}) async {
  if (authors.isEmpty) return 0;
  final owned = {for (final i in items) ?i.isbn13};
  final ownedWorks = {
    for (final i in items) 'work:${mainTitle(i.title)}',
    for (final i in items)
      if (i.volumeTitle case final v?) 'work:${mainTitle(v)}',
  };
  var found = 0;
  for (final a in authors) {
    try {
      final records = await sources.booksByAuthor(a.name);
      // Builds of 2026-11-19 (commit 1362cca) used the sorted authorKey.
      final seenRaw =
          await store.get(seenKeyOf(a.name)) ??
          await store.get('releases_seen_${authorKey(a.name)}');
      // Nothing found (source off or failing): no reference yet.
      if (seenRaw == null && records.isEmpty) continue;
      final first = seenRaw == null;
      final seen = <String>{
        if (!first) ...(jsonDecode(seenRaw) as List<dynamic>).cast<String>(),
      };
      final fresh = newBooks(
        records,
        author: a.name,
        seen: seen,
        owned: owned,
        ownedWorks: ownedWorks,
      ).where((r) => !first || isRecentRelease(r, now)).toList();
      final type = fresh.isEmpty ? null : dominantType(items, a.name);
      for (final r in fresh) {
        final added = await alerts.addIfNew(
          releaseAlertOf(
            r,
            key: 'isbn:${r.isbn13}',
            kind: AlertKind.auteur,
            type: type!,
            title: r.seriesTitle ?? r.title,
            volumeNumber: r.volumeNumber,
            authorName: a.name,
          ),
        );
        if (added) found++;
      }
      await store.set(
        seenKeyOf(a.name),
        jsonEncode(
          {
            ...seen,
            for (final r in records) ...[?r.isbn13, workKey(r)],
          }.toList(),
        ),
      );
    } on Object catch (e) {
      appLog.warning('releases', e);
    }
  }
  return found;
}
