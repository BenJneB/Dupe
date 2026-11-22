import 'package:dupe/features/loans/data/loans_repository.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// App bar action of the loans screen: empties the history of [count]
/// returned loans, after confirmation (current loans stay).
class ClearLoanHistoryButton extends ConsumerWidget {
  const new({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      key: const Key('clearLoanHistory'),
      tooltip: l10n.loansClearHistory,
      icon: const Icon(Icons.delete_sweep_outlined),
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.loansClearHistoryQuestion),
            content: Text(l10n.loansClearHistoryHelp(count)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                key: const Key('confirmClearLoanHistory'),
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.loansClearHistoryConfirm),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
        await ref.read(loansRepositoryProvider).clearHistory();
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.loansHistoryCleared)),
        );
      },
    );
  }
}
