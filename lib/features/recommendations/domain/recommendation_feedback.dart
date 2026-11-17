import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_feedback.freezed.dart';

/// "Pas intéressé" on a suggestion (PLAN_V4 phase 30), synced so that a
/// suggestion dismissed on one device is gone on the other.
@freezed
abstract class RecommendationFeedback with _$RecommendationFeedback {
  const factory({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// `Suggestion.key` of the dismissed suggestion.
    required String suggestionKey,

    /// Its reason (`SuggestionReason.kind` name and key): each dismissal
    /// lowers the weight of that reason.
    required String reasonKind,
    required String reasonKey,
    String? userId,
    DateTime? deletedAt,
    @Default(true) bool syncPending,
  }) = _RecommendationFeedback;
}
