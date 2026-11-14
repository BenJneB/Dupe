import 'package:dio/dio.dart';
import 'package:dupe/core/config/env.dart';
import 'package:dupe/core/database/database_provider.dart';
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

/// Sources that need an API key (env.json) are unavailable without it.
/// Google Books without a key answers HTTP 429.
bool sourceHasKey(SourceId id) => switch (id) {
  SourceId.googleBooks => Env.googleBooksApiKey.isNotEmpty,
  SourceId.comicVine => Env.comicVineApiKey.isNotEmpty,
  _ => true,
};

/// Whether a source has its key and is not turned off in the settings.
bool Function(SourceId) _enabledSources(Ref ref) {
  final disabled = ref.watch(disabledSourcesProvider).value ?? const {};
  return (id) => sourceHasKey(id) && !disabled.contains(id);
}

/// Enabled metadata sources, with the on-disk response cache.
@Riverpod(keepAlive: true)
MetadataAggregator metadataAggregator(Ref ref) {
  final dio = ref.watch(httpClientProvider);
  final on = _enabledSources(ref);
  return MetadataAggregator(
    store: ref.watch(responseStoreProvider),
    providers: [
      if (on(SourceId.bnf)) BnfProvider(dio),
      if (on(SourceId.openLibrary))
        OpenLibraryProvider(dio, contact: Env.openLibraryContact),
      if (on(SourceId.googleBooks))
        GoogleBooksProvider(dio, apiKey: Env.googleBooksApiKey),
      if (on(SourceId.comicVine))
        ComicVineProvider(dio, apiKey: Env.comicVineApiKey),
    ],
  );
}

/// Enabled series-level sources (AniList, Comic Vine).
@Riverpod(keepAlive: true)
SeriesLookup seriesLookup(Ref ref) {
  final dio = ref.watch(httpClientProvider);
  final on = _enabledSources(ref);
  return SeriesLookup(
    anilist: on(SourceId.anilist) ? AniListProvider(dio) : null,
    comicVine: on(SourceId.comicVine)
        ? ComicVineProvider(dio, apiKey: Env.comicVineApiKey)
        : null,
  );
}
