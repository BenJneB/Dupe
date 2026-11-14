// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_reminders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loanReminders)
final loanRemindersProvider = LoanRemindersProvider._();

final class LoanRemindersProvider
    extends $FunctionalProvider<LoanReminders, LoanReminders, LoanReminders>
    with $Provider<LoanReminders> {
  LoanRemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loanRemindersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loanRemindersHash();

  @$internal
  @override
  $ProviderElement<LoanReminders> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoanReminders create(Ref ref) {
    return loanReminders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoanReminders value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoanReminders>(value),
    );
  }
}

String _$loanRemindersHash() => r'ba94dfa093867b16184cf414069055f7787c0cdc';
