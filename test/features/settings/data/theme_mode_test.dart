import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/settings/data/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/test_repositories.dart';

void main() {
  test('a choice made while the saved theme loads is kept', () async {
    final env = TestEnv();
    addTearDown(env.dispose);
    await AppSettingsStore(env.db).set('theme_mode', ThemeMode.light.name);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(env.db)],
    );
    addTearDown(container.dispose);

    container.read(appThemeModeProvider); // Starts loading "light".
    await container.read(appThemeModeProvider.notifier).set(ThemeMode.dark);
    await pumpEventQueue();

    expect(container.read(appThemeModeProvider), ThemeMode.dark);
    expect(await AppSettingsStore(env.db).get('theme_mode'), 'dark');
  });
}
