import 'package:dupe/core/database/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volume_view_provider.g.dart';

/// Series screen: volumes as a list (cover, title, status) instead of the
/// grid of pastilles. Remembered on this device.
@Riverpod(keepAlive: true)
class VolumesAsList extends _$VolumesAsList {
  static const settingKey = 'series_volumes_as_list';

  @override
  Future<bool> build() async =>
      await ref.watch(appSettingsStoreProvider).get(settingKey) == '1';

  Future<void> toggle() async {
    final asList = !(state.value ?? false);
    state = AsyncData(asList);
    await ref
        .read(appSettingsStoreProvider)
        .set(settingKey, asList ? '1' : '0');
  }
}
