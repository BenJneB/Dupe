import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/recommendations/domain/recommendation_feedback.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';
import 'package:dupe/features/recommendations/domain/suggestion_ranking.dart';
import 'package:dupe/features/recommendations/domain/taste_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/collection_builders.dart';

final _at = DateTime.utc(2026, 11, 16);

Suggestion suggestion(
  String title, {
  SuggestionKind kind = SuggestionKind.sameAuthor,
  String reason = 'larcenet',
  double score = 1,
  int votes = 0,
  List<String> alt = const [],
}) => Suggestion(
  key: 'work:$title',
  type: CollectionType.bd,
  title: title,
  altTitles: alt,
  votes: votes,
  score: score,
  reason: SuggestionReason(kind: kind, key: reason, label: reason, count: 1),
);

RecommendationFeedback dismissed(String key, String reason) =>
    RecommendationFeedback(
      id: key,
      createdAt: _at,
      updatedAt: _at,
      suggestionKey: key,
      reasonKind: SuggestionKind.sameAuthor.name,
      reasonKey: reason,
    );

void main() {
  group('profile', () {
    test('a read, well rated book weighs more; a wish little', () {
      expect(bookWeight(item('a')), 1);
      expect(bookWeight(item('a', reading: ReadingStatus.lu, rating: 5)), 3);
      expect(bookWeight(item('a', rating: 0)), 0);
      expect(bookWeight(item('a', ownership: Ownership.envie)), 0.3);
    });

    test('authors merged whatever the spelling, heaviest first', () {
      final p = TasteProfile.of([
        item('Blast 1', authors: ['Larcenet, Manu']),
        item('Le combat ordinaire', authors: ['Manu Larcenet']),
        item('Dune', authors: ['Frank Herbert'], type: CollectionType.livre),
        // Wished only: not an author of the collection.
        item('X', authors: ['Nobody'], ownership: Ownership.envie),
      ], const []);
      expect(p.authors.map((a) => (a.name, a.count)), [
        ('Manu Larcenet', 2),
        ('Frank Herbert', 1),
      ]);
      expect(p.authors.last.type, CollectionType.livre);
    });

    test('manga series by weight, for the AniList lookups', () {
      final p = TasteProfile.of(
        [
          item('V1', seriesId: 'v', type: CollectionType.manga),
          item('F1', seriesId: 'f', type: CollectionType.manga),
          item('F2', seriesId: 'f', type: CollectionType.manga),
          item('B1', seriesId: 'b'),
        ],
        [
          series('v', 'Vinland Saga'),
          series('f', 'Frieren'),
          series('b', 'Blast', type: CollectionType.bd),
        ],
      );
      expect(p.topManga(5).map((s) => s.series.title), [
        'Frieren',
        'Vinland Saga',
      ]);
    });
  });

  group('ranking', () {
    final owned = OwnedWorks.of(
      [
        item('Le Combat ordinaire'),
        item('Presque', ownership: Ownership.envie),
      ],
      [series('s', "L'Atelier des sorciers")],
    );

    test('owned, wished, owned under another title and dismissed: out', () {
      final ranked = rankSuggestions(
        [
          suggestion('Le combat ordinaire : 1'),
          suggestion('Presque'),
          suggestion('Witch Hat Atelier', alt: ["L'atelier des Sorciers"]),
          suggestion('Blast'),
          suggestion('Nic Oumouk'),
        ],
        owned: owned,
        feedback: [dismissed('work:Nic Oumouk', 'larcenet')],
      );
      expect(ranked.map((s) => s.title), ['Blast']);
    });

    test('a sequel first, then the author, then the crowd', () {
      final ranked = rankSuggestions([
        suggestion('Crowd', kind: SuggestionKind.community, votes: 1000),
        suggestion('Author', reason: 'a'),
        suggestion('Sequel', kind: SuggestionKind.related, reason: 'b'),
      ], owned: owned);
      expect(ranked.map((s) => s.title), ['Sequel', 'Author', 'Crowd']);
      expect(ranked.first.score, closeTo(1.2, 1e-9));
    });

    test('popularity is moderate: a loved series beats a crowd', () {
      final ranked = rankSuggestions([
        suggestion(
          'Many votes',
          kind: SuggestionKind.community,
          votes: 2000,
          score: 0.5,
          reason: 'x',
        ),
        suggestion(
          'Few votes',
          kind: SuggestionKind.community,
          votes: 3,
          reason: 'y',
        ),
      ], owned: owned);
      expect(ranked.first.title, 'Few votes');
    });

    test('each "Pas intéressé" halves its reason', () {
      final ranked = rankSuggestions(
        [suggestion('Blast'), suggestion('Other', reason: 'b', score: 0.6)],
        owned: owned,
        feedback: [dismissed('work:Nic Oumouk', 'larcenet')],
      );
      expect(ranked.map((s) => (s.title, s.score)), [
        ('Other', 0.6),
        ('Blast', 0.5),
      ]);
    });

    test('diversity: one author does not fill the list', () {
      final ranked = rankSuggestions([
        for (var i = 0; i < 3; i++) suggestion('L$i', score: 1 - i / 100),
        suggestion('Other', reason: 'b', score: 0.8),
      ], owned: owned);
      // 0.99 / 1.4 = 0.71 < 0.8: the other author comes second.
      expect(ranked.map((s) => s.title), ['L0', 'Other', 'L1', 'L2']);
    });

    test('found by two reasons: best score plus 10 % of the other', () {
      final ranked = rankSuggestions([
        suggestion('Blast'),
        suggestion('Blast', reason: 'b', score: 0.5),
      ], owned: owned);
      expect(ranked.single.score, closeTo(1.05, 1e-9));
    });
  });
}
