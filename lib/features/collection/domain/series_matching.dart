import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/utils/text_fold.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series.dart';

/// "L'Épée, de cristal !" -> "l epee de cristal". Parenthesized qualifiers
/// are ignored: "Batman (DC Renaissance)" matches the BnF series "Batman".
String normalizeTitle(String input) =>
    foldForSearch(input.replaceAll(RegExp(r'\([^)]*\)'), ' '))
        .replaceAll(RegExp('[^a-z0-9]+'), ' ')
        .trim();

/// Publisher names vary ("Glénat", "Glénat Manga", "Éditions Glénat"):
/// match when one contains the other. Unknown publishers match.
bool publishersMatch(String? a, String? b) {
  if (a == null || b == null) return true;
  final na = normalizeTitle(a);
  final nb = normalizeTitle(b);
  if (na.isEmpty || nb.isEmpty) return true;
  return na.contains(nb) || nb.contains(na);
}

/// Series titles a result may belong to: its explicit series (BnF 461),
/// and its own title when it is a numbered volume ("One Piece", tome 112).
List<String> seriesTitleCandidates(MetadataResult m) =>
    {?m.seriesTitle, if (m.volumeNumber != null) m.title}.toList();

/// Existing series a scanned volume belongs to: same series title and
/// compatible publisher. Series of [preferredType] win over other types.
Series? findMatchingSeries(
  MetadataResult m,
  List<Series> series, {
  CollectionType? preferredType,
}) {
  final titles = seriesTitleCandidates(m).map(normalizeTitle).toSet();
  if (titles.isEmpty) return null;
  final matches = series
      .where(
        (s) =>
            titles.contains(normalizeTitle(s.title)) &&
            publishersMatch(s.publisher, m.publisher),
      )
      .toList();
  return matches.where((s) => s.type == preferredType).firstOrNull ??
      matches.firstOrNull;
}
