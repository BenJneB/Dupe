import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_parser.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_provider.dart';
import 'package:dupe/core/metadata/providers/bnf/bnf_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggestion_sources.g.dart';

/// Where the suggestions come from (PLAN_V4 phase 30): the BnF for the
/// other works of an author, AniList for the manga neighbours. Wikidata and
/// MangaUpdates come with phase 32. Faked in tests (`pumpApp`).
abstract interface class SuggestionSources {
  /// Printed works of [author]; empty when the BnF is off.
  Future<List<MetadataResult>> booksByAuthor(String author);

  /// The AniList entry of a manga (by [anilistId], else [title]) and its
  /// neighbours; null when unknown or AniList is off.
  Future<AniListNeighbours?> mangaNeighbours({
    required String title,
    String? anilistId,
  });
}

class ApiSuggestionSources implements SuggestionSources {
  const new(this._bnf, this._anilist);

  final BnfProvider? _bnf;
  final AniListProvider? _anilist;

  @override
  Future<List<MetadataResult>> booksByAuthor(String author) async =>
      await _bnf?.searchByAuthor(author) ?? const [];

  @override
  Future<AniListNeighbours?> mangaNeighbours({
    required String title,
    String? anilistId,
  }) async {
    final id = anilistId == null ? null : int.tryParse(anilistId);
    return await _anilist?.neighbours(id: id, title: id == null ? title : null);
  }
}

@Riverpod(keepAlive: true)
SuggestionSources suggestionSources(Ref ref) => ApiSuggestionSources(
  ref.watch(bnfSourceProvider),
  ref.watch(anilistSourceProvider),
);
