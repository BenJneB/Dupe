import 'dart:async';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/network/network_status.dart';
import 'package:dupe/features/covers/data/cover_cache.dart';
import 'package:dupe/features/covers/data/cover_photos.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cover_prefetch.g.dart';

/// Why the prefetch is not running.
enum PrefetchPause { disabled, offline, metered }

/// Progress of the cover prefetch.
@immutable
class PrefetchState {
  const new({
    this.running = false,
    this.done = 0,
    this.total = 0,
    this.failed = 0,
    this.pause,
  });

  final bool running;

  /// Covers checked so far (already there, downloaded or failed).
  final int done;
  final int total;
  final int failed;
  final PrefetchPause? pause;

  /// The last run went through every cover.
  bool get complete => !running && pause == null && total > 0 && done == total;
}

/// "Couvertures hors ligne" settings.
class PrefetchSettings {
  const new(this._settings);

  final AppSettingsStore _settings;

  static const enabledKey = 'cover_prefetch_enabled';
  static const wifiOnlyKey = 'cover_prefetch_wifi_only';

  Future<bool> get enabled async => await _settings.get(enabledKey) != '0';

  Future<bool> get wifiOnly async => await _settings.get(wifiOnlyKey) != '0';

  Future<void> setEnabled({required bool enabled}) =>
      _settings.set(enabledKey, enabled ? '1' : '0');

  Future<void> setWifiOnly({required bool wifiOnly}) =>
      _settings.set(wifiOnlyKey, wifiOnly ? '1' : '0');
}

@riverpod
PrefetchSettings prefetchSettings(Ref ref) =>
    PrefetchSettings(ref.watch(appSettingsStoreProvider));

/// Every cover of the collection and the wishlist (items and series).
Future<List<String>> coverUrls(AppDatabase db) async {
  const live =
      "deleted_at IS NULL AND cover_url IS NOT NULL AND cover_url <> ''";
  final rows = await db
      .customSelect(
        'SELECT cover_url FROM items WHERE $live '
        'UNION SELECT cover_url FROM series WHERE $live '
        // A stable order: the same failures give the same journal entry.
        'ORDER BY cover_url',
        readsFrom: {db.itemsTable, db.seriesTable},
      )
      .get();
  return [for (final row in rows) row.read<String>('cover_url')];
}

/// Downloads in the background every cover not on the device yet, so that
/// the collection shows its covers offline (PLAN_V3 phase 20). Runs at
/// start-up, on resume and when the connection changes; stops as soon as
/// the connection is no longer allowed (Wi-Fi only by default).
@Riverpod(keepAlive: true)
class CoverPrefetch extends _$CoverPrefetch {
  /// Incremented to cancel the current run.
  var _run = 0;
  var _wifiOnly = true;

  /// Failures last written to the journal (count and listed addresses): a
  /// run that fails on the same covers (resume, connection changes) does not
  /// repeat them during this execution of the app.
  String? _loggedFailures;

  @override
  PrefetchState build() {
    final changes = ref
        .watch(networkStatusProvider)
        .changes
        .listen(_onNetwork, onError: (Object e) => appLog.warning('covers', e));
    final lifecycle = AppLifecycleListener(onResume: () => unawaited(start()));
    ref.onDispose(() {
      _run++;
      unawaited(changes.cancel());
      lifecycle.dispose();
    });
    return const PrefetchState();
  }

  bool _allowed(NetworkKind kind) => kind.allows(wifiOnly: _wifiOnly);

  void _onNetwork(NetworkKind kind) {
    if (!state.running) {
      unawaited(start());
    } else if (!_allowed(kind)) {
      _run++;
      state = _paused(kind);
    }
  }

  PrefetchState _paused(NetworkKind kind) => PrefetchState(
    done: state.done,
    total: state.total,
    failed: state.failed,
    pause: kind == NetworkKind.none
        ? PrefetchPause.offline
        : PrefetchPause.metered,
  );

  /// Stops the current run (if any) and starts again: after a settings
  /// change or from the "Télécharger maintenant" button.
  Future<void> restart() {
    _run++;
    state = const PrefetchState();
    return start();
  }

  Future<void> start() async {
    if (state.running) return;
    final run = ++_run;
    final settings = ref.read(prefetchSettingsProvider);
    if (!await settings.enabled) {
      state = const PrefetchState(pause: PrefetchPause.disabled);
      return;
    }
    _wifiOnly = await settings.wifiOnly;
    final kind = await ref.read(networkStatusProvider).current();
    if (run != _run) return;
    if (!_allowed(kind)) {
      state = _paused(kind);
      return;
    }
    final urls = await coverUrls(ref.read(appDatabaseProvider));
    if (run != _run) return;
    state = PrefetchState(running: urls.isNotEmpty, total: urls.length);
    var failed = 0;
    final failures = <String>[];
    for (final (i, url) in urls.indexed) {
      if (await _fetch(url) case final error?) {
        failed++;
        if (failures.length < 20) failures.add('$url ($error)');
      }
      if (run != _run) return; // Cancelled: the new state is already set.
      state = PrefetchState(
        running: i + 1 < urls.length,
        done: i + 1,
        total: urls.length,
        failed: failed,
      );
    }
    final report = '$failed\n${failures.join('\n')}';
    if (failed > 0 && report != _loggedFailures) {
      appLog.info(
        'covers',
        '$failed couverture(s) non téléchargée(s) :\n${failures.join('\n')}',
      );
    }
    _loggedFailures = failed > 0 ? report : null;
  }

  /// Why the cover could not be downloaded; null when it is on the device.
  Future<String?> _fetch(String url) async {
    try {
      if (CoverPhotos.nameOf(url) case final name?) {
        final file = await ensureUserCover(
          ref.read(coverPhotosProvider),
          ref.read(coverStoreProvider),
          name,
        );
        return file == null ? 'photo absente' : null;
      }
      final cache = ref.read(coverCacheProvider);
      if (!await cache.has(url)) await cache.fetch(url);
      return null;
    } on Object catch (e) {
      return coverError(e);
    }
  }
}
