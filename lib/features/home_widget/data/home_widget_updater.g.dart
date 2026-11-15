// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_widget_updater.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the counters of the home-screen widget up to date: [delay] after
/// the last change of items or loans (local edits and sync alike), so that
/// an import or a sync refreshes the widget once, not for every row.

@ProviderFor(HomeWidgetUpdater)
final homeWidgetUpdaterProvider = HomeWidgetUpdaterProvider._();

/// Keeps the counters of the home-screen widget up to date: [delay] after
/// the last change of items or loans (local edits and sync alike), so that
/// an import or a sync refreshes the widget once, not for every row.
final class HomeWidgetUpdaterProvider
    extends $NotifierProvider<HomeWidgetUpdater, void> {
  /// Keeps the counters of the home-screen widget up to date: [delay] after
  /// the last change of items or loans (local edits and sync alike), so that
  /// an import or a sync refreshes the widget once, not for every row.
  HomeWidgetUpdaterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeWidgetUpdaterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeWidgetUpdaterHash();

  @$internal
  @override
  HomeWidgetUpdater create() => HomeWidgetUpdater();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$homeWidgetUpdaterHash() => r'419af89dfb96826ca56bfb0735b7b823f305533e';

/// Keeps the counters of the home-screen widget up to date: [delay] after
/// the last change of items or loans (local edits and sync alike), so that
/// an import or a sync refreshes the widget once, not for every row.

abstract class _$HomeWidgetUpdater extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
