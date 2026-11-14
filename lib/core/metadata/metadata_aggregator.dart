import 'dart:async';
import 'dart:convert';

import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/metadata_merge.dart';
import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/response_store.dart';
import 'package:dupe/core/network/memory_cache.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';

/// Result of an ISBN lookup across sources.
typedef IsbnLookup = ({
  /// Field-by-field merge of [results]; null when no source knows the ISBN.
  MetadataResult? merged,
  List<MetadataResult> results,
  List<MetadataSource> failed,
});

typedef TextSearch = ({
  List<MetadataResult> results,
  List<MetadataSource> failed,
});

/// Priority of sources per collection type (first = most trusted fields).
/// BnF first for French editions; Google Books has covers and summaries.
const Map<CollectionType, List<MetadataSource>> defaultPriorities = {
  CollectionType.livre: [
    MetadataSource.bnf,
    MetadataSource.googleBooks,
    MetadataSource.openLibrary,
  ],
  CollectionType.bd: [MetadataSource.bnf, MetadataSource.googleBooks],
  CollectionType.manga: [MetadataSource.bnf, MetadataSource.googleBooks],
  // French TPBs (Urban Comics…) are in the BnF; Comic Vine for US issues.
  CollectionType.comic: [
    MetadataSource.bnf,
    MetadataSource.googleBooks,
    MetadataSource.openLibrary,
    MetadataSource.comicVine,
  ],
};

/// Queries the relevant sources in parallel, each with its own timeout, and
/// never fails because of one source. Answers are cached in memory and, with
/// a [store], on disk (offline use, fewer calls to rate-limited APIs).
class MetadataAggregator {
  new({
    required List<MetadataProvider> providers,
    this.priorities = defaultPriorities,
    this.timeout = const Duration(seconds: 5),
    this.store,
    this.policy = const CachePolicy(),
    DateTime Function()? now,
  }) : _providers = {for (final p in providers) p.source: p},
       _now = now ?? DateTime.now;

  final Map<MetadataSource, MetadataProvider> _providers;
  final Map<CollectionType, List<MetadataSource>> priorities;
  final Duration timeout;
  final ResponseStore? store;
  final CachePolicy policy;
  final DateTime Function() _now;
  final _isbnCache = MemoryCache<MetadataResult?>();
  final _textCache = MemoryCache<List<MetadataResult>>();

  List<MetadataProvider> _providersFor(CollectionType type) => [
    for (final source in priorities[type] ?? const <MetadataSource>[])
      if (_providers[source] case final p? when p.supportedTypes.contains(type))
        p,
  ];

  Future<IsbnLookup> lookupIsbn(String isbn13, CollectionType type) async {
    final providers = _providersFor(type);
    final outcomes = await Future.wait([
      for (final p in providers)
        _guard(
          _isbnCache.getOrCompute(
            '${p.source.name}:$isbn13',
            () => _persisted(
              '${p.source.name}:isbn:$isbn13',
              () => p.searchByIsbn(isbn13),
              encode: (r) => jsonEncode(r?.toJson()),
              decode: (json) => switch (jsonDecode(json)) {
                final Map<String, dynamic> m => MetadataResult.fromJson(m),
                _ => null,
              },
              ttl: (r) => r == null ? policy.notFound : policy.found,
            ),
          ),
        ),
    ]);
    final results = <MetadataResult>[];
    final failed = <MetadataSource>[];
    for (var i = 0; i < providers.length; i++) {
      switch (outcomes[i]) {
        case (ok: true, :final value?):
          results.add(value);
        case (ok: false, value: _):
          failed.add(providers[i].source);
        default:
      }
    }
    return (
      merged: mergeResults(results, isbn13),
      results: results,
      failed: failed,
    );
  }

  /// Results grouped by source priority, deduplicated by ISBN.
  Future<TextSearch> searchText(String query, CollectionType type) async {
    final providers = _providersFor(type);
    final key = query.trim().toLowerCase();
    final outcomes = await Future.wait([
      for (final p in providers)
        _guard(
          _textCache.getOrCompute(
            '${p.source.name}:$key',
            () => _persisted(
              '${p.source.name}:text:$key',
              () => p.searchByText(query),
              encode: (list) => jsonEncode([for (final r in list) r.toJson()]),
              decode: (json) => [
                for (final m in jsonDecode(json) as List<dynamic>)
                  MetadataResult.fromJson(m as Map<String, dynamic>),
              ],
              ttl: (_) => policy.text,
            ),
          ),
        ),
    ]);
    final results = <MetadataResult>[];
    final failed = <MetadataSource>[];
    final seenIsbns = <String>{};
    for (var i = 0; i < providers.length; i++) {
      final outcome = outcomes[i];
      if (!outcome.ok) {
        failed.add(providers[i].source);
        continue;
      }
      for (final r in outcome.value ?? const <MetadataResult>[]) {
        final isbn = r.isbn13;
        if (isbn != null && !seenIsbns.add(isbn)) continue;
        results.add(r);
      }
    }
    return (results: results, failed: failed);
  }

  /// Disk cache around one source call: fresh entries are returned as is,
  /// stale ones only when the source fails. Store errors are ignored.
  Future<T> _persisted<T>(
    String key,
    Future<T> Function() fetch, {
    required String Function(T) encode,
    required T Function(String) decode,
    required Duration Function(T) ttl,
  }) async {
    final store = this.store;
    if (store == null) return await fetch().timeout(timeout);
    T? stale;
    var hasStale = false;
    try {
      if (await store.read(key) case final stored?) {
        final value = decode(stored.payload);
        if (_now().difference(stored.fetchedAt) < ttl(value)) return value;
        (stale, hasStale) = (value, true);
      }
    } on Object {
      // Unreadable entry: refetch.
    }
    try {
      final value = await fetch().timeout(timeout);
      unawaited(
        store.write(key, encode(value)).catchError((Object e) {
          appLog.warning('cache', '$key: $e');
        }),
      );
      return value;
    } on Object catch (e) {
      appLog.warning(
        'metadata',
        hasStale ? '$key (cache used): $e' : '$key: $e',
      );
      if (hasStale) return stale as T;
      rethrow;
    }
  }

  Future<({bool ok, T? value})> _guard<T>(Future<T> future) async {
    try {
      // Timeouts are applied per source call in _persisted.
      return (ok: true, value: await future);
    } on Object {
      // Timeouts, HTTP and parsing errors: the source is reported as failed.
      return (ok: false, value: null);
    }
  }
}
