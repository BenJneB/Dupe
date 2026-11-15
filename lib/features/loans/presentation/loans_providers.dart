import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:dupe/features/loans/domain/loan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loans_providers.g.dart';

@riverpod
Stream<Loan?> activeLoan(Ref ref, String itemId) =>
    ref.watch(loansRepositoryProvider).watchActiveLoan(itemId);

@riverpod
Stream<List<LoanWithItem>> allLoans(Ref ref) =>
    ref.watch(loansRepositoryProvider).watchLoans();
