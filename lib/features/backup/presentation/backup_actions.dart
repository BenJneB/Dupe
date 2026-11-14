import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/backup/data/csv_codec.dart';
import 'package:dupe/features/backup/data/csv_export.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Backup / export / import actions of the settings screen.
class BackupActions {
  const new(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  AppLocalizations get _l10n => AppLocalizations.of(context);

  String _stamp() {
    final d = ref.read(clockProvider)();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _guard(Future<String?> Function() action) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = _l10n;
    try {
      final message = await action();
      if (message != null) {
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
    } on Object catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.fileError('$e'))));
    }
  }

  Future<void> exportJson() => _guard(() async {
    final json = await JsonBackup(ref.read(appDatabaseProvider))
        .export(now: ref.read(clockProvider)());
    final saved = await ref
        .read(fileIoProvider)
        .save(
          'dupe-sauvegarde-${_stamp()}.json',
          Uint8List.fromList(utf8.encode(json)),
          mimeType: 'application/json',
        );
    return saved ? _l10n.exportDone : null;
  });

  Future<void> restoreJson() => _guard(() async {
    final l10n = _l10n;
    final file = await ref
        .read(fileIoProvider)
        .open(
          label: 'JSON',
          extensions: const ['json'],
          mimeTypes: const ['application/json'],
        );
    if (file == null) return null;
    try {
      final count = await JsonBackup(ref.read(appDatabaseProvider))
          .restore(utf8.decode(file.bytes));
      return l10n.restoreDone(count);
    } on BackupFormatException {
      return l10n.restoreInvalid;
    }
  });

  /// [type] null: every type in one file.
  Future<void> exportCsv(CollectionType? type) => _guard(() async {
    final db = ref.read(appDatabaseProvider);
    final items =
        await (db.select(db.itemsTable)..where(
              (t) =>
                  t.deletedAt.isNull() &
                  (type == null
                      ? const Constant(true)
                      : t.type.equalsValue(type)),
            ))
            .get();
    final series = {
      for (final s in await db.select(db.seriesTable).get()) s.id: s,
    };
    items.sort((a, b) {
      final byTitle = (series[a.seriesId]?.title ?? a.title).compareTo(
        series[b.seriesId]?.title ?? b.title,
      );
      if (byTitle != 0) return byTitle;
      return (int.tryParse(a.volumeNumber ?? '') ?? 0).compareTo(
        int.tryParse(b.volumeNumber ?? '') ?? 0,
      );
    });
    final saved = await ref
        .read(fileIoProvider)
        .save(
          'dupe-${type?.dbValue ?? 'collection'}-${_stamp()}.csv',
          Uint8List.fromList(utf8.encode(itemsToCsv(items, series))),
          mimeType: 'text/csv',
        );
    return saved ? _l10n.exportDone : null;
  });

  Future<void> importCsv() => _guard(() async {
    final l10n = _l10n;
    final file = await ref
        .read(fileIoProvider)
        .open(
          label: 'CSV',
          extensions: const ['csv', 'txt'],
          mimeTypes: const [
            'text/csv',
            'text/comma-separated-values',
            'text/plain',
          ],
        );
    if (file == null) return null;
    final rows = Csv.parse(utf8.decode(file.bytes, allowMalformed: true));
    if (rows.length < 2) return l10n.csvEmpty;
    if (context.mounted) {
      await context.push(
        AppRoutes.csvImport,
        extra: (name: file.name, rows: rows),
      );
    }
    return null;
  });
}
