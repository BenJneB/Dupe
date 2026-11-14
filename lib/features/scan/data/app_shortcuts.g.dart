// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_shortcuts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in tests (no platform channel).

@ProviderFor(appShortcuts)
final appShortcutsProvider = AppShortcutsProvider._();

/// Overridden in tests (no platform channel).

final class AppShortcutsProvider
    extends $FunctionalProvider<AppShortcuts, AppShortcuts, AppShortcuts>
    with $Provider<AppShortcuts> {
  /// Overridden in tests (no platform channel).
  AppShortcutsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appShortcutsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appShortcutsHash();

  @$internal
  @override
  $ProviderElement<AppShortcuts> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppShortcuts create(Ref ref) {
    return appShortcuts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppShortcuts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppShortcuts>(value),
    );
  }
}

String _$appShortcutsHash() => r'b8712e4caf54dee1150a3541f22a19bde87072ee';
