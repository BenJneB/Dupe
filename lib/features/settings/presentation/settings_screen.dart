import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Placeholder until the feature is implemented (see PLAN.md phases).
class SettingsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreSettings)),
      body: PlaceholderBody(
        icon: Icons.settings_outlined,
        title: l10n.comingSoon,
      ),
    );
  }
}
