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
/// check, in turn. State: a check is running.

@ProviderFor(ReleaseChecker)
final releaseCheckerProvider = ReleaseCheckerProvider._();

/// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
/// day (at start-up): followed series at the BnF (volumes after the last
/// known one), followed authors (ISBNs not seen at the previous check).
/// The sources' rate limiters and caches apply; [seriesPerRun] series per
/// check, in turn. State: a check is running.
final class ReleaseCheckerProvider
    extends $NotifierProvider<ReleaseChecker, bool> {
  /// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
  /// day (at start-up): followed series at the BnF (volumes after the last
  /// known one), followed authors (ISBNs not seen at the previous check).
  /// The sources' rate limiters and caches apply; [seriesPerRun] series per
  /// check, in turn. State: a check is running.
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
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$releaseCheckerHash() => r'b2928d9fee2fa9e289c03084e4e0df14bc1b3e09';

/// Looks for new releases (PLAN_V4 phase 33), on the device, at most once a
/// day (at start-up): followed series at the BnF (volumes after the last
/// known one), followed authors (ISBNs not seen at the previous check).
/// The sources' rate limiters and caches apply; [seriesPerRun] series per
/// check, in turn. State: a check is running.

abstract class _$ReleaseChecker extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
