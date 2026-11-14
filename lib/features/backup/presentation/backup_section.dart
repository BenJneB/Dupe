import 'dart:async';

import 'package:dupe/features/backup/presentation/backup_actions.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Settings section: JSON backup, CSV export and import.
class BackupSection extends ConsumerWidget {
  const new({super.key});

  Future<void> _exportCsv(BuildContext context, BackupActions actions) async {
    final l10n = AppLocalizations.of(context);
    // Record so that "all types" (null) differs from a cancelled dialog.
    final choice = await showDialog<({CollectionType? type})>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.exportCsv),
        children: [
          for (final type in [...CollectionType.values, null])
            SimpleDialogOption(
              key: Key('csvType-${type?.dbValue ?? 'all'}'),
              onPressed: () => Navigator.pop(context, (type: type)),
              child: Text(type?.label(l10n) ?? l10n.exportCsvAll),
            ),
        ],
      ),
    );
    if (choice != null) await actions.exportCsv(choice.type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final actions = BackupActions(context, ref);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            l10n.backupSection,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          key: const Key('exportJson'),
          leading: const Icon(Icons.save_alt),
          title: Text(l10n.exportJson),
          subtitle: Text(l10n.exportJsonHelp),
          onTap: () => unawaited(actions.exportJson()),
        ),
        ListTile(
          key: const Key('restoreJson'),
          leading: const Icon(Icons.settings_backup_restore),
          title: Text(l10n.restoreJson),
          subtitle: Text(l10n.restoreJsonHelp),
          onTap: () => unawaited(actions.restoreJson()),
        ),
        ListTile(
          key: const Key('exportCsv'),
          leading: const Icon(Icons.table_view_outlined),
          title: Text(l10n.exportCsv),
          subtitle: Text(l10n.exportCsvHelp),
          onTap: () => unawaited(_exportCsv(context, actions)),
        ),
        ListTile(
          key: const Key('importCsv'),
          leading: const Icon(Icons.upload_file),
          title: Text(l10n.importCsv),
          subtitle: Text(l10n.importCsvHelp),
          onTap: () => unawaited(actions.importCsv()),
        ),
      ],
    );
  }
}
