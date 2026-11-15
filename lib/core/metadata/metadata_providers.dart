import 'package:dio/dio.dart';
import 'package:dupe/core/config/env.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/api_keys.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_provider.dart';
import 'package:dupe/core/metadata/providers/bnf/bnf_provider.dart';
import 'package:dupe/core/metadata/providers/comic_vine/comic_vine_provider.dart';
import 'package:dupe/core/metadata/providers/google_books/google_books_provider.dart';
import 'package:dupe/core/metadata/providers/open_library/open_library_provider.dart';
import 'package:dupe/core/metadata/series_lookup.dart';
import 'package:dupe/core/metadata/source_settings.dart';
import 'package:dupe/core/network/http_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metadata_providers.g.dart';

@Riverpod(keepAlive: true)
Dio httpClient(Ref ref) {
  final dio = createHttpClient();
  ref.onDispose(dio.close);
  return dio;
}

/// Whether a source has its key and is not turned off in the settings.
/// Watching the keys rebuilds the sources as soon as one is entered.
bool Function(SourceId) _enabledSources(Ref ref) {
  final disabled = ref.watch(disabledSourcesProvider).value ?? const {};
  final keys = ref.watch(apiKeysProvider);
  return (id) => sourceHasKey(id, keys) && !disabled.contains(id);
}

/// Enabled metadata sources, with the on-disk response cache.
@Riverpod(keepAlive: true)
MetadataAggregator metadataAggregator(Ref ref) {
  final dio = ref.watch(httpClientProvider);
  final on = _enabledSources(ref);
  final keys = ref.watch(apiKeysProvider);
  return MetadataAggregator(
    store: ref.watch(responseStoreProvider),
    providers: [
      if (on(SourceId.bnf)) BnfProvider(dio),
      if (on(SourceId.openLibrary))
        OpenLibraryProvider(dio, contact: Env.openLibraryContact),
      if (on(SourceId.googleBooks))
        GoogleBooksProvider(dio, apiKey: keys[SourceId.googleBooks]!),
      if (on(SourceId.comicVine))
        ComicVineProvider(dio, apiKey: keys[SourceId.comicVine]!),
    ],
  );
}

/// Enabled series-level sources (AniList, Comic Vine).
@Riverpod(keepAlive: true)
SeriesLookup seriesLookup(Ref ref) {
  final dio = ref.watch(httpClientProvider);
  final on = _enabledSources(ref);
  final keys = ref.watch(apiKeysProvider);
  return SeriesLookup(
    anilist: on(SourceId.anilist) ? AniListProvider(dio) : null,
    comicVine: on(SourceId.comicVine)
        ? ComicVineProvider(dio, apiKey: keys[SourceId.comicVine]!)
        : null,
  );
}
