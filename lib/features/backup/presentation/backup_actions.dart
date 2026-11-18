import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/backup/data/auto_backups.dart';
import 'package:dupe/features/backup/data/csv_codec.dart';
import 'package:dupe/features/backup/data/csv_export.dart';
import 'package:dupe/features/backup/data/file_io.dart';
import 'package:dupe/features/backup/data/full_archive.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:dupe/features/backup/presentation/restore_dialog.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/covers/data/cover_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Backup / export / import actions of the settings screen.
///
/// The texts and the provider container are taken at creation: an action
/// carries on (restore, export after the share sheet) even when its screen
/// is closed meanwhile; only dialogs and navigation need [context].
class BackupActions {
  new(this.context)
    : _l10n = AppLocalizations.of(context),
      ref = ProviderScope.containerOf(context, listen: false);

  final BuildContext context;
  final ProviderContainer ref;
  final AppLocalizations _l10n;

  String _stamp() {
    final d = ref.read(clockProvider)();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _guard(Future<String?> Function() action) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = _l10n;
    // Replaces any previous message (e.g. the import report).
    void show(String text) => messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
    try {
      if (await action() case final message?) show(message);
    } on BackupFormatException {
      show(l10n.restoreInvalid);
    } on Object catch (e, stack) {
      show(l10n.fileError(reportError(l10n, 'backup', e, stack)));
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

  /// Zip with the backup and every photo (phase 31).
  Future<void> exportArchive() => _guard(() async {
    final (:bytes, :photos) = await _archive().export(
      now: ref.read(clockProvider)(),
    );
    final saved = await ref
        .read(fileIoProvider)
        .save(
          'dupe-archive-${_stamp()}.zip',
          bytes,
          mimeType: 'application/zip',
        );
    return saved ? _l10n.fullArchiveSaved(photos) : null;
  });

  Future<void> restoreArchive() => _guard(() async {
    final file = await ref
        .read(fileIoProvider)
        .open(
          label: 'Zip',
          extensions: const ['zip'],
          mimeTypes: const ['application/zip'],
        );
    if (file == null) return null;
    final (:rows, :photos) = await _archive().restore(file.bytes);
    return _l10n.fullArchiveRestored(rows, photos);
  });

  FullArchive _archive() => FullArchive(
    ref.read(appDatabaseProvider),
    ref.read(coverPhotosProvider),
    ref.read(coverStoreProvider),
  );

  Future<void> restoreJson() => _guard(() async {
    final file = await ref
        .read(fileIoProvider)
        .open(
          label: 'JSON',
          extensions: const ['json'],
          mimeTypes: const ['application/json'],
        );
    if (file == null) return null;
    final json = utf8.decode(file.bytes);
    JsonBackup.decode(json); // Not a backup: stop before asking.
    if (!context.mounted) return null;
    final choice = await showRestoreDialog(context, subtitle: file.name);
    return choice == null ? null : await _restore(json, choice);
  });

  /// Restores (or exports) an automatic backup.
  Future<void> restoreAuto(AutoBackup backup, String label) => _guard(() async {
    final choice = await showRestoreDialog(
      context,
      subtitle: label,
      export: true,
    );
    if (choice == null) return null;
    // Read first: the backup taken before restoring may prune it.
    final json = await ref.read(autoBackupsProvider).read(backup);
    if (choice == RestoreChoice.export) {
      final saved = await ref
          .read(fileIoProvider)
          .save(
            'dupe-${backup.name}',
            Uint8List.fromList(utf8.encode(json)),
            mimeType: 'application/json',
          );
      return saved ? _l10n.exportDone : null;
    }
    return await _restore(json, choice);
  });

  Future<String> _restore(String json, RestoreChoice choice) async {
    final l10n = _l10n;
    await ref.read(autoBackupsProvider).create(AutoBackupKind.beforeRestore);
    ref.invalidate(autoBackupListProvider);
    final backup = JsonBackup(ref.read(appDatabaseProvider));
    if (choice == RestoreChoice.merge) {
      return l10n.restoreDone(await backup.restore(json));
    }
    final r = await backup.replace(json, now: ref.read(clockProvider)());
    return l10n.replaceDone(r.restored, r.removed);
  }

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
