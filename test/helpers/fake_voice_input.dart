import 'package:dupe/features/search/data/voice_input.dart';

/// Dictation without a microphone: the given phrases are "heard" in order.
class FakeVoiceInput implements VoiceInput {
  new({this.supported = true, List<String?> phrases = const []})
    : _phrases = [...phrases];

  @override
  final bool supported;
  final List<String?> _phrases;
  int listens = 0;

  @override
  Future<String?> listenOnce() async {
    listens++;
    return _phrases.isEmpty ? null : _phrases.removeAt(0);
  }

  @override
  Future<void> stop() async {}
}
