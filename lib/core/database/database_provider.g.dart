// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The local database, the app's source of truth. Overridden in tests.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// The local database, the app's source of truth. Overridden in tests.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// The local database, the app's source of truth. Overridden in tests.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'365ef3f215d780c29a21b6328f0b547a8363c6a6';

/// Current time; overridable in tests.

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// Current time; overridable in tests.

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// Current time; overridable in tests.
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

/// Client-side id generator (UUID v7: time-ordered, index friendly).

@ProviderFor(idGenerator)
final idGeneratorProvider = IdGeneratorProvider._();

/// Client-side id generator (UUID v7: time-ordered, index friendly).

final class IdGeneratorProvider
    extends
        $FunctionalProvider<
          String Function(),
          String Function(),
          String Function()
        >
    with $Provider<String Function()> {
  /// Client-side id generator (UUID v7: time-ordered, index friendly).
  IdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idGeneratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idGeneratorHash();

  @$internal
  @override
  $ProviderElement<String Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String Function() create(Ref ref) {
    return idGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String Function()>(value),
    );
  }
}

String _$idGeneratorHash() => r'd6d383eff8fa4cdc20f04ac3b720942b8f184642';

@ProviderFor(appSettingsStore)
final appSettingsStoreProvider = AppSettingsStoreProvider._();

final class AppSettingsStoreProvider
    extends
        $FunctionalProvider<
          AppSettingsStore,
          AppSettingsStore,
          AppSettingsStore
        >
    with $Provider<AppSettingsStore> {
  AppSettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsStoreHash();

  @$internal
  @override
  $ProviderElement<AppSettingsStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppSettingsStore create(Ref ref) {
    return appSettingsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettingsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettingsStore>(value),
    );
  }
}

String _$appSettingsStoreHash() => r'280d649999e65d0d6d4a942c57021d5daf0c7b29';

/// On-disk cache of metadata source answers.

@ProviderFor(responseStore)
final responseStoreProvider = ResponseStoreProvider._();

/// On-disk cache of metadata source answers.

final class ResponseStoreProvider
    extends $FunctionalProvider<ResponseStore, ResponseStore, ResponseStore>
    with $Provider<ResponseStore> {
  /// On-disk cache of metadata source answers.
  ResponseStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'responseStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$responseStoreHash();

  @$internal
  @override
  $ProviderElement<ResponseStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResponseStore create(Ref ref) {
    return responseStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResponseStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResponseStore>(value),
    );
  }
}

String _$responseStoreHash() => r'33a90ebcac0beb80706c397098d713a9567a0f9d';
