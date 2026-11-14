// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_keys.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keys entered in the app, in the local `app_settings` table: never synced,
/// never in backups (only series, items and loans are), never in the journal
/// (registered with [AppLog.hideSecret]).

@ProviderFor(SavedApiKeys)
final savedApiKeysProvider = SavedApiKeysProvider._();

/// Keys entered in the app, in the local `app_settings` table: never synced,
/// never in backups (only series, items and loans are), never in the journal
/// (registered with [AppLog.hideSecret]).
final class SavedApiKeysProvider
    extends $AsyncNotifierProvider<SavedApiKeys, Map<SourceId, String>> {
  /// Keys entered in the app, in the local `app_settings` table: never synced,
  /// never in backups (only series, items and loans are), never in the journal
  /// (registered with [AppLog.hideSecret]).
  SavedApiKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedApiKeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedApiKeysHash();

  @$internal
  @override
  SavedApiKeys create() => SavedApiKeys();
}

String _$savedApiKeysHash() => r'fb34f90f6e9769360e2536b8167f0095997702a6';

/// Keys entered in the app, in the local `app_settings` table: never synced,
/// never in backups (only series, items and loans are), never in the journal
/// (registered with [AppLog.hideSecret]).

abstract class _$SavedApiKeys extends $AsyncNotifier<Map<SourceId, String>> {
  FutureOr<Map<SourceId, String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<SourceId, String>>, Map<SourceId, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<SourceId, String>>,
                Map<SourceId, String>
              >,
              AsyncValue<Map<SourceId, String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Keys in use (saved first). Empty for a moment at start-up, until the saved
/// ones are read.

@ProviderFor(apiKeys)
final apiKeysProvider = ApiKeysProvider._();

/// Keys in use (saved first). Empty for a moment at start-up, until the saved
/// ones are read.

final class ApiKeysProvider
    extends
        $FunctionalProvider<
          Map<SourceId, String>,
          Map<SourceId, String>,
          Map<SourceId, String>
        >
    with $Provider<Map<SourceId, String>> {
  /// Keys in use (saved first). Empty for a moment at start-up, until the saved
  /// ones are read.
  ApiKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiKeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiKeysHash();

  @$internal
  @override
  $ProviderElement<Map<SourceId, String>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<SourceId, String> create(Ref ref) {
    return apiKeys(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<SourceId, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<SourceId, String>>(value),
    );
  }
}

String _$apiKeysHash() => r'b29b229925b2a42db4fa5e7884b59f06977708b0';
