import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Volumes after the last one known of a series (owned or wished), in the
/// edition of [publisher] (the biggest one when several match), at most
/// [limit]: a series left long ago does not flood the alerts.
List<CatalogVolume> nextVolumes(
  List<Item> items,
  List<CatalogEdition> editions, {
  String? publisher,
  int limit = 3,
}) {
  final last = items
      .where((i) => i.deletedAt == null)
      .map((i) => VolumeNumber.asInt(i.volumeNumber))
      .nonNulls
      .fold<int?>(null, (a, b) => a == null || b > a ? b : a);
  if (last == null) return const [];
  final edition = editions
      .where((e) => publishersMatch(publisher, e.publisher))
      .firstOrNull;
  if (edition == null) return const [];
  return edition.volumes.where((v) => v.number > last).take(limit).toList();
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
