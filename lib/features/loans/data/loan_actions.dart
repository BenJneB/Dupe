import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/loans/data/loan_reminders.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:dupe/features/loans/domain/loan.dart';
import 'package:dupe/features/loans/domain/loan_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loan_actions.g.dart';

/// Loan operations with their reminders.
class LoanActions {
  const new(this._repo, this._reminders, this._settings, this._now);

  final LoansRepository _repo;
  final LoanReminders _reminders;
  final AppSettingsStore _settings;
  final DateTime Function() _now;

  static const _overdueNotifiedKey = 'loans_overdue_notified_on';

  Future<Loan> lend(
    Item item, {
    required String borrower,
    DateTime? dueAt,
  }) async {
    final loan = await _repo.lend(item.id, borrower: borrower, dueAt: dueAt);
    if (dueAt != null) await _reminders.schedule(loan, item.title);
    return loan;
  }

  /// A reminder of a loan due on [dueAt] would show: scheduling is possible
  /// here and notifications are allowed (recette N-01: they were off).
  Future<bool> reminderWillShow(DateTime? dueAt) async =>
      dueAt == null ||
      !_reminders.canSchedule ||
      await _reminders.notificationsAllowed();

  /// At start-up (Android): reminders of the current loans scheduled again,
  /// those of returned loans and deleted volumes cancelled. Covers a
  /// reinstalled app (scheduled reminders are lost) and loans created or
  /// returned on another device. Scheduling a loan again replaces its
  /// reminder (same id).
  Future<void> syncReminders() async {
    if (!_reminders.canSchedule) return;
    for (final (:loan, :item) in await _repo.allLoans()) {
      if (loan.dueAt == null) continue;
      if (loan.isActive) {
        await _reminders.schedule(loan, item.title);
      } else {
        await _reminders.cancel(loan);
      }
    }
    for (final (:loan, item: _) in await _repo.loansOfDeletedItems()) {
      await _reminders.cancel(loan);
    }
  }

  Future<void> markReturned(Loan loan) async {
    await _repo.markReturned(loan);
    await _reminders.cancel(loan);
  }

  /// At start-up: one notification per day listing the overdue loans. The
  /// only reminder on desktop; on Android, it covers loans whose reminder
  /// could not be scheduled (synced already overdue; lent after the reminder
  /// time of its due day, notified the next day).
  Future<void> notifyOverdueOnStartup() async {
    final now = _now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    if (await _settings.get(_overdueNotifiedKey) == today) return;
    final overdue = [
      for (final l in await _repo.activeLoans())
        if (l.loan.isOverdue(now)) l,
    ];
    if (overdue.isEmpty) return;
    await _reminders.showOverdue(overdue);
    await _settings.set(_overdueNotifiedKey, today);
  }
}

@riverpod
LoanActions loanActions(Ref ref) => LoanActions(
  ref.watch(loansRepositoryProvider),
  ref.watch(loanRemindersProvider),
  ref.watch(appSettingsStoreProvider),
  ref.watch(clockProvider),
);
