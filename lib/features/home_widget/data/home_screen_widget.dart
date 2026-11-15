import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_widget.g.dart';

/// The Android home-screen widget (PLAN_V3 phase 19, native part:
/// `DupeWidgetProvider.kt`). Its "Scanner" button opens `dupe://scan`.
abstract interface class HomeScreenWidget {
  /// Link the app was launched with from the widget, or null.
  Future<Uri?> initialLaunch();

  /// Links of the widget taps while the app is running.
  Stream<Uri?> get taps;

  /// Shows [counts] (already formatted) on the widget.
  Future<void> showCounts(String counts);
}

/// home_widget plugin; does nothing outside Android (no implementation).
class PluginHomeScreenWidget implements HomeScreenWidget {
  const new();

  static const _provider = 'DupeWidgetProvider';

  bool get _android => defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<Uri?> initialLaunch() async =>
      _android ? await HomeWidget.initiallyLaunchedFromHomeWidget() : null;

  @override
  Stream<Uri?> get taps =>
      _android ? HomeWidget.widgetClicked : const Stream.empty();

  @override
  Future<void> showCounts(String counts) async {
    if (!_android) return;
    await HomeWidget.saveWidgetData<String>('counts', counts);
    await HomeWidget.updateWidget(androidName: _provider);
  }
}

/// Overridden in tests (no platform channel).
@Riverpod(keepAlive: true)
HomeScreenWidget homeScreenWidget(Ref ref) => const PluginHomeScreenWidget();
