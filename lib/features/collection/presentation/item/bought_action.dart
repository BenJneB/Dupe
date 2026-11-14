import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/purchase_actions.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// "Je l'ai acheté": asks the price paid (optional, prefilled with the cover
/// price), then marks [item] as owned. Returns false when cancelled.
Future<bool> confirmBought(
  BuildContext context,
  WidgetRef ref,
  Item item,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final result = await showDialog<({double? price})>(
    context: context,
    builder: (context) => _BoughtDialog(item: item),
  );
  if (result == null) return false;
  await ref
      .read(collectionRepositoryProvider)
      .markBought(item, today: ref.read(clockProvider)(), price: result.price);
  messenger.showSnackBar(SnackBar(content: Text(l10n.boughtDone(item.title))));
  return true;
}

class _BoughtDialog extends StatefulWidget {
  const new({required this.item});

  final Item item;

  @override
  State<_BoughtDialog> createState() => _BoughtDialogState();
}

class _BoughtDialogState extends State<_BoughtDialog> {
  late final _price = TextEditingController(
    text: switch (widget.item.coverPrice) {
      final p? => p.toStringAsFixed(2).replaceAll('.', ','),
      null => '',
    },
  );

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  void _submit() =>
      Navigator.pop(context, (price: Formatters.parseDecimal(_price.text)));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.boughtTitle),
      content: TextField(
        key: const Key('paidPriceField'),
        controller: _price,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d,.]'))],
        decoration: InputDecoration(
          labelText: l10n.paidPriceOptional,
          suffixText: widget.item.currency,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('confirmBought'),
          onPressed: _submit,
          child: Text(l10n.markOwned),
        ),
      ],
    );
  }
}
