import 'dart:convert';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/domain/edition_match.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cover_proposals.g.dart';

/// A cover of another edition, found by text search for [item] (which has an
/// ISBN but no cover of its own edition): shown, never applied, until kept.
@immutable
class CoverProposal {
  const new({required this.item, required this.url, required this.from});

  final Item item;
  final String url;

  /// The result it comes from (source, title, ISBN of that edition).
  final MetadataResult from;

  String get key => '${item.id}|$url';
}

/// Covers refused by the user, on this device only (decision 2026-11-16):
/// not proposed again here.
class RefusedCovers {
  const new(this._settings);

  final AppSettingsStore _settings;
  static const settingKey = 'cover_refused';

  Future<Set<String>> load() async {
    final raw = await _settings.get(settingKey);
    if (raw == null || raw.isEmpty) return {};
    return {for (final k in jsonDecode(raw) as List<dynamic>) k as String};
  }

  Future<void> add(String key) async {
    final keys = await load()
      ..add(key);
    await _settings.set(settingKey, jsonEncode(keys.toList()));
  }
}

/// Text search (title + author, or series + number) for a cover of another
/// edition of [item] that downloads; null when nothing fits.
Future<CoverProposal?> proposeCover(
  MetadataAggregator sources,
  CoverCache cache,
  Item item, {
  required Set<String> refused,
  String? seriesTitle,
}) async {
  final volume = seriesTitle == null ? null : item.volumeNumber;
  final query = volume != null
      ? '$seriesTitle $volume'
      : [item.title, ...item.authors.take(1)].join(' ');
  final results =
      (await sources.searchText(
          query,
          item.type,
          except: const {MetadataSource.bnf},
        )).results.toList()
        // The same edition first, when a source has it.
        ..sort(
          (a, b) =>
              (b.isbn13 == item.isbn13 ? 1 : 0) -
              (a.isbn13 == item.isbn13 ? 1 : 0),
        );
  for (final r in results) {
    final url = r.coverUrl;
    if (url == null || url.isEmpty || url == item.coverUrl) continue;
    if (refused.contains('${item.id}|$url')) continue;
    final fits = sameWork(
      r,
      title: item.title,
      authors: item.authors,
      seriesTitle: seriesTitle,
      volume: volume,
    );
    if (!fits) continue;
    try {
      await cache.fetch(url);
      return CoverProposal(item: item, url: url, from: r);
    } on Object {
      continue;
    }
  }
  return null;
}

/// Proposals waiting in Plus → Qualité (filled by "Compléter les
/// couvertures manquantes").
@Riverpod(keepAlive: true)
class CoverProposals extends _$CoverProposals {
  @override
  List<CoverProposal> build() => const [];

  RefusedCovers get _refused =>
      RefusedCovers(ref.read(appSettingsStoreProvider));

  Future<Set<String>> refusedKeys() => _refused.load();

  void add(CoverProposal p) {
    if (state.any((o) => o.item.id == p.item.id)) return;
    state = [...state, p];
  }

  void _remove(CoverProposal p) => state = [
    for (final o in state)
      if (o.key != p.key) o,
  ];

  /// Applies the cover, unless the book got one meanwhile.
  Future<void> keep(CoverProposal p) async {
    final repo = ref.read(collectionRepositoryProvider);
    final fresh = await repo.getItem(p.item.id);
    if (fresh != null && fresh.coverUrl == p.item.coverUrl) {
      await repo.saveItem(fresh.copyWith(coverUrl: p.url));
    }
    _remove(p);
  }

  Future<void> refuse(CoverProposal p) async {
    await _refused.add(p.key);
    _remove(p);
  }

  Future<void> keepAll() async {
    for (final p in [...state]) {
      await keep(p);
    }
  }
}
