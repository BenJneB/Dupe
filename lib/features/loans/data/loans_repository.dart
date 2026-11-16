import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/database/tables/loans_table.drift.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/loans/domain/loan.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loans_repository.g.dart';

@Riverpod(keepAlive: true)
LoansRepository loansRepository(Ref ref) => LoansRepository(
  ref.watch(appDatabaseProvider),
  now: ref.watch(clockProvider),
  newId: ref.watch(idGeneratorProvider),
);

/// A loan with the lent item.
typedef LoanWithItem = ({Loan loan, Item item});

/// Loans of items to people. Same write rules as the collection: updated_at
/// bumped, pending sync, soft delete.
class LoansRepository {
  new(this._db, {required this.now, required this.newId});

  final AppDatabase _db;
  final DateTime Function() now;
  final String Function() newId;

  Future<Loan> lend(
    String itemId, {
    required String borrower,
    DateTime? dueAt,
  }) async {
    final at = now();
    final loan = Loan(
      id: newId(),
      createdAt: at,
      updatedAt: at,
      itemId: itemId,
      borrowerName: borrower.trim(),
      loanedAt: at,
      dueAt: dueAt,
    );
    await _db.into(_db.loansTable).insert(loan.toInsertable());
    return loan;
  }

  Future<void> markReturned(Loan loan) {
    final at = now();
    return _db
        .into(_db.loansTable)
        .insertOnConflictUpdate(
          loan
              .copyWith(returnedAt: at, updatedAt: at, syncPending: true)
              .toInsertable(),
        );
  }

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

  /// Current loan of an item, if any.
  Stream<Loan?> watchActiveLoan(String itemId) =>
      (_db.select(_db.loansTable)
            ..where(
              (t) =>
                  t.itemId.equals(itemId) &
                  t.returnedAt.isNull() &
                  t.deletedAt.isNull(),
            )
            ..limit(1))
          .watchSingleOrNull();

  /// All loans with their item, current ones first then by due date,
  /// returned ones by return date (most recent first).
  Stream<List<LoanWithItem>> watchLoans() => _loansQuery().watch().map(_read);

  /// Every loan, returned ones included (reminders to cancel).
  Future<List<LoanWithItem>> allLoans() async =>
      _read(await _loansQuery().get());

  /// Current loans (for reminders).
  Future<List<LoanWithItem>> activeLoans() async => [
    for (final entry in _read(await _loansQuery().get()))
      if (entry.loan.isActive) entry,
  ];

  JoinedSelectStatement<HasResultSet, dynamic> _loansQuery() {
    final l = _db.loansTable;
    final i = _db.itemsTable;
    return _db.select(l).join([innerJoin(i, i.id.equalsExp(l.itemId))])
      ..where(l.deletedAt.isNull() & i.deletedAt.isNull())
      ..orderBy([
        OrderingTerm.desc(l.returnedAt.isNull()),
        OrderingTerm.asc(l.dueAt),
        OrderingTerm.desc(l.returnedAt),
        OrderingTerm.desc(l.loanedAt),
      ]);
  }

  List<LoanWithItem> _read(List<TypedResult> rows) => [
    for (final row in rows)
      (
        loan: row.readTable(_db.loansTable),
        item: row.readTable(_db.itemsTable),
      ),
  ];

  /// Names already used, most frequent first (borrower autocomplete).
  Future<List<String>> borrowerNames() async {
    final l = _db.loansTable;
    final count = l.id.count();
    final rows =
        await (_db.selectOnly(l)
              ..addColumns([l.borrowerName, count])
              ..where(l.deletedAt.isNull())
              ..groupBy([l.borrowerName])
              ..orderBy([OrderingTerm.desc(count)]))
            .get();
    return [for (final row in rows) row.read(l.borrowerName)!];
  }
}
