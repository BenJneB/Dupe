import 'dart:math' as math;

import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// The edition of [publisher] among [editions] (the biggest one when
/// several match).
CatalogEdition? editionOf(List<CatalogEdition> editions, String? publisher) =>
    editions.where((e) => publishersMatch(publisher, e.publisher)).firstOrNull;

/// Volumes of [edition] after the last one known of a series (owned or
/// wished) and after [baseline] (the newest one at the first check), not
/// [alerted] yet, at most [limit]: a series left long ago does not flood
/// the alerts, and handled alerts do not hide the next volumes.
List<CatalogVolume> nextVolumes(
  List<Item> items,
  CatalogEdition? edition, {
  int baseline = 0,
  Set<int> alerted = const {},
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
      .where((v) => v.number > after && !alerted.contains(v.number))
      .take(limit)
      .toList();
}

/// Books of [author] in [records] that are new: an ISBN not [seen] at the
/// previous check and not in the collection ([owned]), one per ISBN.
List<MetadataResult> newBooks(
  List<MetadataResult> records, {
  required String author,
  required Set<String> seen,
  required Set<String> owned,
}) {
  final key = authorKey(author);
  final found = <String, MetadataResult>{};
  for (final r in records) {
    final isbn = r.isbn13;
    if (isbn == null || seen.contains(isbn) || owned.contains(isbn)) continue;
    if (!r.authors.map(authorKey).contains(key)) continue;
    found.putIfAbsent(isbn, () => r);
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
