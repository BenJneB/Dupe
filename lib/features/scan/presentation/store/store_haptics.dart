import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/scan/domain/store_check.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_haptics.g.dart';

/// One vibration of a pattern; null = a pause between two.
typedef HapticStep = Future<void> Function()?;

/// Store mode: a different vibration per verdict, to know the answer
/// without looking (PLAN_V2 phase 13). Uses the system haptic feedback:
/// nothing happens when it is turned off in the phone settings.
class StoreHaptics {
  new(this._settings, {this._gap = const Duration(milliseconds: 160)});

  final AppSettingsStore _settings;
  final Duration _gap;

  static const enabledKey = 'store_haptics_enabled';

  Future<bool> get enabled async => await _settings.get(enabledKey) != '0';

  Future<void> setEnabled({required bool enabled}) =>
      _settings.set(enabledKey, enabled ? '1' : '0');

  /// Owned: one strong. Wished: two medium. Missing volume of a series:
  /// three light. Unknown: one tick.
  static List<HapticStep> pattern(StoreVerdict verdict) => switch (verdict) {
    StoreVerdict.owned => [HapticFeedback.heavyImpact],
    StoreVerdict.wished => [
      HapticFeedback.mediumImpact,
      null,
      HapticFeedback.mediumImpact,
    ],
    StoreVerdict.seriesNotOwned => [
      HapticFeedback.lightImpact,
      null,
      HapticFeedback.lightImpact,
      null,
      HapticFeedback.lightImpact,
    ],
    StoreVerdict.unknown => [HapticFeedback.selectionClick],
  };

  Future<void> play(StoreVerdict verdict) async {
    if (!await enabled) return;
    for (final step in pattern(verdict)) {
      if (step == null) {
        await Future<void>.delayed(_gap);
      } else {
        await step();
      }
    }
  }
}

@Riverpod(keepAlive: true)
StoreHaptics storeHaptics(Ref ref) =>
    StoreHaptics(ref.watch(appSettingsStoreProvider));
