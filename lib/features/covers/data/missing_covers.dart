import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/mangadex/mangadex_covers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_proposals.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'missing_covers.g.dart';

/// Progress of "Compléter les couvertures manquantes".
@immutable
class CoverFillState {
  const new({
    this.running = false,
    this.done = 0,
    this.total = 0,
    this.found = 0,
  });

  final bool running;
  final int done;
  final int total;

  /// Covers found and saved so far.
  final int found;

  bool get finished => !running && total > 0 && done == total;
}

/// Live items with an ISBN (only they can be looked up).
Future<List<Item>> itemsWithIsbn(AppDatabase db) => (db.select(
  db.itemsTable,
)..where((t) => t.deletedAt.isNull() & t.isbn13.isNotNull())).get();

/// The item needs a cover: none, or an address that does not download
/// (Open Library guess saved at scan time). Photos taken by the user are
/// never replaced.
Future<bool> needsCover(CoverCache cache, Item item) async {
  final url = item.coverUrl;
  if (url == null || url.isEmpty) return true;
  if (CoverPhotos.isUserCover(url) || await cache.has(url)) return false;
  try {
    await cache.fetch(url);
    return false;
  } on Object {
    return true;
  }
}

/// First cover of the sources that really downloads (kept in the cache for
/// offline use), or why none was found (for the journal). The Open Library
/// cover-by-ISBN guess comes last: it is often missing for French editions.
Future<({String? url, String why})> findCover(
  MetadataAggregator sources,
  CoverCache cache,
  Item item,
) async {
  // The BnF never has images: not queried (faster on a large collection).
  final lookup = await sources.lookupIsbn(
    item.isbn13!,
    item.type,
    except: const {MetadataSource.bnf},
  );
  final broken = item.coverUrl;
  final candidates = <String>{
    for (final r in lookup.results)
      if (r.coverUrl case final url? when url.isNotEmpty) url,
    if (lookup.merged?.coverUrl case final url? when url.isNotEmpty) url,
  };
  final tried = <String>[];
  for (final url in candidates) {
    if (url == broken) continue;
    try {
      await cache.fetch(url);
      return (url: url, why: '');
    } on Object catch (e) {
      tried.add('${Uri.tryParse(url)?.host ?? url} ${coverError(e)}');
    }
  }
  final answered = [for (final r in lookup.results) r.source.name];
  final failed = [for (final s in lookup.failed) s.name];
  return (
    url: null,
    why: [
      'réponses : ${answered.isEmpty ? 'aucune' : answered.join(', ')}',
      if (failed.isNotEmpty) 'en échec : ${failed.join(', ')}',
      if (tried.isNotEmpty) 'images : ${tried.join(', ')}',
    ].join(' ; '),
  );
}

/// The French cover of manga volume [item] on MangaDex, when it downloads.
Future<String?> mangaDexCover(
  MangaDexCovers mangaDex,
  CoverCache cache,
  Item item,
  String seriesTitle,
) async {
  final volume = item.volumeNumber;
  if (item.type != CollectionType.manga || volume == null) return null;
  final url = await mangaDex.frenchCover(seriesTitle, volume);
  if (url == null || url == item.coverUrl) return null;
  try {
    await cache.fetch(url);
    return url;
  } on Object {
    return null; // Image refused: the text search proposal still runs.
  }
}

/// Looks up, one by one, a cover for every item that has none or whose
/// cover does not download.
@Riverpod(keepAlive: true)
class MissingCoversFill extends _$MissingCoversFill {
  @override
  CoverFillState build() => const CoverFillState();

  Future<void> run() async {
    if (state.running) return;
    final repo = ref.read(collectionRepositoryProvider);
    final sources = ref.read(metadataAggregatorProvider);
    final cache = ref.read(coverCacheProvider);
    final mangaDex = ref.read(mangaDexCoversProvider);
    final items = await itemsWithIsbn(ref.read(appDatabaseProvider));
    final proposals = ref.read(coverProposalsProvider.notifier);
    final refused = await proposals.refusedKeys();
    final seriesTitles = {
      for (final s in await repo.listSeries()) s.id: s.title,
    };
    state = CoverFillState(running: items.isNotEmpty, total: items.length);
    var found = 0;
    var proposed = 0;
    final notFound = <String>[];
    for (final (i, item) in items.indexed) {
      try {
        if (!await needsCover(cache, item)) continue;
        var (:url, :why) = await findCover(sources, cache, item);
        // A manga volume: its French cover on MangaDex (phase 32), same
        // edition, applied like an ISBN cover.
        final seriesTitle = seriesTitles[item.seriesId];
        if (url == null && mangaDex != null && seriesTitle != null) {
          url = await mangaDexCover(mangaDex, cache, item, seriesTitle);
          if (url == null) why = '$why ; MangaDex : aucune';
        }
        if (url == null) {
          // Another edition's cover, by text search: proposed, not applied
          // (phase 25).
          final proposal = await proposeCover(
            sources,
            cache,
            item,
            refused: refused,
            seriesTitle: seriesTitles[item.seriesId],
          );
          if (proposal != null) {
            proposals.add(proposal);
            proposed++;
            continue;
          }
        }
        if (url == null && notFound.length < 30) {
          notFound.add(
            '${item.title} ${item.volumeNumber ?? ''} [${item.isbn13}] $why',
          );
        }
        if (url != null) {
          // Re-read: the item may have changed during the lookup.
          final fresh = await repo.getItem(item.id);
          if (fresh != null && fresh.coverUrl == item.coverUrl) {
            await repo.saveItem(fresh.copyWith(coverUrl: url));
            found++;
          }
        }
      } on Object catch (e) {
        appLog.warning('covers', e);
      } finally {
        state = CoverFillState(
          running: i + 1 < items.length,
          done: i + 1,
          total: items.length,
          found: found,
        );
      }
    }
    final summary =
        '$found couverture(s) ajoutée(s) ou remplacée(s), '
        "$proposed proposée(s) d'une autre édition, "
        '${items.length} livres vérifiés';
    appLog.info(
      'covers',
      [
        summary,
        if (notFound.isNotEmpty) 'Sans couverture trouvée :',
        ...notFound,
      ].join('\n'),
    );
  }
}
