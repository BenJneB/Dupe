import 'package:flutter/foundation.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_shortcuts.g.dart';

/// Long press on the app icon → "Scan" (Android only).
abstract interface class AppShortcuts {
  /// Registers the shortcut; [onScan] runs when it opens the app.
  Future<void> setUp({required String scanTitle, required VoidCallback onScan});
}

class QuickActionsShortcuts implements AppShortcuts {
  const new();

  static const scanType = 'scan';

  @override
  Future<void> setUp({
    required String scanTitle,
    required VoidCallback onScan,
  }) async {
    // The plugin has no desktop implementation.
    if (defaultTargetPlatform != TargetPlatform.android) return;
    const actions = QuickActions();
    await actions.initialize((type) {
      if (type == scanType) onScan();
    });
    await actions.setShortcutItems([
      ShortcutItem(
        type: scanType,
        localizedTitle: scanTitle,
        icon: 'ic_shortcut_scan',
      ),
    ]);
  }
}

/// Overridden in tests (no platform channel).
@Riverpod(keepAlive: true)
AppShortcuts appShortcuts(Ref ref) => const QuickActionsShortcuts();
