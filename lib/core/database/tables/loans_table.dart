import 'package:drift/drift.dart';
import 'package:dupe/core/database/tables/items_table.dart';
import 'package:dupe/core/database/tables/synced_columns.dart';
import 'package:dupe/features/loans/domain/loan.dart';

@UseRowClass(Loan, generateInsertable: true)
@TableIndex(name: 'loans_item_id_idx', columns: {#itemId})
class LoansTable extends Table with SyncedColumns {
  @override
  String get tableName => 'loans';

  TextColumn get itemId => text().references(ItemsTable, #id)();
  TextColumn get borrowerName => text()();
  DateTimeColumn get loanedAt => dateTime()();
  DateTimeColumn get dueAt => dateTime().nullable()();
  DateTimeColumn get returnedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}
