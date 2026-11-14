// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updates_section.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(updateCheckEnabled)
final updateCheckEnabledProvider = UpdateCheckEnabledProvider._();

final class UpdateCheckEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  UpdateCheckEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCheckEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCheckEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return updateCheckEnabled(ref);
  }
}

String _$updateCheckEnabledHash() =>
    r'ebe8f459c6eb80a0dfaab8c8c90b59282eedf899';
