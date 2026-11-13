import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Global search over the local collection, shown at the top of each tab.
/// Search logic is wired in phase 1.
class GlobalSearchBar extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: AppLocalizations.of(context).searchHint,
      leading: const Icon(Icons.search),
      elevation: const WidgetStatePropertyAll(0),
      constraints: const BoxConstraints(minHeight: 44, maxWidth: 720),
    );
  }
}
