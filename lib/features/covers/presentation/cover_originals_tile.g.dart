// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_originals_tile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Disk space of the uncropped photos kept on this device.

@ProviderFor(coverOriginalsSize)
final coverOriginalsSizeProvider = CoverOriginalsSizeProvider._();

/// Disk space of the uncropped photos kept on this device.

final class CoverOriginalsSizeProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Disk space of the uncropped photos kept on this device.
  CoverOriginalsSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coverOriginalsSizeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coverOriginalsSizeHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return coverOriginalsSize(ref);
  }
}

String _$coverOriginalsSizeHash() =>
    r'7488847d0cc05b1354eee0ee1458e550b82a6d85';
