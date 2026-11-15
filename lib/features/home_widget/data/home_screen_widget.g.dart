// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_screen_widget.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in tests (no platform channel).

@ProviderFor(homeScreenWidget)
final homeScreenWidgetProvider = HomeScreenWidgetProvider._();

/// Overridden in tests (no platform channel).

final class HomeScreenWidgetProvider
    extends
        $FunctionalProvider<
          HomeScreenWidget,
          HomeScreenWidget,
          HomeScreenWidget
        >
    with $Provider<HomeScreenWidget> {
  /// Overridden in tests (no platform channel).
  HomeScreenWidgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeScreenWidgetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeScreenWidgetHash();

  @$internal
  @override
  $ProviderElement<HomeScreenWidget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeScreenWidget create(Ref ref) {
    return homeScreenWidget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeScreenWidget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeScreenWidget>(value),
    );
  }
}

String _$homeScreenWidgetHash() => r'f9fd419ded944f3af9cc4d2abf5d9cb5d5de812d';
