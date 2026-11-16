import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/local_stores.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/loans/data/loan_actions.dart';
import 'package:dupe/features/loans/data/loan_reminders.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/fake_reminders.dart';
import '../../helpers/scan_helpers.dart';

late Item dune;

Future<void> seedDune(AppDatabase db) async {
  final repo = repoOf(db);
  dune = repo.newItem(CollectionType.livre).copyWith(title: 'Dune');
  await repo.saveItem(dune);
}

Future<ProviderContainer> openItem(WidgetTester tester) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(Scaffold).first),
  );
  container.read(appRouterProvider).go(AppRoutes.item(dune.type, dune.id));
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('lend an item, suggest known borrowers, mark it returned', (
    tester,
  ) async {
    final reminders = FakeLoanReminders(canSchedule: true);
    await pumpApp(tester, seed: seedDune, reminders: reminders);
    await openItem(tester);

    await tester.tap(find.byKey(const Key('lendButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('borrowerField')), 'Alice');
    await tester.pump();
    await tester.tap(find.byKey(const Key('confirmLend')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('activeLoan')), findsOneWidget);
    expect(find.text('Prêté à Alice'), findsOneWidget);
    // No due date: nothing to schedule.
    expect(reminders.scheduled, isEmpty);

    await tester.tap(find.byKey(const Key('markReturned')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('lendButton')), findsOneWidget);

    // The name is suggested next time.
    await tester.tap(find.byKey(const Key('lendButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('borrowerField')), 'al');
    await tester.pumpAndSettle();
    expect(find.text('Alice'), findsOneWidget);
  });

  testWidgets('loans screen highlights overdue loans and keeps history', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (db) async {
        await seedDune(db);
        final loans = LoansRepository(
          db,
          now: () => DateTime(2026, 10),
          newId: () => 'loan-1',
        );
        await loans.lend(
          dune.id,
          borrower: 'Bob',
          dueAt: DateTime(2026, 10, 15),
        );
      },
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold).first),
    );
    container.read(appRouterProvider).go(AppRoutes.loans);
    await tester.pumpAndSettle();

    expect(find.text('En cours (1)'), findsOneWidget);
    expect(find.textContaining('En retard'), findsOneWidget);
    await tester.tap(find.text('Rendu'));
    await tester.pumpAndSettle();
    expect(find.text('En cours (0)'), findsOneWidget);

    await tester.tap(find.text('Historique'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Prêté à Bob · Rendu le'), findsOneWidget);
  });

  test('desktop: overdue loans are notified once a day at start-up', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    var now = DateTime(2026, 11, 14, 9);
    final reminders = FakeLoanReminders();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        loanRemindersProvider.overrideWithValue(reminders),
      ],
    );
    addTearDown(container.dispose);
    await seedDune(db);
    final repo = container.read(loansRepositoryProvider);
    await repo.lend(dune.id, borrower: 'Bob', dueAt: DateTime(2026, 11, 10));
    await repo.lend(dune.id, borrower: 'Eve', dueAt: DateTime(2026, 12));

    final actions = container.read(loanActionsProvider);
    await actions.notifyOverdueOnStartup();
    await actions.notifyOverdueOnStartup();
    expect(reminders.overdueShown, hasLength(1));
    expect(reminders.overdueShown.single.single.loan.borrowerName, 'Bob');

    now = now.add(const Duration(days: 1));
    await actions.notifyOverdueOnStartup();
    expect(reminders.overdueShown, hasLength(2));
    expect(
      await AppSettingsStore(db).get('loans_overdue_notified_on'),
      '2026-11-15',
    );
  });

  test('Android: a due date schedules a reminder, return cancels it', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final reminders = FakeLoanReminders(canSchedule: true);
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        loanRemindersProvider.overrideWithValue(reminders),
      ],
    );
    addTearDown(container.dispose);
    await seedDune(db);

    final actions = container.read(loanActionsProvider);
    final loan = await actions.lend(
      dune,
      borrower: 'Bob',
      dueAt: DateTime.now().add(const Duration(days: 7)),
    );
    expect(reminders.scheduled, {loan.id});
    await actions.markReturned(loan);
    expect(reminders.scheduled, isEmpty);
  });

  test(
    'start-up: reminders scheduled again, returned loans cancelled',
    () async {
      // Recette N-01: after a reinstall (or for loans of another device), no
      // reminder was scheduled any more.
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final reminders = FakeLoanReminders(canSchedule: true);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          loanRemindersProvider.overrideWithValue(reminders),
        ],
      );
      addTearDown(container.dispose);
      await seedDune(db);
      final repo = container.read(loansRepositoryProvider);
      final soon = DateTime.now().add(const Duration(days: 3));
      final active = await repo.lend(dune.id, borrower: 'Bob', dueAt: soon);
      final returned = await repo.lend(dune.id, borrower: 'Eve', dueAt: soon);
      await repo.markReturned(returned);
      await repo.lend(dune.id, borrower: 'Zoé'); // No due date.
      reminders.scheduled.add(returned.id); // Left over from before.

      await container.read(loanActionsProvider).syncReminders();

      expect(reminders.scheduled, {active.id});
    },
  );

  test('a reminder will not show when notifications are off', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    LoanActions actions(FakeLoanReminders reminders) => ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        loanRemindersProvider.overrideWithValue(reminders),
      ],
    ).read(loanActionsProvider);
    final due = DateTime.now().add(const Duration(days: 1));

    final off = actions(FakeLoanReminders(canSchedule: true, allowed: false));
    expect(await off.reminderWillShow(due), isFalse);
    expect(await off.reminderWillShow(null), isTrue);
    expect(
      await actions(FakeLoanReminders(canSchedule: true)).reminderWillShow(due),
      isTrue,
    );
    // Desktop: no scheduled reminders, nothing to warn about.
    expect(
      await actions(FakeLoanReminders(allowed: false)).reminderWillShow(due),
      isTrue,
    );
  });
}
