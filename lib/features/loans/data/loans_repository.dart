import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loans_repository.g.dart';

@Riverpod(keepAlive: true)
LoansRepository loansRepository(Ref ref) =>
    LoansRepository(ref.watch(appDatabaseProvider));

/// Loans (full CRUD comes in phase 5; the grid already shows loaned items).
class LoansRepository {
  new(this._db);

  final AppDatabase _db;

  /// Ids of items currently on loan.
  Stream<Set<String>> watchLoanedItemIds() {
    final l = _db.loansTable;
    final query = _db.selectOnly(l)
      ..addColumns([l.itemId])
      ..where(l.returnedAt.isNull() & l.deletedAt.isNull());
    return query.watch().map(
      (rows) => {for (final row in rows) row.read(l.itemId)!},
    );
  }
}
