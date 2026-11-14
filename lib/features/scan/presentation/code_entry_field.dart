import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// ISBN text field. A USB barcode reader behaves like a keyboard that types
/// the digits then Enter, so validating on submit is enough.
class CodeEntryField extends StatefulWidget {
  const new({required this.onSubmitted, this.autofocus = true, super.key});

  final ValueChanged<String> onSubmitted;
  final bool autofocus;

  @override
  State<CodeEntryField> createState() => _CodeEntryFieldState();
}

class _CodeEntryFieldState extends State<CodeEntryField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onSubmitted(value);
    _controller.clear();
    // Keep focus for the next scan with a USB reader.
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      key: const Key('codeEntryField'),
      controller: _controller,
      focusNode: _focus,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\dxX\- ]')),
      ],
      decoration: InputDecoration(
        labelText: l10n.isbnEntryLabel,
        helperText: l10n.isbnEntryHelper,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.qr_code),
        suffixIcon: IconButton(
          tooltip: l10n.search,
          icon: const Icon(Icons.arrow_forward),
          onPressed: _submit,
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _submit(),
    );
  }
}
