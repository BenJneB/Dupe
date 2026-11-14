// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_checker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(updateChecker)
final updateCheckerProvider = UpdateCheckerProvider._();

final class UpdateCheckerProvider
    extends $FunctionalProvider<UpdateChecker, UpdateChecker, UpdateChecker>
    with $Provider<UpdateChecker> {
  UpdateCheckerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCheckerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCheckerHash();

  @$internal
  @override
  $ProviderElement<UpdateChecker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateChecker create(Ref ref) {
    return updateChecker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateChecker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateChecker>(value),
    );
  }
}

String _$updateCheckerHash() => r'010dd568ef1f3fa7ca3cde0984abea2320c0129d';
