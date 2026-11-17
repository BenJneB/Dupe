// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/features/collection/domain/item_photo.dart' as i1;
import 'package:dupe/features/collection/domain/enums.dart' as i2;
import 'package:dupe/core/database/tables/item_photos_table.drift.dart' as i3;
import 'package:dupe/core/database/tables/item_photos_table.dart' as i4;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i5;
import 'package:dupe/core/database/converters.dart' as i6;
import 'package:dupe/core/database/tables/items_table.drift.dart' as i7;
import 'package:drift/internal/modular.dart' as i8;

typedef $$ItemPhotosTableTableCreateCompanionBuilder =
    i3.ItemPhotosTableCompanion Function({
      required String id,
      i0.Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      required String itemId,
      required String url,
      i0.Value<i2.PhotoKind> kind,
      i0.Value<int> position,
      i0.Value<int> rowid,
    });
typedef $$ItemPhotosTableTableUpdateCompanionBuilder =
    i3.ItemPhotosTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String?> userId,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<String> itemId,
      i0.Value<String> url,
      i0.Value<i2.PhotoKind> kind,
      i0.Value<int> position,
      i0.Value<int> rowid,
    });

final class $$ItemPhotosTableTableReferences
    extends
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i3.$ItemPhotosTableTable,
          i1.ItemPhoto
        > {
  $$ItemPhotosTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static i7.$ItemsTableTable _itemIdTable(i0.GeneratedDatabase db) =>
      i8.ReadDatabaseContainer(db)
          .resultSet<i7.$ItemsTableTable>('items')
          .createAlias('item_photos__item_id__items__id');

  i7.$$ItemsTableTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<String>('item_id')!;

    final manager = i7
        .$$ItemsTableTableTableManager(
          $_db,
          i8.ReadDatabaseContainer($_db)
              .resultSet<i7.$ItemsTableTable>('items'),
        )
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemPhotosTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$ItemPhotosTableTable> {
  $$ItemPhotosTableTableFilterComposer({
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

  i0.ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i2.PhotoKind, i2.PhotoKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => i0.ColumnFilters(column),
  );

  i7.$$ItemsTableTableFilterComposer get itemId {
    final i7.$$ItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: i8.ReadDatabaseContainer($db)
          .resultSet<i7.$ItemsTableTable>('items'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i7.$$ItemsTableTableFilterComposer(
            $db: $db,
            $table: i8.ReadDatabaseContainer($db)
                .resultSet<i7.$ItemsTableTable>('items'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$ItemPhotosTableTable> {
  $$ItemPhotosTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i7.$$ItemsTableTableOrderingComposer get itemId {
    final i7.$$ItemsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: i8.ReadDatabaseContainer($db)
          .resultSet<i7.$ItemsTableTable>('items'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i7.$$ItemsTableTableOrderingComposer(
            $db: $db,
            $table: i8.ReadDatabaseContainer($db)
                .resultSet<i7.$ItemsTableTable>('items'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$ItemPhotosTableTable> {
  $$ItemPhotosTableTableAnnotationComposer({
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

  i0.GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i2.PhotoKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  i0.GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  i7.$$ItemsTableTableAnnotationComposer get itemId {
    final i7.$$ItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: i8.ReadDatabaseContainer($db)
          .resultSet<i7.$ItemsTableTable>('items'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i7.$$ItemsTableTableAnnotationComposer(
            $db: $db,
            $table: i8.ReadDatabaseContainer($db)
                .resultSet<i7.$ItemsTableTable>('items'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i3.$ItemPhotosTableTable,
          i1.ItemPhoto,
          i3.$$ItemPhotosTableTableFilterComposer,
          i3.$$ItemPhotosTableTableOrderingComposer,
          i3.$$ItemPhotosTableTableAnnotationComposer,
          $$ItemPhotosTableTableCreateCompanionBuilder,
          $$ItemPhotosTableTableUpdateCompanionBuilder,
          (i1.ItemPhoto, i3.$$ItemPhotosTableTableReferences),
          i1.ItemPhoto,
          i0.PrefetchHooks Function({bool itemId})
        > {
  $$ItemPhotosTableTableTableManager(
    i0.GeneratedDatabase db,
    i3.$ItemPhotosTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i3.$$ItemPhotosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i3.$$ItemPhotosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => i3
              .$$ItemPhotosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String?> userId = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime> updatedAt = const i0.Value.absent(),
                i0.Value<DateTime?> deletedAt = const i0.Value.absent(),
                i0.Value<bool> syncPending = const i0.Value.absent(),
                i0.Value<String> itemId = const i0.Value.absent(),
                i0.Value<String> url = const i0.Value.absent(),
                i0.Value<i2.PhotoKind> kind = const i0.Value.absent(),
                i0.Value<int> position = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i3.ItemPhotosTableCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                itemId: itemId,
                url: url,
                kind: kind,
                position: position,
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
                required String url,
                i0.Value<i2.PhotoKind> kind = const i0.Value.absent(),
                i0.Value<int> position = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i3.ItemPhotosTableCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                itemId: itemId,
                url: url,
                kind: kind,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i3.$ItemPhotosTableTable, i1.ItemPhoto>(table),
                  i3.$$ItemPhotosTableTableReferences(db, table, e),
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
                        referencedTable: i3.$$ItemPhotosTableTableReferences
                            ._itemIdTable(db),
                        referencedColumn: i3.$$ItemPhotosTableTableReferences
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

typedef $$ItemPhotosTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i3.$ItemPhotosTableTable,
      i1.ItemPhoto,
      i3.$$ItemPhotosTableTableFilterComposer,
      i3.$$ItemPhotosTableTableOrderingComposer,
      i3.$$ItemPhotosTableTableAnnotationComposer,
      $$ItemPhotosTableTableCreateCompanionBuilder,
      $$ItemPhotosTableTableUpdateCompanionBuilder,
      (i1.ItemPhoto, i3.$$ItemPhotosTableTableReferences),
      i1.ItemPhoto,
      i0.PrefetchHooks Function({bool itemId})
    >;
i0.Index get itemPhotosItemIdIdx => i0.Index(
  'item_photos_item_id_idx',
  'CREATE INDEX item_photos_item_id_idx ON item_photos (item_id)',
);

class $ItemPhotosTableTable extends i4.ItemPhotosTable
    with i0.TableInfo<$ItemPhotosTableTable, i1.ItemPhoto> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemPhotosTableTable(this.attachedDatabase, [this._alias]);
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
    defaultValue: const i5.Constant(true),
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
  static const i0.VerificationMeta _urlMeta = const i0.VerificationMeta('url');
  @override
  late final i0.GeneratedColumn<String> url = i0.GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.PhotoKind, String> kind =
      i0.GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const i5.Constant('dedicace'),
      ).withConverter<i2.PhotoKind>(i3.$ItemPhotosTableTable.$converterkind);
  static const i0.VerificationMeta _positionMeta = const i0.VerificationMeta(
    'position',
  );
  @override
  late final i0.GeneratedColumn<int> position = i0.GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const i5.Constant(0),
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
    url,
    kind,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_photos';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.ItemPhoto> instance, {
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
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.ItemPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.ItemPhoto(
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
      url: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      kind: i3.$ItemPhotosTableTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      position: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}position'],
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
  $ItemPhotosTableTable createAlias(String alias) {
    return $ItemPhotosTableTable(attachedDatabase, alias);
  }

  static i0.TypeConverter<i2.PhotoKind, String> $converterkind =
      const i6.DbEnumConverter(i2.PhotoKind.values);
}

class ItemPhotosTableCompanion extends i0.UpdateCompanion<i1.ItemPhoto> {
  final i0.Value<String> id;
  final i0.Value<String?> userId;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> updatedAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<bool> syncPending;
  final i0.Value<String> itemId;
  final i0.Value<String> url;
  final i0.Value<i2.PhotoKind> kind;
  final i0.Value<int> position;
  final i0.Value<int> rowid;
  const ItemPhotosTableCompanion({
    this.id = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.updatedAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.itemId = const i0.Value.absent(),
    this.url = const i0.Value.absent(),
    this.kind = const i0.Value.absent(),
    this.position = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ItemPhotosTableCompanion.insert({
    required String id,
    this.userId = const i0.Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    required String itemId,
    required String url,
    this.kind = const i0.Value.absent(),
    this.position = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       createdAt = i0.Value(createdAt),
       updatedAt = i0.Value(updatedAt),
       itemId = i0.Value(itemId),
       url = i0.Value(url);
  static i0.Insertable<i1.ItemPhoto> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? updatedAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<bool>? syncPending,
    i0.Expression<String>? itemId,
    i0.Expression<String>? url,
    i0.Expression<String>? kind,
    i0.Expression<int>? position,
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
      if (url != null) 'url': url,
      if (kind != null) 'kind': kind,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i3.ItemPhotosTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String?>? userId,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? updatedAt,
    i0.Value<DateTime?>? deletedAt,
    i0.Value<bool>? syncPending,
    i0.Value<String>? itemId,
    i0.Value<String>? url,
    i0.Value<i2.PhotoKind>? kind,
    i0.Value<int>? position,
    i0.Value<int>? rowid,
  }) {
    return i3.ItemPhotosTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncPending: syncPending ?? this.syncPending,
      itemId: itemId ?? this.itemId,
      url: url ?? this.url,
      kind: kind ?? this.kind,
      position: position ?? this.position,
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
    if (url.present) {
      map['url'] = i0.Variable<String>(url.value);
    }
    if (kind.present) {
      map['kind'] = i0.Variable<String>(
        i3.$ItemPhotosTableTable.$converterkind.toSql(kind.value),
      );
    }
    if (position.present) {
      map['position'] = i0.Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemPhotosTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('itemId: $itemId, ')
          ..write('url: $url, ')
          ..write('kind: $kind, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ItemPhotoInsertable implements i0.Insertable<i1.ItemPhoto> {
  i1.ItemPhoto _object;
  _$ItemPhotoInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i3.ItemPhotosTableCompanion(
      id: i0.Value(_object.id),
      userId: i0.Value(_object.userId),
      createdAt: i0.Value(_object.createdAt),
      updatedAt: i0.Value(_object.updatedAt),
      deletedAt: i0.Value(_object.deletedAt),
      syncPending: i0.Value(_object.syncPending),
      itemId: i0.Value(_object.itemId),
      url: i0.Value(_object.url),
      kind: i0.Value(_object.kind),
      position: i0.Value(_object.position),
    ).toColumns(false);
  }
}

extension ItemPhotoToInsertable on i1.ItemPhoto {
  _$ItemPhotoInsertable toInsertable() {
    return _$ItemPhotoInsertable(this);
  }
}
