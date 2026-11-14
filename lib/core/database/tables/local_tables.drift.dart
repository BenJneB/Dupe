// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/core/database/tables/local_tables.drift.dart' as i1;
import 'package:dupe/core/database/tables/local_tables.dart' as i2;
import 'package:dupe/features/scan/domain/scan_queue_entry.dart' as i3;
import 'package:dupe/features/collection/domain/collection_type.dart' as i4;
import 'package:dupe/core/metadata/metadata_result.dart' as i5;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i6;
import 'package:dupe/core/database/converters.dart' as i7;

typedef $$AppSettingsTableTableCreateCompanionBuilder =
    i1.AppSettingsTableCompanion Function({
      required String key,
      required String value,
      i0.Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    i1.AppSettingsTableCompanion Function({
      i0.Value<String> key,
      i0.Value<String> value,
      i0.Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  i0.GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$AppSettingsTableTable,
          i1.AppSetting,
          i1.$$AppSettingsTableTableFilterComposer,
          i1.$$AppSettingsTableTableOrderingComposer,
          i1.$$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            i1.AppSetting,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$AppSettingsTableTable,
              i1.AppSetting
            >,
          ),
          i1.AppSetting,
          i0.PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    i0.GeneratedDatabase db,
    i1.$AppSettingsTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => i1
              .$$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i1.$$AppSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                i0.Value<String> key = const i0.Value.absent(),
                i0.Value<String> value = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.AppSettingsTableCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.AppSettingsTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i1.$AppSettingsTableTable, i1.AppSetting>(table),
                  i0.BaseReferences<
                    i0.GeneratedDatabase,
                    i1.$AppSettingsTableTable,
                    i1.AppSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$AppSettingsTableTable,
      i1.AppSetting,
      i1.$$AppSettingsTableTableFilterComposer,
      i1.$$AppSettingsTableTableOrderingComposer,
      i1.$$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        i1.AppSetting,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$AppSettingsTableTable,
          i1.AppSetting
        >,
      ),
      i1.AppSetting,
      i0.PrefetchHooks Function()
    >;
typedef $$MetadataCacheTableTableCreateCompanionBuilder =
    i1.MetadataCacheTableCompanion Function({
      required String key,
      required String payload,
      required DateTime fetchedAt,
      i0.Value<int> rowid,
    });
typedef $$MetadataCacheTableTableUpdateCompanionBuilder =
    i1.MetadataCacheTableCompanion Function({
      i0.Value<String> key,
      i0.Value<String> payload,
      i0.Value<DateTime> fetchedAt,
      i0.Value<int> rowid,
    });

class $$MetadataCacheTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$MetadataCacheTableTable> {
  $$MetadataCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$MetadataCacheTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$MetadataCacheTableTable> {
  $$MetadataCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$MetadataCacheTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$MetadataCacheTableTable> {
  $$MetadataCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  i0.GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$MetadataCacheTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$MetadataCacheTableTable,
          i1.CachedResponse,
          i1.$$MetadataCacheTableTableFilterComposer,
          i1.$$MetadataCacheTableTableOrderingComposer,
          i1.$$MetadataCacheTableTableAnnotationComposer,
          $$MetadataCacheTableTableCreateCompanionBuilder,
          $$MetadataCacheTableTableUpdateCompanionBuilder,
          (
            i1.CachedResponse,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$MetadataCacheTableTable,
              i1.CachedResponse
            >,
          ),
          i1.CachedResponse,
          i0.PrefetchHooks Function()
        > {
  $$MetadataCacheTableTableTableManager(
    i0.GeneratedDatabase db,
    i1.$MetadataCacheTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => i1
              .$$MetadataCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i1.$$MetadataCacheTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              i1.$$MetadataCacheTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                i0.Value<String> key = const i0.Value.absent(),
                i0.Value<String> payload = const i0.Value.absent(),
                i0.Value<DateTime> fetchedAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.MetadataCacheTableCompanion(
                key: key,
                payload: payload,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String payload,
                required DateTime fetchedAt,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.MetadataCacheTableCompanion.insert(
                key: key,
                payload: payload,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i1.$MetadataCacheTableTable, i1.CachedResponse>(
                    table,
                  ),
                  i0.BaseReferences<
                    i0.GeneratedDatabase,
                    i1.$MetadataCacheTableTable,
                    i1.CachedResponse
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetadataCacheTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$MetadataCacheTableTable,
      i1.CachedResponse,
      i1.$$MetadataCacheTableTableFilterComposer,
      i1.$$MetadataCacheTableTableOrderingComposer,
      i1.$$MetadataCacheTableTableAnnotationComposer,
      $$MetadataCacheTableTableCreateCompanionBuilder,
      $$MetadataCacheTableTableUpdateCompanionBuilder,
      (
        i1.CachedResponse,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$MetadataCacheTableTable,
          i1.CachedResponse
        >,
      ),
      i1.CachedResponse,
      i0.PrefetchHooks Function()
    >;
typedef $$ScanQueueTableTableCreateCompanionBuilder =
    i1.ScanQueueTableCompanion Function({
      required String id,
      required String isbn13,
      required i4.CollectionType type,
      i0.Value<i3.ScanStatus> status,
      i0.Value<i5.MetadataResult?> result,
      required DateTime scannedAt,
      i0.Value<int> rowid,
    });
typedef $$ScanQueueTableTableUpdateCompanionBuilder =
    i1.ScanQueueTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String> isbn13,
      i0.Value<i4.CollectionType> type,
      i0.Value<i3.ScanStatus> status,
      i0.Value<i5.MetadataResult?> result,
      i0.Value<DateTime> scannedAt,
      i0.Value<int> rowid,
    });

class $$ScanQueueTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$ScanQueueTableTable> {
  $$ScanQueueTableTableFilterComposer({
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

  i0.ColumnFilters<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<
    i4.CollectionType,
    i4.CollectionType,
    String
  >
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i3.ScanStatus, i3.ScanStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<
    i5.MetadataResult?,
    i5.MetadataResult,
    String
  >
  get result => $composableBuilder(
    column: $table.result,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$ScanQueueTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$ScanQueueTableTable> {
  $$ScanQueueTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$ScanQueueTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i1.$ScanQueueTableTable> {
  $$ScanQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  i0.GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  i0.GeneratedColumn<String> get isbn13 =>
      $composableBuilder(column: $table.isbn13, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i4.CollectionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i3.ScanStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i5.MetadataResult?, String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);
}

class $$ScanQueueTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i1.$ScanQueueTableTable,
          i3.ScanQueueEntry,
          i1.$$ScanQueueTableTableFilterComposer,
          i1.$$ScanQueueTableTableOrderingComposer,
          i1.$$ScanQueueTableTableAnnotationComposer,
          $$ScanQueueTableTableCreateCompanionBuilder,
          $$ScanQueueTableTableUpdateCompanionBuilder,
          (
            i3.ScanQueueEntry,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i1.$ScanQueueTableTable,
              i3.ScanQueueEntry
            >,
          ),
          i3.ScanQueueEntry,
          i0.PrefetchHooks Function()
        > {
  $$ScanQueueTableTableTableManager(
    i0.GeneratedDatabase db,
    i1.$ScanQueueTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i1.$$ScanQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i1.$$ScanQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => i1
              .$$ScanQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String> isbn13 = const i0.Value.absent(),
                i0.Value<i4.CollectionType> type = const i0.Value.absent(),
                i0.Value<i3.ScanStatus> status = const i0.Value.absent(),
                i0.Value<i5.MetadataResult?> result = const i0.Value.absent(),
                i0.Value<DateTime> scannedAt = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.ScanQueueTableCompanion(
                id: id,
                isbn13: isbn13,
                type: type,
                status: status,
                result: result,
                scannedAt: scannedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String isbn13,
                required i4.CollectionType type,
                i0.Value<i3.ScanStatus> status = const i0.Value.absent(),
                i0.Value<i5.MetadataResult?> result = const i0.Value.absent(),
                required DateTime scannedAt,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i1.ScanQueueTableCompanion.insert(
                id: id,
                isbn13: isbn13,
                type: type,
                status: status,
                result: result,
                scannedAt: scannedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i1.$ScanQueueTableTable, i3.ScanQueueEntry>(
                    table,
                  ),
                  i0.BaseReferences<
                    i0.GeneratedDatabase,
                    i1.$ScanQueueTableTable,
                    i3.ScanQueueEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScanQueueTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i1.$ScanQueueTableTable,
      i3.ScanQueueEntry,
      i1.$$ScanQueueTableTableFilterComposer,
      i1.$$ScanQueueTableTableOrderingComposer,
      i1.$$ScanQueueTableTableAnnotationComposer,
      $$ScanQueueTableTableCreateCompanionBuilder,
      $$ScanQueueTableTableUpdateCompanionBuilder,
      (
        i3.ScanQueueEntry,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i1.$ScanQueueTableTable,
          i3.ScanQueueEntry
        >,
      ),
      i3.ScanQueueEntry,
      i0.PrefetchHooks Function()
    >;

class $AppSettingsTableTable extends i2.AppSettingsTable
    with i0.TableInfo<$AppSettingsTableTable, i1.AppSetting> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _keyMeta = const i0.VerificationMeta('key');
  @override
  late final i0.GeneratedColumn<String> key = i0.GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _valueMeta = const i0.VerificationMeta(
    'value',
  );
  @override
  late final i0.GeneratedColumn<String> value = i0.GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<i0.GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {key};
  @override
  i1.AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.AppSetting(
      key: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSetting extends i0.DataClass implements i0.Insertable<i1.AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['key'] = i0.Variable<String>(key);
    map['value'] = i0.Variable<String>(value);
    return map;
  }

  i1.AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return i1.AppSettingsTableCompanion(
      key: i0.Value(key),
      value: i0.Value(value),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  i1.AppSetting copyWith({String? key, String? value}) =>
      i1.AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(i1.AppSettingsTableCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsTableCompanion extends i0.UpdateCompanion<i1.AppSetting> {
  final i0.Value<String> key;
  final i0.Value<String> value;
  final i0.Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const i0.Value.absent(),
    this.value = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const i0.Value.absent(),
  }) : key = i0.Value(key),
       value = i0.Value(value);
  static i0.Insertable<i1.AppSetting> custom({
    i0.Expression<String>? key,
    i0.Expression<String>? value,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.AppSettingsTableCompanion copyWith({
    i0.Value<String>? key,
    i0.Value<String>? value,
    i0.Value<int>? rowid,
  }) {
    return i1.AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (key.present) {
      map['key'] = i0.Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = i0.Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetadataCacheTableTable extends i2.MetadataCacheTable
    with i0.TableInfo<$MetadataCacheTableTable, i1.CachedResponse> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetadataCacheTableTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _keyMeta = const i0.VerificationMeta('key');
  @override
  late final i0.GeneratedColumn<String> key = i0.GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _payloadMeta = const i0.VerificationMeta(
    'payload',
  );
  @override
  late final i0.GeneratedColumn<String> payload = i0.GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _fetchedAtMeta = const i0.VerificationMeta(
    'fetchedAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> fetchedAt =
      i0.GeneratedColumn<DateTime>(
        'fetched_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<i0.GeneratedColumn> get $columns => [key, payload, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metadata_cache';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.CachedResponse> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {key};
  @override
  i1.CachedResponse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.CachedResponse(
      key: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $MetadataCacheTableTable createAlias(String alias) {
    return $MetadataCacheTableTable(attachedDatabase, alias);
  }
}

class CachedResponse extends i0.DataClass
    implements i0.Insertable<i1.CachedResponse> {
  /// `source:isbn:isbn13` or `source:text:query`.
  final String key;

  /// JSON-encoded result.
  final String payload;
  final DateTime fetchedAt;
  const CachedResponse({
    required this.key,
    required this.payload,
    required this.fetchedAt,
  });
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['key'] = i0.Variable<String>(key);
    map['payload'] = i0.Variable<String>(payload);
    map['fetched_at'] = i0.Variable<DateTime>(fetchedAt);
    return map;
  }

  i1.MetadataCacheTableCompanion toCompanion(bool nullToAbsent) {
    return i1.MetadataCacheTableCompanion(
      key: i0.Value(key),
      payload: i0.Value(payload),
      fetchedAt: i0.Value(fetchedAt),
    );
  }

  factory CachedResponse.fromJson(
    Map<String, dynamic> json, {
    i0.ValueSerializer? serializer,
  }) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return CachedResponse(
      key: serializer.fromJson<String>(json['key']),
      payload: serializer.fromJson<String>(json['payload']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'payload': serializer.toJson<String>(payload),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  i1.CachedResponse copyWith({
    String? key,
    String? payload,
    DateTime? fetchedAt,
  }) => i1.CachedResponse(
    key: key ?? this.key,
    payload: payload ?? this.payload,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedResponse copyWithCompanion(i1.MetadataCacheTableCompanion data) {
    return CachedResponse(
      key: data.key.present ? data.key.value : this.key,
      payload: data.payload.present ? data.payload.value : this.payload,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedResponse(')
          ..write('key: $key, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, payload, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.CachedResponse &&
          other.key == this.key &&
          other.payload == this.payload &&
          other.fetchedAt == this.fetchedAt);
}

class MetadataCacheTableCompanion
    extends i0.UpdateCompanion<i1.CachedResponse> {
  final i0.Value<String> key;
  final i0.Value<String> payload;
  final i0.Value<DateTime> fetchedAt;
  final i0.Value<int> rowid;
  const MetadataCacheTableCompanion({
    this.key = const i0.Value.absent(),
    this.payload = const i0.Value.absent(),
    this.fetchedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  MetadataCacheTableCompanion.insert({
    required String key,
    required String payload,
    required DateTime fetchedAt,
    this.rowid = const i0.Value.absent(),
  }) : key = i0.Value(key),
       payload = i0.Value(payload),
       fetchedAt = i0.Value(fetchedAt);
  static i0.Insertable<i1.CachedResponse> custom({
    i0.Expression<String>? key,
    i0.Expression<String>? payload,
    i0.Expression<DateTime>? fetchedAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (key != null) 'key': key,
      if (payload != null) 'payload': payload,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.MetadataCacheTableCompanion copyWith({
    i0.Value<String>? key,
    i0.Value<String>? payload,
    i0.Value<DateTime>? fetchedAt,
    i0.Value<int>? rowid,
  }) {
    return i1.MetadataCacheTableCompanion(
      key: key ?? this.key,
      payload: payload ?? this.payload,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (key.present) {
      map['key'] = i0.Variable<String>(key.value);
    }
    if (payload.present) {
      map['payload'] = i0.Variable<String>(payload.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = i0.Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetadataCacheTableCompanion(')
          ..write('key: $key, ')
          ..write('payload: $payload, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanQueueTableTable extends i2.ScanQueueTable
    with i0.TableInfo<$ScanQueueTableTable, i3.ScanQueueEntry> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanQueueTableTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _isbn13Meta = const i0.VerificationMeta(
    'isbn13',
  );
  @override
  late final i0.GeneratedColumn<String> isbn13 = i0.GeneratedColumn<String>(
    'isbn13',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i4.CollectionType, String>
  type = i0.GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<i4.CollectionType>(i1.$ScanQueueTableTable.$convertertype);
  @override
  late final i0.GeneratedColumnWithTypeConverter<i3.ScanStatus, String> status =
      i0.GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const i6.Constant('pending'),
      ).withConverter<i3.ScanStatus>(i1.$ScanQueueTableTable.$converterstatus);
  @override
  late final i0.GeneratedColumnWithTypeConverter<i5.MetadataResult?, String>
  result =
      i0.GeneratedColumn<String>(
        'result',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<i5.MetadataResult?>(
        i1.$ScanQueueTableTable.$converterresultn,
      );
  static const i0.VerificationMeta _scannedAtMeta = const i0.VerificationMeta(
    'scannedAt',
  );
  @override
  late final i0.GeneratedColumn<DateTime> scannedAt =
      i0.GeneratedColumn<DateTime>(
        'scanned_at',
        aliasedName,
        false,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    isbn13,
    type,
    status,
    result,
    scannedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_queue';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i3.ScanQueueEntry> instance, {
    bool isInserting = false,
  }) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('isbn13')) {
      context.handle(
        _isbn13Meta,
        isbn13.isAcceptableOrUnknown(data['isbn13']!, _isbn13Meta),
      );
    } else if (isInserting) {
      context.missing(_isbn13Meta);
    }
    if (data.containsKey('scanned_at')) {
      context.handle(
        _scannedAtMeta,
        scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_scannedAtMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i3.ScanQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i3.ScanQueueEntry(
      id: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      isbn13: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}isbn13'],
      )!,
      type: i1.$ScanQueueTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      scannedAt: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}scanned_at'],
      )!,
      status: i1.$ScanQueueTableTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      result: i1.$ScanQueueTableTable.$converterresultn.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}result'],
        ),
      ),
    );
  }

  @override
  $ScanQueueTableTable createAlias(String alias) {
    return $ScanQueueTableTable(attachedDatabase, alias);
  }

  static i0.TypeConverter<i4.CollectionType, String> $convertertype =
      const i7.DbEnumConverter(i4.CollectionType.values);
  static i0.TypeConverter<i3.ScanStatus, String> $converterstatus =
      const i7.DbEnumConverter(i3.ScanStatus.values);
  static i0.TypeConverter<i5.MetadataResult, String> $converterresult =
      const i7.MetadataResultConverter();
  static i0.TypeConverter<i5.MetadataResult?, String?> $converterresultn =
      i0.NullAwareTypeConverter.wrap($converterresult);
}

class ScanQueueTableCompanion extends i0.UpdateCompanion<i3.ScanQueueEntry> {
  final i0.Value<String> id;
  final i0.Value<String> isbn13;
  final i0.Value<i4.CollectionType> type;
  final i0.Value<i3.ScanStatus> status;
  final i0.Value<i5.MetadataResult?> result;
  final i0.Value<DateTime> scannedAt;
  final i0.Value<int> rowid;
  const ScanQueueTableCompanion({
    this.id = const i0.Value.absent(),
    this.isbn13 = const i0.Value.absent(),
    this.type = const i0.Value.absent(),
    this.status = const i0.Value.absent(),
    this.result = const i0.Value.absent(),
    this.scannedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ScanQueueTableCompanion.insert({
    required String id,
    required String isbn13,
    required i4.CollectionType type,
    this.status = const i0.Value.absent(),
    this.result = const i0.Value.absent(),
    required DateTime scannedAt,
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       isbn13 = i0.Value(isbn13),
       type = i0.Value(type),
       scannedAt = i0.Value(scannedAt);
  static i0.Insertable<i3.ScanQueueEntry> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? isbn13,
    i0.Expression<String>? type,
    i0.Expression<String>? status,
    i0.Expression<String>? result,
    i0.Expression<DateTime>? scannedAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (isbn13 != null) 'isbn13': isbn13,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (result != null) 'result': result,
      if (scannedAt != null) 'scanned_at': scannedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.ScanQueueTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String>? isbn13,
    i0.Value<i4.CollectionType>? type,
    i0.Value<i3.ScanStatus>? status,
    i0.Value<i5.MetadataResult?>? result,
    i0.Value<DateTime>? scannedAt,
    i0.Value<int>? rowid,
  }) {
    return i1.ScanQueueTableCompanion(
      id: id ?? this.id,
      isbn13: isbn13 ?? this.isbn13,
      type: type ?? this.type,
      status: status ?? this.status,
      result: result ?? this.result,
      scannedAt: scannedAt ?? this.scannedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (isbn13.present) {
      map['isbn13'] = i0.Variable<String>(isbn13.value);
    }
    if (type.present) {
      map['type'] = i0.Variable<String>(
        i1.$ScanQueueTableTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = i0.Variable<String>(
        i1.$ScanQueueTableTable.$converterstatus.toSql(status.value),
      );
    }
    if (result.present) {
      map['result'] = i0.Variable<String>(
        i1.$ScanQueueTableTable.$converterresultn.toSql(result.value),
      );
    }
    if (scannedAt.present) {
      map['scanned_at'] = i0.Variable<DateTime>(scannedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('isbn13: $isbn13, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('result: $result, ')
          ..write('scannedAt: $scannedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ScanQueueEntryInsertable implements i0.Insertable<i3.ScanQueueEntry> {
  i3.ScanQueueEntry _object;
  _$ScanQueueEntryInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i1.ScanQueueTableCompanion(
      id: i0.Value(_object.id),
      isbn13: i0.Value(_object.isbn13),
      type: i0.Value(_object.type),
      status: i0.Value(_object.status),
      result: i0.Value(_object.result),
      scannedAt: i0.Value(_object.scannedAt),
    ).toColumns(false);
  }
}

extension ScanQueueEntryToInsertable on i3.ScanQueueEntry {
  _$ScanQueueEntryInsertable toInsertable() {
    return _$ScanQueueEntryInsertable(this);
  }
}
