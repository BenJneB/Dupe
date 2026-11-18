import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/presentation/item/item_form_controllers.dart';
import 'package:dupe/features/collection/presentation/item/item_text_input.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// "Dédicace" section of the item form (PLAN_V4 phase 31): the box, then
/// who signed (prefilled with the authors), when, where, and the dedication.
class ItemSigningFields extends StatelessWidget {
  const new(this.c, {required this.onChanged, super.key});

  final ItemFormControllers c;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        FormSection(l10n.sectionSigning),
        SwitchListTile(
          key: const Key('signedSwitch'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.fieldSigned),
          value: c.signed,
          onChanged: (v) {
            c.signed = v;
            final by = c[ItemTextField.signedBy];
            if (v && by.text.trim().isEmpty) {
              by.text = c[ItemTextField.authors].text;
            }
            onChanged();
          },
        ),
        if (c.signed) ...[
          ItemTextInput(c, ItemTextField.signedBy, l10n.fieldSignedBy),
          FormDate(
            label: l10n.fieldSignedOn,
            value: c.signedOn,
            format: (d) => Formatters.date(d, l10n.localeName),
            onChanged: (d) {
              c.signedOn = d;
              onChanged();
            },
          ),
          formGap,
          ItemTextInput(
            c,
            ItemTextField.signedPlace,
            l10n.fieldSignedPlace,
            helper: l10n.fieldSignedPlaceHelper,
          ),
          ItemTextInput(
            c,
            ItemTextField.signingNote,
            l10n.fieldSigningNote,
            lines: 3,
          ),
        ],
      ],
    );
  }
}
