import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:dupe/features/loans/domain/loan.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'loan_reminders.g.dart';

/// System notifications about loans.
abstract interface class LoanReminders {
  /// Android can schedule a reminder on the due date. Linux has no scheduler
  /// and Windows cannot cancel notifications outside MSIX packages: desktop
  /// gets an "overdue" notification when the app starts instead.
  bool get canSchedule;

  Future<void> schedule(Loan loan, String itemTitle);
  Future<void> cancel(Loan loan);
  Future<void> showOverdue(List<LoanWithItem> overdue);
}

@Riverpod(keepAlive: true)
LoanReminders loanReminders(Ref ref) => LocalLoanReminders();

/// [LoanReminders] with flutter_local_notifications.
class LocalLoanReminders implements LoanReminders {
  final _plugin = FlutterLocalNotificationsPlugin();
  final AppLocalizations _l10n = lookupAppLocalizations(const Locale('fr'));
  Future<bool>? _ready;

  static const _overdueId = 0;

  @override
  bool get canSchedule => defaultTargetPlatform == TargetPlatform.android;

  Future<bool> _init() => _ready ??= () async {
    try {
      await _plugin.initialize(
        settings: InitializationSettings(
          android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
          linux: LinuxInitializationSettings(
            defaultActionName: _l10n.notificationOpen,
          ),
          windows: WindowsInitializationSettings(
            appName: _l10n.appTitle,
            appUserModelId: 'Dev.Dupe.Dupe',
            guid: '6f1d9c2e-4b7a-4d55-9a0e-3c8b2f71d5a4',
          ),
        ),
      );
      if (canSchedule) {
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      }
      return true;
    } on Object catch (e) {
      // No notification server (e.g. headless Linux): reminders are
      // optional, the loans screen still shows overdue loans.
      appLog.warning('notifications', 'Notifications unavailable: $e');
      return false;
    }
  }();

  NotificationDetails get _details => NotificationDetails(
    android: AndroidNotificationDetails(
      'loans',
      _l10n.moreLoans,
      channelDescription: _l10n.notificationChannelLoans,
    ),
  );

  /// Stable notification id of a loan (FNV-1a of its UUID, 31 bits, not 0).
  static int idOf(Loan loan) {
    var hash = 0x811c9dc5;
    for (final unit in loan.id.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0x7fffffff;
    }
    return hash == _overdueId ? 1 : hash;
  }

  @override
  Future<void> schedule(Loan loan, String itemTitle) async {
    final due = loan.dueAt;
    if (!canSchedule || due == null || !await _init()) return;
    final at = DateTime(due.year, due.month, due.day, 10);
    if (!at.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id: idOf(loan),
      title: _l10n.loanDueTitle,
      body: _l10n.loanDueBody(itemTitle, loan.borrowerName),
      // An absolute instant: no time zone database needed.
      scheduledDate: tz.TZDateTime.from(at, tz.UTC),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(Loan loan) async {
    if (!canSchedule || !await _init()) return;
    await _plugin.cancel(id: idOf(loan));
  }

  @override
  Future<void> showOverdue(List<LoanWithItem> overdue) async {
    if (overdue.isEmpty || !await _init()) return;
    await _plugin.show(
      id: _overdueId,
      title: _l10n.loansOverdueTitle(overdue.length),
      body: [
        for (final o in overdue)
          _l10n.loanDueBody(o.item.title, o.loan.borrowerName),
      ].join('\n'),
      notificationDetails: _details,
    );
  }
}
