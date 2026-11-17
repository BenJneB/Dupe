// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_isbn_fill.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Qualité (PLAN_V4 phase 37, every series at once): the volumes owned
/// without ISBN get the one of the BnF, edition chosen by the publisher of
/// the series. Nothing is created; a series whose edition is unclear is
/// skipped (to complete from its own menu).

@ProviderFor(SeriesIsbnFill)
final seriesIsbnFillProvider = SeriesIsbnFillProvider._();

/// Qualité (PLAN_V4 phase 37, every series at once): the volumes owned
/// without ISBN get the one of the BnF, edition chosen by the publisher of
/// the series. Nothing is created; a series whose edition is unclear is
/// skipped (to complete from its own menu).
final class SeriesIsbnFillProvider
    extends $NotifierProvider<SeriesIsbnFill, SeriesIsbnFillState> {
  /// Qualité (PLAN_V4 phase 37, every series at once): the volumes owned
  /// without ISBN get the one of the BnF, edition chosen by the publisher of
  /// the series. Nothing is created; a series whose edition is unclear is
  /// skipped (to complete from its own menu).
  SeriesIsbnFillProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seriesIsbnFillProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seriesIsbnFillHash();

  @$internal
  @override
  SeriesIsbnFill create() => SeriesIsbnFill();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeriesIsbnFillState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeriesIsbnFillState>(value),
    );
  }
}

String _$seriesIsbnFillHash() => r'4bc280f6f6242acfd83e1f68fab4b603bb98f990';

/// Qualité (PLAN_V4 phase 37, every series at once): the volumes owned
/// without ISBN get the one of the BnF, edition chosen by the publisher of
/// the series. Nothing is created; a series whose edition is unclear is
/// skipped (to complete from its own menu).

abstract class _$SeriesIsbnFill extends $Notifier<SeriesIsbnFillState> {
  SeriesIsbnFillState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SeriesIsbnFillState, SeriesIsbnFillState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SeriesIsbnFillState, SeriesIsbnFillState>,
              SeriesIsbnFillState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
