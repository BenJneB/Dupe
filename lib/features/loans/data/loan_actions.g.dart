// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loanActions)
final loanActionsProvider = LoanActionsProvider._();

final class LoanActionsProvider
    extends $FunctionalProvider<LoanActions, LoanActions, LoanActions>
    with $Provider<LoanActions> {
  LoanActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanActionsHash();

  @$internal
  @override
  $ProviderElement<LoanActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoanActions create(Ref ref) {
    return loanActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanActions>(value),
    );
  }
}

String _$loanActionsHash() => r'9bd5752a236b212fa83996197b9a09207dcfb4a5';
