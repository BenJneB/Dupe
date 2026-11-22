import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/core/logging/log_observer.dart';
import 'package:dupe/features/releases/data/release_checker.dart';
import 'package:dupe/features/releases/data/release_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workmanager/workmanager.dart';

part 'release_background.g.dart';

/// New releases checked in the background on Android (WorkManager), even
/// with the app closed: the same `ReleaseChecker.runIfDue` as at start-up
/// (at most once every 20 hours, Wi-Fi when asked). Elsewhere: start-up only.
abstract interface class ReleaseBackground {
  /// Schedules the periodic check with [options], or cancels it when off.
  Future<void> schedule(ReleaseOptions options);
}

@Riverpod(keepAlive: true)
ReleaseBackground releaseBackground(Ref ref) =>
    defaultTargetPlatform == TargetPlatform.android
    ? WorkManagerReleaseBackground()
    : const NoReleaseBackground();

class NoReleaseBackground implements ReleaseBackground {
  const new();

  @override
  Future<void> schedule(ReleaseOptions options) async {}
}

class WorkManagerReleaseBackground implements ReleaseBackground {
  static const taskName = 'dupe-releases';
  bool _initialized = false;

  @override
  Future<void> schedule(ReleaseOptions options) async {
    final manager = Workmanager();
    if (!_initialized) {
      await manager.initialize(releaseTaskDispatcher);
      _initialized = true;
    }
    if (!options.enabled) return await manager.cancelByUniqueName(taskName);
    await manager.registerPeriodicTask(
      taskName,
      taskName,
      // Twice the daily check: one run skipped by the 20 h guard, the next
      // one checks (WorkManager may delay a run).
      frequency: const Duration(hours: 12),
      constraints: Constraints(
        networkType: options.wifiOnly
            ? NetworkType.unmetered
            : NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );
  }
}

/// Entry point of the background engine started by WorkManager.
@pragma('vm:entry-point')
void releaseTaskDispatcher() {
  Workmanager().executeTask((_, _) => runReleaseTask());
}

/// The background check, with its own providers and database connection
/// (closed when done). Never fails the task: a failure is retried at the
/// next period. [overrides]: for tests.
Future<bool> runReleaseTask({List<Override> overrides = const []}) async {
  final container = ProviderContainer(
    overrides: overrides,
    observers: const [LogObserver()],
  );
  try {
    await container.read(releaseCheckerProvider.notifier).runIfDue();
  } on Object catch (e, stack) {
    appLog.error('releases', e, stack);
  } finally {
    container.dispose();
  }
  return true;
}
