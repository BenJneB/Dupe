// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/features/recommendations/domain/recommendation_feedback.dart'
    as i1;
import 'package:dupe/core/database/tables/recommendation_feedback_table.drift.dart'
    as i2;
import 'package:dupe/core/database/tables/recommendation_feedback_table.dart'
    as i3;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i4;

typedef $$RecommendationFeedbackTableTableCreateCompanionBuilder =
    i2.RecommendationFeedbackTableCompanion Function({
      required String id,
      i0.Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      required String suggestionKey,
      required String reasonKind,
      required String reasonKey,
      i0.Value<int> rowid,
    });
typedef $$RecommendationFeedbackTableTableUpdateCompanionBuilder =
    i2.RecommendationFeedbackTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String?> userId,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<String> suggestionKey,
      i0.Value<String> reasonKind,
      i0.Value<String> reasonKey,
      i0.Value<int> rowid,
    });

class $$RecommendationFeedbackTableTableFilterComposer
    extends
        i0.Composer<
          i0.GeneratedDatabase,
          i2.$RecommendationFeedbackTableTable
        > {
  $$RecommendationFeedbackTableTableFilterComposer({
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

  i0.ColumnFilters<String> get suggestionKey => $composableBuilder(
    column: $table.suggestionKey,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get reasonKind => $composableBuilder(
    column: $table.reasonKind,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get reasonKey => $composableBuilder(
    column: $table.reasonKey,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$RecommendationFeedbackTableTableOrderingComposer
    extends
        i0.Composer<
          i0.GeneratedDatabase,
          i2.$RecommendationFeedbackTableTable
        > {
  $$RecommendationFeedbackTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get suggestionKey => $composableBuilder(
    column: $table.suggestionKey,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get reasonKind => $composableBuilder(
    column: $table.reasonKind,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get reasonKey => $composableBuilder(
    column: $table.reasonKey,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$RecommendationFeedbackTableTableAnnotationComposer
    extends
        i0.Composer<
          i0.GeneratedDatabase,
          i2.$RecommendationFeedbackTableTable
        > {
  $$RecommendationFeedbackTableTableAnnotationComposer({
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

  i0.GeneratedColumn<String> get suggestionKey => $composableBuilder(
    column: $table.suggestionKey,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get reasonKind => $composableBuilder(
    column: $table.reasonKind,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get reasonKey =>
      $composableBuilder(column: $table.reasonKey, builder: (column) => column);
}

class $$RecommendationFeedbackTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i2.$RecommendationFeedbackTableTable,
          i1.RecommendationFeedback,
          i2.$$RecommendationFeedbackTableTableFilterComposer,
          i2.$$RecommendationFeedbackTableTableOrderingComposer,
          i2.$$RecommendationFeedbackTableTableAnnotationComposer,
          $$RecommendationFeedbackTableTableCreateCompanionBuilder,
          $$RecommendationFeedbackTableTableUpdateCompanionBuilder,
          (
            i1.RecommendationFeedback,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i2.$RecommendationFeedbackTableTable,
              i1.RecommendationFeedback
            >,
          ),
          i1.RecommendationFeedback,
          i0.PrefetchHooks Function()
        > {
  $$RecommendationFeedbackTableTableTableManager(
    i0.GeneratedDatabase db,
    i2.$RecommendationFeedbackTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i2.$$RecommendationFeedbackTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              i2.$$RecommendationFeedbackTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              i2.$$RecommendationFeedbackTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String?> userId = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime> updatedAt = const i0.Value.absent(),
                i0.Value<DateTime?> deletedAt = const i0.Value.absent(),
                i0.Value<bool> syncPending = const i0.Value.absent(),
                i0.Value<String> suggestionKey = const i0.Value.absent(),
                i0.Value<String> reasonKind = const i0.Value.absent(),
                i0.Value<String> reasonKey = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.RecommendationFeedbackTableCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                suggestionKey: suggestionKey,
                reasonKind: reasonKind,
                reasonKey: reasonKey,
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
                required String suggestionKey,
                required String reasonKind,
                required String reasonKey,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i2.RecommendationFeedbackTableCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                suggestionKey: suggestionKey,
                reasonKind: reasonKind,
                reasonKey: reasonKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    i2.$RecommendationFeedbackTableTable,
                    i1.RecommendationFeedback
                  >(table),
                  i0.BaseReferences<
                    i0.GeneratedDatabase,
                    i2.$RecommendationFeedbackTableTable,
                    i1.RecommendationFeedback
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecommendationFeedbackTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i2.$RecommendationFeedbackTableTable,
      i1.RecommendationFeedback,
      i2.$$RecommendationFeedbackTableTableFilterComposer,
      i2.$$RecommendationFeedbackTableTableOrderingComposer,
      i2.$$RecommendationFeedbackTableTableAnnotationComposer,
      $$RecommendationFeedbackTableTableCreateCompanionBuilder,
      $$RecommendationFeedbackTableTableUpdateCompanionBuilder,
      (
        i1.RecommendationFeedback,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i2.$RecommendationFeedbackTableTable,
          i1.RecommendationFeedback
        >,
      ),
      i1.RecommendationFeedback,
      i0.PrefetchHooks Function()
    >;

class $RecommendationFeedbackTableTable extends i3.RecommendationFeedbackTable
    with
        i0.TableInfo<
          $RecommendationFeedbackTableTable,
          i1.RecommendationFeedback
        > {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecommendationFeedbackTableTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _suggestionKeyMeta =
      const i0.VerificationMeta('suggestionKey');
  @override
  late final i0.GeneratedColumn<String> suggestionKey =
      i0.GeneratedColumn<String>(
        'suggestion_key',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const i0.VerificationMeta _reasonKindMeta = const i0.VerificationMeta(
    'reasonKind',
  );
  @override
  late final i0.GeneratedColumn<String> reasonKind = i0.GeneratedColumn<String>(
    'reason_kind',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _reasonKeyMeta = const i0.VerificationMeta(
    'reasonKey',
  );
  @override
  late final i0.GeneratedColumn<String> reasonKey = i0.GeneratedColumn<String>(
    'reason_key',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    syncPending,
    suggestionKey,
    reasonKind,
    reasonKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recommendation_feedback';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.RecommendationFeedback> instance, {
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
    if (data.containsKey('suggestion_key')) {
      context.handle(
        _suggestionKeyMeta,
        suggestionKey.isAcceptableOrUnknown(
          data['suggestion_key']!,
          _suggestionKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_suggestionKeyMeta);
    }
    if (data.containsKey('reason_kind')) {
      context.handle(
        _reasonKindMeta,
        reasonKind.isAcceptableOrUnknown(data['reason_kind']!, _reasonKindMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonKindMeta);
    }
    if (data.containsKey('reason_key')) {
      context.handle(
        _reasonKeyMeta,
        reasonKey.isAcceptableOrUnknown(data['reason_key']!, _reasonKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonKeyMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.RecommendationFeedback map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.RecommendationFeedback(
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
      suggestionKey: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}suggestion_key'],
      )!,
      reasonKind: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}reason_kind'],
      )!,
      reasonKey: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}reason_key'],
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
    );
  }

  @override
  $RecommendationFeedbackTableTable createAlias(String alias) {
    return $RecommendationFeedbackTableTable(attachedDatabase, alias);
  }
}

class RecommendationFeedbackTableCompanion
    extends i0.UpdateCompanion<i1.RecommendationFeedback> {
  final i0.Value<String> id;
  final i0.Value<String?> userId;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> updatedAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<bool> syncPending;
  final i0.Value<String> suggestionKey;
  final i0.Value<String> reasonKind;
  final i0.Value<String> reasonKey;
  final i0.Value<int> rowid;
  const RecommendationFeedbackTableCompanion({
    this.id = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.updatedAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.suggestionKey = const i0.Value.absent(),
    this.reasonKind = const i0.Value.absent(),
    this.reasonKey = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  RecommendationFeedbackTableCompanion.insert({
    required String id,
    this.userId = const i0.Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    required String suggestionKey,
    required String reasonKind,
    required String reasonKey,
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       createdAt = i0.Value(createdAt),
       updatedAt = i0.Value(updatedAt),
       suggestionKey = i0.Value(suggestionKey),
       reasonKind = i0.Value(reasonKind),
       reasonKey = i0.Value(reasonKey);
  static i0.Insertable<i1.RecommendationFeedback> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? updatedAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<bool>? syncPending,
    i0.Expression<String>? suggestionKey,
    i0.Expression<String>? reasonKind,
    i0.Expression<String>? reasonKey,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncPending != null) 'sync_pending': syncPending,
      if (suggestionKey != null) 'suggestion_key': suggestionKey,
      if (reasonKind != null) 'reason_kind': reasonKind,
      if (reasonKey != null) 'reason_key': reasonKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i2.RecommendationFeedbackTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String?>? userId,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? updatedAt,
    i0.Value<DateTime?>? deletedAt,
    i0.Value<bool>? syncPending,
    i0.Value<String>? suggestionKey,
    i0.Value<String>? reasonKind,
    i0.Value<String>? reasonKey,
    i0.Value<int>? rowid,
  }) {
    return i2.RecommendationFeedbackTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncPending: syncPending ?? this.syncPending,
      suggestionKey: suggestionKey ?? this.suggestionKey,
      reasonKind: reasonKind ?? this.reasonKind,
      reasonKey: reasonKey ?? this.reasonKey,
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
    if (suggestionKey.present) {
      map['suggestion_key'] = i0.Variable<String>(suggestionKey.value);
    }
    if (reasonKind.present) {
      map['reason_kind'] = i0.Variable<String>(reasonKind.value);
    }
    if (reasonKey.present) {
      map['reason_key'] = i0.Variable<String>(reasonKey.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecommendationFeedbackTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('suggestionKey: $suggestionKey, ')
          ..write('reasonKind: $reasonKind, ')
          ..write('reasonKey: $reasonKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$RecommendationFeedbackInsertable
    implements i0.Insertable<i1.RecommendationFeedback> {
  i1.RecommendationFeedback _object;
  _$RecommendationFeedbackInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i2.RecommendationFeedbackTableCompanion(
      id: i0.Value(_object.id),
      userId: i0.Value(_object.userId),
      createdAt: i0.Value(_object.createdAt),
      updatedAt: i0.Value(_object.updatedAt),
      deletedAt: i0.Value(_object.deletedAt),
      syncPending: i0.Value(_object.syncPending),
      suggestionKey: i0.Value(_object.suggestionKey),
      reasonKind: i0.Value(_object.reasonKind),
      reasonKey: i0.Value(_object.reasonKey),
    ).toColumns(false);
  }
}

extension RecommendationFeedbackToInsertable on i1.RecommendationFeedback {
  _$RecommendationFeedbackInsertable toInsertable() {
    return _$RecommendationFeedbackInsertable(this);
  }
}
