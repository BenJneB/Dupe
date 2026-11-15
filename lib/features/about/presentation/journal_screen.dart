import 'dart:async';
import 'dart:convert';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/logging/app_log.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// The error journal ([appLog]), newest first, to copy or share when
/// reporting a problem.
class JournalScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    await Clipboard.setData(ClipboardData(text: appLog.export()));
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.journalCopied)));
  }

  Future<void> _share(WidgetRef ref) async {
    final d = ref.read(clockProvider)();
    await ref
        .read(fileIoProvider)
        .save(
          'dupe-journal-${DateFormat('yyyy-MM-dd-HHmm').format(d)}.txt',
          Uint8List.fromList(utf8.encode(appLog.export())),
          mimeType: 'text/plain',
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<void>(
      stream: appLog.changes,
      builder: (context, _) {
        final entries = appLog.entries.reversed.toList();
        final empty = entries.isEmpty;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.journalTitle),
            actions: [
              IconButton(
                key: const Key('journalCopy'),
                tooltip: l10n.journalCopy,
                icon: const Icon(Icons.copy),
                onPressed: empty ? null : () => unawaited(_copy(context)),
              ),
              IconButton(
                key: const Key('journalShare'),
                tooltip: l10n.journalShare,
                icon: const Icon(Icons.share_outlined),
                onPressed: empty ? null : () => unawaited(_share(ref)),
              ),
              IconButton(
                key: const Key('journalClear'),
                tooltip: l10n.journalClear,
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: empty ? null : () => unawaited(appLog.clear()),
              ),
            ],
          ),
          body: empty
              ? Center(child: Text(l10n.journalEmpty))
              : ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => _EntryTile(entries[i]),
                ),
        );
      },
    );
  }
}

class _EntryTile extends StatelessWidget {
  const new(this.entry);

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final locale = AppLocalizations.of(context).localeName;
    final (icon, color) = switch (entry.level) {
      LogLevel.info => (Icons.info_outline, colors.onSurfaceVariant),
      LogLevel.warning => (Icons.warning_amber, colors.tertiary),
      LogLevel.error => (Icons.error_outline, colors.error),
    };
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color),
      title: Text(
        '${DateFormat.yMd(locale).add_Hms().format(entry.at)} · '
        '${entry.source}',
      ),
      subtitle: SelectableText(entry.message, maxLines: 6),
    );
  }
}
