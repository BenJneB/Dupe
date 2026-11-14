import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/presentation/item/item_form_controllers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// One text field of the item form.
class ItemTextInput extends StatelessWidget {
  const new(
    this.controllers,
    this.field,
    this.label, {
    this.digits = false,
    this.decimal = false,
    this.required = false,
    this.lines = 1,
    this.helper,
    super.key,
  });

  final ItemFormControllers controllers;
  final ItemTextField field;
  final String label;
  final bool digits;
  final bool decimal;
  final bool required;
  final int lines;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String? validate(String? v) {
      final value = v?.trim() ?? '';
      if (required && value.isEmpty) return l10n.requiredField;
      if (decimal &&
          value.isNotEmpty &&
          Formatters.parseDecimal(value) == null) {
        return l10n.invalidNumber;
      }
      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FormText(
        fieldKey: Key('field-${field.name}'),
        controller: controllers[field],
        label: label,
        digitsOnly: digits,
        maxLines: lines,
        validator: validate,
        helper: helper,
        keyboardType: decimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
      ),
    );
  }
}

/// "Informations" section: text-only bibliographic fields.
class ItemGeneralFields extends StatelessWidget {
  const new(this.c, {super.key});

  final ItemFormControllers c;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        ItemTextInput(c, ItemTextField.title, l10n.fieldTitle, required: true),
        ItemTextInput(
          c,
          ItemTextField.volume,
          l10n.fieldVolumeNumber,
          helper: l10n.fieldVolumeNumberHelper,
        ),
        ItemTextInput(
          c,
          ItemTextField.authors,
          l10n.fieldAuthors,
          helper: l10n.commaSeparated,
        ),
        ItemTextInput(c, ItemTextField.publisher, l10n.fieldPublisher),
        ItemTextInput(c, ItemTextField.edition, l10n.fieldEdition),
        ItemTextInput(c, ItemTextField.format, l10n.fieldFormat),
        ItemTextInput(c, ItemTextField.publishDate, l10n.fieldPublishDate),
        ItemTextInput(
          c,
          ItemTextField.pageCount,
          l10n.fieldPageCount,
          digits: true,
        ),
        ItemTextInput(c, ItemTextField.language, l10n.fieldLanguage),
        ItemTextInput(c, ItemTextField.isbn, l10n.fieldIsbn),
        ItemTextInput(c, ItemTextField.upc, l10n.fieldUpc),
        ItemTextInput(c, ItemTextField.coverUrl, l10n.fieldCoverUrl),
        ItemTextInput(
          c,
          ItemTextField.description,
          l10n.fieldDescription,
          lines: 5,
        ),
      ],
    );
  }
}
