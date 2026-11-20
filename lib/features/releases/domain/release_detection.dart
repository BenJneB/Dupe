import 'dart:math' as math;

import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';
import 'package:dupe/features/covers/domain/edition_match.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';

/// The edition of [publisher] among [editions] (the biggest one when
/// several match).
CatalogEdition? editionOf(List<CatalogEdition> editions, String? publisher) =>
    editions.where((e) => publishersMatch(publisher, e.publisher)).firstOrNull;

/// Published this year or last year (records only give the year): what a
/// first check shows, instead of nothing until a newer volume appears.
bool isRecentRelease(MetadataResult r, DateTime now) =>
    (int.tryParse(r.publishDate ?? '') ?? 0) >= now.year - 1;

/// Volumes of [edition] after the last one known of a series (owned or
/// wished) and after [baseline] (the newest one at the previous check), not
/// [alerted] yet, kept by [where], at most [limit]: a series left long ago
/// does not flood the alerts, and handled alerts do not hide the next ones.
List<CatalogVolume> nextVolumes(
  List<Item> items,
  CatalogEdition? edition, {
  int baseline = 0,
  Set<int> alerted = const {},
  bool Function(CatalogVolume v)? where,
  int limit = 3,
}) {
  final last = items
      .where((i) => i.deletedAt == null)
      .map((i) => VolumeNumber.asInt(i.volumeNumber))
      .nonNulls
      .fold<int?>(null, (a, b) => a == null || b > a ? b : a);
  if (last == null || edition == null) return const [];
  final after = math.max(last, baseline);
  return edition.volumes
      .where(
        (v) =>
            v.number > after &&
            !alerted.contains(v.number) &&
            (where?.call(v) ?? true),
      )
      .take(limit)
      .toList();
}

/// The work a record belongs to (its series, else its main title), as kept
/// in the "seen" list of an author: a re-edition (pocket, book club,
/// omnibus) has a new ISBN but the same work.
String workKey(MetadataResult r) =>
    'work:${mainTitle(r.seriesTitle ?? r.title)}';

/// Books of [author] in [records] that are new: an ISBN not [seen] at the
/// previous check, of a work neither [seen] nor in the collection
/// ([owned] ISBNs, [ownedWorks] keys), one per work.
List<MetadataResult> newBooks(
  List<MetadataResult> records, {
  required String author,
  required Set<String> seen,
  required Set<String> owned,
  Set<String> ownedWorks = const {},
}) {
  final key = authorKey(author);
  final found = <String, MetadataResult>{};
  for (final r in records) {
    final isbn = r.isbn13;
    if (isbn == null || seen.contains(isbn) || owned.contains(isbn)) continue;
    if (!r.authors.map(authorKey).contains(key)) continue;
    final work = workKey(r);
    if (seen.contains(work) || ownedWorks.contains(work)) continue;
    found.putIfAbsent(work, () => r);
  }
  return found.values.toList();
}

/// The tab of most of [author]'s books in [items] (books when none).
CollectionType dominantType(List<Item> items, String author) {
  final key = authorKey(author);
  final counts = <CollectionType, int>{};
  for (final i in items) {
    if (i.authors.map(authorKey).contains(key)) {
      counts[i.type] = (counts[i.type] ?? 0) + 1;
    }
  }
  var (best, max) = (CollectionType.livre, 0);
  for (final t in CollectionType.values) {
    if ((counts[t] ?? 0) > max) (best, max) = (t, counts[t]!);
  }
  return best;
}

/// An alert for [r]; id and dates are set by `ReleasesRepository.addIfNew`.
ReleaseAlert releaseAlertOf(
  MetadataResult r, {
  required String key,
  required AlertKind kind,
  required CollectionType type,
  required String title,
  String? seriesId,
  String? volumeNumber,
  String? authorName,
}) => ReleaseAlert(
  id: '',
  createdAt: DateTime(0),
  updatedAt: DateTime(0),
  key: key,
  kind: kind,
  type: type,
  title: title,
  seriesId: seriesId,
  volumeNumber: volumeNumber,
  authorName: authorName,
  authors: r.authors,
  isbn13: r.isbn13,
  publisher: r.publisher,
  publishDate: r.publishDate,
  coverUrl: r.coverUrl,
);
