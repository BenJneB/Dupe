import 'dart:async';

import 'package:dupe/core/metadata/metadata_merge.dart';
import 'package:dupe/core/metadata/metadata_provider.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
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
  CollectionType.comic: [
    MetadataSource.googleBooks,
    MetadataSource.openLibrary,
  ],
};

/// Queries the relevant sources in parallel, each with its own timeout, and
/// never fails because of one source.
class MetadataAggregator {
  new({
    required List<MetadataProvider> providers,
    this.priorities = defaultPriorities,
    this.timeout = const Duration(seconds: 5),
  }) : _providers = {for (final p in providers) p.source: p};

  final Map<MetadataSource, MetadataProvider> _providers;
  final Map<CollectionType, List<MetadataSource>> priorities;
  final Duration timeout;
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
            () => p.searchByIsbn(isbn13),
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
            () => p.searchByText(query),
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

  Future<({bool ok, T? value})> _guard<T>(Future<T> future) async {
    try {
      return (ok: true, value: await future.timeout(timeout));
    } on Object {
      // Timeouts, HTTP and parsing errors: the source is reported as failed.
      return (ok: false, value: null);
    }
  }
}
