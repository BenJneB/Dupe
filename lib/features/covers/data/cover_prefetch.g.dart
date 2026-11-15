// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_prefetch.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prefetchSettings)
final prefetchSettingsProvider = PrefetchSettingsProvider._();

final class PrefetchSettingsProvider
    extends
        $FunctionalProvider<
          PrefetchSettings,
          PrefetchSettings,
          PrefetchSettings
        >
    with $Provider<PrefetchSettings> {
  PrefetchSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefetchSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefetchSettingsHash();

  @$internal
  @override
  $ProviderElement<PrefetchSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrefetchSettings create(Ref ref) {
    return prefetchSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrefetchSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrefetchSettings>(value),
    );
  }
}

String _$prefetchSettingsHash() => r'697d3f678d40dd2ec2a63cd0b16ec1338780b8c7';

/// Downloads in the background every cover not on the device yet, so that
/// the collection shows its covers offline (PLAN_V3 phase 20). Runs at
/// start-up, on resume and when the connection changes; stops as soon as
/// the connection is no longer allowed (Wi-Fi only by default).

@ProviderFor(CoverPrefetch)
final coverPrefetchProvider = CoverPrefetchProvider._();

/// Downloads in the background every cover not on the device yet, so that
/// the collection shows its covers offline (PLAN_V3 phase 20). Runs at
/// start-up, on resume and when the connection changes; stops as soon as
/// the connection is no longer allowed (Wi-Fi only by default).
final class CoverPrefetchProvider
    extends $NotifierProvider<CoverPrefetch, PrefetchState> {
  /// Downloads in the background every cover not on the device yet, so that
  /// the collection shows its covers offline (PLAN_V3 phase 20). Runs at
  /// start-up, on resume and when the connection changes; stops as soon as
  /// the connection is no longer allowed (Wi-Fi only by default).
  CoverPrefetchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverPrefetchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverPrefetchHash();

  @$internal
  @override
  CoverPrefetch create() => CoverPrefetch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrefetchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrefetchState>(value),
    );
  }
}

String _$coverPrefetchHash() => r'c0b99cf6c559b7bfd4175f487d62464a431303cc';

/// Downloads in the background every cover not on the device yet, so that
/// the collection shows its covers offline (PLAN_V3 phase 20). Runs at
/// start-up, on resume and when the connection changes; stops as soon as
/// the connection is no longer allowed (Wi-Fi only by default).

abstract class _$CoverPrefetch extends $Notifier<PrefetchState> {
  PrefetchState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PrefetchState, PrefetchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PrefetchState, PrefetchState>,
              PrefetchState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
