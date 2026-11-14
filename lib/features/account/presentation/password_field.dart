import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Password (or other secret) input with a show / hide button.
class PasswordField extends StatefulWidget {
  const new({
    required this.controller,
    required this.label,
    this.isNew = false,
    this.autofocus = false,
    this.onSubmitted,
    this.autofill = true,
    super.key,
  });

  final TextEditingController controller;
  final String label;

  /// New password (sign-up, change): lets password managers suggest one.
  final bool isNew;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  /// Offer to password managers (false for API keys).
  final bool autofill;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  var _visible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      obscureText: !_visible,
      enableSuggestions: false,
      autocorrect: false,
      autofillHints: !widget.autofill
          ? null
          : [
              if (widget.isNew)
                AutofillHints.newPassword
              else
                AutofillHints.password,
            ],
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          tooltip: _visible ? l10n.hidePassword : l10n.showPassword,
          icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _visible = !_visible),
        ),
      ),
      onSubmitted: widget.onSubmitted,
    );
  }
}
