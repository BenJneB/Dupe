import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

enum RestoreChoice { merge, replace, export }

/// Asks how to restore a backup; [export] adds "export this file"
/// (automatic backups). Null when cancelled.
Future<RestoreChoice?> showRestoreDialog(
  BuildContext context, {
  String? subtitle,
  bool export = false,
}) => showDialog<RestoreChoice>(
  context: context,
  builder: (context) {
    final l10n = AppLocalizations.of(context);
    final error = Theme.of(context).colorScheme.error;
    Widget option(
      RestoreChoice choice,
      IconData icon,
      String title,
      String? help, {
      Color? color,
    }) => ListTile(
      key: Key('restore-${choice.name}'),
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: help == null ? null : Text(help),
      onTap: () => Navigator.pop(context, choice),
    );
    return AlertDialog(
      title: Text(l10n.restoreTitle),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(subtitle),
              ),
            option(
              RestoreChoice.merge,
              Icons.merge_type,
              l10n.restoreMerge,
              l10n.restoreMergeHelp,
            ),
            option(
              RestoreChoice.replace,
              Icons.restore,
              l10n.restoreReplace,
              l10n.restoreReplaceHelp,
              color: error,
            ),
            if (export)
              option(
                RestoreChoice.export,
                Icons.save_alt,
                l10n.autoBackupExport,
                null,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  },
);
