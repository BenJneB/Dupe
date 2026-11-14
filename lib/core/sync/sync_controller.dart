import 'dart:async';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/core/sync/sync_remote.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/features/covers/data/cover_sync.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_controller.g.dart';

enum SyncPhase { localOnly, signedOut, idle, syncing, offline, failed }

@immutable
class SyncState {
  const new(this.phase, {this.email, this.lastSync, this.error});

  final SyncPhase phase;
  final String? email;
  final DateTime? lastSync;

  /// Cause of [SyncPhase.failed] (shown with `errorText`).
  final Object? error;

  SyncState to(SyncPhase phase, {DateTime? lastSync, Object? error}) =>
      SyncState(
        phase,
        email: email,
        lastSync: lastSync ?? this.lastSync,
        error: error,
      );
}

/// Runs the sync when signed in (PLAN.md §6): at start-up, when the app
/// comes back to the foreground, a few seconds after local changes, every
/// [period] while in the foreground (changes made on another device), and
/// on demand.
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  static const period = Duration(seconds: 30);
  static const debounce = Duration(seconds: 3);

  final _subscriptions = <StreamSubscription<Object?>>[];
  Timer? _periodic;
  Timer? _debounce;
  AppLifecycleListener? _lifecycle;
  Future<void>? _running;
  ({SyncPhase? phase, String? text}) _lastFailure = (phase: null, text: null);

  @override
  SyncState build() {
    final auth = ref.watch(syncAuthProvider);
    ref.onDispose(_stopTriggers);
    ref.onDispose(() {
      for (final s in _subscriptions) {
        unawaited(s.cancel());
      }
    });
    if (!auth.configured) return const SyncState(SyncPhase.localOnly);
    _subscriptions.add(auth.changes.listen((_) => _onAuthChanged()));
    unawaited(auth.restore());
    return const SyncState(SyncPhase.signedOut);
  }

  void _onAuthChanged() {
    final auth = ref.read(syncAuthProvider);
    final userId = auth.userId;
    if (userId == null) {
      _stopTriggers();
      state = const SyncState(SyncPhase.signedOut);
      return;
    }
    if (state.phase == SyncPhase.signedOut) {
      state = SyncState(SyncPhase.idle, email: auth.email);
      _startTriggers();
      unawaited(syncNow());
    }
  }

  void _startTriggers() {
    _periodic = Timer.periodic(period, (_) => unawaited(syncNow()));
    _lifecycle = AppLifecycleListener(
      onResume: () {
        _periodic ??= Timer.periodic(period, (_) => unawaited(syncNow()));
        unawaited(syncNow());
      },
      onHide: () {
        _periodic?.cancel();
        _periodic = null;
      },
    );
    final db = ref.read(appDatabaseProvider);
    _subscriptions.add(
      db
          .tableUpdates(
            TableUpdateQuery.onAllTables([
              db.seriesTable,
              db.itemsTable,
              db.loansTable,
            ]),
          )
          .listen((_) {
            _debounce?.cancel();
            _debounce = Timer(debounce, () => unawaited(_syncIfPending()));
          }),
    );
  }

  void _stopTriggers() {
    _periodic?.cancel();
    _periodic = null;
    _debounce?.cancel();
    _lifecycle?.dispose();
    _lifecycle = null;
  }

  Future<void> _syncIfPending() async {
    final engine = ref.read(syncEngineProvider);
    if (engine != null && await engine.hasPending()) await syncNow();
  }

  /// Synchronises now; concurrent calls share the running sync.
  Future<void> syncNow() =>
      _running ??= _sync().whenComplete(() => _running = null);

  Future<void> _sync() async {
    final userId = ref.read(syncAuthProvider).userId;
    final engine = ref.read(syncEngineProvider);
    if (userId == null || engine == null) return;
    state = state.to(SyncPhase.syncing);
    try {
      await engine.adoptUser(userId);
      final report = await engine.sync(userId);
      if (report.pushed + report.pulled > 0) {
        appLog.info('sync', 'sent ${report.pushed}, received ${report.pulled}');
      }
      if (ref.read(coverStoreProvider) case final store?) {
        await uploadPendingCovers(
          ref.read(appDatabaseProvider),
          ref.read(coverPhotosProvider),
          store,
          ref.read(appSettingsStoreProvider),
        );
      }
      state = state.to(SyncPhase.idle, lastSync: ref.read(clockProvider)());
    } on Object catch (e, stack) {
      final phase = e is SyncException && e.offline
          ? SyncPhase.offline
          : SyncPhase.failed;
      // Retried every 30 s: log a failure once, not at every attempt.
      if (phase != _lastFailure.phase || '$e' != _lastFailure.text) {
        if (phase == SyncPhase.offline) {
          appLog.warning('sync', e);
        } else {
          appLog.error('sync', e, stack);
        }
      }
      _lastFailure = (phase: phase, text: '$e');
      state = state.to(phase, error: e);
      return;
    }
    _lastFailure = (phase: null, text: null);
  }

  Future<void> signOut() async {
    await _running;
    await ref.read(syncAuthProvider).signOut();
    await ref.read(syncEngineProvider)?.reset();
  }
}
