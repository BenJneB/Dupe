import 'package:dupe/features/loans/domain/loan.dart';

extension LoanStatus on Loan {
  /// Current loan whose due date has passed (day granularity).
  bool isOverdue(DateTime now) {
    final due = dueAt;
    if (!isActive || due == null) return false;
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(due.year, due.month, due.day);
    return dueDay.isBefore(today);
  }
}
