import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// Picks the series sources for a collection type: AniList then
/// MangaUpdates for manga (it knows the French manga AniList ignores), Comic
/// Vine for comics. BD and books have no series API (Bédéthèque has no API
/// and must not be scraped): external links only.
class SeriesLookup {
  new({this.anilist, this.comicVine, this.mangaUpdates});

  final SeriesMetadataProvider? anilist;
  final SeriesMetadataProvider? comicVine;
  final SeriesMetadataProvider? mangaUpdates;

  List<SeriesMetadataProvider> providersFor(CollectionType type) =>
      switch (type) {
        CollectionType.manga => [?anilist, ?mangaUpdates],
        CollectionType.comic => [?comicVine],
        CollectionType.bd || CollectionType.livre => const [],
      };

  /// The first source of [type], if any (whether series lookups exist).
  SeriesMetadataProvider? providerFor(CollectionType type) =>
      providersFor(type).firstOrNull;

  /// Results of every source of [type], in order. One failing source is
  /// logged when another one answers; all failing: the first error.
  Future<List<SeriesMetadata>> search(String query, CollectionType type) async {
    final providers = providersFor(type);
    if (providers.isEmpty || query.trim().isEmpty) return const [];
    final results = <SeriesMetadata>[];
    SeriesLookupException? firstError;
    var answered = false;
    for (final p in providers) {
      try {
        results.addAll(await p.searchSeries(query.trim()));
        answered = true;
      } on SeriesLookupException catch (e) {
        firstError ??= e;
        appLog.warning('series', e);
      }
    }
    if (!answered && firstError != null) throw firstError;
    return results;
  }
}
