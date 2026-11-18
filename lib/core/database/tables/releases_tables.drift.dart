// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/features/releases/domain/release_alert.dart' as i1;
import 'package:dupe/features/collection/domain/collection_type.dart' as i2;
import 'package:dupe/core/database/tables/releases_tables.drift.dart' as i3;
import 'package:dupe/core/database/tables/releases_tables.dart' as i4;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i5;
import 'package:dupe/core/database/converters.dart' as i6;

typedef $$ReleaseAlertsTableTableCreateCompanionBuilder =
    i3.ReleaseAlertsTableCompanion Function({
      required String id,
      i0.Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      required String key,
      required i1.AlertKind kind,
      required i2.CollectionType type,
      required String title,
      i0.Value<i1.AlertStatus> status,
      i0.Value<String?> seriesId,
      i0.Value<String?> volumeNumber,
      i0.Value<String?> authorName,
      i0.Value<List<String>> authors,
      i0.Value<String?> isbn13,
      i0.Value<String?> publisher,
      i0.Value<String?> publishDate,
      i0.Value<String?> coverUrl,
      i0.Value<int> rowid,
    });
typedef $$ReleaseAlertsTableTableUpdateCompanionBuilder =
    i3.ReleaseAlertsTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String?> userId,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<String> key,
      i0.Value<i1.AlertKind> kind,
      i0.Value<i2.CollectionType> type,
      i0.Value<String> title,
      i0.Value<i1.AlertStatus> status,
      i0.Value<String?> seriesId,
      i0.Value<String?> volumeNumber,
      i0.Value<String?> authorName,
      i0.Value<List<String>> authors,
      i0.Value<String?> isbn13,
      i0.Value<String?> publisher,
      i0.Value<String?> publishDate,
      i0.Value<String?> coverUrl,
      i0.Value<int> rowid,
    });

