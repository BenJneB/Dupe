import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan.freezed.dart';

/// A loan of an item to someone.
@freezed
abstract class Loan with _$Loan {
  const factory({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String itemId,
    required String borrowerName,
    required DateTime loanedAt,
    String? userId,
    DateTime? deletedAt,
    @Default(true) bool syncPending,
    DateTime? dueAt,
    DateTime? returnedAt,
    String? notes,
  }) = _Loan;

  const new _();

  bool get isActive => returnedAt == null && deletedAt == null;
}
