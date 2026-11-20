import 'dart:math' as math;

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/series_completion_service.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/recommendations/data/suggestion_sources.dart';
import 'package:dupe/features/releases/data/release_author_check.dart';
import 'package:dupe/features/releases/data/release_notifications.dart';
import 'package:dupe/features/releases/data/release_settings.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:dupe/features/releases/domain/release_detection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'release_checker.g.dart';

/// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
/// day (at start-up): followed series at the BnF (volumes after the last
/// known one), followed authors (ISBNs not seen at the previous check).
/// The sources' rate limiters and caches apply; [seriesPerRun] series per
/// check, in turn. State: a check is running.
@Riverpod(keepAlive: true)
class ReleaseChecker extends _$ReleaseChecker {
  static const seriesPerRun = 12;
  static const _lastRun = 'releases_last_run';
  static const _cursor = 'releases_cursor';
  static String _baselineKey(String seriesId) => 'releases_base_$seriesId';

  @override
  bool build() => false;

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
    if (!network.allows(wifiOnly: options.wifiOnly)) return;
    await run();
  }

  /// Checks now; returns the number of new alerts. [all]: every followed
  /// series ("Vérifier maintenant"), not the next [seriesPerRun].
  Future<int> run({bool all = false}) async {
    if (state) return 0;
    state = true;
    var found = 0;
    try {
      final repo = ref.read(collectionRepositoryProvider);
      final series = [
        for (final s in await repo.listSeries())
          if (s.followed) s,
      ];
      final authors = await ref.read(releasesRepositoryProvider).listFollowed();
      // Nothing followed: no need to load the collection.
      if (series.isNotEmpty || authors.isNotEmpty) {
        final items = await repo.listItems();
        await ref.read(releasesRepositoryProvider).closeOwned(items);
        found += await _checkSeries(series, items, all: all);
        found += await _checkAuthors(authors, items);
      }
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
    state = false;
    return found;
  }

  Future<int> _checkSeries(
    List<Series> followed,
    List<Item> items, {
    required bool all,
  }) async {
    followed.sort((a, b) => a.id.compareTo(b.id));
    if (followed.isEmpty) return 0;
    final store = ref.read(appSettingsStoreProvider);
    final start =
        (int.tryParse(await store.get(_cursor) ?? '') ?? 0) % followed.length;
    final batch = all
        ? followed
        : [
            for (var i = 0; i < followed.length && i < seriesPerRun; i++)
              followed[(start + i) % followed.length],
          ];
    if (!all) await store.set(_cursor, '${start + batch.length}');
    final now = ref.read(clockProvider)();
    final source = ref.read(seriesCatalogSourceProvider);
    final alerts = ref.read(releasesRepositoryProvider);
    final known = await alerts.knownKeys();
    var found = 0;
    for (final s in batch) {
      try {
        final own = items.where((i) => i.seriesId == s.id).toList();
        final publisher =
            s.publisher ?? own.map((i) => i.publisher).nonNulls.firstOrNull;
        final edition = editionOf(
          buildCatalog(s.title, await source.volumesOf(s.title)),
          publisher,
        );
        if (edition == null) continue;
        final baseline = int.tryParse(
          await store.get(_baselineKey(s.id)) ?? '',
        );
        // First check of a series: only the volumes out this year or last
        // year (old ones are missing volumes, not news), then what exists
        // becomes the reference.
        final first = baseline == null;
        if (first) {
          await store.set(
            _baselineKey(s.id),
            '${edition.volumes.map((v) => v.number).fold<int>(0, math.max)}',
          );
        }
        final prefix = 'series:${s.id}:';
        final next = nextVolumes(
          own,
          edition,
          baseline: baseline ?? 0,
          where: first ? (v) => isRecentRelease(v.preferred, now) : null,
          alerted: {
            for (final k in known)
              if (k.startsWith(prefix))
                ?int.tryParse(k.substring(prefix.length)),
            // Already announced through a followed author (same ISBN):
            // addIfNew would refuse it and block the volumes after it.
            for (final v in edition.volumes)
              if (v.preferred.isbn13 case final isbn?
                  when known.contains('isbn:$isbn'))
                v.number,
          },
        );
        for (final v in next) {
          final r = v.preferred;
          final added = await alerts.addIfNew(
            releaseAlertOf(
              r,
              key: '$prefix${v.number}',
              kind: AlertKind.serie,
              type: s.type,
              title: s.title,
              seriesId: s.id,
              volumeNumber: '${v.number}',
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

  Future<int> _checkAuthors(List<FollowedAuthor> authors, List<Item> items) =>
      checkFollowedAuthors(
        authors,
        items,
        store: ref.read(appSettingsStoreProvider),
        alerts: ref.read(releasesRepositoryProvider),
        sources: ref.read(suggestionSourcesProvider),
        now: ref.read(clockProvider)(),
      );
}
