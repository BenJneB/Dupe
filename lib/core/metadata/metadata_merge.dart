import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/open_library/open_library_parser.dart';

/// Merges results for the same ISBN, field by field: the first non-empty
/// value in [ordered] (priority order) wins. Covers prefer any source with
/// an image, then fall back to Open Library's cover-by-ISBN URL.
MetadataResult? mergeResults(List<MetadataResult> ordered, String isbn13) {
  if (ordered.isEmpty) return null;
  T? pick<T>(T? Function(MetadataResult r) field) {
    for (final r in ordered) {
      final value = field(r);
      if (value == null) continue;
      if (value is String && value.trim().isEmpty) continue;
      if (value is List && value.isEmpty) continue;
      return value;
    }
    return null;
  }

  final base = ordered.first;
  final priced = ordered.where((r) => r.coverPrice != null).firstOrNull;
  return base.copyWith(
    subtitle: pick((r) => r.subtitle),
    authors: pick((r) => r.authors) ?? const [],
    publisher: pick((r) => r.publisher),
    publishDate: pick((r) => r.publishDate),
    pageCount: pick((r) => r.pageCount),
    language: pick((r) => r.language),
    isbn13: isbn13,
    coverUrl: pick((r) => r.coverUrl) ?? openLibraryCoverByIsbn(isbn13),
    description: pick((r) => r.description),
    seriesTitle: pick((r) => r.seriesTitle),
    volumeNumber: pick((r) => r.volumeNumber),
    // Price and currency must come from the same source.
    coverPrice: priced?.coverPrice,
    currency: priced?.currency,
  );
}
