import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_parser.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/covers/domain/edition_match.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';
import 'package:dupe/features/recommendations/domain/recommendation_feedback.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';
import 'package:dupe/features/recommendations/domain/suggestion_ranking.dart';
import 'package:dupe/features/recommendations/domain/taste_profile.dart';

/// Relations of AniList kept as "related" (not adaptations, not "other").
const _relations = {'SEQUEL', 'PREQUEL', 'SIDE_STORY', 'SPIN_OFF', 'PARENT'};

/// Computes the suggestions from the collection (local profile) and the
/// sources: the [authorCount] heaviest authors at the BnF, the [mangaCount]
/// heaviest manga series on AniList. A failing source is logged and skipped.
class SuggestionEngine {
  const new(this._sources, {this.authorCount = 6, this.mangaCount = 6});

  final SuggestionSources _sources;
  final int authorCount;
  final int mangaCount;

  Future<List<Suggestion>> compute({
    required List<Item> items,
    required List<Series> series,
    List<RecommendationFeedback> feedback = const [],
    void Function(int done, int total)? onProgress,
  }) async {
    final profile = TasteProfile.of(items, series);
    final max = profile.maxWeight;
    final authors = profile.authors.take(authorCount).toList();
    final manga = profile.topManga(mangaCount);
    final total = authors.length + manga.length;
    var done = 0;
    void step() => onProgress?.call(++done, total);

    final candidates = <Suggestion>[];
    for (final a in authors) {
      try {
        final books = await _sources.booksByAuthor(a.name);
        candidates.addAll(_fromAuthor(a, books, max));
      } on Object catch (e) {
        appLog.warning('suggestions', e);
      }
      step();
    }
    final known = <String>{};
    for (final s in manga) {
      try {
        final n = await _sources.mangaNeighbours(
          title: s.series.title,
          anilistId: s.series.externalIds['anilist_id'],
        );
        if (n != null && _sameManga(n, s.series)) {
          known.add(n.media.sourceId);
          candidates.addAll(_fromManga(s, n, max));
        }
      } on Object catch (e) {
        appLog.warning('suggestions', e);
      }
      step();
    }
    return rankSuggestions(
      candidates,
      owned: OwnedWorks.of(items, series, anilistIds: known),
      feedback: feedback,
    );
  }

  /// AniList found by title: kept only when one of its titles is the
  /// series title or an author is shared (a search can return a homonym).
  bool _sameManga(AniListNeighbours n, Series s) {
    if (s.externalIds['anilist_id'] != null) return true;
    final titles = n.synonyms.map(normalizeTitle).toSet();
    if (titles.contains(normalizeTitle(s.title))) return true;
    final keys = s.authors.map(authorKey).toSet();
    return n.media.authors.map(authorKey).any(keys.contains);
  }

  /// One suggestion per work (series or book) of the BnF records, the
  /// author checked (the search also finds co-authors and prefaces).
  Iterable<Suggestion> _fromAuthor(
    AuthorTaste a,
    List<MetadataResult> books,
    double max,
  ) {
    final works = <String, Suggestion>{};
    for (final b in books) {
      if (!b.authors.map(authorKey).contains(a.key)) continue;
      final series = b.seriesTitle;
      final key = 'work:${mainTitle(series ?? b.title)}';
      // Volume 1 (or a standalone book) gives the ISBN and cover added
      // to the wishes; the records of a work are merged.
      final first = series == null || b.volumeNumber == '1';
      final previous = works[key];
      final seriesTitle = previous?.seriesTitle ?? series;
      works[key] = Suggestion(
        key: key,
        type: a.type,
        title: seriesTitle ?? previous?.title ?? b.title,
        seriesTitle: seriesTitle,
        authors: previous?.authors ?? b.authors,
        publisher: previous?.publisher ?? b.publisher,
        isbn13: previous?.isbn13 ?? (first ? b.isbn13 : null),
        coverUrl: previous?.coverUrl ?? (first ? b.coverUrl : null),
        reason: SuggestionReason(
          kind: SuggestionKind.sameAuthor,
          key: a.key,
          label: a.name,
          count: a.count,
        ),
        score: a.weight / max,
      );
    }
    return works.values;
  }

  Iterable<Suggestion> _fromManga(
    SeriesTaste s,
    AniListNeighbours n,
    double max,
  ) sync* {
    Suggestion of(AniListNeighbour m, SuggestionKind kind) => Suggestion(
      key: 'anilist:${m.media.sourceId}',
      type: CollectionType.manga,
      title: m.media.title,
      // A one-shot is a single book.
      seriesTitle: m.format == 'ONE_SHOT' ? null : m.media.title,
      altTitles: m.synonyms,
      authors: m.media.authors,
      coverUrl: m.media.coverUrl,
      siteUrl: m.media.siteUrl,
      anilistId: m.media.sourceId,
      votes: m.votes,
      reason: SuggestionReason(
        kind: kind,
        key: s.series.id,
        label: s.series.title,
        count: s.count,
      ),
      score: s.weight / max,
    );
    for (final m in n.recommendations) {
      if (m.votes > 0) yield of(m, SuggestionKind.community);
    }
    for (final m in n.related) {
      if (_relations.contains(m.relation)) yield of(m, SuggestionKind.related);
    }
  }
}
