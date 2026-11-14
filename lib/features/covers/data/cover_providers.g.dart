// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coverPhotos)
final coverPhotosProvider = CoverPhotosProvider._();

final class CoverPhotosProvider
    extends $FunctionalProvider<CoverPhotos, CoverPhotos, CoverPhotos>
    with $Provider<CoverPhotos> {
  CoverPhotosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverPhotosProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverPhotosHash();

  @$internal
  @override
  $ProviderElement<CoverPhotos> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CoverPhotos create(Ref ref) {
    return coverPhotos(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoverPhotos value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoverPhotos>(value),
    );
  }
}

String _$coverPhotosHash() => r'afb907c76384ae166648b56ef87a707a126db620';

/// Remote photo storage, or null in local-only mode.

@ProviderFor(coverStore)
final coverStoreProvider = CoverStoreProvider._();

/// Remote photo storage, or null in local-only mode.

final class CoverStoreProvider
    extends $FunctionalProvider<CoverStore?, CoverStore?, CoverStore?>
    with $Provider<CoverStore?> {
  /// Remote photo storage, or null in local-only mode.
  CoverStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverStoreHash();

  @$internal
  @override
  $ProviderElement<CoverStore?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CoverStore? create(Ref ref) {
    return coverStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoverStore? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoverStore?>(value),
    );
  }
}

String _$coverStoreHash() => r'e403b7a88cd1faa68f07f366ecdf91f2eb78b0e7';

/// Local file of a user photo, downloaded on first display on another
/// device; null when unavailable (offline, not signed in).

@ProviderFor(userCoverFile)
final userCoverFileProvider = UserCoverFileFamily._();

/// Local file of a user photo, downloaded on first display on another
/// device; null when unavailable (offline, not signed in).

final class UserCoverFileProvider
    extends $FunctionalProvider<AsyncValue<File?>, File?, FutureOr<File?>>
    with $FutureModifier<File?>, $FutureProvider<File?> {
  /// Local file of a user photo, downloaded on first display on another
  /// device; null when unavailable (offline, not signed in).
  UserCoverFileProvider._({
    required UserCoverFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userCoverFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userCoverFileHash();

  @override
  String toString() {
    return r'userCoverFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<File?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<File?> create(Ref ref) {
    final argument = this.argument as String;
    return userCoverFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserCoverFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userCoverFileHash() => r'8fbfc4049b251f6fc747a3261dfdc3fe8cb36240';

/// Local file of a user photo, downloaded on first display on another
/// device; null when unavailable (offline, not signed in).

final class UserCoverFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<File?>, String> {
  UserCoverFileFamily._()
    : super(
        retry: null,
        name: r'userCoverFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Local file of a user photo, downloaded on first display on another
  /// device; null when unavailable (offline, not signed in).

  UserCoverFileProvider call(String name) =>
      UserCoverFileProvider._(argument: name, from: this);

  @override
  String toString() => r'userCoverFileProvider';
}

/// Takes a photo (camera on Android, file picker on desktop). Overridden in
/// tests.

@ProviderFor(pickImage)
final pickImageProvider = PickImageProvider._();

/// Takes a photo (camera on Android, file picker on desktop). Overridden in
/// tests.

final class PickImageProvider
    extends
        $FunctionalProvider<
          Future<PickedImage?> Function({required bool camera}),
          Future<PickedImage?> Function({required bool camera}),
          Future<PickedImage?> Function({required bool camera})
        >
    with $Provider<Future<PickedImage?> Function({required bool camera})> {
  /// Takes a photo (camera on Android, file picker on desktop). Overridden in
  /// tests.
  PickImageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pickImageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pickImageHash();

  @$internal
  @override
  $ProviderElement<Future<PickedImage?> Function({required bool camera})>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Future<PickedImage?> Function({required bool camera}) create(Ref ref) {
    return pickImage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<PickedImage?> Function({required bool camera}) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Future<PickedImage?> Function({required bool camera})
          >(value),
    );
  }
}

String _$pickImageHash() => r'020d0dcee0521b936c284af8ae842d0f8d33afb6';
