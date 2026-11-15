import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// Picks the series source for a collection type: AniList for manga,
/// Comic Vine for comics. BD and books have no series API (Bédéthèque has no
/// API and must not be scraped): external links only.
class SeriesLookup {
  new({this.anilist, this.comicVine});

  final SeriesMetadataProvider? anilist;
  final SeriesMetadataProvider? comicVine;

  SeriesMetadataProvider? providerFor(CollectionType type) => switch (type) {
    CollectionType.manga => anilist,
    CollectionType.comic => comicVine,
    CollectionType.bd || CollectionType.livre => null,
  };

  Future<List<SeriesMetadata>> search(String query, CollectionType type) async {
    final provider = providerFor(type);
    if (provider == null || query.trim().isEmpty) return const [];
    return await provider.searchSeries(query.trim());
  }
}
