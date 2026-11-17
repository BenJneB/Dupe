// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_notifications.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(releaseNotifications)
final releaseNotificationsProvider = ReleaseNotificationsProvider._();

final class ReleaseNotificationsProvider
    extends
        $FunctionalProvider<
          ReleaseNotifications,
          ReleaseNotifications,
          ReleaseNotifications
        >
    with $Provider<ReleaseNotifications> {
  ReleaseNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseNotificationsHash();

  @$internal
  @override
  $ProviderElement<ReleaseNotifications> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReleaseNotifications create(Ref ref) {
    return releaseNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReleaseNotifications value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReleaseNotifications>(value),
    );
  }
}

String _$releaseNotificationsHash() =>
    r'08084ba40670fa4c0554e88722b96cb48cd1fd62';
