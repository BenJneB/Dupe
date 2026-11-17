import 'package:drift/drift.dart';
import 'package:dupe/core/database/tables/synced_columns.dart';
import 'package:dupe/features/recommendations/domain/recommendation_feedback.dart';

/// Dismissed suggestions (v4 phase 30), synced.
@UseRowClass(RecommendationFeedback, generateInsertable: true)
class RecommendationFeedbackTable extends Table with SyncedColumns {
  @override
  String get tableName => 'recommendation_feedback';

  TextColumn get suggestionKey => text()();
  TextColumn get reasonKind => text()();
  TextColumn get reasonKey => text()();
}
