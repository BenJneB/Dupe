// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_settings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// New release checks, per device (local `app_settings`): on, Wi-Fi only
/// and notifications by default.

@ProviderFor(ReleaseSettings)
final releaseSettingsProvider = ReleaseSettingsProvider._();

/// New release checks, per device (local `app_settings`): on, Wi-Fi only
/// and notifications by default.
final class ReleaseSettingsProvider
    extends $AsyncNotifierProvider<ReleaseSettings, ReleaseOptions> {
  /// New release checks, per device (local `app_settings`): on, Wi-Fi only
  /// and notifications by default.
  ReleaseSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseSettingsHash();

  @$internal
  @override
  ReleaseSettings create() => ReleaseSettings();
}

String _$releaseSettingsHash() => r'df84ba94ec1311c0c015c125f6fe5f31c90db45f';

/// New release checks, per device (local `app_settings`): on, Wi-Fi only
/// and notifications by default.

abstract class _$ReleaseSettings extends $AsyncNotifier<ReleaseOptions> {
  FutureOr<ReleaseOptions> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ReleaseOptions>, ReleaseOptions>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReleaseOptions>, ReleaseOptions>,
              AsyncValue<ReleaseOptions>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
