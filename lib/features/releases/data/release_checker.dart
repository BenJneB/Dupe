import 'dart:convert';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/series_completion_service.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';
import 'package:dupe/features/releases/data/release_notifications.dart';
import 'package:dupe/features/releases/data/release_settings.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:dupe/features/releases/domain/release_detection.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'release_checker.g.dart';

@immutable
class ReleaseCheckState {
  const new({this.running = false, this.found, this.lastRun});

  final bool running;

  /// New alerts of the last check.
  final int? found;
  final DateTime? lastRun;
}

/// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
/// day (at start-up): followed series at the BnF (volumes after the last
/// known one), followed authors (ISBNs not seen at the previous check).
/// The sources' rate limiters and caches apply; [seriesPerRun] series per
/// check, in turn.
@Riverpod(keepAlive: true)
class ReleaseChecker extends _$ReleaseChecker {
  static const seriesPerRun = 12;
  static const _lastRun = 'releases_last_run';
  static const _cursor = 'releases_cursor';
  static String _seenKey(String author) => 'releases_seen_${authorKey(author)}';

  @override
  ReleaseCheckState build() => const ReleaseCheckState();

  /// Start-up: checks when on, due (a day), and on Wi-Fi if asked.
  Future<void> runIfDue() async {
    final options = await ref.read(releaseSettingsProvider.future);
    if (!options.enabled) return;
    final store = ref.read(appSettingsStoreProvider);
    final last = DateTime.tryParse(await store.get(_lastRun) ?? '');
    final now = ref.read(clockProvider)();
    if (last != null && now.difference(last) < const Duration(hours: 20)) {
      return;
    }
    final network = await ref.read(networkStatusProvider).current();
    if (network == NetworkKind.none) return;
    if (options.wifiOnly && network != NetworkKind.unmetered) return;
    await run();
  }

  /// Checks now; returns the number of new alerts.
  Future<int> run() async {
    if (state.running) return 0;
    state = ReleaseCheckState(running: true, lastRun: state.lastRun);
    var found = 0;
    try {
      final repo = ref.read(collectionRepositoryProvider);
      final items = await repo.listItems();
      found += await _checkSeries(await repo.listSeries(), items);
      found += await _checkAuthors(items);
      final options = await ref.read(releaseSettingsProvider.future);
      if (found > 0 && options.notify) {
        await ref.read(releaseNotificationsProvider).show(found);
      }
    } on Object catch (e, stack) {
      appLog.error('releases', e, stack);
    }
    final now = ref.read(clockProvider)();
    await ref
        .read(appSettingsStoreProvider)
        .set(_lastRun, now.toUtc().toIso8601String());
    state = ReleaseCheckState(found: found, lastRun: now);
    return found;
  }

  Future<int> _checkSeries(List<Series> all, List<Item> items) async {
    final followed = all.where((s) => s.followed).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    if (followed.isEmpty) return 0;
    final store = ref.read(appSettingsStoreProvider);
    final start =
        (int.tryParse(await store.get(_cursor) ?? '') ?? 0) % followed.length;
    final batch = [
      for (var i = 0; i < followed.length && i < seriesPerRun; i++)
        followed[(start + i) % followed.length],
    ];
    await store.set(_cursor, '${start + batch.length}');
    final source = ref.read(seriesCatalogSourceProvider);
    final alerts = ref.read(releasesRepositoryProvider);
    var found = 0;
    for (final s in batch) {
      try {
        final own = items.where((i) => i.seriesId == s.id).toList();
        final publisher =
            s.publisher ?? own.map((i) => i.publisher).nonNulls.firstOrNull;
        final next = nextVolumes(
          own,
          buildCatalog(s.title, await source.volumesOf(s.title)),
          publisher: publisher,
        );
        for (final v in next) {
          final r = v.preferred;
          final added = await alerts.addIfNew(
            ReleaseAlert(
              id: '',
              createdAt: DateTime(0),
              updatedAt: DateTime(0),
              key: 'series:${s.id}:${v.number}',
              kind: AlertKind.serie,
              type: s.type,
              title: s.title,
              seriesId: s.id,
              volumeNumber: '${v.number}',
              authors: r.authors,
              isbn13: r.isbn13,
              publisher: r.publisher,
              publishDate: r.publishDate,
              coverUrl: r.coverUrl,
            ),
          );
          if (added) found++;
        }
      } on Object catch (e) {
        appLog.warning('releases', e);
      }
    }
    return found;
  }

  Future<int> _checkAuthors(List<Item> items) async {
    final authors = await ref.read(releasesRepositoryProvider).listFollowed();
    if (authors.isEmpty) return 0;
    final store = ref.read(appSettingsStoreProvider);
    final owned = {for (final i in items) ?i.isbn13};
    final sources = ref.read(suggestionSourcesProvider);
    var found = 0;
    for (final a in authors) {
      try {
        final records = await sources.booksByAuthor(a.name);
        final seenRaw = await store.get(_seenKey(a.name));
        final seen = {
          if (seenRaw != null)
            ...(jsonDecode(seenRaw) as List<dynamic>).cast<String>(),
        };
        // First check of an author: what exists now is the reference.
        if (seenRaw != null) {
          for (final r in newBooks(
            records,
            author: a.name,
            seen: seen,
            owned: owned,
          )) {
            final added = await ref
                .read(releasesRepositoryProvider)
                .addIfNew(_authorAlert(a.name, r.isbn13!, r, items));
            if (added) found++;
          }
        }
        await store.set(
          _seenKey(a.name),
          jsonEncode({...seen, for (final r in records) ?r.isbn13}.toList()),
        );
      } on Object catch (e) {
        appLog.warning('releases', e);
      }
    }
    return found;
  }

  ReleaseAlert _authorAlert(
    String author,
    String isbn,
    MetadataResult r,
    List<Item> items,
  ) {
    final key = authorKey(author);
    // The tab of most of their books in the collection.
    final types = [
      for (final i in items)
        if (i.authors.map(authorKey).contains(key)) i.type,
    ];
    final type = types.isEmpty
        ? CollectionType.livre
        : CollectionType.values.reduce(
            (a, b) =>
                types.where((t) => t == b).length >
                    types.where((t) => t == a).length
                ? b
                : a,
          );
    return ReleaseAlert(
      id: '',
      createdAt: DateTime(0),
      updatedAt: DateTime(0),
      key: 'isbn:$isbn',
      kind: AlertKind.auteur,
      type: type,
      title: r.seriesTitle ?? r.title,
      volumeNumber: r.volumeNumber,
      authorName: author,
      authors: r.authors,
      isbn13: isbn,
      publisher: r.publisher,
      publishDate: r.publishDate,
      coverUrl: r.coverUrl,
    );
  }
}
