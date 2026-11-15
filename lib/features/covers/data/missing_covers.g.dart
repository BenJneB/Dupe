// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_covers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Looks up, one by one, a cover for every item that has none or whose
/// cover does not download.

@ProviderFor(MissingCoversFill)
final missingCoversFillProvider = MissingCoversFillProvider._();

/// Looks up, one by one, a cover for every item that has none or whose
/// cover does not download.
final class MissingCoversFillProvider
    extends $NotifierProvider<MissingCoversFill, CoverFillState> {
  /// Looks up, one by one, a cover for every item that has none or whose
  /// cover does not download.
  MissingCoversFillProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'missingCoversFillProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missingCoversFillHash();

  @$internal
  @override
  MissingCoversFill create() => MissingCoversFill();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoverFillState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoverFillState>(value),
    );
  }
}

String _$missingCoversFillHash() => r'5bcad8acff16109a4c317512546f4a0af5b06f8d';

/// Looks up, one by one, a cover for every item that has none or whose
/// cover does not download.

abstract class _$MissingCoversFill extends $Notifier<CoverFillState> {
  CoverFillState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CoverFillState, CoverFillState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoverFillState, CoverFillState>,
              CoverFillState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
