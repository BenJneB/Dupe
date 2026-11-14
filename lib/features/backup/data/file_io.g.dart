// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_io.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in tests.

@ProviderFor(fileIo)
final fileIoProvider = FileIoProvider._();

/// Overridden in tests.

final class FileIoProvider extends $FunctionalProvider<FileIo, FileIo, FileIo>
    with $Provider<FileIo> {
  /// Overridden in tests.
  FileIoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileIoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileIoHash();

  @$internal
  @override
  $ProviderElement<FileIo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FileIo create(Ref ref) {
    return fileIo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileIo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileIo>(value),
    );
  }
}

String _$fileIoHash() => r'4fbff3cd8952152ec4e0448a0219c71a09705d31';
