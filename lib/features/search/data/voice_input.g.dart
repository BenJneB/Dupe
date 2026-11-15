// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_input.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in tests (no microphone).

@ProviderFor(voiceInput)
final voiceInputProvider = VoiceInputProvider._();

/// Overridden in tests (no microphone).

final class VoiceInputProvider
    extends $FunctionalProvider<VoiceInput, VoiceInput, VoiceInput>
    with $Provider<VoiceInput> {
  /// Overridden in tests (no microphone).
  VoiceInputProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceInputProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceInputHash();

  @$internal
  @override
  $ProviderElement<VoiceInput> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VoiceInput create(Ref ref) {
    return voiceInput(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceInput value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceInput>(value),
    );
  }
}

String _$voiceInputHash() => r'0338c21dc63a8827f936e8d41b34d9b7c9171256';
