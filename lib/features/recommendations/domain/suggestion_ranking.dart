import 'dart:math' as math;

import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/covers/domain/edition_match.dart';
import 'package:dupe/features/recommendations/domain/recommendation_feedback.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';

/// Scoring of the suggestions (PLAN_V4 phase 30), documented here:
/// - a candidate starts with the weight of its reason (author or series in
///   the profile, 0-1);
/// - × the weight of its family: a sequel of a loved series first, then
///   another book of a loved author, then the community picks;
/// - × a moderate popularity for the community picks (0.6 for one vote,
///   1 from 500 votes): a loved series weighs more than the crowd;
/// - × 0.5 for each "Pas intéressé" given to a suggestion of the same
///   reason;
/// - the same work found by several reasons keeps its best score + 10 % of
///   the others;
/// - diversity: each pick divides by 1.4 the next scores of the same reason,
///   so that one prolific author does not fill the whole list.
const Map<SuggestionKind, double> familyWeight = {
  SuggestionKind.related: 1.2,
  SuggestionKind.sameAuthor: 1.0,
  SuggestionKind.community: 0.9,
};

double popularity(Suggestion s) => s.reason.kind == SuggestionKind.community
    ? 0.6 + 0.4 * math.min(1, math.log(1 + s.votes) / math.log(500))
    : 1;

String reasonId(String kind, String key) => '$kind:$key';

/// What the user already has, owned or wished (excluded from suggestions).
class OwnedWorks {
  new(this.titles, this.anilistIds);

  /// Live rows only; [anilistIds] of the series known on AniList.
  factory of(
    List<Item> items,
    List<Series> series, {
    Set<String> anilistIds = const {},
  }) => OwnedWorks(
    {
      for (final s in series)
        if (s.deletedAt == null) ...{
          mainTitle(s.title),
          if (s.originalTitle case final o?) mainTitle(o),
        },
      for (final i in items)
        if (i.deletedAt == null) ...{
          mainTitle(i.title),
          if (i.volumeTitle case final v?) mainTitle(v),
        },
    }..remove(''),
    {...anilistIds, for (final s in series) ?s.externalIds['anilist_id']},
  );

  final Set<String> titles;
  final Set<String> anilistIds;

  bool has(Suggestion s) =>
      (s.anilistId != null && anilistIds.contains(s.anilistId)) ||
      [
        s.title,
        ?s.seriesTitle,
        ...s.altTitles,
      ].map(mainTitle).any(titles.contains);
}

/// The [limit] best suggestions among [candidates], owned, wished and
/// dismissed works excluded.
List<Suggestion> rankSuggestions(
  Iterable<Suggestion> candidates, {
  required OwnedWorks owned,
  Iterable<RecommendationFeedback> feedback = const [],
  int limit = 40,
}) {
  final live = feedback.where((f) => f.deletedAt == null);
  final dismissed = {for (final f in live) f.suggestionKey};
  final penalties = <String, int>{};
  for (final f in live) {
    final id = reasonId(f.reasonKind, f.reasonKey);
    penalties[id] = (penalties[id] ?? 0) + 1;
  }
  String idOf(Suggestion s) => reasonId(s.reason.kind.name, s.reason.key);

  final best = <String, Suggestion>{};
  for (final c in candidates) {
    if (dismissed.contains(c.key) || owned.has(c)) continue;
    final score =
        c.score *
        familyWeight[c.reason.kind]! *
        popularity(c) *
        math.pow(0.5, penalties[idOf(c)] ?? 0);
    final s = c.copyWith(score: score);
    final other = best[c.key];
    best[c.key] = switch (other) {
      null => s,
      _ when other.score >= score => other.copyWith(
        score: other.score + 0.1 * score,
      ),
      _ => s.copyWith(score: score + 0.1 * other.score),
    };
  }

  final remaining = best.values.toList();
  final picked = <Suggestion>[];
  final perReason = <String, int>{};
  double adjusted(Suggestion s) =>
      s.score / math.pow(1.4, perReason[idOf(s)] ?? 0);
  while (remaining.isNotEmpty && picked.length < limit) {
    final next = remaining.reduce((a, b) => adjusted(b) > adjusted(a) ? b : a);
    remaining.remove(next);
    picked.add(next);
    perReason[idOf(next)] = (perReason[idOf(next)] ?? 0) + 1;
  }
  return picked;
}
