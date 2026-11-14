import 'dart:io';

import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/backup/data/backup_store.dart';
import 'package:dupe/features/backup/data/json_backup.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_backups.g.dart';

enum AutoBackupKind { weekly, beforeImport, beforeRestore }

/// One automatic backup; its metadata is in its file name
/// (`<kind>_<UTC instant>_<item count>.json`).
@immutable
class AutoBackup {
  const new(this.name, this.kind, this.at, this.items);

  final String name;
  final AutoBackupKind kind;
  final DateTime at;

  /// Items (not deleted) in the collection when it was taken.
  final int items;

  static final _pattern = RegExp(r'^(\w+)_(\d{8}T\d{6}Z)_(\d+)\.json$');

  static AutoBackup? parse(String name) {
    final m = _pattern.firstMatch(name);
    if (m == null) return null;
    final kind = AutoBackupKind.values.asNameMap()[m[1]];
    final at = DateTime.tryParse(m[2]!);
    if (kind == null || at == null) return null;
    return AutoBackup(name, kind, at, int.parse(m[3]!));
  }

  static String nameFor(AutoBackupKind kind, DateTime at, int items) {
    final stamp = at
        .toUtc()
        .toIso8601String()
        .replaceAll(RegExp('[-:]'), '')
        .split('.')
        .first;
    return '${kind.name}_${stamp}Z_$items.json';
  }
}

/// Automatic JSON backups (PLAN_V2 phase 11): weekly, and before a CSV
/// import or a restore. The last [keep] of each kind are kept.
class AutoBackups {
  new(this._db, this._store, this._now, {this.keep = 8});

  final AppDatabase _db;
  final BackupStore _store;
  final DateTime Function() _now;
  final int keep;

  static const weeklyEvery = Duration(days: 7);

  /// Newest first.
  Future<List<AutoBackup>> list() async =>
      [for (final n in await _store.names()) ?AutoBackup.parse(n)]
        ..sort((a, b) => b.at.compareTo(a.at));

  Future<String> read(AutoBackup backup) => _store.read(backup.name);

  /// Takes a backup now; none when the collection is empty (nothing to
  /// protect).
  Future<AutoBackup?> create(AutoBackupKind kind) async {
    final items = await _db
        .customSelect(
          'SELECT COUNT(*) AS n FROM items WHERE deleted_at IS NULL',
          readsFrom: {_db.itemsTable},
        )
        .getSingle();
    final count = items.read<int>('n');
    if (count == 0) return null;
    final now = _now();
    final json = await JsonBackup(_db).export(now: now);
    final backup = AutoBackup(
      AutoBackup.nameFor(kind, now, count),
      kind,
      now,
      count,
    );
    await _store.write(backup.name, json);
    await _prune(kind);
    return backup;
  }

  /// The weekly backup, when the last one is older than [weeklyEvery].
  Future<AutoBackup?> weeklyIfDue() async {
    final last = (await list())
        .where((b) => b.kind == AutoBackupKind.weekly)
        .firstOrNull;
    if (last != null && _now().difference(last.at) < weeklyEvery) return null;
    return await create(AutoBackupKind.weekly);
  }

  Future<void> _prune(AutoBackupKind kind) async {
    final old = (await list()).where((b) => b.kind == kind).skip(keep);
    for (final b in old) {
      await _store.delete(b.name);
    }
  }
}

/// Overridden in tests (memory).
@Riverpod(keepAlive: true)
BackupStore backupStore(Ref ref) => DirectoryBackupStore(
  () async => Directory(
    p.join((await getApplicationSupportDirectory()).path, 'backups'),
  ),
);

@riverpod
AutoBackups autoBackups(Ref ref) => AutoBackups(
  ref.watch(appDatabaseProvider),
  ref.watch(backupStoreProvider),
  ref.watch(clockProvider),
);

@riverpod
Future<List<AutoBackup>> autoBackupList(Ref ref) =>
    ref.watch(autoBackupsProvider).list();
