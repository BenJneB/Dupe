import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/releases/data/release_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'release_settings.g.dart';

typedef ReleaseOptions = ({bool enabled, bool wifiOnly, bool notify});

/// New release checks, per device (local `app_settings`): on, Wi-Fi only
/// and notifications by default.
@Riverpod(keepAlive: true)
class ReleaseSettings extends _$ReleaseSettings {
  static const _enabled = 'releases_enabled';
  static const _wifi = 'releases_wifi_only';
  static const _notify = 'releases_notify';

  /// All on: a missing setting reads as on.
  static const ReleaseOptions defaults = (
    enabled: true,
    wifiOnly: true,
    notify: true,
  );

  AppSettingsStore get _store => ref.read(appSettingsStoreProvider);

  @override
  Future<ReleaseOptions> build() async {
    final store = ref.watch(appSettingsStoreProvider);
    Future<bool> on(String key) => store.getBool(key, orElse: true);
    return (
      enabled: await on(_enabled),
      wifiOnly: await on(_wifi),
      notify: await on(_notify),
    );
  }

  Future<void> set({bool? enabled, bool? wifiOnly, bool? notify}) async {
    for (final (key, value) in [
      (_enabled, enabled),
      (_wifi, wifiOnly),
      (_notify, notify),
    ]) {
      if (value != null) await _store.setBool(key, value: value);
    }
    ref.invalidateSelf();
    await scheduleBackground();
  }

  /// The Android background check follows these settings (start-up and
  /// every change).
  Future<void> scheduleBackground() async {
    final options = await future;
    await ref.read(releaseBackgroundProvider).schedule(options);
  }
}
