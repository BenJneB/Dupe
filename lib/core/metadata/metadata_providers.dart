import 'package:dio/dio.dart';
import 'package:dupe/core/config/env.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/providers/bnf/bnf_provider.dart';
import 'package:dupe/core/metadata/providers/google_books/google_books_provider.dart';
import 'package:dupe/core/metadata/providers/open_library/open_library_provider.dart';
import 'package:dupe/core/network/http_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metadata_providers.g.dart';

@Riverpod(keepAlive: true)
Dio httpClient(Ref ref) {
  final dio = createHttpClient();
  ref.onDispose(dio.close);
  return dio;
}

/// All metadata sources. Google Books is only used with an API key
/// (GOOGLE_BOOKS_API_KEY in env.json): without one it answers HTTP 429.
@Riverpod(keepAlive: true)
MetadataAggregator metadataAggregator(Ref ref) {
  final dio = ref.watch(httpClientProvider);
  return MetadataAggregator(
    providers: [
      BnfProvider(dio),
      OpenLibraryProvider(dio, contact: Env.openLibraryContact),
      if (Env.googleBooksApiKey.isNotEmpty)
        GoogleBooksProvider(dio, apiKey: Env.googleBooksApiKey),
    ],
  );
}
