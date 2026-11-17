import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';

/// "T07", ". 31", "Tome 3", "01" -> the volume number; null otherwise.
int? catalogNumber(String? raw) {
  final m = RegExp(
    r'^\W*(?:t(?:ome)?\W*)?(\d+)\W*$',
    caseSensitive: false,
  ).firstMatch(raw ?? '');
  return m == null ? null : int.parse(m.group(1)!);
}

/// One volume of a series in a source catalog, with every record found for
/// it (reprints and new editions have their own ISBN).
class CatalogVolume {
  new(this.number, this.records);

  final int number;
  final List<MetadataResult> records;

  /// Default record: the lowest ISBN (usually the first printing).
  MetadataResult get preferred =>
      (records.toList()
            ..sort((a, b) => (a.isbn13 ?? '~').compareTo(b.isbn13 ?? '~')))
          .first;
}

/// The volumes of one publisher (an edition of the series).
class CatalogEdition {
  new(this.publisher, this.volumes);

  final String? publisher;

  /// By number.
  final List<CatalogVolume> volumes;
}

/// Groups the records of [seriesTitle] by publisher ("Pika édition" and
/// "Pika éditions" are one), then by volume number. Records of another title
/// ("Blue Lock épisode Nagi") or without number are left out. Biggest
/// edition first.
List<CatalogEdition> buildCatalog(
  String seriesTitle,
  Iterable<MetadataResult> records,
) {
  final wanted = normalizeTitle(seriesTitle);
  final groups = <({String? publisher, Map<int, List<MetadataResult>> byNo})>[];
  for (final r in records) {
    if (normalizeTitle(r.seriesTitle ?? r.title) != wanted) continue;
    final number = catalogNumber(r.volumeNumber);
    if (number == null) continue;
    final group =
        groups
            .where((g) => publishersMatch(g.publisher, r.publisher))
            .firstOrNull ??
        (() {
          final g = (
            publisher: r.publisher,
            byNo: <int, List<MetadataResult>>{},
          );
          groups.add(g);
          return g;
        })();
    final copies = group.byNo.putIfAbsent(number, () => []);
    if (!copies.any((c) => c.isbn13 != null && c.isbn13 == r.isbn13)) {
      copies.add(r);
    }
  }
  return [
    for (final g in groups)
      CatalogEdition(g.publisher, [
        for (final n in g.byNo.keys.toList()..sort())
          CatalogVolume(n, g.byNo[n]!),
      ]),
  ]..sort((a, b) => b.volumes.length.compareTo(a.volumes.length));
}
