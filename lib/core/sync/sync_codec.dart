import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';

/// Converts rows between SQLite (drift storage) and the remote JSON.
///
/// Generic over the synced tables: column types come from drift. Dates go
/// out as UTC ISO-8601; JSON text columns (lists, maps) as JSON values;
/// `sync_pending` is local only.
class SyncCodec {
  const new(this._db);

  final AppDatabase _db;

  /// Synced tables, in push order (series before their items and loans).
  List<TableInfo<Table, Object?>> get tables => [
    _db.seriesTable,
    _db.itemsTable,
    _db.loansTable,
    _db.recommendationFeedbackTable,
    _db.itemPhotosTable,
  ];

  static const _localOnly = {'sync_pending'};

  /// Text columns holding JSON (authors lists, external ids).
  static const _jsonColumns = {'authors', 'external_ids'};

  Iterable<GeneratedColumn<Object>> syncedColumns(
    TableInfo<Table, Object?> t,
  ) => t.$columns.where((c) => !_localOnly.contains(c.name));

  /// Raw SQLite row -> remote JSON.
  /// [userId] replaces the owner (sync); null keeps it (backup).
  Map<String, Object?> toRemote(
    TableInfo<Table, Object?> table,
    Map<String, Object?> raw, [
    String? userId,
  ]) => {
    for (final c in syncedColumns(table))
      c.name: c.name == 'user_id' && userId != null
          ? userId
          : _out(c, raw[c.name]),
  };

  /// Writes a remote/backup row locally unless a local row is newer
  /// (last write wins). [pending]: whether the row must be pushed later.
  /// [force]: write even over a newer local row (full restore).
  /// Returns whether the row was written.
  Future<bool> apply(
    TableInfo<Table, Object?> table,
    Map<String, Object?> row, {
    required bool pending,
    bool force = false,
  }) async {
    final name = table.actualTableName;
    final local = await _db
        .customSelect(
          'SELECT updated_at, sync_pending, user_id FROM $name WHERE id = ?',
          variables: [Variable(row['id'])],
          readsFrom: {table},
        )
        .getSingleOrNull();
    if (local != null && !force) {
      final localAt = _db.typeMapping.read(
        DriftSqlType.dateTime,
        local.data['updated_at'],
      )!;
      final rowAt = DateTime.parse(row['updated_at']! as String);
      // Sync: only a pending local change can be newer. Restore: any.
      final localMayWin = pending || local.data['sync_pending'] == 1;
      if (localMayWin && !rowAt.isAfter(localAt)) return false;
      // Same write received again (pull overlap): nothing to change.
      if (rowAt.isAtSameMomentAs(localAt) &&
          local.data['user_id'] == row['user_id']) {
        return false;
      }
    }
    final columns = syncedColumns(table).map((c) => c.name).toList();
    final flag = pending ? 1 : 0;
    await _db.customInsert(
      'INSERT INTO $name (${columns.join(', ')}, sync_pending) '
      'VALUES (${List.filled(columns.length, '?').join(', ')}, $flag) '
      'ON CONFLICT(id) DO UPDATE SET '
      '${[for (final c in columns.skip(1)) '$c = excluded.$c'].join(', ')}, '
      'sync_pending = $flag',
      variables: toLocal(table, row),
      updates: {table},
    );
    return true;
  }

  Object? _out(GeneratedColumn<Object> c, Object? raw) {
    if (raw == null) return null;
    if (_jsonColumns.contains(c.name)) return jsonDecode(raw as String);
    final value = _db.typeMapping.read(c.type, raw);
    return value is DateTime ? value.toUtc().toIso8601String() : value;
  }

  /// Remote JSON -> drift variables, in [syncedColumns] order.
  List<Variable<Object>> toLocal(
    TableInfo<Table, Object?> table,
    Map<String, Object?> remote,
  ) => [for (final c in syncedColumns(table)) Variable(_in(c, remote[c.name]))];

  Object? _in(GeneratedColumn<Object> c, Object? value) {
    if (value == null) return null;
    if (_jsonColumns.contains(c.name)) return jsonEncode(value);
    return switch (c.type) {
      DriftSqlType.dateTime => DateTime.parse(value as String).toLocal(),
      DriftSqlType.double => (value as num).toDouble(),
      DriftSqlType.int => (value as num).toInt(),
      _ => value,
    };
  }
}
