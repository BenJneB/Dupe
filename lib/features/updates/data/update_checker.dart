import 'dart:async';
import 'dart:ffi' show Abi;

import 'package:dio/dio.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/core/network/http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_checker.g.dart';

/// A newer release: its page, and the file for this device when found.
typedef AvailableUpdate = ({String version, Uri page, Uri? download});

typedef ReleaseAsset = ({String name, Uri url});

/// "New version available" (PLAN_V2 phase 12): the latest GitHub release of
/// the (public) repository, anonymously, at most once a day.
class UpdateChecker {
  new(
    this._dio,
    this._settings, {
    required this._now,
    required this._installedVersion,
    required this.platform,
    required this.abi,
  });

  final Dio _dio;
  final AppSettingsStore _settings;
  final DateTime Function() _now;
  final Future<String> Function() _installedVersion;
  final TargetPlatform platform;
  final Abi abi;

  static final Uri latestRelease = Uri.parse(
    'https://api.github.com/repos/BenJneB/Dupe/releases/latest',
  );
  static const enabledKey = 'update_check_enabled';
  static const checkedOnKey = 'update_checked_on';

  Future<bool> get enabled async => await _settings.get(enabledKey) != '0';

  Future<void> setEnabled({required bool enabled}) =>
      _settings.set(enabledKey, enabled ? '1' : '0');

  /// Null when up to date, disabled, or already checked today (unless
  /// [force]), or when the repository has no release yet. Network errors
  /// are thrown.
  Future<AvailableUpdate?> check({bool force = false}) async {
    final today = _now().toIso8601String().substring(0, 10);
    if (!force) {
      if (!await enabled) return null;
      if (await _settings.get(checkedOnKey) == today) return null;
    }
    final Response<Map<String, dynamic>> response;
    try {
      response = await _dio.getUri<Map<String, dynamic>>(
        latestRelease,
        options: Options(headers: {'Accept': 'application/vnd.github+json'}),
      );
    } on DioException catch (e) {
      // 404: no published release yet (or only pre-releases): nothing new.
      if (e.response?.statusCode != 404) rethrow;
      await _settings.set(checkedOnKey, today);
      return null;
    }
    await _settings.set(checkedOnKey, today);
    final release = response.data!;
    final version = (release['tag_name'] as String).replaceFirst('v', '');
    if (compareVersions(version, await _installedVersion()) <= 0) return null;
    final assets = [
      for (final a in (release['assets'] as List<dynamic>? ?? const []))
        if (a case {
          'name': final String name,
          'browser_download_url': final String url,
        })
          (name: name, url: Uri.parse(url)),
    ];
    return (
      version: version,
      page: Uri.parse(release['html_url'] as String),
      download: assetFor(assets, platform, abi)?.url,
    );
  }

  /// The release file for this platform (APK of the device's ABI).
  static ReleaseAsset? assetFor(
    List<ReleaseAsset> assets,
    TargetPlatform platform,
    Abi abi,
  ) {
    final suffix = switch (platform) {
      TargetPlatform.android => switch (abi) {
        Abi.androidArm64 => '-arm64-v8a.apk',
        Abi.androidArm => '-armeabi-v7a.apk',
        Abi.androidX64 => '-x86_64.apk',
        _ => null,
      },
      TargetPlatform.linux => 'x86_64.AppImage',
      TargetPlatform.windows => '-setup.exe',
      _ => null,
    };
    if (suffix == null) return null;
    return assets.where((a) => a.name.endsWith(suffix)).firstOrNull;
  }

  /// Compares `1.2.10` and `1.10` numerically; missing parts are 0.
  static int compareVersions(String a, String b) {
    List<int> parts(String v) => [
      for (final p in v.split('+').first.split('.')) int.tryParse(p) ?? 0,
    ];
    final (x, y) = (parts(a), parts(b));
    for (var i = 0; i < x.length || i < y.length; i++) {
      final c = (i < x.length ? x[i] : 0).compareTo(i < y.length ? y[i] : 0);
      if (c != 0) return c;
    }
    return 0;
  }
}

@riverpod
UpdateChecker updateChecker(Ref ref) => UpdateChecker(
  createHttpClient(),
  ref.watch(appSettingsStoreProvider),
  now: ref.watch(clockProvider),
  installedVersion: () async => (await PackageInfo.fromPlatform()).version,
  platform: defaultTargetPlatform,
  abi: Abi.current(),
);
