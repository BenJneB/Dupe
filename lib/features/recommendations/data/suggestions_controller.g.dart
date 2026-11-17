// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The suggestions screen state (PLAN_V4 phase 30): cached on this device a
/// week, computed in the background (kept alive: leaving the screen does
/// not stop it).

@ProviderFor(Suggestions)
final suggestionsProvider = SuggestionsProvider._();

/// The suggestions screen state (PLAN_V4 phase 30): cached on this device a
/// week, computed in the background (kept alive: leaving the screen does
/// not stop it).
final class SuggestionsProvider
    extends $NotifierProvider<Suggestions, SuggestionsState> {
  /// The suggestions screen state (PLAN_V4 phase 30): cached on this device a
  /// week, computed in the background (kept alive: leaving the screen does
  /// not stop it).
  SuggestionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suggestionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suggestionsHash();

  @$internal
  @override
  Suggestions create() => Suggestions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SuggestionsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SuggestionsState>(value),
    );
  }
}

String _$suggestionsHash() => r'52bc1a51885273e2e7acf7bfb64a406dfd88f08c';

/// The suggestions screen state (PLAN_V4 phase 30): cached on this device a
/// week, computed in the background (kept alive: leaving the screen does
/// not stop it).

abstract class _$Suggestions extends $Notifier<SuggestionsState> {
  SuggestionsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SuggestionsState, SuggestionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SuggestionsState, SuggestionsState>,
              SuggestionsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
