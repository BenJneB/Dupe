import 'package:dupe/features/scan/data/app_shortcuts.dart';
import 'package:flutter/foundation.dart';

/// Records the shortcut; [openScan] simulates a launch from it.
class FakeAppShortcuts implements AppShortcuts {
  String? scanTitle;
  late VoidCallback _onScan;

  void openScan() => _onScan();

  @override
  Future<void> setUp({
    required String scanTitle,
    required VoidCallback onScan,
  }) async {
    this.scanTitle = scanTitle;
    _onScan = onScan;
  }
}
