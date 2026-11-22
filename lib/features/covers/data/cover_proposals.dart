import 'dart:convert';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/domain/cover_image_key.dart';
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

/// Refused cover proposals: an image refused for a book is never proposed
/// again for it, whatever its URL variant (`coverImageKey`); other images
/// still may be. Stored on the item (`refusedCovers`, synced). Before
/// 2026-11-20 refusals were kept on the device only (`cover_refused`,
/// `id|url`): still read here.
class RefusedCovers {
  const new(this._settings);

  final AppSettingsStore _settings;
  static const settingKey = 'cover_refused';

  /// Whether [url] was refused for [item], on the item or by a [legacy]
  /// device key.
  static bool refuses(Set<String> legacy, Item item, String url) {
    final key = coverImageKey(url);
    return item.refusedCovers.contains(key) ||
        legacy.any((k) {
          final (id, old) = switch (k.indexOf('|')) {
            -1 => (k, ''),
            final i => (k.substring(0, i), k.substring(i + 1)),
          };
          return id == item.id && coverImageKey(old) == key;
        });
  }

  /// Device keys written before 2026-11-20.
  Future<Set<String>> loadLegacy() async {
    final raw = await _settings.get(settingKey);
    if (raw == null || raw.isEmpty) return {};
    return {for (final k in jsonDecode(raw) as List<dynamic>) k as String};
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
    if (RefusedCovers.refuses(refused, item, url)) continue;
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

  Future<Set<String>> refusedKeys() => _refused.loadLegacy();

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

  /// Refuses this image for this book (synced); others may come later.
  Future<void> refuse(CoverProposal p) async {
    final repo = ref.read(collectionRepositoryProvider);
    final fresh = await repo.getItem(p.item.id);
    final key = coverImageKey(p.url);
    if (fresh != null && !fresh.refusedCovers.contains(key)) {
      await repo.saveItem(
        fresh.copyWith(refusedCovers: [...fresh.refusedCovers, key]),
      );
    }
    _remove(p);
  }

  /// All in one transaction: the collection streams refresh once.
  Future<void> keepAll() =>
      ref.read(collectionRepositoryProvider).inTransaction(() async {
        for (final p in [...state]) {
          await keep(p);
        }
      });
}
