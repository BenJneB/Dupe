// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_checker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
/// day (at start-up): followed series at the BnF (volumes after the last
/// known one), followed authors (ISBNs not seen at the previous check).
/// The sources' rate limiters and caches apply; [seriesPerRun] series per
/// check, in turn.

@ProviderFor(ReleaseChecker)
final releaseCheckerProvider = ReleaseCheckerProvider._();

/// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
/// day (at start-up): followed series at the BnF (volumes after the last
/// known one), followed authors (ISBNs not seen at the previous check).
/// The sources' rate limiters and caches apply; [seriesPerRun] series per
/// check, in turn.
final class ReleaseCheckerProvider
    extends $NotifierProvider<ReleaseChecker, ReleaseCheckState> {
  /// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
  /// day (at start-up): followed series at the BnF (volumes after the last
  /// known one), followed authors (ISBNs not seen at the previous check).
  /// The sources' rate limiters and caches apply; [seriesPerRun] series per
  /// check, in turn.
  ReleaseCheckerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseCheckerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseCheckerHash();

  @$internal
  @override
  ReleaseChecker create() => ReleaseChecker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReleaseCheckState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReleaseCheckState>(value),
    );
  }
}

String _$releaseCheckerHash() => r'09accf0a4429ed4e01b790cb9cf434c83d573838';

/// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
/// day (at start-up): followed series at the BnF (volumes after the last
/// known one), followed authors (ISBNs not seen at the previous check).
/// The sources' rate limiters and caches apply; [seriesPerRun] series per
/// check, in turn.

abstract class _$ReleaseChecker extends $Notifier<ReleaseCheckState> {
  ReleaseCheckState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReleaseCheckState, ReleaseCheckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReleaseCheckState, ReleaseCheckState>,
              ReleaseCheckState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
