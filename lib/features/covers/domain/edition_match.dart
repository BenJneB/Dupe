import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// "Dune : le cycle" → "dune" ; "One Piece" → "one piece". The main title
/// only: subtitles differ between editions.
String mainTitle(String title) => normalizeTitle(title.split(' : ').first);

bool _sameAuthor(List<String> a, List<String> b) {
  final keys = {for (final n in a) authorKey(n)}..remove('');
  return b.map(authorKey).any(keys.contains);
}

/// [candidate] (text search result) is another edition of the book described
/// by [title], [authors] and, for a volume, [seriesTitle] + [volume]: same
/// main title (or series), same volume number, and a common author when both
/// sides name some. Used to propose its cover (phase 25).
bool sameWork(
  MetadataResult candidate, {
  required String title,
  List<String> authors = const [],
  String? seriesTitle,
  String? volume,
}) {
  final wanted = {
    mainTitle(title),
    ?seriesTitle == null ? null : mainTitle(seriesTitle),
  }..remove('');
  final theirs = {
    mainTitle(candidate.title),
    ?candidate.seriesTitle == null ? null : mainTitle(candidate.seriesTitle!),
  }..remove('');
  if (!wanted.any(theirs.contains)) return false;
  if (volume != null &&
      VolumeNumber.asInt(candidate.volumeNumber) !=
          VolumeNumber.asInt(volume)) {
    return false;
  }
  if (authors.isNotEmpty && candidate.authors.isNotEmpty) {
    return _sameAuthor(authors, candidate.authors);
  }
  return true;
}

/// Store mode: the scanned record [found] is a standalone book owned in
/// another edition — same main title **and** a common author (both
/// required: no false "already owned" for a namesake, decision 2026-11-16).
bool sameStandaloneBook(
  MetadataResult found, {
  required String title,
  required List<String> authors,
}) =>
    found.authors.isNotEmpty &&
    authors.isNotEmpty &&
    mainTitle(found.title) == mainTitle(title) &&
    _sameAuthor(authors, found.authors);
