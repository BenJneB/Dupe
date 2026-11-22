import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/loans/data/loan_actions.dart';
import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:dupe/features/loans/domain/loan_status.dart';
import 'package:dupe/features/loans/presentation/clear_loan_history.dart';
import 'package:dupe/features/loans/presentation/loans_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Current loans (overdue highlighted) and history.
class LoansScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loans = ref.watch(allLoansProvider).value ?? const [];
    final current = [
      for (final l in loans)
        if (l.loan.isActive) l,
    ];
    final history = [
      for (final l in loans)
        if (!l.loan.isActive) l,
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.moreLoans),
          actions: [
            if (history.isNotEmpty)
              ClearLoanHistoryButton(count: history.length),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: '${l10n.loansCurrent} (${current.length})'),
              Tab(text: l10n.loansHistory),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _LoanList(loans: current, empty: l10n.loansEmpty),
            _LoanList(loans: history, empty: l10n.loansHistoryEmpty),
          ],
        ),
      ),
    );
  }
}

class _LoanList extends ConsumerWidget {
  const new({required this.loans, required this.empty});

  final List<LoanWithItem> loans;
  final String empty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final now = ref.watch(clockProvider)();
    final scheme = Theme.of(context).colorScheme;
    if (loans.isEmpty) {
      return PlaceholderBody(icon: Icons.handshake_outlined, title: empty);
    }
    return ListView(
      children: [
        for (final (:loan, :item) in loans)
          ListTile(
            key: ValueKey('loan-${loan.id}'),
            tileColor: loan.isOverdue(now) ? scheme.errorContainer : null,
            leading: CoverImage(url: item.coverUrl, width: 40, height: 60),
            title: Text(item.displayTitle(l10n)),
            subtitle: Text(
              [
                l10n.loanedTo(loan.borrowerName),
                if (loan.returnedAt case final returned?)
                  l10n.loanReturnedOn(Formatters.date(returned, locale))
                else if (loan.dueAt case final due?)
                  l10n.loanDueOn(Formatters.date(due, locale))
                else
                  l10n.loanedSince(Formatters.date(loan.loanedAt, locale)),
                if (loan.isOverdue(now)) l10n.loanOverdue,
              ].join(' · '),
            ),
            trailing: loan.isActive
                ? TextButton(
                    onPressed: () =>
                        ref.read(loanActionsProvider).markReturned(loan),
                    child: Text(l10n.markReturned),
                  )
                : null,
            onTap: () => context.push(AppRoutes.item(item.type, item.id)),
          ),
      ],
    );
  }
}
