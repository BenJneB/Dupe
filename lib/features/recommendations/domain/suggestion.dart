import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggestion.freezed.dart';
part 'suggestion.g.dart';

/// Why a work is suggested (PLAN_V4 phase 30): shown to the user, and the
/// unit whose weight a "Pas intéressé" lowers.
enum SuggestionKind {
  /// Another work of an author of the collection.
  sameAuthor,

  /// AniList readers who liked a manga of the collection also liked it.
  community,

  /// Sequel, prequel or side story of a manga of the collection (AniList).
  related,
}

@freezed
abstract class SuggestionReason with _$SuggestionReason {
  const factory({
    required SuggestionKind kind,

    /// Author key or AniList id of the owned series behind the reason.
    required String key,

    /// Author name or series title, as displayed.
    required String label,

    /// Owned books of that author or series ("12 albums de Larcenet").
    required int count,
  }) = _SuggestionReason;

  factory fromJson(Map<String, dynamic> json) =>
      _$SuggestionReasonFromJson(json);
}

/// A work the user does not have, with what is needed to add it to the
/// wishlist (as volume 1 of a series, or a standalone book).
@freezed
abstract class Suggestion with _$Suggestion {
  const factory({
    /// Stable identity: `anilist:<id>`, `series:<title>` or `book:<title>`.
    required String key,
    required CollectionType type,
    required String title,
    required SuggestionReason reason,

    /// Set for a series (the wish is its volume 1).
    String? seriesTitle,

    /// Other titles of the work (romaji, synonyms): owned under another
    /// name means owned.
    @Default(<String>[]) List<String> altTitles,
    @Default(<String>[]) List<String> authors,
    String? publisher,
    String? isbn13,
    String? coverUrl,
    String? siteUrl,

    /// AniList id, kept on the series created from the suggestion.
    String? anilistId,

    /// Community votes (AniList recommendation rating).
    @Default(0) int votes,
    @Default(0) double score,
  }) = _Suggestion;

  factory fromJson(Map<String, dynamic> json) => _$SuggestionFromJson(json);
}
