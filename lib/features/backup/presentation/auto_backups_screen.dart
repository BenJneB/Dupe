import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/features/backup/data/auto_backups.dart';
import 'package:dupe/features/backup/presentation/backup_actions.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Automatic backups, newest first; each one can be merged, restored
/// exactly or exported.
class AutoBackupsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final backups = ref.watch(autoBackupListProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.autoBackups)),
      body: switch (backups) {
        AsyncData(value: []) => Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l10n.autoBackupsEmpty),
        ),
        AsyncData(:final value) => ListView(
          children: [for (final b in value) _BackupTile(b)],
        ),
        AsyncError(:final error) => Center(
          child: Text(l10n.loadError(errorText(l10n, error))),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _BackupTile extends ConsumerWidget {
  const new(this.backup);

  final AutoBackup backup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final when = DateFormat.yMMMd(l10n.localeName)
        .add_Hm()
        .format(backup.at.toLocal());
    final kind = switch (backup.kind) {
      AutoBackupKind.weekly => l10n.autoBackupWeekly,
      AutoBackupKind.beforeImport => l10n.autoBackupBeforeImport,
      AutoBackupKind.beforeRestore => l10n.autoBackupBeforeRestore,
    };
    final label = '$when · $kind';
    return ListTile(
      key: Key('autoBackup-${backup.name}'),
      leading: Icon(switch (backup.kind) {
        AutoBackupKind.weekly => Icons.event_repeat,
        AutoBackupKind.beforeImport => Icons.upload_file,
        AutoBackupKind.beforeRestore => Icons.settings_backup_restore,
      }),
      title: Text(when),
      subtitle: Text('$kind · ${l10n.autoBackupItems(backup.items)}'),
      onTap: () =>
          unawaited(BackupActions(context, ref).restoreAuto(backup, label)),
    );
  }
}
