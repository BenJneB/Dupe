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
  ];

  static const _localOnly = {'sync_pending'};

  /// Text columns holding JSON (authors lists, external ids).
  static const _jsonColumns = {'authors', 'external_ids'};

  Iterable<GeneratedColumn<Object>> syncedColumns(
    TableInfo<Table, Object?> t,
  ) => t.$columns.where((c) => !_localOnly.contains(c.name));

  /// Raw SQLite row -> remote JSON.
  Map<String, Object?> toRemote(
    TableInfo<Table, Object?> table,
    Map<String, Object?> raw,
    String userId,
  ) => {
    for (final c in syncedColumns(table))
      c.name: c.name == 'user_id' ? userId : _out(c, raw[c.name]),
  };

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
