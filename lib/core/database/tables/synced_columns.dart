import 'package:drift/drift.dart';

/// Columns shared by every synced table (see PLAN.md §4).
mixin SyncedColumns on Table {
  /// UUID generated client-side.
  TextColumn get id => text()();

  /// Owner (Supabase auth uid); null while the app is used without account.
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete, required for sync.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Local only: row modified since the last successful push.
  BoolColumn get syncPending => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
