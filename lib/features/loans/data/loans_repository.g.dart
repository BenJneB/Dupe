// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loans_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loansRepository)
final loansRepositoryProvider = LoansRepositoryProvider._();

final class LoansRepositoryProvider
    extends
        $FunctionalProvider<LoansRepository, LoansRepository, LoansRepository>
    with $Provider<LoansRepository> {
  LoansRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loansRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loansRepositoryHash();

  @$internal
  @override
  $ProviderElement<LoansRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoansRepository create(Ref ref) {
    return loansRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoansRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoansRepository>(value),
    );
  }
}

String _$loansRepositoryHash() => r'57ef41ce153dcc65f96337135d8ebfe0cd896380';
