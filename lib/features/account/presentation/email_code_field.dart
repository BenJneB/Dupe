import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The 6-digit code of a Supabase email, or its link pasted (copied with a
/// long press, without opening it) (PLAN_V4 phase 34).
class EmailCodeField extends StatelessWidget {
  const new({required this.controller, this.onSubmitted, super.key});

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      // A code, or the whole link of the email pasted.
      keyboardType: TextInputType.url,
      autofillHints: const [AutofillHints.oneTimeCode],
      decoration: InputDecoration(
        labelText: l10n.emailCodeLabel,
        helperText: l10n.emailCodeHelp,
        border: const OutlineInputBorder(),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
