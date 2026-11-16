import 'dart:async';

import 'package:dupe/core/database/database_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

/// Light / dark / system theme, persisted in `app_settings`.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  static const _key = 'theme_mode';

  /// A theme chosen before the saved one was read: the saved one is older.
  var _chosen = false;

  @override
  ThemeMode build() {
    unawaited(_load());
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final saved = await ref.read(appSettingsStoreProvider).get(_key);
    final mode = ThemeMode.values.where((m) => m.name == saved).firstOrNull;
    if (mode != null && !_chosen) state = mode;
  }

  Future<void> set(ThemeMode mode) async {
    _chosen = true;
    state = mode;
    await ref.read(appSettingsStoreProvider).set(_key, mode.name);
  }
}
