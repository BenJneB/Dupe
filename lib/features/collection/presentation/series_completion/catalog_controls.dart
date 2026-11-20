import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// One chip per edition (publisher) found in the catalog.
class CatalogEditionChips extends StatelessWidget {
  const new({
    required this.editions,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<CatalogEdition> editions;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: [
          for (final (i, e) in editions.indexed)
            ChoiceChip(
              key: ValueKey('catalogEdition-$i'),
              label: Text(
                l10n.catalogEdition(e.publisher ?? '?', e.volumes.length),
              ),
              selected: i == selected,
              onSelected: (_) => onSelected(i),
            ),
        ],
      ),
    );
  }
}

/// "Possédés jusqu'au tome N": marks volumes 1..N (all when empty) owned.
class CatalogUpToRow extends StatelessWidget {
  const new({required this.controller, required this.onOwnUpTo, super.key});

  final TextEditingController controller;
  final ValueChanged<int?> onOwnUpTo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('catalogUpTo'),
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.catalogUpTo),
              onSubmitted: (v) => onOwnUpTo(int.tryParse(v)),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            key: const Key('catalogAllOwned'),
            onPressed: () => onOwnUpTo(int.tryParse(controller.text)),
            child: Text(l10n.catalogMarkOwned),
          ),
        ],
      ),
    );
  }
}
