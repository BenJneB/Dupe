import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/loans/data/loan_actions.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:dupe/features/loans/domain/loan_status.dart';
import 'package:dupe/features/loans/presentation/lend_dialog.dart';
import 'package:dupe/features/loans/presentation/loans_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Loan status of an owned item: "Prêter", or who has it and "Rendu".
class ItemLoanSection extends ConsumerWidget {
  const new({required this.item, super.key});

  final Item item;

  Future<void> _lend(BuildContext context, WidgetRef ref) async {
    final names = await ref.read(loansRepositoryProvider).borrowerNames();
    if (!context.mounted) return;
    final request = await askLend(
      context,
      title: item.title,
      knownNames: names,
      today: ref.read(clockProvider)(),
    );
    if (request == null) return;
    await ref
        .read(loanActionsProvider)
        .lend(item, borrower: request.borrower, dueAt: request.dueAt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loan = ref.watch(activeLoanProvider(item.id)).value;
    if (loan == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          key: const Key('lendButton'),
          icon: const Icon(Icons.handshake_outlined),
          label: Text(l10n.lend),
          onPressed: () => _lend(context, ref),
        ),
      );
    }
    final locale = l10n.localeName;
    final overdue = loan.isOverdue(ref.watch(clockProvider)());
    final scheme = Theme.of(context).colorScheme;
    final due = loan.dueAt;
    return Card(
      key: const Key('activeLoan'),
      color: overdue ? scheme.errorContainer : scheme.secondaryContainer,
      child: ListTile(
        leading: Icon(overdue ? Icons.warning_amber : Icons.handshake),
        title: Text(l10n.loanedTo(loan.borrowerName)),
        subtitle: Text(
          [
            l10n.loanedSince(Formatters.date(loan.loanedAt, locale)),
            if (due != null) l10n.loanDueOn(Formatters.date(due, locale)),
            if (overdue) l10n.loanOverdue,
          ].join(' · '),
        ),
        trailing: TextButton(
          key: const Key('markReturned'),
          onPressed: () => ref.read(loanActionsProvider).markReturned(loan),
          child: Text(l10n.markReturned),
        ),
      ),
    );
  }
}
