import 'package:dio/dio.dart';
import 'package:dupe/core/config/env.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/api_keys.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/providers/anilist/anilist_provider.dart';
import 'package:dupe/core/metadata/providers/bnf/bnf_provider.dart';
import 'package:dupe/core/metadata/providers/comic_vine/comic_vine_provider.dart';
import 'package:dupe/core/metadata/providers/google_books/google_books_provider.dart';
import 'package:dupe/core/metadata/providers/mangadex/mangadex_covers.dart';
import 'package:dupe/core/metadata/providers/mangaupdates/mangaupdates_provider.dart';
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
      ?ref.watch(bnfSourceProvider),
      if (on(SourceId.openLibrary))
        OpenLibraryProvider(dio, contact: Env.openLibraryContact),
      if (on(SourceId.googleBooks))
        GoogleBooksProvider(dio, apiKey: keys[SourceId.googleBooks]!),
      ?ref.watch(comicVineSourceProvider),
    ],
  );
}

/// The one Comic Vine client, shared by the volume lookups and the series
/// lookups: its rate limiter (1 request/s, or Comic Vine blocks the key)
/// then covers both. Null when the source is off or has no key.
@Riverpod(keepAlive: true)
ComicVineProvider? comicVineSource(Ref ref) {
  final key = ref.watch(apiKeysProvider)[SourceId.comicVine];
  return _enabledSources(ref)(SourceId.comicVine) && key != null
      ? ComicVineProvider(ref.watch(httpClientProvider), apiKey: key)
      : null;
}

/// The one BnF client (lookups and suggestions share its rate limiter);
/// null when the source is off.
@Riverpod(keepAlive: true)
BnfProvider? bnfSource(Ref ref) => _enabledSources(ref)(SourceId.bnf)
    ? BnfProvider(ref.watch(httpClientProvider))
    : null;

/// The one AniList client (series lookups and suggestions); null when off.
@Riverpod(keepAlive: true)
AniListProvider? anilistSource(Ref ref) =>
    _enabledSources(ref)(SourceId.anilist)
    ? AniListProvider(ref.watch(httpClientProvider))
    : null;

/// Enabled series-level sources (AniList, Comic Vine).
@Riverpod(keepAlive: true)
SeriesLookup seriesLookup(Ref ref) => SeriesLookup(
  anilist: ref.watch(anilistSourceProvider),
  comicVine: ref.watch(comicVineSourceProvider),
  mangaUpdates: _enabledSources(ref)(SourceId.mangaUpdates)
      ? MangaUpdatesProvider(ref.watch(httpClientProvider))
      : null,
);

/// French manga covers by volume (phase 32); null when the source is off.
@Riverpod(keepAlive: true)
MangaDexCovers? mangaDexCovers(Ref ref) =>
    _enabledSources(ref)(SourceId.mangadex)
    ? MangaDexCovers(ref.watch(httpClientProvider))
    : null;
