package dev.dupe.dupe

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Store mode verdicts: real vibrations with explicit durations. The
        // system haptic constants of HapticFeedback all feel like the same
        // short tick on many phones ("heavy" is a CONTEXT_CLICK).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dev.dupe.dupe/vibration")
            .setMethodCallHandler { call, result ->
                if (call.method != "waveform") return@setMethodCallHandler result.notImplemented()
                val timings = call.argument<List<Int>>("timings").orEmpty()
                val amplitudes = call.argument<List<Int>>("amplitudes").orEmpty()
                vibrate(timings.map { it.toLong() }.toLongArray(), amplitudes.toIntArray())
                result.success(null)
            }
    }

    private fun vibrator(): Vibrator? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            (getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager)?.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        }

    /** [timings]: off, on, off, on… in ms; [amplitudes]: 0-255, one per timing. */
    private fun vibrate(timings: LongArray, amplitudes: IntArray) {
        val vibrator = vibrator() ?: return
        if (!vibrator.hasVibrator() || timings.isEmpty()) return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val effect = if (vibrator.hasAmplitudeControl() && amplitudes.size == timings.size) {
                VibrationEffect.createWaveform(timings, amplitudes, -1)
            } else {
                VibrationEffect.createWaveform(timings, -1)
            }
            vibrator.vibrate(effect)
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(timings, -1)
        }
    }
}