class $$ReleaseAlertsTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$ReleaseAlertsTableTable> {
  $$ReleaseAlertsTableTableFilterComposer({
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

  i0.ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i1.AlertKind, i1.AlertKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
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

  i0.ColumnWithTypeConverterFilters<i1.AlertStatus, i1.AlertStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get seriesId => $composableBuilder(
    column: $table.seriesId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get publishDate => $composableBuilder(
    column: $table.publishDate,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$ReleaseAlertsTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$ReleaseAlertsTableTable> {
  $$ReleaseAlertsTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
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

  i0.ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get seriesId => $composableBuilder(
    column: $table.seriesId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get authors => $composableBuilder(
    column: $table.authors,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get publishDate => $composableBuilder(
    column: $table.publishDate,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$ReleaseAlertsTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$ReleaseAlertsTableTable> {
  $$ReleaseAlertsTableTableAnnotationComposer({
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

  i0.GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i1.AlertKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i2.CollectionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  i0.GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i1.AlertStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  i0.GeneratedColumn<String> get seriesId =>
      $composableBuilder(column: $table.seriesId, builder: (column) => column);

  i0.GeneratedColumn<String> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<List<String>, String> get authors =>
      $composableBuilder(column: $table.authors, builder: (column) => column);

  i0.GeneratedColumn<String> get isbn13 =>
      $composableBuilder(column: $table.isbn13, builder: (column) => column);

  i0.GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  i0.GeneratedColumn<String> get publishDate => $composableBuilder(
    column: $table.publishDate,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);
}

class $$ReleaseAlertsTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i3.$ReleaseAlertsTableTable,
          i1.ReleaseAlert,
          i3.$$ReleaseAlertsTableTableFilterComposer,
          i3.$$ReleaseAlertsTableTableOrderingComposer,
          i3.$$ReleaseAlertsTableTableAnnotationComposer,
          $$ReleaseAlertsTableTableCreateCompanionBuilder,
          $$ReleaseAlertsTableTableUpdateCompanionBuilder,
          (
            i1.ReleaseAlert,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i3.$ReleaseAlertsTableTable,
              i1.ReleaseAlert
            >,
          ),
          i1.ReleaseAlert,
          i0.PrefetchHooks Function()
        > {
  $$ReleaseAlertsTableTableTableManager(
    i0.GeneratedDatabase db,
    i3.$ReleaseAlertsTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => i3
              .$$ReleaseAlertsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i3.$$ReleaseAlertsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              i3.$$ReleaseAlertsTableTableAnnotationComposer(
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
                i0.Value<String> key = const i0.Value.absent(),
                i0.Value<i1.AlertKind> kind = const i0.Value.absent(),
                i0.Value<i2.CollectionType> type = const i0.Value.absent(),
                i0.Value<String> title = const i0.Value.absent(),
                i0.Value<i1.AlertStatus> status = const i0.Value.absent(),
                i0.Value<String?> seriesId = const i0.Value.absent(),
                i0.Value<String?> volumeNumber = const i0.Value.absent(),
                i0.Value<String?> authorName = const i0.Value.absent(),
                i0.Value<List<String>> authors = const i0.Value.absent(),
                i0.Value<String?> isbn13 = const i0.Value.absent(),
                i0.Value<String?> publisher = const i0.Value.absent(),
                i0.Value<String?> publishDate = const i0.Value.absent(),
                i0.Value<String?> coverUrl = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i3.ReleaseAlertsTableCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                key: key,
                kind: kind,
                type: type,
                title: title,
                status: status,
                seriesId: seriesId,
                volumeNumber: volumeNumber,
                authorName: authorName,
                authors: authors,
                isbn13: isbn13,
                publisher: publisher,
                publishDate: publishDate,
                coverUrl: coverUrl,
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
                required String key,
                required i1.AlertKind kind,
                required i2.CollectionType type,
                required String title,
                i0.Value<i1.AlertStatus> status = const i0.Value.absent(),
                i0.Value<String?> seriesId = const i0.Value.absent(),
                i0.Value<String?> volumeNumber = const i0.Value.absent(),
                i0.Value<String?> authorName = const i0.Value.absent(),
                i0.Value<List<String>> authors = const i0.Value.absent(),
                i0.Value<String?> isbn13 = const i0.Value.absent(),
                i0.Value<String?> publisher = const i0.Value.absent(),
                i0.Value<String?> publishDate = const i0.Value.absent(),
                i0.Value<String?> coverUrl = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i3.ReleaseAlertsTableCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                key: key,
                kind: kind,
                type: type,
                title: title,
                status: status,
                seriesId: seriesId,
                volumeNumber: volumeNumber,
                authorName: authorName,
                authors: authors,
                isbn13: isbn13,
                publisher: publisher,
                publishDate: publishDate,
                coverUrl: coverUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i3.$ReleaseAlertsTableTable, i1.ReleaseAlert>(
                    table,
                  ),
                  i0.BaseReferences<
                    i0.GeneratedDatabase,
                    i3.$ReleaseAlertsTableTable,
                    i1.ReleaseAlert
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReleaseAlertsTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i3.$ReleaseAlertsTableTable,
      i1.ReleaseAlert,
      i3.$$ReleaseAlertsTableTableFilterComposer,
      i3.$$ReleaseAlertsTableTableOrderingComposer,
      i3.$$ReleaseAlertsTableTableAnnotationComposer,
      $$ReleaseAlertsTableTableCreateCompanionBuilder,
      $$ReleaseAlertsTableTableUpdateCompanionBuilder,
      (
        i1.ReleaseAlert,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i3.$ReleaseAlertsTableTable,
          i1.ReleaseAlert
        >,
      ),
      i1.ReleaseAlert,
      i0.PrefetchHooks Function()
    >;
typedef $$FollowedAuthorsTableTableCreateCompanionBuilder =
    i3.FollowedAuthorsTableCompanion Function({
      required String id,
      i0.Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      required String name,
      i0.Value<int> rowid,
    });
typedef $$FollowedAuthorsTableTableUpdateCompanionBuilder =
    i3.FollowedAuthorsTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String?> userId,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<String> name,
      i0.Value<int> rowid,
    });

class $$FollowedAuthorsTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$FollowedAuthorsTableTable> {
  $$FollowedAuthorsTableTableFilterComposer({
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

  i0.ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => i0.ColumnFilters(column),
  );
}

class $$FollowedAuthorsTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$FollowedAuthorsTableTable> {
  $$FollowedAuthorsTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => i0.ColumnOrderings(column),
  );
}

class $$FollowedAuthorsTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i3.$FollowedAuthorsTableTable> {
  $$FollowedAuthorsTableTableAnnotationComposer({
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

  i0.GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$FollowedAuthorsTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i3.$FollowedAuthorsTableTable,
          i1.FollowedAuthor,
          i3.$$FollowedAuthorsTableTableFilterComposer,
          i3.$$FollowedAuthorsTableTableOrderingComposer,
          i3.$$FollowedAuthorsTableTableAnnotationComposer,
          $$FollowedAuthorsTableTableCreateCompanionBuilder,
          $$FollowedAuthorsTableTableUpdateCompanionBuilder,
          (
            i1.FollowedAuthor,
            i0.BaseReferences<
              i0.GeneratedDatabase,
              i3.$FollowedAuthorsTableTable,
              i1.FollowedAuthor
            >,
          ),
          i1.FollowedAuthor,
          i0.PrefetchHooks Function()
        > {
  $$FollowedAuthorsTableTableTableManager(
    i0.GeneratedDatabase db,
    i3.$FollowedAuthorsTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i3.$$FollowedAuthorsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              i3.$$FollowedAuthorsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              i3.$$FollowedAuthorsTableTableAnnotationComposer(
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
                i0.Value<String> name = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i3.FollowedAuthorsTableCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                name: name,
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
                required String name,
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i3.FollowedAuthorsTableCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i3.$FollowedAuthorsTableTable, i1.FollowedAuthor>(
                    table,
                  ),
                  i0.BaseReferences<
                    i0.GeneratedDatabase,
                    i3.$FollowedAuthorsTableTable,
                    i1.FollowedAuthor
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FollowedAuthorsTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i3.$FollowedAuthorsTableTable,
      i1.FollowedAuthor,
      i3.$$FollowedAuthorsTableTableFilterComposer,
      i3.$$FollowedAuthorsTableTableOrderingComposer,
      i3.$$FollowedAuthorsTableTableAnnotationComposer,
      $$FollowedAuthorsTableTableCreateCompanionBuilder,
      $$FollowedAuthorsTableTableUpdateCompanionBuilder,
      (
        i1.FollowedAuthor,
        i0.BaseReferences<
          i0.GeneratedDatabase,
          i3.$FollowedAuthorsTableTable,
          i1.FollowedAuthor
        >,
      ),
      i1.FollowedAuthor,
      i0.PrefetchHooks Function()
    >;

class $ReleaseAlertsTableTable extends i4.ReleaseAlertsTable
    with i0.TableInfo<$ReleaseAlertsTableTable, i1.ReleaseAlert> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReleaseAlertsTableTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _keyMeta = const i0.VerificationMeta('key');
  @override
  late final i0.GeneratedColumn<String> key = i0.GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i1.AlertKind, String> kind =
      i0.GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<i1.AlertKind>(i3.$ReleaseAlertsTableTable.$converterkind);
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.CollectionType, String>
  type =
      i0.GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<i2.CollectionType>(
        i3.$ReleaseAlertsTableTable.$convertertype,
      );
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
  @override
  late final i0.GeneratedColumnWithTypeConverter<i1.AlertStatus, String>
  status = i0.GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const i5.Constant('nouveau'),
  ).withConverter<i1.AlertStatus>(i3.$ReleaseAlertsTableTable.$converterstatus);
  static const i0.VerificationMeta _seriesIdMeta = const i0.VerificationMeta(
    'seriesId',
  );
  @override
  late final i0.GeneratedColumn<String> seriesId = i0.GeneratedColumn<String>(
    'series_id',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _volumeNumberMeta =
      const i0.VerificationMeta('volumeNumber');
  @override
  late final i0.GeneratedColumn<String> volumeNumber =
      i0.GeneratedColumn<String>(
        'volume_number',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _authorNameMeta = const i0.VerificationMeta(
    'authorName',
  );
  @override
  late final i0.GeneratedColumn<String> authorName = i0.GeneratedColumn<String>(
    'author_name',
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
        defaultValue: const i5.Constant('[]'),
      ).withConverter<List<String>>(
        i3.$ReleaseAlertsTableTable.$converterauthors,
      );
  static const i0.VerificationMeta _isbn13Meta = const i0.VerificationMeta(
    'isbn13',
  );
  @override
  late final i0.GeneratedColumn<String> isbn13 = i0.GeneratedColumn<String>(
    'isbn13',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
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
  static const i0.VerificationMeta _publishDateMeta = const i0.VerificationMeta(
    'publishDate',
  );
  @override
  late final i0.GeneratedColumn<String> publishDate =
      i0.GeneratedColumn<String>(
        'publish_date',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
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
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    syncPending,
    key,
    kind,
    type,
    title,
    status,
    seriesId,
    volumeNumber,
    authorName,
    authors,
    isbn13,
    publisher,
    publishDate,
    coverUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'release_alerts';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.ReleaseAlert> instance, {
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
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    }
    if (data.containsKey('volume_number')) {
      context.handle(
        _volumeNumberMeta,
        volumeNumber.isAcceptableOrUnknown(
          data['volume_number']!,
          _volumeNumberMeta,
        ),
      );
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    }
    if (data.containsKey('isbn13')) {
      context.handle(
        _isbn13Meta,
        isbn13.isAcceptableOrUnknown(data['isbn13']!, _isbn13Meta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('publish_date')) {
      context.handle(
        _publishDateMeta,
        publishDate.isAcceptableOrUnknown(
          data['publish_date']!,
          _publishDateMeta,
        ),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.ReleaseAlert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.ReleaseAlert(
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
      key: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      kind: i3.$ReleaseAlertsTableTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      type: i3.$ReleaseAlertsTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: i3.$ReleaseAlertsTableTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      seriesId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      ),
      volumeNumber: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}volume_number'],
      ),
      authorName: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      ),
      authors: i3.$ReleaseAlertsTableTable.$converterauthors.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}authors'],
        )!,
      ),
      isbn13: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}isbn13'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      publishDate: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}publish_date'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
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
  $ReleaseAlertsTableTable createAlias(String alias) {
    return $ReleaseAlertsTableTable(attachedDatabase, alias);
  }

  static i0.TypeConverter<i1.AlertKind, String> $converterkind =
      const i6.DbEnumConverter(i1.AlertKind.values);
  static i0.TypeConverter<i2.CollectionType, String> $convertertype =
      const i6.DbEnumConverter(i2.CollectionType.values);
  static i0.TypeConverter<i1.AlertStatus, String> $converterstatus =
      const i6.DbEnumConverter(i1.AlertStatus.values);
  static i0.TypeConverter<List<String>, String> $converterauthors =
      const i6.StringListConverter();
}

class ReleaseAlertsTableCompanion extends i0.UpdateCompanion<i1.ReleaseAlert> {
  final i0.Value<String> id;
  final i0.Value<String?> userId;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> updatedAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<bool> syncPending;
  final i0.Value<String> key;
  final i0.Value<i1.AlertKind> kind;
  final i0.Value<i2.CollectionType> type;
  final i0.Value<String> title;
  final i0.Value<i1.AlertStatus> status;
  final i0.Value<String?> seriesId;
  final i0.Value<String?> volumeNumber;
  final i0.Value<String?> authorName;
  final i0.Value<List<String>> authors;
  final i0.Value<String?> isbn13;
  final i0.Value<String?> publisher;
  final i0.Value<String?> publishDate;
  final i0.Value<String?> coverUrl;
  final i0.Value<int> rowid;
  const ReleaseAlertsTableCompanion({
    this.id = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.updatedAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.key = const i0.Value.absent(),
    this.kind = const i0.Value.absent(),
    this.type = const i0.Value.absent(),
    this.title = const i0.Value.absent(),
    this.status = const i0.Value.absent(),
    this.seriesId = const i0.Value.absent(),
    this.volumeNumber = const i0.Value.absent(),
    this.authorName = const i0.Value.absent(),
    this.authors = const i0.Value.absent(),
    this.isbn13 = const i0.Value.absent(),
    this.publisher = const i0.Value.absent(),
    this.publishDate = const i0.Value.absent(),
    this.coverUrl = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ReleaseAlertsTableCompanion.insert({
    required String id,
    this.userId = const i0.Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    required String key,
    required i1.AlertKind kind,
    required i2.CollectionType type,
    required String title,
    this.status = const i0.Value.absent(),
    this.seriesId = const i0.Value.absent(),
    this.volumeNumber = const i0.Value.absent(),
    this.authorName = const i0.Value.absent(),
    this.authors = const i0.Value.absent(),
    this.isbn13 = const i0.Value.absent(),
    this.publisher = const i0.Value.absent(),
    this.publishDate = const i0.Value.absent(),
    this.coverUrl = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       createdAt = i0.Value(createdAt),
       updatedAt = i0.Value(updatedAt),
       key = i0.Value(key),
       kind = i0.Value(kind),
       type = i0.Value(type),
       title = i0.Value(title);
  static i0.Insertable<i1.ReleaseAlert> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? updatedAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<bool>? syncPending,
    i0.Expression<String>? key,
    i0.Expression<String>? kind,
    i0.Expression<String>? type,
    i0.Expression<String>? title,
    i0.Expression<String>? status,
    i0.Expression<String>? seriesId,
    i0.Expression<String>? volumeNumber,
    i0.Expression<String>? authorName,
    i0.Expression<String>? authors,
    i0.Expression<String>? isbn13,
    i0.Expression<String>? publisher,
    i0.Expression<String>? publishDate,
    i0.Expression<String>? coverUrl,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncPending != null) 'sync_pending': syncPending,
      if (key != null) 'key': key,
      if (kind != null) 'kind': kind,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (seriesId != null) 'series_id': seriesId,
      if (volumeNumber != null) 'volume_number': volumeNumber,
      if (authorName != null) 'author_name': authorName,
      if (authors != null) 'authors': authors,
      if (isbn13 != null) 'isbn13': isbn13,
      if (publisher != null) 'publisher': publisher,
      if (publishDate != null) 'publish_date': publishDate,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i3.ReleaseAlertsTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String?>? userId,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? updatedAt,
    i0.Value<DateTime?>? deletedAt,
    i0.Value<bool>? syncPending,
    i0.Value<String>? key,
    i0.Value<i1.AlertKind>? kind,
    i0.Value<i2.CollectionType>? type,
    i0.Value<String>? title,
    i0.Value<i1.AlertStatus>? status,
    i0.Value<String?>? seriesId,
    i0.Value<String?>? volumeNumber,
    i0.Value<String?>? authorName,
    i0.Value<List<String>>? authors,
    i0.Value<String?>? isbn13,
    i0.Value<String?>? publisher,
    i0.Value<String?>? publishDate,
    i0.Value<String?>? coverUrl,
    i0.Value<int>? rowid,
  }) {
    return i3.ReleaseAlertsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncPending: syncPending ?? this.syncPending,
      key: key ?? this.key,
      kind: kind ?? this.kind,
      type: type ?? this.type,
      title: title ?? this.title,
      status: status ?? this.status,
      seriesId: seriesId ?? this.seriesId,
      volumeNumber: volumeNumber ?? this.volumeNumber,
      authorName: authorName ?? this.authorName,
      authors: authors ?? this.authors,
      isbn13: isbn13 ?? this.isbn13,
      publisher: publisher ?? this.publisher,
      publishDate: publishDate ?? this.publishDate,
      coverUrl: coverUrl ?? this.coverUrl,
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
    if (key.present) {
      map['key'] = i0.Variable<String>(key.value);
    }
    if (kind.present) {
      map['kind'] = i0.Variable<String>(
        i3.$ReleaseAlertsTableTable.$converterkind.toSql(kind.value),
      );
    }
    if (type.present) {
      map['type'] = i0.Variable<String>(
        i3.$ReleaseAlertsTableTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = i0.Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = i0.Variable<String>(
        i3.$ReleaseAlertsTableTable.$converterstatus.toSql(status.value),
      );
    }
    if (seriesId.present) {
      map['series_id'] = i0.Variable<String>(seriesId.value);
    }
    if (volumeNumber.present) {
      map['volume_number'] = i0.Variable<String>(volumeNumber.value);
    }
    if (authorName.present) {
      map['author_name'] = i0.Variable<String>(authorName.value);
    }
    if (authors.present) {
      map['authors'] = i0.Variable<String>(
        i3.$ReleaseAlertsTableTable.$converterauthors.toSql(authors.value),
      );
    }
    if (isbn13.present) {
      map['isbn13'] = i0.Variable<String>(isbn13.value);
    }
    if (publisher.present) {
      map['publisher'] = i0.Variable<String>(publisher.value);
    }
    if (publishDate.present) {
      map['publish_date'] = i0.Variable<String>(publishDate.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = i0.Variable<String>(coverUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReleaseAlertsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('key: $key, ')
          ..write('kind: $kind, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('seriesId: $seriesId, ')
          ..write('volumeNumber: $volumeNumber, ')
          ..write('authorName: $authorName, ')
          ..write('authors: $authors, ')
          ..write('isbn13: $isbn13, ')
          ..write('publisher: $publisher, ')
          ..write('publishDate: $publishDate, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ReleaseAlertInsertable implements i0.Insertable<i1.ReleaseAlert> {
  i1.ReleaseAlert _object;
  _$ReleaseAlertInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i3.ReleaseAlertsTableCompanion(
      id: i0.Value(_object.id),
      userId: i0.Value(_object.userId),
      createdAt: i0.Value(_object.createdAt),
      updatedAt: i0.Value(_object.updatedAt),
      deletedAt: i0.Value(_object.deletedAt),
      syncPending: i0.Value(_object.syncPending),
      key: i0.Value(_object.key),
      kind: i0.Value(_object.kind),
      type: i0.Value(_object.type),
      title: i0.Value(_object.title),
      status: i0.Value(_object.status),
      seriesId: i0.Value(_object.seriesId),
      volumeNumber: i0.Value(_object.volumeNumber),
      authorName: i0.Value(_object.authorName),
      authors: i0.Value(_object.authors),
      isbn13: i0.Value(_object.isbn13),
      publisher: i0.Value(_object.publisher),
      publishDate: i0.Value(_object.publishDate),
      coverUrl: i0.Value(_object.coverUrl),
    ).toColumns(false);
  }
}

extension ReleaseAlertToInsertable on i1.ReleaseAlert {
  _$ReleaseAlertInsertable toInsertable() {
    return _$ReleaseAlertInsertable(this);
  }
}

class $FollowedAuthorsTableTable extends i4.FollowedAuthorsTable
    with i0.TableInfo<$FollowedAuthorsTableTable, i1.FollowedAuthor> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FollowedAuthorsTableTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _nameMeta = const i0.VerificationMeta(
    'name',
  );
  @override
  late final i0.GeneratedColumn<String> name = i0.GeneratedColumn<String>(
    'name',
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
    name,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'followed_authors';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.FollowedAuthor> instance, {
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.FollowedAuthor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.FollowedAuthor(
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
      name: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}name'],
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
  $FollowedAuthorsTableTable createAlias(String alias) {
    return $FollowedAuthorsTableTable(attachedDatabase, alias);
  }
}

class FollowedAuthorsTableCompanion
    extends i0.UpdateCompanion<i1.FollowedAuthor> {
  final i0.Value<String> id;
  final i0.Value<String?> userId;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> updatedAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<bool> syncPending;
  final i0.Value<String> name;
  final i0.Value<int> rowid;
  const FollowedAuthorsTableCompanion({
    this.id = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.updatedAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.name = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  FollowedAuthorsTableCompanion.insert({
    required String id,
    this.userId = const i0.Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    required String name,
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       createdAt = i0.Value(createdAt),
       updatedAt = i0.Value(updatedAt),
       name = i0.Value(name);
  static i0.Insertable<i1.FollowedAuthor> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? updatedAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<bool>? syncPending,
    i0.Expression<String>? name,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncPending != null) 'sync_pending': syncPending,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i3.FollowedAuthorsTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String?>? userId,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? updatedAt,
    i0.Value<DateTime?>? deletedAt,
    i0.Value<bool>? syncPending,
    i0.Value<String>? name,
    i0.Value<int>? rowid,
  }) {
    return i3.FollowedAuthorsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncPending: syncPending ?? this.syncPending,
      name: name ?? this.name,
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
    if (name.present) {
      map['name'] = i0.Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FollowedAuthorsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$FollowedAuthorInsertable implements i0.Insertable<i1.FollowedAuthor> {
  i1.FollowedAuthor _object;
  _$FollowedAuthorInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i3.FollowedAuthorsTableCompanion(
      id: i0.Value(_object.id),
      userId: i0.Value(_object.userId),
      createdAt: i0.Value(_object.createdAt),
      updatedAt: i0.Value(_object.updatedAt),
      deletedAt: i0.Value(_object.deletedAt),
      syncPending: i0.Value(_object.syncPending),
      name: i0.Value(_object.name),
    ).toColumns(false);
  }
}

extension FollowedAuthorToInsertable on i1.FollowedAuthor {
  _$FollowedAuthorInsertable toInsertable() {
    return _$FollowedAuthorInsertable(this);
  }
}
