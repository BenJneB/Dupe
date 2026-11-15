import 'package:dupe/features/collection/domain/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'series_metadata.freezed.dart';

/// Sources describing whole series (not editions).
enum SeriesSource { anilist, comicVine }

/// Normalized series information (AniList for manga, Comic Vine for comics).
/// AniList describes the original work, not the French edition: volume
/// counts are the Japanese ones.
@freezed
abstract class SeriesMetadata with _$SeriesMetadata {
  const factory({
    required SeriesSource source,
    required String sourceId,
    required String title,
    String? originalTitle,
    @Default(<String>[]) List<String> authors,
    String? publisher,
    int? totalVolumes,
    @Default(PublicationStatus.inconnue) PublicationStatus status,
    int? startYear,
    String? coverUrl,
    String? description,
    String? siteUrl,
  }) = _SeriesMetadata;
}

/// A source of series information.
abstract interface class SeriesMetadataProvider {
  SeriesSource get seriesSource;

  Future<List<SeriesMetadata>> searchSeries(String query);
}

/// A series source failed (network, HTTP error, invalid key…).
class SeriesLookupException implements Exception {
  const new(this.source, this.message);

  final SeriesSource source;
  final String message;

  @override
  String toString() => 'SeriesLookupException(${source.name}): $message';
}

/// Strips HTML tags and entities from API descriptions.
String? plainText(String? html) {
  if (html == null) return null;
  final text = html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp('<[^>]+>'), '')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&nbsp;', ' ')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
  return text.isEmpty ? null : text;
}
