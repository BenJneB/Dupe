// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/features/collection/domain/series.dart' as i1;
import 'package:dupe/features/collection/domain/collection_type.dart' as i2;
import 'package:dupe/features/collection/domain/enums.dart' as i3;
import 'package:dupe/core/database/tables/series_table.drift.dart' as i4;
import 'package:dupe/core/database/tables/series_table.dart' as i5;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i6;
import 'package:dupe/core/database/converters.dart' as i7;

typedef $$SeriesTableTableCreateCompanionBuilder =
    i4.SeriesTableCompanion Function({
      required String id,
      i0.Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      required i2.CollectionType type,
      required String title,
      i0.Value<String?> originalTitle,
      i0.Value<List<String>> authors,
      i0.Value<String?> publisher,
      i0.Value<String?> collection,
      i0.Value<i3.PublicationStatus> statusPublication,
      i0.Value<int?> totalVolumes,
      i0.Value<String?> coverUrl,
      i0.Value<String?> description,
      i0.Value<Map<String, String>> externalIds,
      i0.Value<bool> followed,
      i0.Value<String?> notes,
      i0.Value<int> rowid,
    });
typedef $$SeriesTableTableUpdateCompanionBuilder =
    i4.SeriesTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String?> userId,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<i2.CollectionType> type,
      i0.Value<String> title,
      i0.Value<String?> originalTitle,
      i0.Value<List<String>> authors,
      i0.Value<String?> publisher,
      i0.Value<String?> collection,
      i0.Value<i3.PublicationStatus> statusPublication,
      i0.Value<int?> totalVolumes,
      i0.Value<String?> coverUrl,
      i0.Value<String?> description,
      i0.Value<Map<String, String>> externalIds,
      i0.Value<bool> followed,
      i0.Value<String?> notes,
      i0.Value<int> rowid,
    });

