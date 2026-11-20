import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/presentation/item/item_form_controllers.dart';
import 'package:dupe/features/collection/presentation/item/item_text_input.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// "Prix" section, plus "Envie" (priority, maximum price) for a wish.
class ItemPriceFields extends StatelessWidget {
  const new(this.c, {required this.onChanged, super.key});

  final ItemFormControllers c;

  /// Called after a value of [c] changed, to rebuild the form.
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormSection(l10n.sectionPrice),
        ItemTextInput(
          c,
          ItemTextField.purchasePrice,
          l10n.fieldPurchasePrice,
          decimal: true,
        ),
        FormDate(
          label: l10n.fieldPurchaseDate,
          value: c.purchaseDate,
          format: (d) => Formatters.date(d, l10n.localeName),
          onChanged: (d) {
            c.purchaseDate = d;
            onChanged();
          },
        ),
        formGap,
        ItemTextInput(
          c,
          ItemTextField.coverPrice,
          l10n.fieldCoverPrice,
          decimal: true,
        ),
        ItemTextInput(
          c,
          ItemTextField.estimatedValue,
          l10n.fieldEstimatedValue,
          decimal: true,
        ),
        ItemTextInput(c, ItemTextField.currency, l10n.fieldCurrency),
        if (c.ownership == Ownership.envie) ...[
          FormSection(l10n.sectionWishlist),
          FormDropdown<int?>(
            label: l10n.fieldWishlistPriority,
            value: c.priority,
            items: {null: l10n.none, for (var p = 1; p <= 3; p++) p: '$p'},
            onChanged: (p) {
              c.priority = p;
              onChanged();
            },
          ),
          formGap,
          ItemTextInput(
            c,
            ItemTextField.maxPrice,
            l10n.fieldWishlistMaxPrice,
            decimal: true,
          ),
        ],
      ],
    );
  }
}
