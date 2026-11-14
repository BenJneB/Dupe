import 'package:freezed_annotation/freezed_annotation.dart';

part 'metadata_result.freezed.dart';

/// External metadata sources.
enum MetadataSource { bnf, googleBooks, openLibrary, comicVine }

/// Normalized metadata returned by any source.
@freezed
abstract class MetadataResult with _$MetadataResult {
  const factory({
    required MetadataSource source,
    required String sourceId,
    required String title,
    String? subtitle,
    @Default(<String>[]) List<String> authors,
    String? publisher,

    /// Free text: "2022", "2021-08-26"…
    String? publishDate,
    int? pageCount,

    /// ISO 639-1 code ("fr").
    String? language,
    String? isbn13,
    String? coverUrl,
    String? description,

    /// Series the volume belongs to, and its number ("1", "HS 2").
    String? seriesTitle,
    String? volumeNumber,
    double? coverPrice,
    String? currency,
  }) = _MetadataResult;
}
