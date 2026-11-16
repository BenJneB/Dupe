import 'package:drift/drift.dart';

extension UpsertKeepingDeletion on DatabaseConnectionUser {
  /// Inserts [row], or updates every column of the existing one except
  /// `deleted_at`: saving a copy read before a deletion (open form, dialog,
  /// sync meanwhile) never revives the row. Restoring and deleting go
  /// through explicit updates.
  Future<void> upsertKeepingDeletion<T extends Table, D>(
    TableInfo<T, D> table,
    Insertable<D> row,
  ) =>
      into(table)
          .insert(row, onConflict: DoUpdate((_) => _WithoutDeletion(row)));
}

class _WithoutDeletion<D> implements Insertable<D> {
  const new(this._row);

  final Insertable<D> _row;

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) =>
      _row.toColumns(nullToAbsent)..remove('deleted_at');
}
