import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/features/collection/domain/enums.dart';

typedef WidgetCounts = ({int owned, int overdueLoans});

/// Owned copies and loans past their due date, for the home-screen widget.
Future<WidgetCounts> readWidgetCounts(AppDatabase db, DateTime now) async {
  final owned = await db
      .customSelect(
        'SELECT COUNT(*) AS n FROM items '
        'WHERE deleted_at IS NULL AND ownership = ?',
        variables: [Variable(Ownership.possede.dbValue)],
        readsFrom: {db.itemsTable},
      )
      .getSingle();
  final overdue =
      await (db.selectOnly(db.loansTable)
            ..addColumns([db.loansTable.id.count()])
            ..where(
              db.loansTable.deletedAt.isNull() &
                  db.loansTable.returnedAt.isNull() &
                  db.loansTable.dueAt.isSmallerThanValue(now),
            ))
          .getSingle();
  return (
    owned: owned.read<int>('n'),
    overdueLoans: overdue.read(db.loansTable.id.count()) ?? 0,
  );
}
