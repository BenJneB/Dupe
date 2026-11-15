import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/sync/sync_codec.dart';

/// Full backup (series, items, loans, deleted rows included so that a
/// restore also propagates deletions), in the sync JSON format.
class JsonBackup {
  new(this._db) : _codec = SyncCodec(_db);

  final AppDatabase _db;
  final SyncCodec _codec;

  static const format = 'dupe-backup';
  static const version = 1;

  Future<String> export({required DateTime now}) async {
    final data = <String, Object?>{
      'format': format,
      'version': version,
      'exported_at': now.toUtc().toIso8601String(),
    };
    for (final table in _codec.tables) {
      final rows = await _db
          .customSelect(
            'SELECT * FROM ${table.actualTableName} ORDER BY created_at',
            readsFrom: {table},
          )
          .get();
      data[table.actualTableName] = [
        for (final r in rows) _codec.toRemote(table, r.data),
      ];
    }
    return const JsonEncoder.withIndent(' ').convert(data);
  }

  /// Merges a backup: missing rows are added, rows newer than the local
  /// ones replace them. Returns the number of rows written.
  Future<int> restore(String json) async {
    final decoded = decode(json);
    var written = 0;
    await _db.transaction(() async {
      for (final table in _codec.tables) {
        for (final row in _rows(decoded, table)) {
          // Restored rows are pushed by the next sync.
          if (await _codec.apply(table, row, pending: true)) written++;
        }
      }
    });
    return written;
  }

  /// Puts the collection back exactly in the state of the backup: its rows
  /// are rewritten as of [now] (so that they win at the next sync on every
  /// device) and the local rows it does not contain are deleted (soft).
  /// Returns the numbers of items restored and removed.
  Future<({int restored, int removed})> replace(
    String json, {
    required DateTime now,
  }) async {
    final decoded = decode(json);
    final at = now.toUtc().toIso8601String();
    var restored = 0;
    var removed = 0;
    await _db.transaction(() async {
      for (final table in _codec.tables) {
        final name = table.actualTableName;
        final ids = <Object?>{};
        for (final row in _rows(decoded, table)) {
          ids.add(row['id']);
          await _codec.apply(
            table,
            {...row, 'updated_at': at},
            pending: true,
            force: true,
          );
          if (name == 'items' && row['deleted_at'] == null) restored++;
        }
        final alive = await _db
            .customSelect(
              'SELECT id FROM $name WHERE deleted_at IS NULL',
              readsFrom: {table},
            )
            .get();
        for (final r in alive.where((r) => !ids.contains(r.data['id']))) {
          final n = await _db.customUpdate(
            'UPDATE $name SET deleted_at = ?, updated_at = ?, '
            'sync_pending = 1 WHERE id = ?',
            variables: [
              Variable<DateTime>(now),
              Variable<DateTime>(now),
              Variable(r.data['id']),
            ],
            updates: {table},
          );
          if (name == 'items') removed += n;
        }
      }
    });
    return (restored: restored, removed: removed);
  }

  /// Parses a backup; throws [BackupFormatException] if it is not one.
  static Map<String, dynamic> decode(String json) {
    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(json) as Map<String, dynamic>;
    } on Object {
      throw const BackupFormatException();
    }
    if (decoded['format'] != format) throw const BackupFormatException();
    return decoded;
  }

  static Iterable<Map<String, dynamic>> _rows(
    Map<String, dynamic> decoded,
    TableInfo<Table, Object?> table,
  ) => switch (decoded[table.actualTableName]) {
    final List<dynamic> rows => rows.cast<Map<String, dynamic>>(),
    _ => const [],
  };
}

/// Not a Dupe backup file.
class BackupFormatException implements Exception {
  const new();
}
