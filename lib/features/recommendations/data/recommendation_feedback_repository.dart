import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/tables/recommendation_feedback_table.drift.dart';
import 'package:dupe/features/recommendations/domain/recommendation_feedback.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendation_feedback_repository.g.dart';

/// "Pas intéressé" answers (synced table `recommendation_feedback`).
class RecommendationFeedbackRepository {
  new(this._db, {required this.now, required this.newId});

  final AppDatabase _db;
  final DateTime Function() now;
  final String Function() newId;

  Future<List<RecommendationFeedback>> list() => (_db.select(
    _db.recommendationFeedbackTable,
  )..where((t) => t.deletedAt.isNull())).get();

  Future<void> dismiss(Suggestion s) {
    final at = now();
    return _db
        .into(_db.recommendationFeedbackTable)
        .insert(
          RecommendationFeedback(
            id: newId(),
            createdAt: at,
            updatedAt: at,
            suggestionKey: s.key,
            reasonKind: s.reason.kind.name,
            reasonKey: s.reason.key,
          ).toInsertable(),
        );
  }
}

@Riverpod(keepAlive: true)
RecommendationFeedbackRepository recommendationFeedbackRepository(Ref ref) =>
    RecommendationFeedbackRepository(
      ref.watch(appDatabaseProvider),
      now: ref.watch(clockProvider),
      newId: ref.watch(idGeneratorProvider),
    );
