// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loans_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeLoan)
final activeLoanProvider = ActiveLoanFamily._();

final class ActiveLoanProvider
    extends $FunctionalProvider<AsyncValue<Loan?>, Loan?, Stream<Loan?>>
    with $FutureModifier<Loan?>, $StreamProvider<Loan?> {
  ActiveLoanProvider._({
    required ActiveLoanFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activeLoanProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeLoanHash();

  @override
  String toString() {
    return r'activeLoanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Loan?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Loan?> create(Ref ref) {
    final argument = this.argument as String;
    return activeLoan(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveLoanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeLoanHash() => r'34ffa495d6a3ed3c726e21a1e8eb219fa21d4c56';

final class ActiveLoanFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Loan?>, String> {
  ActiveLoanFamily._()
    : super(
        retry: null,
        name: r'activeLoanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiveLoanProvider call(String itemId) =>
      ActiveLoanProvider._(argument: itemId, from: this);

  @override
  String toString() => r'activeLoanProvider';
}

@ProviderFor(allLoans)
final allLoansProvider = AllLoansProvider._();

final class AllLoansProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LoanWithItem>>,
          List<LoanWithItem>,
          Stream<List<LoanWithItem>>
        >
    with
        $FutureModifier<List<LoanWithItem>>,
        $StreamProvider<List<LoanWithItem>> {
  AllLoansProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allLoansProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allLoansHash();

  @$internal
  @override
  $StreamProviderElement<List<LoanWithItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LoanWithItem>> create(Ref ref) {
    return allLoans(ref);
  }
}

String _$allLoansHash() => r'96eb3e6c010b6dbd5ee791073c2ba72c909980c4';
