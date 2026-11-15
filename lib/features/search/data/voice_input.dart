import 'dart:async';

import 'package:dupe/core/logging/app_log.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'voice_input.g.dart';

/// Dictation for the search (PLAN_V3 phase 19), French.
abstract interface class VoiceInput {
  /// Whether this platform can dictate (speech_to_text: Android, Windows;
  /// not Linux). The microphone permission is asked on first [listenOnce].
  bool get supported;

  /// Listens until the user stops talking; the recognised phrase, or null
  /// (nothing heard, permission refused, cancelled).
  Future<String?> listenOnce();

  /// Stops listening; [listenOnce] then completes with what was heard.
  Future<void> stop();
}

class SpeechToTextInput implements VoiceInput {
  final _speech = SpeechToText();
  Completer<String?>? _pending;
  var _heard = '';

  @override
  bool get supported => switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.windows => true,
    _ => false,
  };

  void _finish() {
    final pending = _pending;
    _pending = null;
    if (pending != null && !pending.isCompleted) {
      pending.complete(_heard.trim().isEmpty ? null : _heard.trim());
    }
  }

  @override
  Future<String?> listenOnce() async {
    final ready = await _speech.initialize(
      onError: (e) {
        appLog.warning('voice', e.errorMsg);
        _finish();
      },
      onStatus: (status) {
        if (status == SpeechToText.doneStatus) _finish();
      },
    );
    if (!ready) return null;
    _heard = '';
    final pending = _pending = Completer<String?>();
    await _speech.listen(
      onResult: (r) {
        _heard = r.recognizedWords;
        if (r.finalResult) _finish();
      },
      listenOptions: SpeechListenOptions(
        localeId: 'fr_FR',
        listenMode: ListenMode.search,
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 3),
        cancelOnError: true,
      ),
    );
    return await pending.future;
  }

  @override
  Future<void> stop() async {
    await _speech.stop();
    _finish();
  }
}

/// Overridden in tests (no microphone).
@Riverpod(keepAlive: true)
VoiceInput voiceInput(Ref ref) => SpeechToTextInput();
