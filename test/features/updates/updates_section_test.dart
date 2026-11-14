import 'dart:ffi' show Abi;

import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/updates/data/update_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_http.dart';
import '../../helpers/screen_helpers.dart';

void main() {
  testWidgets('settings: check now, then turn the notice off', (tester) async {
    final http = FakeHttpAdapter()
      ..on(
        (u) => u == UpdateChecker.latestRelease,
        fixture('github/release_appimagetool_1.9.1.json'),
      );
    late AppSettingsStore settings;
    await pumpApp(
      tester,
      overrides: [
        updateCheckerProvider.overrideWith((ref) {
          return UpdateChecker(
            fakeDio(http),
            settings,
            now: () => DateTime(2026, 11, 14),
            installedVersion: () async => '1.0.0',
            platform: TargetPlatform.linux,
            abi: Abi.linuxX64,
          );
        }),
      ],
      seed: (db) async => settings = AppSettingsStore(db),
    );
    await openSettings(tester);

    await tapTile(tester, 'checkUpdateNow');
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('Version 1.9.1 disponible'), findsOneWidget);
    expect(find.text('Télécharger'), findsOneWidget);

    await tapTile(tester, 'updateCheckSwitch');
    await tester.pumpAndSettle();
    final enabled = await tester.runAsync(
      () => settings.get(UpdateChecker.enabledKey),
    );
    expect(enabled, '0');
  });
}
