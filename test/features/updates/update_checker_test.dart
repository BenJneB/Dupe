import 'dart:ffi' show Abi;

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/updates/data/update_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http.dart';

void main() {
  late AppDatabase db;
  late FakeHttpAdapter http;
  var now = DateTime(2026, 11, 14, 9);
  var installed = '1.0.0';

  UpdateChecker checker({TargetPlatform platform = TargetPlatform.linux}) =>
      UpdateChecker(
        fakeDio(http),
        AppSettingsStore(db),
        now: () => now,
        installedVersion: () async => installed,
        platform: platform,
        abi: Abi.linuxX64,
      );

  setUp(() {
    db = AppDatabase.memory();
    // Real response of a public release that ships AppImages.
    http = FakeHttpAdapter()
      ..on(
        (u) => u == UpdateChecker.latestRelease,
        fixture('github/release_appimagetool_1.9.1.json'),
      );
    now = DateTime(2026, 11, 14, 9);
    installed = '1.0.0';
  });
  tearDown(() => db.close());

  test('versions compare numerically', () {
    expect(UpdateChecker.compareVersions('1.10.0', '1.9.3'), 1);
    expect(UpdateChecker.compareVersions('1.2', '1.2.0+7'), 0);
    expect(UpdateChecker.compareVersions('0.9', '1.0.0'), -1);
  });

  test('picks the file of this platform', () {
    final assets = [
      for (final n in [
        'dupe-1.2.0-arm64-v8a.apk',
        'dupe-1.2.0-armeabi-v7a.apk',
        'dupe-1.2.0-x86_64.apk',
        'Dupe-1.2.0-x86_64.AppImage',
        'Dupe-1.2.0-setup.exe',
      ])
        (name: n, url: Uri.parse('https://example.org/$n')),
    ];
    String? pick(TargetPlatform p, Abi abi) =>
        UpdateChecker.assetFor(assets, p, abi)?.name;
    expect(
      pick(TargetPlatform.android, Abi.androidArm64),
      'dupe-1.2.0-arm64-v8a.apk',
    );
    expect(
      pick(TargetPlatform.android, Abi.androidArm),
      'dupe-1.2.0-armeabi-v7a.apk',
    );
    expect(
      pick(TargetPlatform.linux, Abi.linuxX64),
      'Dupe-1.2.0-x86_64.AppImage',
    );
    expect(
      pick(TargetPlatform.windows, Abi.windowsX64),
      'Dupe-1.2.0-setup.exe',
    );
    expect(pick(TargetPlatform.iOS, Abi.iosArm64), isNull);
  });

  test('a newer release is reported once a day', () async {
    final update = (await checker().check())!;
    expect(update.version, '1.9.1');
    expect(update.page.path, '/AppImage/appimagetool/releases/tag/1.9.1');
    expect(
      update.download.toString(),
      endsWith('appimagetool-x86_64.AppImage'),
    );

    expect(await checker().check(), isNull);
    expect(http.requests, hasLength(1));
    expect(await checker().check(force: true), isNotNull);

    now = now.add(const Duration(days: 1));
    installed = '1.9.1';
    expect(await checker().check(), isNull);
    expect(http.requests, hasLength(3));
  });

  test('no request when disabled; the page when no file fits', () async {
    await checker().setEnabled(enabled: false);
    expect(await checker().check(), isNull);
    expect(http.requests, isEmpty);

    final update = await checker(platform: TargetPlatform.windows)
        .check(force: true);
    expect(update!.download, isNull);
  });
}
