import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/scan/domain/store_check.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_haptics.g.dart';

/// A vibration: `timings` off, on, off, on… in ms, one 0-255 `amplitudes`
/// value per timing (ignored by phones without amplitude control).
typedef Waveform = ({List<int> timings, List<int> amplitudes});

/// Store mode: a different vibration per verdict, to know the answer
/// without looking (PLAN_V2 phase 13). Real vibrations with explicit
/// durations (MainActivity): the system haptic constants of HapticFeedback
/// all felt like the same short tick. Nothing on desktop (no vibrator).
class StoreHaptics {
  new(this._settings);

  final AppSettingsStore _settings;

  static const enabledKey = 'store_haptics_enabled';
  static const channel = MethodChannel('dev.dupe.dupe/vibration');

  Future<bool> get enabled => _settings.getBool(enabledKey, orElse: true);

  Future<void> setEnabled({required bool enabled}) =>
      _settings.setBool(enabledKey, value: enabled);

  /// Owned: one long and strong. Wished: two medium. Missing volume of a
  /// series: three short. Unknown: one brief tick.
  static Waveform pattern(StoreVerdict verdict) => switch (verdict) {
    StoreVerdict.owned => (timings: [0, 400], amplitudes: [0, 255]),
    StoreVerdict.wished => (
      timings: [0, 150, 150, 150],
      amplitudes: [0, 180, 0, 180],
    ),
    StoreVerdict.seriesNotOwned => (
      timings: [0, 60, 120, 60, 120, 60],
      amplitudes: [0, 120, 0, 120, 0, 120],
    ),
    StoreVerdict.unknown => (timings: [0, 25], amplitudes: [0, 80]),
  };

  /// Burst mode: a light one per book queued, a brief tick for a duplicate.
  static Waveform queuedPattern({required bool added}) => added
      ? (timings: [0, 60], amplitudes: [0, 150])
      : (timings: [0, 25], amplitudes: [0, 80]);

  Future<void> play(StoreVerdict verdict) => _vibrate(pattern(verdict));

  Future<void> queued({required bool added}) =>
      _vibrate(queuedPattern(added: added));

  Future<void> _vibrate(Waveform waveform) async {
    if (!await enabled) return;
    try {
      await channel.invokeMethod<void>('waveform', {
        'timings': waveform.timings,
        'amplitudes': waveform.amplitudes,
      });
    } on MissingPluginException {
      // Desktop: no vibrator.
    }
  }
}

@Riverpod(keepAlive: true)
StoreHaptics storeHaptics(Ref ref) =>
    StoreHaptics(ref.watch(appSettingsStoreProvider));
