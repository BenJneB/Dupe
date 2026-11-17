import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
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

  AppSettingsStore get _store => ref.read(appSettingsStoreProvider);

  @override
  Future<ReleaseOptions> build() async {
    final store = ref.watch(appSettingsStoreProvider);
    Future<bool> on(String key) async => await store.get(key) != '0';
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
      if (value != null) await _store.set(key, value ? '1' : '0');
    }
    ref.invalidateSelf();
  }
}
