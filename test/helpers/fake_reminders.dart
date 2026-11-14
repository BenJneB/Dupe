import 'package:dupe/features/loans/data/loan_reminders.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:dupe/features/loans/domain/loan.dart';

/// Records reminder calls instead of using system notifications.
class FakeLoanReminders implements LoanReminders {
  new({this.canSchedule = false});

  @override
  final bool canSchedule;

  final scheduled = <String>{};
  final overdueShown = <List<LoanWithItem>>[];

  @override
  Future<void> schedule(Loan loan, String itemTitle) async =>
      scheduled.add(loan.id);

  @override
  Future<void> cancel(Loan loan) async => scheduled.remove(loan.id);

  @override
  Future<void> showOverdue(List<LoanWithItem> overdue) async =>
      overdueShown.add(overdue);
}
