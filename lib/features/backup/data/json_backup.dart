import 'dart:convert';

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
    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(json) as Map<String, dynamic>;
    } on Object {
      throw const BackupFormatException();
    }
    if (decoded['format'] != format) throw const BackupFormatException();
    var written = 0;
    await _db.transaction(() async {
      for (final table in _codec.tables) {
        final rows = decoded[table.actualTableName];
        if (rows is! List<dynamic>) continue;
        for (final row in rows.cast<Map<String, dynamic>>()) {
          // Restored rows are pushed by the next sync.
          if (await _codec.apply(table, row, pending: true)) written++;
        }
      }
    });
    return written;
  }
}

/// Not a Dupe backup file.
class BackupFormatException implements Exception {
  const new();
}
