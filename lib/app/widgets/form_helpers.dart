import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Spacing between form fields.
const formGap = SizedBox(height: 12);

/// Outlined text field with consistent styling.
class FormText extends StatelessWidget {
  const new({
    required this.controller,
    required this.label,
    this.fieldKey,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.digitsOnly = false,
    this.helper,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final Key? fieldKey;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool digitsOnly;
  final String? helper;

  @override
  Widget build(BuildContext context) => TextFormField(
    key: fieldKey,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      helperText: helper,
      border: const OutlineInputBorder(),
    ),
    validator: validator,
    keyboardType: digitsOnly ? TextInputType.number : keyboardType,
    inputFormatters: digitsOnly
        ? [FilteringTextInputFormatter.digitsOnly]
        : null,
    maxLines: maxLines,
    minLines: 1,
    textInputAction: maxLines == 1 ? TextInputAction.next : null,
  );
}

/// Section title inside a form.
class FormSection extends StatelessWidget {
  const new(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

/// Date picker field showing the formatted date, with a clear button.
class FormDate extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.format,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String Function(DateTime) format;

  @override
  Widget build(BuildContext context) {
    final current = value;
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: current ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: current == null
              ? const Icon(Icons.calendar_today_outlined)
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(current == null ? '' : format(current)),
      ),
    );
  }
}

/// Text value or null when blank.
String? textOrNull(TextEditingController c) {
  final v = c.text.trim();
  return v.isEmpty ? null : v;
}
