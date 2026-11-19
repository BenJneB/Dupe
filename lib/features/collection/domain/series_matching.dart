import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/utils/text_fold.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';

/// "L'Épée, de cristal !" -> "l epee de cristal". Parenthesized qualifiers
/// are ignored: "Batman (DC Renaissance)" matches the BnF series "Batman".
String normalizeTitle(String input) =>
    foldForSearch(input.replaceAll(RegExp(r'\([^)]*\)'), ' '))
        .replaceAll(RegExp('[^a-z0-9]+'), ' ')
        .trim();

/// Words that say nothing about the publisher ("Éditions Glénat").
const _publisherNoise = {'editions', 'edition', 'ed', 'les', 'le', 'la', 'l'};

/// Publisher names vary ("Glénat", "Glénat Manga", "Éditions Glénat",
/// "Panini France" / "Panini comics"): match when one contains the other or
/// when they start with the same significant word. Unknown publishers match.
bool publishersMatch(String? a, String? b) {
  if (a == null || b == null) return true;
  final na = normalizeTitle(a);
  final nb = normalizeTitle(b);
  if (na.isEmpty || nb.isEmpty) return true;
  if (na.contains(nb) || nb.contains(na)) return true;
  String? head(String s) =>
      s.split(' ').where((w) => !_publisherNoise.contains(w)).firstOrNull;
  final ha = head(na);
  return ha != null && ha.length >= 3 && ha == head(nb);
}

/// Series titles a result may belong to: its explicit series (BnF 461),
/// and, for a numbered volume, its own title ("One Piece", tome 112) and its
/// subtitle (BnF 200 $i "Jupiter's Legacy" for « Requiem (II), Finale »,
/// T. 04, a record without 461).
List<String> seriesTitleCandidates(MetadataResult m) => {
  ?m.seriesTitle,
  if (m.volumeNumber != null) ...[m.title, ?m.subtitle],
}.where((t) => t.trim().isNotEmpty).toList();

/// Existing series a scanned volume belongs to: same series title. Other
/// editions of a work go into the same series (recette 2026-11-19); from
/// another publisher, a common author is required too (another work with
/// the same title, "Spirou" elsewhere, is not that series). The publisher
/// and the type then break ties: same type and compatible publisher first,
/// then same type, then compatible publisher.
Series? findMatchingSeries(
  MetadataResult m,
  List<Series> series, {
  CollectionType? preferredType,
}) {
  final titles = seriesTitleCandidates(m).map(normalizeTitle).toSet();
  if (titles.isEmpty) return null;
  bool samePublisher(Series s) => publishersMatch(s.publisher, m.publisher);
  final matches = series
      .where(
        (s) =>
            titles.contains(normalizeTitle(s.title)) &&
            (samePublisher(s) || authorsCompatible(s.authors, m.authors)),
      )
      .toList();
  bool sameType(Series s) => s.type == preferredType;
  return matches.where((s) => sameType(s) && samePublisher(s)).firstOrNull ??
      matches.where(sameType).firstOrNull ??
      matches.where(samePublisher).firstOrNull ??
      matches.firstOrNull;
}
