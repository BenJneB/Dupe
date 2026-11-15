// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_backups.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in tests (memory).

@ProviderFor(backupStore)
final backupStoreProvider = BackupStoreProvider._();

/// Overridden in tests (memory).

final class BackupStoreProvider
    extends $FunctionalProvider<BackupStore, BackupStore, BackupStore>
    with $Provider<BackupStore> {
  /// Overridden in tests (memory).
  BackupStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupStoreHash();

  @$internal
  @override
  $ProviderElement<BackupStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BackupStore create(Ref ref) {
    return backupStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupStore>(value),
    );
  }
}

String _$backupStoreHash() => r'0b281d773cf02d2906e038ed54d7d7accd95c3fb';

@ProviderFor(autoBackups)
final autoBackupsProvider = AutoBackupsProvider._();

final class AutoBackupsProvider
    extends $FunctionalProvider<AutoBackups, AutoBackups, AutoBackups>
    with $Provider<AutoBackups> {
  AutoBackupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoBackupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoBackupsHash();

  @$internal
  @override
  $ProviderElement<AutoBackups> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AutoBackups create(Ref ref) {
    return autoBackups(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutoBackups value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutoBackups>(value),
    );
  }
}

String _$autoBackupsHash() => r'ce70ba2444a58f045b86785351b309acf2a21414';

@ProviderFor(autoBackupList)
final autoBackupListProvider = AutoBackupListProvider._();

final class AutoBackupListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AutoBackup>>,
          List<AutoBackup>,
          FutureOr<List<AutoBackup>>
        >
    with $FutureModifier<List<AutoBackup>>, $FutureProvider<List<AutoBackup>> {
  AutoBackupListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoBackupListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoBackupListHash();

  @$internal
  @override
  $FutureProviderElement<List<AutoBackup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AutoBackup>> create(Ref ref) {
    return autoBackupList(ref);
  }
}

String _$autoBackupListHash() => r'3ea24dfcde36fafee0725746a76d3bee48b59cba';
