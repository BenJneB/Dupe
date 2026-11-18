import 'dart:async';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/sync/clock_check.dart';
import 'package:dupe/core/sync/sync_codec.dart';
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
  const new(
    this.phase, {
    this.email,
    this.lastSync,
    this.error,
    this.clockSkew,
  });

  final SyncPhase phase;
  final String? email;
  final DateTime? lastSync;

  /// Cause of [SyncPhase.failed] (shown with `errorText`).
  final Object? error;

  /// Device clock minus server clock, when wrong ([ClockCheck]).
  final Duration? clockSkew;

  SyncState to(SyncPhase phase, {DateTime? lastSync, Object? error}) =>
      SyncState(
        phase,
        email: email,
        lastSync: lastSync ?? this.lastSync,
        error: error,
        clockSkew: clockSkew,
      );

  SyncState withClockSkew(Duration? skew) => SyncState(
    phase,
    email: email,
    lastSync: lastSync,
    error: error,
    clockSkew: skew,
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
  StreamSubscription<Object?>? _localChanges;
  Future<void>? _running;
  DateTime? _clockCheckedAt;
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
    // Triggers off: signed out until now (not the phase, which a sync
    // finishing after a sign-out could have overwritten).
    if (_lifecycle == null) {
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
    _localChanges = db
        .tableUpdates(TableUpdateQuery.onAllTables(SyncCodec(db).tables))
        .listen((_) {
          _debounce?.cancel();
          _debounce = Timer(debounce, () => unawaited(_syncIfPending()));
        });
  }

  void _stopTriggers() {
    _periodic?.cancel();
    _periodic = null;
    _debounce?.cancel();
    _lifecycle?.dispose();
    _lifecycle = null;
    unawaited(_localChanges?.cancel());
    _localChanges = null;
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
    // Signed out (or another account) meanwhile: the state is no longer
    // this sync's to set.
    bool ended() => ref.read(syncAuthProvider).userId != userId;
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
          userId: userId,
        );
      }
      if (ended()) return;
      state = state.to(SyncPhase.idle, lastSync: ref.read(clockProvider)());
      await _checkClock();
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
      if (!ended()) state = state.to(phase, error: e);
      return;
    }
    _lastFailure = (phase: null, text: null);
  }

  /// Compares the device clock with the server at most once per hour; never
  /// fails the sync.
  Future<void> _checkClock() async {
    final now = ref.read(clockProvider)();
    final last = _clockCheckedAt;
    if (last != null && now.difference(last) < ClockCheck.every) return;
    _clockCheckedAt = now;
    final server = await ref.read(syncRemoteProvider)?.serverTime();
    if (server == null) return;
    final skew = ClockCheck.skew(ref.read(clockProvider)(), server);
    if (skew != null && state.clockSkew == null) {
      appLog.warning('sync', 'Device clock off by ${skew.inMinutes} min');
    }
    state = state.withClockSkew(skew);
  }

  Future<void> signOut() async {
    await _running;
    await ref.read(syncAuthProvider).signOut();
    await ref.read(syncEngineProvider)?.reset();
  }
}
