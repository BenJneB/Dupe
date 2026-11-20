import 'package:dupe/app/error_text.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// "Impossible de charger : …", centered: the error state of a screen or
/// list fed by a provider.
class LoadErrorView extends StatelessWidget {
  const new(this.error, {super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(child: Text(l10n.loadError(errorText(l10n, error))));
  }
}
