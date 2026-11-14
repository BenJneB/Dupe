// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Supabase client, or null in local-only mode (no URL/key in env.json).

@ProviderFor(supabaseClient)
final supabaseClientProvider = SupabaseClientProvider._();

/// Supabase client, or null in local-only mode (no URL/key in env.json).

final class SupabaseClientProvider
    extends
        $FunctionalProvider<SupabaseClient?, SupabaseClient?, SupabaseClient?>
    with $Provider<SupabaseClient?> {
  /// Supabase client, or null in local-only mode (no URL/key in env.json).
  SupabaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseClientHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient? create(Ref ref) {
    return supabaseClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient?>(value),
    );
  }
}

String _$supabaseClientHash() => r'9dbad51f33d2736959c6ae9af00e5e2e6e86eb61';

@ProviderFor(syncAuth)
final syncAuthProvider = SyncAuthProvider._();

final class SyncAuthProvider
    extends $FunctionalProvider<SyncAuth, SyncAuth, SyncAuth>
    with $Provider<SyncAuth> {
  SyncAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncAuthHash();

  @$internal
  @override
  $ProviderElement<SyncAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncAuth create(Ref ref) {
    return syncAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncAuth>(value),
    );
  }
}

String _$syncAuthHash() => r'f41de2415c4f2ce2c5b1427aeb7bc47a362f486d';

@ProviderFor(syncRemote)
final syncRemoteProvider = SyncRemoteProvider._();

final class SyncRemoteProvider
    extends $FunctionalProvider<SyncRemote?, SyncRemote?, SyncRemote?>
    with $Provider<SyncRemote?> {
  SyncRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRemoteHash();

  @$internal
  @override
  $ProviderElement<SyncRemote?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncRemote? create(Ref ref) {
    return syncRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncRemote? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncRemote?>(value),
    );
  }
}

String _$syncRemoteHash() => r'82c2e66fbef80658221273ed0ec0a099e6d03027';

@ProviderFor(syncEngine)
final syncEngineProvider = SyncEngineProvider._();

final class SyncEngineProvider
    extends $FunctionalProvider<SyncEngine?, SyncEngine?, SyncEngine?>
    with $Provider<SyncEngine?> {
  SyncEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncEngineHash();

  @$internal
  @override
  $ProviderElement<SyncEngine?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncEngine? create(Ref ref) {
    return syncEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncEngine? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncEngine?>(value),
    );
  }
}

String _$syncEngineHash() => r'8c3c7714933f35ef51b0d0d8e934e834c6a3c52f';