class $$SeriesTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i4.$SeriesTableTable> {
  $$SeriesTableTableFilterComposer({
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

  i0.ColumnWithTypeConverterFilters<
    i2.CollectionType,
    i2.CollectionType,
    String
  >
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<
    i3.PublicationStatus,
    i3.PublicationStatus,
    String
  >
  get statusPublication => $composableBuilder(
    column: $table.statusPublication,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<int> get totalVolumes => $composableBuilder(
    column: $table.totalVolumes,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get externalIds => $composableBuilder(
    column: $table.externalIds,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<bool> get followed => $composableBuilder(
    column: $table.followed,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$SeriesTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i4.$SeriesTableTable> {
  $$SeriesTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get statusPublication => $composableBuilder(
    column: $table.statusPublication,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get totalVolumes => $composableBuilder(
    column: $table.totalVolumes,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get externalIds => $composableBuilder(
    column: $table.externalIds,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<bool> get followed => $composableBuilder(
    column: $table.followed,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$SeriesTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i4.$SeriesTableTable> {
  $$SeriesTableTableAnnotationComposer({
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

  i0.GeneratedColumnWithTypeConverter<i2.CollectionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  i0.GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  i0.GeneratedColumn<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<List<String>, String> get authors =>
      $composableBuilder(column: $table.authors, builder: (column) => column);

  i0.GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  i0.GeneratedColumn<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<i3.PublicationStatus, String>
  get statusPublication => $composableBuilder(
    column: $table.statusPublication,
    builder: (column) => column,
  );

  i0.GeneratedColumn<int> get totalVolumes => $composableBuilder(
    column: $table.totalVolumes,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  i0.GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get externalIds => $composableBuilder(
    column: $table.externalIds,
    builder: (column) => column,
  );

  i0.GeneratedColumn<bool> get followed =>
      $composableBuilder(column: $table.followed, builder: (column) => column);

  i0.GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$SeriesTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i4.$SeriesTableTable,
          i1.Series,
          i4.$$SeriesTableTableFilterComposer,
          i4.$$SeriesTableTableOrderingComposer,
          i4.$$SeriesTableTableAnnotationComposer,
          $$SeriesTableTableCreateCompanionBuilder,
          $$SeriesTableTableUpdateCompanionBuilder,
          (
            i1.Series,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i4.$SeriesTableTable,
              i1.Series
            >,
          ),
          i1.Series,
          i0.PrefetchHooks Function()
        > {
  $$SeriesTableTableTableManager(
    i0.GeneratedDatabase db,
    i4.$SeriesTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i4.$$SeriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i4.$$SeriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i4.$$SeriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String?> userId = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime> updatedAt = const i0.Value.absent(),
                i0.Value<DateTime?> deletedAt = const i0.Value.absent(),
                i0.Value<bool> syncPending = const i0.Value.absent(),
                i0.Value<i2.CollectionType> type = const i0.Value.absent(),
                i0.Value<String> title = const i0.Value.absent(),
                i0.Value<String?> originalTitle = const i0.Value.absent(),
                i0.Value<List<String>> authors = const i0.Value.absent(),
                i0.Value<String?> publisher = const i0.Value.absent(),
                i0.Value<String?> collection = const i0.Value.absent(),
                i0.Value<i3.PublicationStatus> statusPublication =
                    const i0.Value.absent(),
                i0.Value<int?> totalVolumes = const i0.Value.absent(),
                i0.Value<String?> coverUrl = const i0.Value.absent(),
                i0.Value<String?> description = const i0.Value.absent(),
                i0.Value<Map<String, String>> externalIds =
                    const i0.Value.absent(),
                i0.Value<bool> followed = const i0.Value.absent(),
                i0.Value<String?> notes = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i4.SeriesTableCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                type: type,
                title: title,
                originalTitle: originalTitle,
                authors: authors,
                publisher: publisher,
                collection: collection,
                statusPublication: statusPublication,
                totalVolumes: totalVolumes,
                coverUrl: coverUrl,
                description: description,
                externalIds: externalIds,
                followed: followed,
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
                required i2.CollectionType type,
                required String title,
                i0.Value<String?> originalTitle = const i0.Value.absent(),
                i0.Value<List<String>> authors = const i0.Value.absent(),
                i0.Value<String?> publisher = const i0.Value.absent(),
                i0.Value<String?> collection = const i0.Value.absent(),
                i0.Value<i3.PublicationStatus> statusPublication =
                    const i0.Value.absent(),
                i0.Value<int?> totalVolumes = const i0.Value.absent(),
                i0.Value<String?> coverUrl = const i0.Value.absent(),
                i0.Value<String?> description = const i0.Value.absent(),
                i0.Value<Map<String, String>> externalIds =
                    const i0.Value.absent(),
                i0.Value<bool> followed = const i0.Value.absent(),
                i0.Value<String?> notes = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i4.SeriesTableCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                type: type,
                title: title,
                originalTitle: originalTitle,
                authors: authors,
                publisher: publisher,
                collection: collection,
                statusPublication: statusPublication,
                totalVolumes: totalVolumes,
                coverUrl: coverUrl,
                description: description,
                externalIds: externalIds,
                followed: followed,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i4.$SeriesTableTable, i1.Series>(table),
                  i0.BaseReferences<
                    i0.GeneratedDatabase,
                    i4.$SeriesTableTable,
                    i1.Series
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeriesTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i4.$SeriesTableTable,
      i1.Series,
      i4.$$SeriesTableTableFilterComposer,
      i4.$$SeriesTableTableOrderingComposer,
      i4.$$SeriesTableTableAnnotationComposer,
      $$SeriesTableTableCreateCompanionBuilder,
      $$SeriesTableTableUpdateCompanionBuilder,
      (
        i1.Series,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i4.$SeriesTableTable,
          i1.Series
        >,
      ),
      i1.Series,
      i0.PrefetchHooks Function()
    >;

class $SeriesTableTable extends i5.SeriesTable
    with i0.TableInfo<$SeriesTableTable, i1.Series> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeriesTableTable(this.attachedDatabase, [this._alias]);
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
    defaultValue: const i6.Constant(true),
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.CollectionType, String>
  type = i0.GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<i2.CollectionType>(i4.$SeriesTableTable.$convertertype);
  static const i0.VerificationMeta _titleMeta = const i0.VerificationMeta(
    'title',
  );
  @override
  late final i0.GeneratedColumn<String> title = i0.GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const i0.VerificationMeta _originalTitleMeta =
      const i0.VerificationMeta('originalTitle');
  @override
  late final i0.GeneratedColumn<String> originalTitle =
      i0.GeneratedColumn<String>(
        'original_title',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<List<String>, String> authors =
      i0.GeneratedColumn<String>(
        'authors',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const i6.Constant('[]'),
      ).withConverter<List<String>>(i4.$SeriesTableTable.$converterauthors);
  static const i0.VerificationMeta _publisherMeta = const i0.VerificationMeta(
    'publisher',
  );
  @override
  late final i0.GeneratedColumn<String> publisher = i0.GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _collectionMeta = const i0.VerificationMeta(
    'collection',
  );
  @override
  late final i0.GeneratedColumn<String> collection = i0.GeneratedColumn<String>(
    'collection',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i3.PublicationStatus, String>
  statusPublication =
      i0.GeneratedColumn<String>(
        'status_publication',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const i6.Constant('inconnue'),
      ).withConverter<i3.PublicationStatus>(
        i4.$SeriesTableTable.$converterstatusPublication,
      );
  static const i0.VerificationMeta _totalVolumesMeta =
      const i0.VerificationMeta('totalVolumes');
  @override
  late final i0.GeneratedColumn<int> totalVolumes = i0.GeneratedColumn<int>(
    'total_volumes',
    aliasedName,
    true,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _coverUrlMeta = const i0.VerificationMeta(
    'coverUrl',
  );
  @override
  late final i0.GeneratedColumn<String> coverUrl = i0.GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _descriptionMeta = const i0.VerificationMeta(
    'description',
  );
  @override
  late final i0.GeneratedColumn<String> description =
      i0.GeneratedColumn<String>(
        'description',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<Map<String, String>, String>
  externalIds =
      i0.GeneratedColumn<String>(
        'external_ids',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const i6.Constant('{}'),
      ).withConverter<Map<String, String>>(
        i4.$SeriesTableTable.$converterexternalIds,
      );
  static const i0.VerificationMeta _followedMeta = const i0.VerificationMeta(
    'followed',
  );
  @override
  late final i0.GeneratedColumn<bool> followed = i0.GeneratedColumn<bool>(
    'followed',
    aliasedName,
    false,
    type: i0.DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'CHECK ("followed" IN (0, 1))',
    ),
    defaultValue: const i6.Constant(true),
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
    type,
    title,
    originalTitle,
    authors,
    publisher,
    collection,
    statusPublication,
    totalVolumes,
    coverUrl,
    description,
    externalIds,
    followed,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'series';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.Series> instance, {
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_title')) {
      context.handle(
        _originalTitleMeta,
        originalTitle.isAcceptableOrUnknown(
          data['original_title']!,
          _originalTitleMeta,
        ),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('collection')) {
      context.handle(
        _collectionMeta,
        collection.isAcceptableOrUnknown(data['collection']!, _collectionMeta),
      );
    }
    if (data.containsKey('total_volumes')) {
      context.handle(
        _totalVolumesMeta,
        totalVolumes.isAcceptableOrUnknown(
          data['total_volumes']!,
          _totalVolumesMeta,
        ),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('followed')) {
      context.handle(
        _followedMeta,
        followed.isAcceptableOrUnknown(data['followed']!, _followedMeta),
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
  i1.Series map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.Series(
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
      type: i4.$SeriesTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}title'],
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
      originalTitle: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}original_title'],
      ),
      authors: i4.$SeriesTableTable.$converterauthors.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}authors'],
        )!,
      ),
      publisher: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      collection: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}collection'],
      ),
      statusPublication: i4.$SeriesTableTable.$converterstatusPublication
          .fromSql(
            attachedDatabase.typeMapping.read(
              i0.DriftSqlType.string,
              data['${effectivePrefix}status_publication'],
            )!,
          ),
      totalVolumes: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}total_volumes'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      description: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      externalIds: i4.$SeriesTableTable.$converterexternalIds.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}external_ids'],
        )!,
      ),
      followed: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.bool,
        data['${effectivePrefix}followed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SeriesTableTable createAlias(String alias) {
    return $SeriesTableTable(attachedDatabase, alias);
  }

  static i0.TypeConverter<i2.CollectionType, String> $convertertype =
      const i7.DbEnumConverter(i2.CollectionType.values);
  static i0.TypeConverter<List<String>, String> $converterauthors =
      const i7.StringListConverter();
  static i0.TypeConverter<i3.PublicationStatus, String>
  $converterstatusPublication = const i7.DbEnumConverter(
    i3.PublicationStatus.values,
  );
  static i0.TypeConverter<Map<String, String>, String> $converterexternalIds =
      const i7.StringMapConverter();
}

class SeriesTableCompanion extends i0.UpdateCompanion<i1.Series> {
  final i0.Value<String> id;
  final i0.Value<String?> userId;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> updatedAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<bool> syncPending;
  final i0.Value<i2.CollectionType> type;
  final i0.Value<String> title;
  final i0.Value<String?> originalTitle;
  final i0.Value<List<String>> authors;
  final i0.Value<String?> publisher;
  final i0.Value<String?> collection;
  final i0.Value<i3.PublicationStatus> statusPublication;
  final i0.Value<int?> totalVolumes;
  final i0.Value<String?> coverUrl;
  final i0.Value<String?> description;
  final i0.Value<Map<String, String>> externalIds;
  final i0.Value<bool> followed;
  final i0.Value<String?> notes;
  final i0.Value<int> rowid;
  const SeriesTableCompanion({
    this.id = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.updatedAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.type = const i0.Value.absent(),
    this.title = const i0.Value.absent(),
    this.originalTitle = const i0.Value.absent(),
    this.authors = const i0.Value.absent(),
    this.publisher = const i0.Value.absent(),
    this.collection = const i0.Value.absent(),
    this.statusPublication = const i0.Value.absent(),
    this.totalVolumes = const i0.Value.absent(),
    this.coverUrl = const i0.Value.absent(),
    this.description = const i0.Value.absent(),
    this.externalIds = const i0.Value.absent(),
    this.followed = const i0.Value.absent(),
    this.notes = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  SeriesTableCompanion.insert({
    required String id,
    this.userId = const i0.Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    required i2.CollectionType type,
    required String title,
    this.originalTitle = const i0.Value.absent(),
    this.authors = const i0.Value.absent(),
    this.publisher = const i0.Value.absent(),
    this.collection = const i0.Value.absent(),
    this.statusPublication = const i0.Value.absent(),
    this.totalVolumes = const i0.Value.absent(),
    this.coverUrl = const i0.Value.absent(),
    this.description = const i0.Value.absent(),
    this.externalIds = const i0.Value.absent(),
    this.followed = const i0.Value.absent(),
    this.notes = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       createdAt = i0.Value(createdAt),
       updatedAt = i0.Value(updatedAt),
       type = i0.Value(type),
       title = i0.Value(title);
  static i0.Insertable<i1.Series> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? updatedAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<bool>? syncPending,
    i0.Expression<String>? type,
    i0.Expression<String>? title,
    i0.Expression<String>? originalTitle,
    i0.Expression<String>? authors,
    i0.Expression<String>? publisher,
    i0.Expression<String>? collection,
    i0.Expression<String>? statusPublication,
    i0.Expression<int>? totalVolumes,
    i0.Expression<String>? coverUrl,
    i0.Expression<String>? description,
    i0.Expression<String>? externalIds,
    i0.Expression<bool>? followed,
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
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (originalTitle != null) 'original_title': originalTitle,
      if (authors != null) 'authors': authors,
      if (publisher != null) 'publisher': publisher,
      if (collection != null) 'collection': collection,
      if (statusPublication != null) 'status_publication': statusPublication,
      if (totalVolumes != null) 'total_volumes': totalVolumes,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (description != null) 'description': description,
      if (externalIds != null) 'external_ids': externalIds,
      if (followed != null) 'followed': followed,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i4.SeriesTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String?>? userId,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? updatedAt,
    i0.Value<DateTime?>? deletedAt,
    i0.Value<bool>? syncPending,
    i0.Value<i2.CollectionType>? type,
    i0.Value<String>? title,
    i0.Value<String?>? originalTitle,
    i0.Value<List<String>>? authors,
    i0.Value<String?>? publisher,
    i0.Value<String?>? collection,
    i0.Value<i3.PublicationStatus>? statusPublication,
    i0.Value<int?>? totalVolumes,
    i0.Value<String?>? coverUrl,
    i0.Value<String?>? description,
    i0.Value<Map<String, String>>? externalIds,
    i0.Value<bool>? followed,
    i0.Value<String?>? notes,
    i0.Value<int>? rowid,
  }) {
    return i4.SeriesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncPending: syncPending ?? this.syncPending,
      type: type ?? this.type,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      authors: authors ?? this.authors,
      publisher: publisher ?? this.publisher,
      collection: collection ?? this.collection,
      statusPublication: statusPublication ?? this.statusPublication,
      totalVolumes: totalVolumes ?? this.totalVolumes,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      externalIds: externalIds ?? this.externalIds,
      followed: followed ?? this.followed,
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
    if (type.present) {
      map['type'] = i0.Variable<String>(
        i4.$SeriesTableTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = i0.Variable<String>(title.value);
    }
    if (originalTitle.present) {
      map['original_title'] = i0.Variable<String>(originalTitle.value);
    }
    if (authors.present) {
      map['authors'] = i0.Variable<String>(
        i4.$SeriesTableTable.$converterauthors.toSql(authors.value),
      );
    }
    if (publisher.present) {
      map['publisher'] = i0.Variable<String>(publisher.value);
    }
    if (collection.present) {
      map['collection'] = i0.Variable<String>(collection.value);
    }
    if (statusPublication.present) {
      map['status_publication'] = i0.Variable<String>(
        i4.$SeriesTableTable.$converterstatusPublication.toSql(
          statusPublication.value,
        ),
      );
    }
    if (totalVolumes.present) {
      map['total_volumes'] = i0.Variable<int>(totalVolumes.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = i0.Variable<String>(coverUrl.value);
    }
    if (description.present) {
      map['description'] = i0.Variable<String>(description.value);
    }
    if (externalIds.present) {
      map['external_ids'] = i0.Variable<String>(
        i4.$SeriesTableTable.$converterexternalIds.toSql(externalIds.value),
      );
    }
    if (followed.present) {
      map['followed'] = i0.Variable<bool>(followed.value);
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
    return (StringBuffer('SeriesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('authors: $authors, ')
          ..write('publisher: $publisher, ')
          ..write('collection: $collection, ')
          ..write('statusPublication: $statusPublication, ')
          ..write('totalVolumes: $totalVolumes, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('description: $description, ')
          ..write('externalIds: $externalIds, ')
          ..write('followed: $followed, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$SeriesInsertable implements i0.Insertable<i1.Series> {
  i1.Series _object;
  _$SeriesInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i4.SeriesTableCompanion(
      id: i0.Value(_object.id),
      userId: i0.Value(_object.userId),
      createdAt: i0.Value(_object.createdAt),
      updatedAt: i0.Value(_object.updatedAt),
      deletedAt: i0.Value(_object.deletedAt),
      syncPending: i0.Value(_object.syncPending),
      type: i0.Value(_object.type),
      title: i0.Value(_object.title),
      originalTitle: i0.Value(_object.originalTitle),
      authors: i0.Value(_object.authors),
      publisher: i0.Value(_object.publisher),
      collection: i0.Value(_object.collection),
      statusPublication: i0.Value(_object.statusPublication),
      totalVolumes: i0.Value(_object.totalVolumes),
      coverUrl: i0.Value(_object.coverUrl),
      description: i0.Value(_object.description),
      externalIds: i0.Value(_object.externalIds),
      followed: i0.Value(_object.followed),
      notes: i0.Value(_object.notes),
    ).toColumns(false);
  }
}

extension SeriesToInsertable on i1.Series {
  _$SeriesInsertable toInsertable() {
    return _$SeriesInsertable(this);
  }
}
