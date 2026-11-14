// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs the sync when signed in (PLAN.md §6): at start-up, when the app
/// comes back to the foreground, a few seconds after local changes, every
/// [period] while in the foreground (changes made on another device), and
/// on demand.

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Runs the sync when signed in (PLAN.md §6): at start-up, when the app
/// comes back to the foreground, a few seconds after local changes, every
/// [period] while in the foreground (changes made on another device), and
/// on demand.
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncState> {
  /// Runs the sync when signed in (PLAN.md §6): at start-up, when the app
  /// comes back to the foreground, a few seconds after local changes, every
  /// [period] while in the foreground (changes made on another device), and
  /// on demand.
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncControllerHash() => r'074ea917cce02e7df5fbe1e4b9f78f979e7d0243';

/// Runs the sync when signed in (PLAN.md §6): at start-up, when the app
/// comes back to the foreground, a few seconds after local changes, every
/// [period] while in the foreground (changes made on another device), and
/// on demand.

abstract class _$SyncController extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
