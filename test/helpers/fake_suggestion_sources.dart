import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_parser.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';

/// Suggestion sources answering from memory (nothing by default).
class FakeSuggestionSources implements SuggestionSources {
  new({this.byAuthor = const {}, this.byTitle = const {}, this.error});

  final Map<String, List<MetadataResult>> byAuthor;
  final Map<String, AniListNeighbours> byTitle;

  /// Thrown for every author lookup (BnF down).
  final Exception? error;
  final calls = <String>[];

  @override
  Future<List<MetadataResult>> booksByAuthor(String author) async {
    calls.add('author:$author');
    if (error case final e?) throw e;
    return byAuthor[author] ?? const [];
  }

  @override
  Future<AniListNeighbours?> mangaNeighbours({
    required String title,
    String? anilistId,
  }) async {
    calls.add('manga:${anilistId ?? title}');
    return byTitle[anilistId ?? title];
  }
}
