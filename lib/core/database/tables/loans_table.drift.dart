// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/features/loans/domain/loan.dart' as i1;
import 'package:dupe/core/database/tables/loans_table.drift.dart' as i2;
import 'package:dupe/core/database/tables/loans_table.dart' as i3;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i4;
import 'package:dupe/core/database/tables/items_table.drift.dart' as i5;
import 'package:drift/internal/modular.dart' as i6;

typedef $$LoansTableTableCreateCompanionBuilder =
    i2.LoansTableCompanion Function({
      required String id,
      i0.Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      required String itemId,
      required String borrowerName,
      required DateTime loanedAt,
      i0.Value<DateTime?> dueAt,
      i0.Value<DateTime?> returnedAt,
      i0.Value<String?> notes,
      i0.Value<int> rowid,
    });
typedef $$LoansTableTableUpdateCompanionBuilder =
    i2.LoansTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String?> userId,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<String> itemId,
      i0.Value<String> borrowerName,
      i0.Value<DateTime> loanedAt,
      i0.Value<DateTime?> dueAt,
      i0.Value<DateTime?> returnedAt,
      i0.Value<String?> notes,
      i0.Value<int> rowid,
    });

final class $$LoansTableTableReferences
    extends
        i0.BaseReferences<i0.GeneratedDatabase, i2.$LoansTableTable, i1.Loan> {
  $$LoansTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static i5.$ItemsTableTable _itemIdTable(i0.GeneratedDatabase db) =>
      i6.ReadDatabaseContainer(db)
          .resultSet<i5.$ItemsTableTable>('items')
          .createAlias('loans__item_id__items__id');

  i5.$$ItemsTableTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = i5
        .$$ItemsTableTableTableManager(
          $_db,
          i6.ReadDatabaseContainer($_db)
              .resultSet<i5.$ItemsTableTable>('items'),
        )
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoansTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$LoansTableTable> {
  $$LoansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<bool> get syncPending => $composableBuilder(
    column: $table.syncPending,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get borrowerName => $composableBuilder(
    column: $table.borrowerName,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get loanedAt => $composableBuilder(
    column: $table.loanedAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => i0.ColumnFilters(column),
  );

  i5.$$ItemsTableTableFilterComposer get itemId {
    final i5.$$ItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: i6.ReadDatabaseContainer($db)
          .resultSet<i5.$ItemsTableTable>('items'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i5.$$ItemsTableTableFilterComposer(
            $db: $db,
            $table: i6.ReadDatabaseContainer($db)
                .resultSet<i5.$ItemsTableTable>('items'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$LoansTableTable> {
  $$LoansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<bool> get syncPending => $composableBuilder(
    column: $table.syncPending,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get borrowerName => $composableBuilder(
    column: $table.borrowerName,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get loanedAt => $composableBuilder(
    column: $table.loanedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i5.$$ItemsTableTableOrderingComposer get itemId {
    final i5.$$ItemsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: i6.ReadDatabaseContainer($db)
          .resultSet<i5.$ItemsTableTable>('items'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i5.$$ItemsTableTableOrderingComposer(
            $db: $db,
            $table: i6.ReadDatabaseContainer($db)
                .resultSet<i5.$ItemsTableTable>('items'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i2.$LoansTableTable> {
  $$LoansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  i0.GeneratedColumn<bool> get syncPending => $composableBuilder(
    column: $table.syncPending,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get borrowerName => $composableBuilder(
    column: $table.borrowerName,
    builder: (column) => column,
  );

  i0.GeneratedColumn<DateTime> get loanedAt =>
      $composableBuilder(column: $table.loanedAt, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  i5.$$ItemsTableTableAnnotationComposer get itemId {
    final i5.$$ItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: i6.ReadDatabaseContainer($db)
          .resultSet<i5.$ItemsTableTable>('items'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i5.$$ItemsTableTableAnnotationComposer(
            $db: $db,
            $table: i6.ReadDatabaseContainer($db)
                .resultSet<i5.$ItemsTableTable>('items'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i2.$LoansTableTable,
          i1.Loan,
          i2.$$LoansTableTableFilterComposer,
          i2.$$LoansTableTableOrderingComposer,
          i2.$$LoansTableTableAnnotationComposer,
          $$LoansTableTableCreateCompanionBuilder,
          $$LoansTableTableUpdateCompanionBuilder,
          (i1.Loan, i2.$$LoansTableTableReferences),
          i1.Loan,
          i0.PrefetchHooks Function({bool itemId})
        > {
  $$LoansTableTableTableManager(
    i0.GeneratedDatabase db,
    i2.$LoansTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$LoansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i2.$$LoansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i2.$$LoansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String?> userId = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime> updatedAt = const i0.Value.absent(),
                i0.Value<DateTime?> deletedAt = const i0.Value.absent(),
                i0.Value<bool> syncPending = const i0.Value.absent(),
                i0.Value<String> itemId = const i0.Value.absent(),
                i0.Value<String> borrowerName = const i0.Value.absent(),
                i0.Value<DateTime> loanedAt = const i0.Value.absent(),
                i0.Value<DateTime?> dueAt = const i0.Value.absent(),
                i0.Value<DateTime?> returnedAt = const i0.Value.absent(),
                i0.Value<String?> notes = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.LoansTableCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                itemId: itemId,
                borrowerName: borrowerName,
                loanedAt: loanedAt,
                dueAt: dueAt,
                returnedAt: returnedAt,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                i0.Value<String?> userId = const i0.Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                i0.Value<DateTime?> deletedAt = const i0.Value.absent(),
                i0.Value<bool> syncPending = const i0.Value.absent(),
                required String itemId,
                required String borrowerName,
                required DateTime loanedAt,
                i0.Value<DateTime?> dueAt = const i0.Value.absent(),
                i0.Value<DateTime?> returnedAt = const i0.Value.absent(),
                i0.Value<String?> notes = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.LoansTableCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                itemId: itemId,
                borrowerName: borrowerName,
                loanedAt: loanedAt,
                dueAt: dueAt,
                returnedAt: returnedAt,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i2.$LoansTableTable, i1.Loan>(table),
                  i2.$$LoansTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return i0.PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends i0.TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: i2.$$LoansTableTableReferences
                            ._itemIdTable(db),
                        referencedColumn: i2.$$LoansTableTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LoansTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i2.$LoansTableTable,
      i1.Loan,
      i2.$$LoansTableTableFilterComposer,
      i2.$$LoansTableTableOrderingComposer,
      i2.$$LoansTableTableAnnotationComposer,
      $$LoansTableTableCreateCompanionBuilder,
      $$LoansTableTableUpdateCompanionBuilder,
      (i1.Loan, i2.$$LoansTableTableReferences),
      i1.Loan,
      i0.PrefetchHooks Function({bool itemId})
    >;
i0.Index get loansItemIdIdx => i0.Index(
  'loans_item_id_idx',
  'CREATE INDEX loans_item_id_idx ON loans (item_id)',
);

class $LoansTableTable extends i3.LoansTable
    with i0.TableInfo<$LoansTableTable, i1.Loan> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTableTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _userIdMeta = const i0.VerificationMeta(
    'userId',
  );
  @override
  late final i0.GeneratedColumn<String> userId = i0.GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _createdAtMeta = const i0.VerificationMeta(
    'createdAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> createdAt =
      i0.GeneratedColumn<DateTime>(
        'created_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _updatedAtMeta = const i0.VerificationMeta(
    'updatedAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> updatedAt =
      i0.GeneratedColumn<DateTime>(
        'updated_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _deletedAtMeta = const i0.VerificationMeta(
    'deletedAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> deletedAt =
      i0.GeneratedColumn<DateTime>(
        'deleted_at',
        aliasedName,
        true,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _syncPendingMeta = const i0.VerificationMeta(
    'syncPending',
  );
  @override
  late final i0.GeneratedColumn<bool> syncPending = i0.GeneratedColumn<bool>(
    'sync_pending',
    aliasedName,
    false,
    type: i0.DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_pending" IN (0, 1))',
    ),
    defaultValue: const i4.Constant(true),
  );
  static const i0.VerificationMeta _itemIdMeta = const i0.VerificationMeta(
    'itemId',
  );
  @override
  late final i0.GeneratedColumn<String> itemId = i0.GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const i0.VerificationMeta _borrowerNameMeta =
      const i0.VerificationMeta('borrowerName');
  @override
  late final i0.GeneratedColumn<String> borrowerName =
      i0.GeneratedColumn<String>(
        'borrower_name',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _loanedAtMeta = const i0.VerificationMeta(
    'loanedAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> loanedAt =
      i0.GeneratedColumn<DateTime>(
        'loaned_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _dueAtMeta = const i0.VerificationMeta(
    'dueAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> dueAt = i0.GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: i0.DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _returnedAtMeta = const i0.VerificationMeta(
    'returnedAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> returnedAt =
      i0.GeneratedColumn<DateTime>(
        'returned_at',
        aliasedName,
        true,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _notesMeta = const i0.VerificationMeta(
    'notes',
  );
  @override
  late final i0.GeneratedColumn<String> notes = i0.GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    syncPending,
    itemId,
    borrowerName,
    loanedAt,
    dueAt,
    returnedAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.Loan> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_pending')) {
      context.handle(
        _syncPendingMeta,
        syncPending.isAcceptableOrUnknown(
          data['sync_pending']!,
          _syncPendingMeta,
        ),
      );
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('borrower_name')) {
      context.handle(
        _borrowerNameMeta,
        borrowerName.isAcceptableOrUnknown(
          data['borrower_name']!,
          _borrowerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_borrowerNameMeta);
    }
    if (data.containsKey('loaned_at')) {
      context.handle(
        _loanedAtMeta,
        loanedAt.isAcceptableOrUnknown(data['loaned_at']!, _loanedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loanedAtMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.Loan(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      borrowerName: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}borrower_name'],
      )!,
      loanedAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}loaned_at'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      syncPending: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.bool,
        data['${effectivePrefix}sync_pending'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      returnedAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $LoansTableTable createAlias(String alias) {
    return $LoansTableTable(attachedDatabase, alias);
  }
}

class LoansTableCompanion extends i0.UpdateCompanion<i1.Loan> {
  final i0.Value<String> id;
  final i0.Value<String?> userId;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> updatedAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<bool> syncPending;
  final i0.Value<String> itemId;
  final i0.Value<String> borrowerName;
  final i0.Value<DateTime> loanedAt;
  final i0.Value<DateTime?> dueAt;
  final i0.Value<DateTime?> returnedAt;
  final i0.Value<String?> notes;
  final i0.Value<int> rowid;
  const LoansTableCompanion({
    this.id = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.updatedAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.itemId = const i0.Value.absent(),
    this.borrowerName = const i0.Value.absent(),
    this.loanedAt = const i0.Value.absent(),
    this.dueAt = const i0.Value.absent(),
    this.returnedAt = const i0.Value.absent(),
    this.notes = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  LoansTableCompanion.insert({
    required String id,
    this.userId = const i0.Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    required String itemId,
    required String borrowerName,
    required DateTime loanedAt,
    this.dueAt = const i0.Value.absent(),
    this.returnedAt = const i0.Value.absent(),
    this.notes = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       createdAt = i0.Value(createdAt),
       updatedAt = i0.Value(updatedAt),
       itemId = i0.Value(itemId),
       borrowerName = i0.Value(borrowerName),
       loanedAt = i0.Value(loanedAt);
  static i0.Insertable<i1.Loan> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? updatedAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<bool>? syncPending,
    i0.Expression<String>? itemId,
    i0.Expression<String>? borrowerName,
    i0.Expression<DateTime>? loanedAt,
    i0.Expression<DateTime>? dueAt,
    i0.Expression<DateTime>? returnedAt,
    i0.Expression<String>? notes,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncPending != null) 'sync_pending': syncPending,
      if (itemId != null) 'item_id': itemId,
      if (borrowerName != null) 'borrower_name': borrowerName,
      if (loanedAt != null) 'loaned_at': loanedAt,
      if (dueAt != null) 'due_at': dueAt,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i2.LoansTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String?>? userId,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? updatedAt,
    i0.Value<DateTime?>? deletedAt,
    i0.Value<bool>? syncPending,
    i0.Value<String>? itemId,
    i0.Value<String>? borrowerName,
    i0.Value<DateTime>? loanedAt,
    i0.Value<DateTime?>? dueAt,
    i0.Value<DateTime?>? returnedAt,
    i0.Value<String?>? notes,
    i0.Value<int>? rowid,
  }) {
    return i2.LoansTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncPending: syncPending ?? this.syncPending,
      itemId: itemId ?? this.itemId,
      borrowerName: borrowerName ?? this.borrowerName,
      loanedAt: loanedAt ?? this.loanedAt,
      dueAt: dueAt ?? this.dueAt,
      returnedAt: returnedAt ?? this.returnedAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = i0.Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = i0.Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = i0.Variable<DateTime>(deletedAt.value);
    }
    if (syncPending.present) {
      map['sync_pending'] = i0.Variable<bool>(syncPending.value);
    }
    if (itemId.present) {
      map['item_id'] = i0.Variable<String>(itemId.value);
    }
    if (borrowerName.present) {
      map['borrower_name'] = i0.Variable<String>(borrowerName.value);
    }
    if (loanedAt.present) {
      map['loaned_at'] = i0.Variable<DateTime>(loanedAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = i0.Variable<DateTime>(dueAt.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = i0.Variable<DateTime>(returnedAt.value);
    }
    if (notes.present) {
      map['notes'] = i0.Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('itemId: $itemId, ')
          ..write('borrowerName: $borrowerName, ')
          ..write('loanedAt: $loanedAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$LoanInsertable implements i0.Insertable<i1.Loan> {
  i1.Loan _object;
  _$LoanInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i2.LoansTableCompanion(
      id: i0.Value(_object.id),
      userId: i0.Value(_object.userId),
      createdAt: i0.Value(_object.createdAt),
      updatedAt: i0.Value(_object.updatedAt),
      deletedAt: i0.Value(_object.deletedAt),
      syncPending: i0.Value(_object.syncPending),
      itemId: i0.Value(_object.itemId),
      borrowerName: i0.Value(_object.borrowerName),
      loanedAt: i0.Value(_object.loanedAt),
      dueAt: i0.Value(_object.dueAt),
      returnedAt: i0.Value(_object.returnedAt),
      notes: i0.Value(_object.notes),
    ).toColumns(false);
  }
}

extension LoanToInsertable on i1.Loan {
  _$LoanInsertable toInsertable() {
    return _$LoanInsertable(this);
  }
}
