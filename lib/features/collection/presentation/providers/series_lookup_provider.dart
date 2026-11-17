import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'series_lookup_provider.g.dart';

@riverpod
Future<List<SeriesMetadata>> seriesLookupResults(
  Ref ref,
  String query,
  CollectionType type,
) => ref.watch(seriesLookupProvider).search(query, type);

extension SeriesSourceLabel on SeriesSource {
  String get label => switch (this) {
    SeriesSource.anilist => 'AniList',
    SeriesSource.comicVine => 'Comic Vine',
    SeriesSource.mangaUpdates => 'MangaUpdates',
  };
}
