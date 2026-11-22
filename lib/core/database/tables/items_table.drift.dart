// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:dupe/features/collection/domain/item.dart' as i1;
import 'package:dupe/features/collection/domain/collection_type.dart' as i2;
import 'package:dupe/features/collection/domain/enums.dart' as i3;
import 'package:dupe/core/database/tables/items_table.drift.dart' as i4;
import 'package:dupe/core/database/tables/items_table.dart' as i5;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i6;
import 'package:dupe/core/database/converters.dart' as i7;
import 'package:dupe/core/database/tables/series_table.drift.dart' as i8;
import 'package:drift/internal/modular.dart' as i9;

typedef $$ItemsTableTableCreateCompanionBuilder =
    i4.ItemsTableCompanion Function({
      required String id,
      i0.Value<String?> userId,
      required DateTime createdAt,
      required DateTime updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<String?> seriesId,
      required i2.CollectionType type,
      required String title,
      i0.Value<String?> volumeNumber,
      i0.Value<String?> volumeTitle,
      i0.Value<String?> isbn13,
      i0.Value<String?> upc,
      i0.Value<List<String>> authors,
      i0.Value<String?> publisher,
      i0.Value<String?> edition,
      i0.Value<String?> format,
      i0.Value<String?> publishDate,
      i0.Value<int?> pageCount,
      i0.Value<String?> language,
      i0.Value<String?> coverUrl,
      i0.Value<String?> description,
      i0.Value<i3.Ownership> ownership,
      i0.Value<i3.ReadingStatus> readingStatus,
      i0.Value<DateTime?> readDate,
      i0.Value<int?> rating,
      i0.Value<bool> isFirstEdition,
      i0.Value<bool> isVariant,
      i0.Value<String?> condition,
      i0.Value<double?> purchasePrice,
      i0.Value<DateTime?> purchaseDate,
      i0.Value<double?> coverPrice,
      i0.Value<double?> estimatedValue,
      i0.Value<String> currency,
      i0.Value<int?> wishlistPriority,
      i0.Value<double?> wishlistMaxPrice,
      i0.Value<String?> location,
      i0.Value<String?> notes,
      i0.Value<String?> source,
      i0.Value<String?> sourceId,
      i0.Value<bool> isSigned,
      i0.Value<String?> signedBy,
      i0.Value<DateTime?> signedOn,
      i0.Value<String?> signedPlace,
      i0.Value<String?> signingNote,
      i0.Value<List<String>> refusedCovers,
      i0.Value<int> rowid,
    });
typedef $$ItemsTableTableUpdateCompanionBuilder =
    i4.ItemsTableCompanion Function({
      i0.Value<String> id,
      i0.Value<String?> userId,
      i0.Value<DateTime> createdAt,
      i0.Value<DateTime> updatedAt,
      i0.Value<DateTime?> deletedAt,
      i0.Value<bool> syncPending,
      i0.Value<String?> seriesId,
      i0.Value<i2.CollectionType> type,
      i0.Value<String> title,
      i0.Value<String?> volumeNumber,
      i0.Value<String?> volumeTitle,
      i0.Value<String?> isbn13,
      i0.Value<String?> upc,
      i0.Value<List<String>> authors,
      i0.Value<String?> publisher,
      i0.Value<String?> edition,
      i0.Value<String?> format,
      i0.Value<String?> publishDate,
      i0.Value<int?> pageCount,
      i0.Value<String?> language,
      i0.Value<String?> coverUrl,
      i0.Value<String?> description,
      i0.Value<i3.Ownership> ownership,
      i0.Value<i3.ReadingStatus> readingStatus,
      i0.Value<DateTime?> readDate,
      i0.Value<int?> rating,
      i0.Value<bool> isFirstEdition,
      i0.Value<bool> isVariant,
      i0.Value<String?> condition,
      i0.Value<double?> purchasePrice,
      i0.Value<DateTime?> purchaseDate,
      i0.Value<double?> coverPrice,
      i0.Value<double?> estimatedValue,
      i0.Value<String> currency,
      i0.Value<int?> wishlistPriority,
      i0.Value<double?> wishlistMaxPrice,
      i0.Value<String?> location,
      i0.Value<String?> notes,
      i0.Value<String?> source,
      i0.Value<String?> sourceId,
      i0.Value<bool> isSigned,
      i0.Value<String?> signedBy,
      i0.Value<DateTime?> signedOn,
      i0.Value<String?> signedPlace,
      i0.Value<String?> signingNote,
      i0.Value<List<String>> refusedCovers,
      i0.Value<int> rowid,
    });

final class $$ItemsTableTableReferences
    extends
        i0.BaseReferences<i0.GeneratedDatabase, i4.$ItemsTableTable, i1.Item> {
  $$ItemsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static i8.$SeriesTableTable _seriesIdTable(i0.GeneratedDatabase db) =>
      i9.ReadDatabaseContainer(db)
          .resultSet<i8.$SeriesTableTable>('series')
          .createAlias('items__series_id__series__id');

  i8.$$SeriesTableTableProcessedTableManager? get seriesId {
    final $_column = $_itemColumn<String>('series_id');
    if ($_column == null) return null;
    final manager = i8
        .$$SeriesTableTableTableManager(
          $_db,
          i9.ReadDatabaseContainer($_db)
              .resultSet<i8.$SeriesTableTable>('series'),
        )
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return i0.ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemsTableTableFilterComposer
    extends i0.Composer<i0.GeneratedDatabase, i4.$ItemsTableTable> {
  $$ItemsTableTableFilterComposer({
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

  i0.ColumnFilters<String> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get volumeTitle => $composableBuilder(
    column: $table.volumeTitle,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get upc => $composableBuilder(
    column: $table.upc,
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

  i0.ColumnFilters<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get publishDate => $composableBuilder(
    column: $table.publishDate,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
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

  i0.ColumnWithTypeConverterFilters<i3.Ownership, i3.Ownership, String>
  get ownership => $composableBuilder(
    column: $table.ownership,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<i3.ReadingStatus, i3.ReadingStatus, String>
  get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i0.ColumnFilters<DateTime> get readDate => $composableBuilder(
    column: $table.readDate,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<bool> get isFirstEdition => $composableBuilder(
    column: $table.isFirstEdition,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<bool> get isVariant => $composableBuilder(
    column: $table.isVariant,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get coverPrice => $composableBuilder(
    column: $table.coverPrice,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<int> get wishlistPriority => $composableBuilder(
    column: $table.wishlistPriority,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<double> get wishlistMaxPrice => $composableBuilder(
    column: $table.wishlistMaxPrice,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<bool> get isSigned => $composableBuilder(
    column: $table.isSigned,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get signedBy => $composableBuilder(
    column: $table.signedBy,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<DateTime> get signedOn => $composableBuilder(
    column: $table.signedOn,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get signedPlace => $composableBuilder(
    column: $table.signedPlace,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnFilters<String> get signingNote => $composableBuilder(
    column: $table.signingNote,
    builder: (column) => i0.ColumnFilters(column),
  );

  i0.ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get refusedCovers => $composableBuilder(
    column: $table.refusedCovers,
    builder: (column) => i0.ColumnWithTypeConverterFilters(column),
  );

  i8.$$SeriesTableTableFilterComposer get seriesId {
    final i8.$$SeriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: i9.ReadDatabaseContainer($db)
          .resultSet<i8.$SeriesTableTable>('series'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i8.$$SeriesTableTableFilterComposer(
            $db: $db,
            $table: i9.ReadDatabaseContainer($db)
                .resultSet<i8.$SeriesTableTable>('series'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableTableOrderingComposer
    extends i0.Composer<i0.GeneratedDatabase, i4.$ItemsTableTable> {
  $$ItemsTableTableOrderingComposer({
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

  i0.ColumnOrderings<String> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get volumeTitle => $composableBuilder(
    column: $table.volumeTitle,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get isbn13 => $composableBuilder(
    column: $table.isbn13,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get upc => $composableBuilder(
    column: $table.upc,
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

  i0.ColumnOrderings<String> get edition => $composableBuilder(
    column: $table.edition,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get publishDate => $composableBuilder(
    column: $table.publishDate,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
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

  i0.ColumnOrderings<String> get ownership => $composableBuilder(
    column: $table.ownership,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get readDate => $composableBuilder(
    column: $table.readDate,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<bool> get isFirstEdition => $composableBuilder(
    column: $table.isFirstEdition,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<bool> get isVariant => $composableBuilder(
    column: $table.isVariant,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get coverPrice => $composableBuilder(
    column: $table.coverPrice,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<int> get wishlistPriority => $composableBuilder(
    column: $table.wishlistPriority,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<double> get wishlistMaxPrice => $composableBuilder(
    column: $table.wishlistMaxPrice,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<bool> get isSigned => $composableBuilder(
    column: $table.isSigned,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get signedBy => $composableBuilder(
    column: $table.signedBy,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<DateTime> get signedOn => $composableBuilder(
    column: $table.signedOn,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get signedPlace => $composableBuilder(
    column: $table.signedPlace,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get signingNote => $composableBuilder(
    column: $table.signingNote,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i0.ColumnOrderings<String> get refusedCovers => $composableBuilder(
    column: $table.refusedCovers,
    builder: (column) => i0.ColumnOrderings(column),
  );

  i8.$$SeriesTableTableOrderingComposer get seriesId {
    final i8.$$SeriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: i9.ReadDatabaseContainer($db)
          .resultSet<i8.$SeriesTableTable>('series'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i8.$$SeriesTableTableOrderingComposer(
            $db: $db,
            $table: i9.ReadDatabaseContainer($db)
                .resultSet<i8.$SeriesTableTable>('series'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableTableAnnotationComposer
    extends i0.Composer<i0.GeneratedDatabase, i4.$ItemsTableTable> {
  $$ItemsTableTableAnnotationComposer({
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

  i0.GeneratedColumn<String> get volumeNumber => $composableBuilder(
    column: $table.volumeNumber,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get volumeTitle => $composableBuilder(
    column: $table.volumeTitle,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get isbn13 =>
      $composableBuilder(column: $table.isbn13, builder: (column) => column);

  i0.GeneratedColumn<String> get upc =>
      $composableBuilder(column: $table.upc, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<List<String>, String> get authors =>
      $composableBuilder(column: $table.authors, builder: (column) => column);

  i0.GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  i0.GeneratedColumn<String> get edition =>
      $composableBuilder(column: $table.edition, builder: (column) => column);

  i0.GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  i0.GeneratedColumn<String> get publishDate => $composableBuilder(
    column: $table.publishDate,
    builder: (column) => column,
  );

  i0.GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  i0.GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  i0.GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  i0.GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<i3.Ownership, String> get ownership =>
      $composableBuilder(column: $table.ownership, builder: (column) => column);

  i0.GeneratedColumnWithTypeConverter<i3.ReadingStatus, String>
  get readingStatus => $composableBuilder(
    column: $table.readingStatus,
    builder: (column) => column,
  );

  i0.GeneratedColumn<DateTime> get readDate =>
      $composableBuilder(column: $table.readDate, builder: (column) => column);

  i0.GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  i0.GeneratedColumn<bool> get isFirstEdition => $composableBuilder(
    column: $table.isFirstEdition,
    builder: (column) => column,
  );

  i0.GeneratedColumn<bool> get isVariant =>
      $composableBuilder(column: $table.isVariant, builder: (column) => column);

  i0.GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  i0.GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  i0.GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get coverPrice => $composableBuilder(
    column: $table.coverPrice,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get estimatedValue => $composableBuilder(
    column: $table.estimatedValue,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  i0.GeneratedColumn<int> get wishlistPriority => $composableBuilder(
    column: $table.wishlistPriority,
    builder: (column) => column,
  );

  i0.GeneratedColumn<double> get wishlistMaxPrice => $composableBuilder(
    column: $table.wishlistMaxPrice,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  i0.GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  i0.GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  i0.GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  i0.GeneratedColumn<bool> get isSigned =>
      $composableBuilder(column: $table.isSigned, builder: (column) => column);

  i0.GeneratedColumn<String> get signedBy =>
      $composableBuilder(column: $table.signedBy, builder: (column) => column);

  i0.GeneratedColumn<DateTime> get signedOn =>
      $composableBuilder(column: $table.signedOn, builder: (column) => column);

  i0.GeneratedColumn<String> get signedPlace => $composableBuilder(
    column: $table.signedPlace,
    builder: (column) => column,
  );

  i0.GeneratedColumn<String> get signingNote => $composableBuilder(
    column: $table.signingNote,
    builder: (column) => column,
  );

  i0.GeneratedColumnWithTypeConverter<List<String>, String> get refusedCovers =>
      $composableBuilder(
        column: $table.refusedCovers,
        builder: (column) => column,
      );

  i8.$$SeriesTableTableAnnotationComposer get seriesId {
    final i8.$$SeriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: i9.ReadDatabaseContainer($db)
          .resultSet<i8.$SeriesTableTable>('series'),
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => i8.$$SeriesTableTableAnnotationComposer(
            $db: $db,
            $table: i9.ReadDatabaseContainer($db)
                .resultSet<i8.$SeriesTableTable>('series'),
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableTableTableManager
    extends
        i0.RootTableManager<
          i0.GeneratedDatabase,
          i4.$ItemsTableTable,
          i1.Item,
          i4.$$ItemsTableTableFilterComposer,
          i4.$$ItemsTableTableOrderingComposer,
          i4.$$ItemsTableTableAnnotationComposer,
          $$ItemsTableTableCreateCompanionBuilder,
          $$ItemsTableTableUpdateCompanionBuilder,
          (i1.Item, i4.$$ItemsTableTableReferences),
          i1.Item,
          i0.PrefetchHooks Function({bool seriesId})
        > {
  $$ItemsTableTableTableManager(
    i0.GeneratedDatabase db,
    i4.$ItemsTableTable table,
  ) : super(
        i0.TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              i4.$$ItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              i4.$$ItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              i4.$$ItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                i0.Value<String> id = const i0.Value.absent(),
                i0.Value<String?> userId = const i0.Value.absent(),
                i0.Value<DateTime> createdAt = const i0.Value.absent(),
                i0.Value<DateTime> updatedAt = const i0.Value.absent(),
                i0.Value<DateTime?> deletedAt = const i0.Value.absent(),
                i0.Value<bool> syncPending = const i0.Value.absent(),
                i0.Value<String?> seriesId = const i0.Value.absent(),
                i0.Value<i2.CollectionType> type = const i0.Value.absent(),
                i0.Value<String> title = const i0.Value.absent(),
                i0.Value<String?> volumeNumber = const i0.Value.absent(),
                i0.Value<String?> volumeTitle = const i0.Value.absent(),
                i0.Value<String?> isbn13 = const i0.Value.absent(),
                i0.Value<String?> upc = const i0.Value.absent(),
                i0.Value<List<String>> authors = const i0.Value.absent(),
                i0.Value<String?> publisher = const i0.Value.absent(),
                i0.Value<String?> edition = const i0.Value.absent(),
                i0.Value<String?> format = const i0.Value.absent(),
                i0.Value<String?> publishDate = const i0.Value.absent(),
                i0.Value<int?> pageCount = const i0.Value.absent(),
                i0.Value<String?> language = const i0.Value.absent(),
                i0.Value<String?> coverUrl = const i0.Value.absent(),
                i0.Value<String?> description = const i0.Value.absent(),
                i0.Value<i3.Ownership> ownership = const i0.Value.absent(),
                i0.Value<i3.ReadingStatus> readingStatus =
                    const i0.Value.absent(),
                i0.Value<DateTime?> readDate = const i0.Value.absent(),
                i0.Value<int?> rating = const i0.Value.absent(),
                i0.Value<bool> isFirstEdition = const i0.Value.absent(),
                i0.Value<bool> isVariant = const i0.Value.absent(),
                i0.Value<String?> condition = const i0.Value.absent(),
                i0.Value<double?> purchasePrice = const i0.Value.absent(),
                i0.Value<DateTime?> purchaseDate = const i0.Value.absent(),
                i0.Value<double?> coverPrice = const i0.Value.absent(),
                i0.Value<double?> estimatedValue = const i0.Value.absent(),
                i0.Value<String> currency = const i0.Value.absent(),
                i0.Value<int?> wishlistPriority = const i0.Value.absent(),
                i0.Value<double?> wishlistMaxPrice = const i0.Value.absent(),
                i0.Value<String?> location = const i0.Value.absent(),
                i0.Value<String?> notes = const i0.Value.absent(),
                i0.Value<String?> source = const i0.Value.absent(),
                i0.Value<String?> sourceId = const i0.Value.absent(),
                i0.Value<bool> isSigned = const i0.Value.absent(),
                i0.Value<String?> signedBy = const i0.Value.absent(),
                i0.Value<DateTime?> signedOn = const i0.Value.absent(),
                i0.Value<String?> signedPlace = const i0.Value.absent(),
                i0.Value<String?> signingNote = const i0.Value.absent(),
                i0.Value<List<String>> refusedCovers = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i4.ItemsTableCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                seriesId: seriesId,
                type: type,
                title: title,
                volumeNumber: volumeNumber,
                volumeTitle: volumeTitle,
                isbn13: isbn13,
                upc: upc,
                authors: authors,
                publisher: publisher,
                edition: edition,
                format: format,
                publishDate: publishDate,
                pageCount: pageCount,
                language: language,
                coverUrl: coverUrl,
                description: description,
                ownership: ownership,
                readingStatus: readingStatus,
                readDate: readDate,
                rating: rating,
                isFirstEdition: isFirstEdition,
                isVariant: isVariant,
                condition: condition,
                purchasePrice: purchasePrice,
                purchaseDate: purchaseDate,
                coverPrice: coverPrice,
                estimatedValue: estimatedValue,
                currency: currency,
                wishlistPriority: wishlistPriority,
                wishlistMaxPrice: wishlistMaxPrice,
                location: location,
                notes: notes,
                source: source,
                sourceId: sourceId,
                isSigned: isSigned,
                signedBy: signedBy,
                signedOn: signedOn,
                signedPlace: signedPlace,
                signingNote: signingNote,
                refusedCovers: refusedCovers,
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
                i0.Value<String?> seriesId = const i0.Value.absent(),
                required i2.CollectionType type,
                required String title,
                i0.Value<String?> volumeNumber = const i0.Value.absent(),
                i0.Value<String?> volumeTitle = const i0.Value.absent(),
                i0.Value<String?> isbn13 = const i0.Value.absent(),
                i0.Value<String?> upc = const i0.Value.absent(),
                i0.Value<List<String>> authors = const i0.Value.absent(),
                i0.Value<String?> publisher = const i0.Value.absent(),
                i0.Value<String?> edition = const i0.Value.absent(),
                i0.Value<String?> format = const i0.Value.absent(),
                i0.Value<String?> publishDate = const i0.Value.absent(),
                i0.Value<int?> pageCount = const i0.Value.absent(),
                i0.Value<String?> language = const i0.Value.absent(),
                i0.Value<String?> coverUrl = const i0.Value.absent(),
                i0.Value<String?> description = const i0.Value.absent(),
                i0.Value<i3.Ownership> ownership = const i0.Value.absent(),
                i0.Value<i3.ReadingStatus> readingStatus =
                    const i0.Value.absent(),
                i0.Value<DateTime?> readDate = const i0.Value.absent(),
                i0.Value<int?> rating = const i0.Value.absent(),
                i0.Value<bool> isFirstEdition = const i0.Value.absent(),
                i0.Value<bool> isVariant = const i0.Value.absent(),
                i0.Value<String?> condition = const i0.Value.absent(),
                i0.Value<double?> purchasePrice = const i0.Value.absent(),
                i0.Value<DateTime?> purchaseDate = const i0.Value.absent(),
                i0.Value<double?> coverPrice = const i0.Value.absent(),
                i0.Value<double?> estimatedValue = const i0.Value.absent(),
                i0.Value<String> currency = const i0.Value.absent(),
                i0.Value<int?> wishlistPriority = const i0.Value.absent(),
                i0.Value<double?> wishlistMaxPrice = const i0.Value.absent(),
                i0.Value<String?> location = const i0.Value.absent(),
                i0.Value<String?> notes = const i0.Value.absent(),
                i0.Value<String?> source = const i0.Value.absent(),
                i0.Value<String?> sourceId = const i0.Value.absent(),
                i0.Value<bool> isSigned = const i0.Value.absent(),
                i0.Value<String?> signedBy = const i0.Value.absent(),
                i0.Value<DateTime?> signedOn = const i0.Value.absent(),
                i0.Value<String?> signedPlace = const i0.Value.absent(),
                i0.Value<String?> signingNote = const i0.Value.absent(),
                i0.Value<List<String>> refusedCovers = const i0.Value.absent(),
                i0.Value<int> rowid = const i0.Value.absent(),
              }) => i4.ItemsTableCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncPending: syncPending,
                seriesId: seriesId,
                type: type,
                title: title,
                volumeNumber: volumeNumber,
                volumeTitle: volumeTitle,
                isbn13: isbn13,
                upc: upc,
                authors: authors,
                publisher: publisher,
                edition: edition,
                format: format,
                publishDate: publishDate,
                pageCount: pageCount,
                language: language,
                coverUrl: coverUrl,
                description: description,
                ownership: ownership,
                readingStatus: readingStatus,
                readDate: readDate,
                rating: rating,
                isFirstEdition: isFirstEdition,
                isVariant: isVariant,
                condition: condition,
                purchasePrice: purchasePrice,
                purchaseDate: purchaseDate,
                coverPrice: coverPrice,
                estimatedValue: estimatedValue,
                currency: currency,
                wishlistPriority: wishlistPriority,
                wishlistMaxPrice: wishlistMaxPrice,
                location: location,
                notes: notes,
                source: source,
                sourceId: sourceId,
                isSigned: isSigned,
                signedBy: signedBy,
                signedOn: signedOn,
                signedPlace: signedPlace,
                signingNote: signingNote,
                refusedCovers: refusedCovers,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<i4.$ItemsTableTable, i1.Item>(table),
                  i4.$$ItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seriesId = false}) {
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
                    if (seriesId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.seriesId,
                        referencedTable: i4.$$ItemsTableTableReferences
                            ._seriesIdTable(db),
                        referencedColumn: i4.$$ItemsTableTableReferences
                            ._seriesIdTable(db)
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

typedef $$ItemsTableTableProcessedTableManager =
    i0.ProcessedTableManager<
      i0.GeneratedDatabase,
      i4.$ItemsTableTable,
      i1.Item,
      i4.$$ItemsTableTableFilterComposer,
      i4.$$ItemsTableTableOrderingComposer,
      i4.$$ItemsTableTableAnnotationComposer,
      $$ItemsTableTableCreateCompanionBuilder,
      $$ItemsTableTableUpdateCompanionBuilder,
      (i1.Item, i4.$$ItemsTableTableReferences),
      i1.Item,
      i0.PrefetchHooks Function({bool seriesId})
    >;
i0.Index get itemsIsbn13Idx => i0.Index(
  'items_isbn13_idx',
  'CREATE INDEX items_isbn13_idx ON items (isbn13)',
);

class $ItemsTableTable extends i5.ItemsTable
    with i0.TableInfo<$ItemsTableTable, i1.Item> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTableTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id)',
    ),
  );
  @override
  late final i0.GeneratedColumnWithTypeConverter<i2.CollectionType, String>
  type = i0.GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<i2.CollectionType>(i4.$ItemsTableTable.$convertertype);
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
  static const i0.VerificationMeta _volumeTitleMeta = const i0.VerificationMeta(
    'volumeTitle',
  );
  @override
  late final i0.GeneratedColumn<String> volumeTitle =
      i0.GeneratedColumn<String>(
        'volume_title',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
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
  static const i0.VerificationMeta _upcMeta = const i0.VerificationMeta('upc');
  @override
  late final i0.GeneratedColumn<String> upc = i0.GeneratedColumn<String>(
    'upc',
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
      ).withConverter<List<String>>(i4.$ItemsTableTable.$converterauthors);
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
  static const i0.VerificationMeta _editionMeta = const i0.VerificationMeta(
    'edition',
  );
  @override
  late final i0.GeneratedColumn<String> edition = i0.GeneratedColumn<String>(
    'edition',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _formatMeta = const i0.VerificationMeta(
    'format',
  );
  @override
  late final i0.GeneratedColumn<String> format = i0.GeneratedColumn<String>(
    'format',
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
  static const i0.VerificationMeta _pageCountMeta = const i0.VerificationMeta(
    'pageCount',
  );
  @override
  late final i0.GeneratedColumn<int> pageCount = i0.GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _languageMeta = const i0.VerificationMeta(
    'language',
  );
  @override
  late final i0.GeneratedColumn<String> language = i0.GeneratedColumn<String>(
    'language',
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
  late final i0.GeneratedColumnWithTypeConverter<i3.Ownership, String>
  ownership = i0.GeneratedColumn<String>(
    'ownership',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const i6.Constant('possede'),
  ).withConverter<i3.Ownership>(i4.$ItemsTableTable.$converterownership);
  @override
  late final i0.GeneratedColumnWithTypeConverter<i3.ReadingStatus, String>
  readingStatus =
      i0.GeneratedColumn<String>(
        'reading_status',
        aliasedName,
        false,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const i6.Constant('non_lu'),
      ).withConverter<i3.ReadingStatus>(
        i4.$ItemsTableTable.$converterreadingStatus,
      );
  static const i0.VerificationMeta _readDateMeta = const i0.VerificationMeta(
    'readDate',
  );
  @override
  late final i0.GeneratedColumn<DateTime> readDate =
      i0.GeneratedColumn<DateTime>(
        'read_date',
        aliasedName,
        true,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _ratingMeta = const i0.VerificationMeta(
    'rating',
  );
  @override
  late final i0.GeneratedColumn<int> rating = i0.GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _isFirstEditionMeta =
      const i0.VerificationMeta('isFirstEdition');
  @override
  late final i0.GeneratedColumn<bool> isFirstEdition = i0.GeneratedColumn<bool>(
    'is_first_edition',
    aliasedName,
    false,
    type: i0.DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'CHECK ("is_first_edition" IN (0, 1))',
    ),
    defaultValue: const i6.Constant(false),
  );
  static const i0.VerificationMeta _isVariantMeta = const i0.VerificationMeta(
    'isVariant',
  );
  @override
  late final i0.GeneratedColumn<bool> isVariant = i0.GeneratedColumn<bool>(
    'is_variant',
    aliasedName,
    false,
    type: i0.DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'CHECK ("is_variant" IN (0, 1))',
    ),
    defaultValue: const i6.Constant(false),
  );
  static const i0.VerificationMeta _conditionMeta = const i0.VerificationMeta(
    'condition',
  );
  @override
  late final i0.GeneratedColumn<String> condition = i0.GeneratedColumn<String>(
    'condition',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _purchasePriceMeta =
      const i0.VerificationMeta('purchasePrice');
  @override
  late final i0.GeneratedColumn<double> purchasePrice =
      i0.GeneratedColumn<double>(
        'purchase_price',
        aliasedName,
        true,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _purchaseDateMeta =
      const i0.VerificationMeta('purchaseDate');
  @override
  late final i0.GeneratedColumn<DateTime> purchaseDate =
      i0.GeneratedColumn<DateTime>(
        'purchase_date',
        aliasedName,
        true,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _coverPriceMeta = const i0.VerificationMeta(
    'coverPrice',
  );
  @override
  late final i0.GeneratedColumn<double> coverPrice = i0.GeneratedColumn<double>(
    'cover_price',
    aliasedName,
    true,
    type: i0.DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _estimatedValueMeta =
      const i0.VerificationMeta('estimatedValue');
  @override
  late final i0.GeneratedColumn<double> estimatedValue =
      i0.GeneratedColumn<double>(
        'estimated_value',
        aliasedName,
        true,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _currencyMeta = const i0.VerificationMeta(
    'currency',
  );
  @override
  late final i0.GeneratedColumn<String> currency = i0.GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const i6.Constant('EUR'),
  );
  static const i0.VerificationMeta _wishlistPriorityMeta =
      const i0.VerificationMeta('wishlistPriority');
  @override
  late final i0.GeneratedColumn<int> wishlistPriority = i0.GeneratedColumn<int>(
    'wishlist_priority',
    aliasedName,
    true,
    type: i0.DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _wishlistMaxPriceMeta =
      const i0.VerificationMeta('wishlistMaxPrice');
  @override
  late final i0.GeneratedColumn<double> wishlistMaxPrice =
      i0.GeneratedColumn<double>(
        'wishlist_max_price',
        aliasedName,
        true,
        type: i0.DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _locationMeta = const i0.VerificationMeta(
    'location',
  );
  @override
  late final i0.GeneratedColumn<String> location = i0.GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
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
  static const i0.VerificationMeta _sourceMeta = const i0.VerificationMeta(
    'source',
  );
  @override
  late final i0.GeneratedColumn<String> source = i0.GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _sourceIdMeta = const i0.VerificationMeta(
    'sourceId',
  );
  @override
  late final i0.GeneratedColumn<String> sourceId = i0.GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _isSignedMeta = const i0.VerificationMeta(
    'isSigned',
  );
  @override
  late final i0.GeneratedColumn<bool> isSigned = i0.GeneratedColumn<bool>(
    'is_signed',
    aliasedName,
    false,
    type: i0.DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
      'CHECK ("is_signed" IN (0, 1))',
    ),
    defaultValue: const i6.Constant(false),
  );
  static const i0.VerificationMeta _signedByMeta = const i0.VerificationMeta(
    'signedBy',
  );
  @override
  late final i0.GeneratedColumn<String> signedBy = i0.GeneratedColumn<String>(
    'signed_by',
    aliasedName,
    true,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const i0.VerificationMeta _signedOnMeta = const i0.VerificationMeta(
    'signedOn',
  );
  @override
  late final i0.GeneratedColumn<DateTime> signedOn =
      i0.GeneratedColumn<DateTime>(
        'signed_on',
        aliasedName,
        true,
        type: i0.DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _signedPlaceMeta = const i0.VerificationMeta(
    'signedPlace',
  );
  @override
  late final i0.GeneratedColumn<String> signedPlace =
      i0.GeneratedColumn<String>(
        'signed_place',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const i0.VerificationMeta _signingNoteMeta = const i0.VerificationMeta(
    'signingNote',
  );
  @override
  late final i0.GeneratedColumn<String> signingNote =
      i0.GeneratedColumn<String>(
        'signing_note',
        aliasedName,
        true,
        type: i0.DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final i0.GeneratedColumnWithTypeConverter<List<String>, String>
  refusedCovers = i0.GeneratedColumn<String>(
    'refused_covers',
    aliasedName,
    false,
    type: i0.DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const i6.Constant('[]'),
  ).withConverter<List<String>>(i4.$ItemsTableTable.$converterrefusedCovers);
  @override
  List<i0.GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    syncPending,
    seriesId,
    type,
    title,
    volumeNumber,
    volumeTitle,
    isbn13,
    upc,
    authors,
    publisher,
    edition,
    format,
    publishDate,
    pageCount,
    language,
    coverUrl,
    description,
    ownership,
    readingStatus,
    readDate,
    rating,
    isFirstEdition,
    isVariant,
    condition,
    purchasePrice,
    purchaseDate,
    coverPrice,
    estimatedValue,
    currency,
    wishlistPriority,
    wishlistMaxPrice,
    location,
    notes,
    source,
    sourceId,
    isSigned,
    signedBy,
    signedOn,
    signedPlace,
    signingNote,
    refusedCovers,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  i0.VerificationContext validateIntegrity(
    i0.Insertable<i1.Item> instance, {
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
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
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
    if (data.containsKey('volume_number')) {
      context.handle(
        _volumeNumberMeta,
        volumeNumber.isAcceptableOrUnknown(
          data['volume_number']!,
          _volumeNumberMeta,
        ),
      );
    }
    if (data.containsKey('volume_title')) {
      context.handle(
        _volumeTitleMeta,
        volumeTitle.isAcceptableOrUnknown(
          data['volume_title']!,
          _volumeTitleMeta,
        ),
      );
    }
    if (data.containsKey('isbn13')) {
      context.handle(
        _isbn13Meta,
        isbn13.isAcceptableOrUnknown(data['isbn13']!, _isbn13Meta),
      );
    }
    if (data.containsKey('upc')) {
      context.handle(
        _upcMeta,
        upc.isAcceptableOrUnknown(data['upc']!, _upcMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('edition')) {
      context.handle(
        _editionMeta,
        edition.isAcceptableOrUnknown(data['edition']!, _editionMeta),
      );
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
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
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
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
    if (data.containsKey('read_date')) {
      context.handle(
        _readDateMeta,
        readDate.isAcceptableOrUnknown(data['read_date']!, _readDateMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_first_edition')) {
      context.handle(
        _isFirstEditionMeta,
        isFirstEdition.isAcceptableOrUnknown(
          data['is_first_edition']!,
          _isFirstEditionMeta,
        ),
      );
    }
    if (data.containsKey('is_variant')) {
      context.handle(
        _isVariantMeta,
        isVariant.isAcceptableOrUnknown(data['is_variant']!, _isVariantMeta),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('cover_price')) {
      context.handle(
        _coverPriceMeta,
        coverPrice.isAcceptableOrUnknown(data['cover_price']!, _coverPriceMeta),
      );
    }
    if (data.containsKey('estimated_value')) {
      context.handle(
        _estimatedValueMeta,
        estimatedValue.isAcceptableOrUnknown(
          data['estimated_value']!,
          _estimatedValueMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('wishlist_priority')) {
      context.handle(
        _wishlistPriorityMeta,
        wishlistPriority.isAcceptableOrUnknown(
          data['wishlist_priority']!,
          _wishlistPriorityMeta,
        ),
      );
    }
    if (data.containsKey('wishlist_max_price')) {
      context.handle(
        _wishlistMaxPriceMeta,
        wishlistMaxPrice.isAcceptableOrUnknown(
          data['wishlist_max_price']!,
          _wishlistMaxPriceMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('is_signed')) {
      context.handle(
        _isSignedMeta,
        isSigned.isAcceptableOrUnknown(data['is_signed']!, _isSignedMeta),
      );
    }
    if (data.containsKey('signed_by')) {
      context.handle(
        _signedByMeta,
        signedBy.isAcceptableOrUnknown(data['signed_by']!, _signedByMeta),
      );
    }
    if (data.containsKey('signed_on')) {
      context.handle(
        _signedOnMeta,
        signedOn.isAcceptableOrUnknown(data['signed_on']!, _signedOnMeta),
      );
    }
    if (data.containsKey('signed_place')) {
      context.handle(
        _signedPlaceMeta,
        signedPlace.isAcceptableOrUnknown(
          data['signed_place']!,
          _signedPlaceMeta,
        ),
      );
    }
    if (data.containsKey('signing_note')) {
      context.handle(
        _signingNoteMeta,
        signingNote.isAcceptableOrUnknown(
          data['signing_note']!,
          _signingNoteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.Item(
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
      type: i4.$ItemsTableTable.$convertertype.fromSql(
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
      seriesId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}series_id'],
      ),
      volumeNumber: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}volume_number'],
      ),
      volumeTitle: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}volume_title'],
      ),
      isbn13: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}isbn13'],
      ),
      upc: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}upc'],
      ),
      authors: i4.$ItemsTableTable.$converterauthors.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}authors'],
        )!,
      ),
      publisher: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      edition: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}edition'],
      ),
      format: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}format'],
      ),
      publishDate: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}publish_date'],
      ),
      pageCount: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      language: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      description: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      ownership: i4.$ItemsTableTable.$converterownership.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}ownership'],
        )!,
      ),
      readingStatus: i4.$ItemsTableTable.$converterreadingStatus.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}reading_status'],
        )!,
      ),
      readDate: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}read_date'],
      ),
      rating: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      isFirstEdition: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.bool,
        data['${effectivePrefix}is_first_edition'],
      )!,
      isVariant: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.bool,
        data['${effectivePrefix}is_variant'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}condition'],
      ),
      purchasePrice: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      coverPrice: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}cover_price'],
      ),
      estimatedValue: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}estimated_value'],
      ),
      currency: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      wishlistPriority: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.int,
        data['${effectivePrefix}wishlist_priority'],
      ),
      wishlistMaxPrice: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.double,
        data['${effectivePrefix}wishlist_max_price'],
      ),
      location: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      notes: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      source: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      isSigned: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.bool,
        data['${effectivePrefix}is_signed'],
      )!,
      signedBy: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}signed_by'],
      ),
      signedOn: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.dateTime,
        data['${effectivePrefix}signed_on'],
      ),
      signedPlace: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}signed_place'],
      ),
      signingNote: attachedDatabase.typeMapping.read(
        i0.DriftSqlType.string,
        data['${effectivePrefix}signing_note'],
      ),
      refusedCovers: i4.$ItemsTableTable.$converterrefusedCovers.fromSql(
        attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}refused_covers'],
        )!,
      ),
    );
  }

  @override
  $ItemsTableTable createAlias(String alias) {
    return $ItemsTableTable(attachedDatabase, alias);
  }

  static i0.TypeConverter<i2.CollectionType, String> $convertertype =
      const i7.DbEnumConverter(i2.CollectionType.values);
  static i0.TypeConverter<List<String>, String> $converterauthors =
      const i7.StringListConverter();
  static i0.TypeConverter<i3.Ownership, String> $converterownership =
      const i7.DbEnumConverter(i3.Ownership.values);
  static i0.TypeConverter<i3.ReadingStatus, String> $converterreadingStatus =
      const i7.DbEnumConverter(i3.ReadingStatus.values);
  static i0.TypeConverter<List<String>, String> $converterrefusedCovers =
      const i7.StringListConverter();
}

class ItemsTableCompanion extends i0.UpdateCompanion<i1.Item> {
  final i0.Value<String> id;
  final i0.Value<String?> userId;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime> updatedAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<bool> syncPending;
  final i0.Value<String?> seriesId;
  final i0.Value<i2.CollectionType> type;
  final i0.Value<String> title;
  final i0.Value<String?> volumeNumber;
  final i0.Value<String?> volumeTitle;
  final i0.Value<String?> isbn13;
  final i0.Value<String?> upc;
  final i0.Value<List<String>> authors;
  final i0.Value<String?> publisher;
  final i0.Value<String?> edition;
  final i0.Value<String?> format;
  final i0.Value<String?> publishDate;
  final i0.Value<int?> pageCount;
  final i0.Value<String?> language;
  final i0.Value<String?> coverUrl;
  final i0.Value<String?> description;
  final i0.Value<i3.Ownership> ownership;
  final i0.Value<i3.ReadingStatus> readingStatus;
  final i0.Value<DateTime?> readDate;
  final i0.Value<int?> rating;
  final i0.Value<bool> isFirstEdition;
  final i0.Value<bool> isVariant;
  final i0.Value<String?> condition;
  final i0.Value<double?> purchasePrice;
  final i0.Value<DateTime?> purchaseDate;
  final i0.Value<double?> coverPrice;
  final i0.Value<double?> estimatedValue;
  final i0.Value<String> currency;
  final i0.Value<int?> wishlistPriority;
  final i0.Value<double?> wishlistMaxPrice;
  final i0.Value<String?> location;
  final i0.Value<String?> notes;
  final i0.Value<String?> source;
  final i0.Value<String?> sourceId;
  final i0.Value<bool> isSigned;
  final i0.Value<String?> signedBy;
  final i0.Value<DateTime?> signedOn;
  final i0.Value<String?> signedPlace;
  final i0.Value<String?> signingNote;
  final i0.Value<List<String>> refusedCovers;
  final i0.Value<int> rowid;
  const ItemsTableCompanion({
    this.id = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.updatedAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.seriesId = const i0.Value.absent(),
    this.type = const i0.Value.absent(),
    this.title = const i0.Value.absent(),
    this.volumeNumber = const i0.Value.absent(),
    this.volumeTitle = const i0.Value.absent(),
    this.isbn13 = const i0.Value.absent(),
    this.upc = const i0.Value.absent(),
    this.authors = const i0.Value.absent(),
    this.publisher = const i0.Value.absent(),
    this.edition = const i0.Value.absent(),
    this.format = const i0.Value.absent(),
    this.publishDate = const i0.Value.absent(),
    this.pageCount = const i0.Value.absent(),
    this.language = const i0.Value.absent(),
    this.coverUrl = const i0.Value.absent(),
    this.description = const i0.Value.absent(),
    this.ownership = const i0.Value.absent(),
    this.readingStatus = const i0.Value.absent(),
    this.readDate = const i0.Value.absent(),
    this.rating = const i0.Value.absent(),
    this.isFirstEdition = const i0.Value.absent(),
    this.isVariant = const i0.Value.absent(),
    this.condition = const i0.Value.absent(),
    this.purchasePrice = const i0.Value.absent(),
    this.purchaseDate = const i0.Value.absent(),
    this.coverPrice = const i0.Value.absent(),
    this.estimatedValue = const i0.Value.absent(),
    this.currency = const i0.Value.absent(),
    this.wishlistPriority = const i0.Value.absent(),
    this.wishlistMaxPrice = const i0.Value.absent(),
    this.location = const i0.Value.absent(),
    this.notes = const i0.Value.absent(),
    this.source = const i0.Value.absent(),
    this.sourceId = const i0.Value.absent(),
    this.isSigned = const i0.Value.absent(),
    this.signedBy = const i0.Value.absent(),
    this.signedOn = const i0.Value.absent(),
    this.signedPlace = const i0.Value.absent(),
    this.signingNote = const i0.Value.absent(),
    this.refusedCovers = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ItemsTableCompanion.insert({
    required String id,
    this.userId = const i0.Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const i0.Value.absent(),
    this.syncPending = const i0.Value.absent(),
    this.seriesId = const i0.Value.absent(),
    required i2.CollectionType type,
    required String title,
    this.volumeNumber = const i0.Value.absent(),
    this.volumeTitle = const i0.Value.absent(),
    this.isbn13 = const i0.Value.absent(),
    this.upc = const i0.Value.absent(),
    this.authors = const i0.Value.absent(),
    this.publisher = const i0.Value.absent(),
    this.edition = const i0.Value.absent(),
    this.format = const i0.Value.absent(),
    this.publishDate = const i0.Value.absent(),
    this.pageCount = const i0.Value.absent(),
    this.language = const i0.Value.absent(),
    this.coverUrl = const i0.Value.absent(),
    this.description = const i0.Value.absent(),
    this.ownership = const i0.Value.absent(),
    this.readingStatus = const i0.Value.absent(),
    this.readDate = const i0.Value.absent(),
    this.rating = const i0.Value.absent(),
    this.isFirstEdition = const i0.Value.absent(),
    this.isVariant = const i0.Value.absent(),
    this.condition = const i0.Value.absent(),
    this.purchasePrice = const i0.Value.absent(),
    this.purchaseDate = const i0.Value.absent(),
    this.coverPrice = const i0.Value.absent(),
    this.estimatedValue = const i0.Value.absent(),
    this.currency = const i0.Value.absent(),
    this.wishlistPriority = const i0.Value.absent(),
    this.wishlistMaxPrice = const i0.Value.absent(),
    this.location = const i0.Value.absent(),
    this.notes = const i0.Value.absent(),
    this.source = const i0.Value.absent(),
    this.sourceId = const i0.Value.absent(),
    this.isSigned = const i0.Value.absent(),
    this.signedBy = const i0.Value.absent(),
    this.signedOn = const i0.Value.absent(),
    this.signedPlace = const i0.Value.absent(),
    this.signingNote = const i0.Value.absent(),
    this.refusedCovers = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  }) : id = i0.Value(id),
       createdAt = i0.Value(createdAt),
       updatedAt = i0.Value(updatedAt),
       type = i0.Value(type),
       title = i0.Value(title);
  static i0.Insertable<i1.Item> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? updatedAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<bool>? syncPending,
    i0.Expression<String>? seriesId,
    i0.Expression<String>? type,
    i0.Expression<String>? title,
    i0.Expression<String>? volumeNumber,
    i0.Expression<String>? volumeTitle,
    i0.Expression<String>? isbn13,
    i0.Expression<String>? upc,
    i0.Expression<String>? authors,
    i0.Expression<String>? publisher,
    i0.Expression<String>? edition,
    i0.Expression<String>? format,
    i0.Expression<String>? publishDate,
    i0.Expression<int>? pageCount,
    i0.Expression<String>? language,
    i0.Expression<String>? coverUrl,
    i0.Expression<String>? description,
    i0.Expression<String>? ownership,
    i0.Expression<String>? readingStatus,
    i0.Expression<DateTime>? readDate,
    i0.Expression<int>? rating,
    i0.Expression<bool>? isFirstEdition,
    i0.Expression<bool>? isVariant,
    i0.Expression<String>? condition,
    i0.Expression<double>? purchasePrice,
    i0.Expression<DateTime>? purchaseDate,
    i0.Expression<double>? coverPrice,
    i0.Expression<double>? estimatedValue,
    i0.Expression<String>? currency,
    i0.Expression<int>? wishlistPriority,
    i0.Expression<double>? wishlistMaxPrice,
    i0.Expression<String>? location,
    i0.Expression<String>? notes,
    i0.Expression<String>? source,
    i0.Expression<String>? sourceId,
    i0.Expression<bool>? isSigned,
    i0.Expression<String>? signedBy,
    i0.Expression<DateTime>? signedOn,
    i0.Expression<String>? signedPlace,
    i0.Expression<String>? signingNote,
    i0.Expression<String>? refusedCovers,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncPending != null) 'sync_pending': syncPending,
      if (seriesId != null) 'series_id': seriesId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (volumeNumber != null) 'volume_number': volumeNumber,
      if (volumeTitle != null) 'volume_title': volumeTitle,
      if (isbn13 != null) 'isbn13': isbn13,
      if (upc != null) 'upc': upc,
      if (authors != null) 'authors': authors,
      if (publisher != null) 'publisher': publisher,
      if (edition != null) 'edition': edition,
      if (format != null) 'format': format,
      if (publishDate != null) 'publish_date': publishDate,
      if (pageCount != null) 'page_count': pageCount,
      if (language != null) 'language': language,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (description != null) 'description': description,
      if (ownership != null) 'ownership': ownership,
      if (readingStatus != null) 'reading_status': readingStatus,
      if (readDate != null) 'read_date': readDate,
      if (rating != null) 'rating': rating,
      if (isFirstEdition != null) 'is_first_edition': isFirstEdition,
      if (isVariant != null) 'is_variant': isVariant,
      if (condition != null) 'condition': condition,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (coverPrice != null) 'cover_price': coverPrice,
      if (estimatedValue != null) 'estimated_value': estimatedValue,
      if (currency != null) 'currency': currency,
      if (wishlistPriority != null) 'wishlist_priority': wishlistPriority,
      if (wishlistMaxPrice != null) 'wishlist_max_price': wishlistMaxPrice,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      if (source != null) 'source': source,
      if (sourceId != null) 'source_id': sourceId,
      if (isSigned != null) 'is_signed': isSigned,
      if (signedBy != null) 'signed_by': signedBy,
      if (signedOn != null) 'signed_on': signedOn,
      if (signedPlace != null) 'signed_place': signedPlace,
      if (signingNote != null) 'signing_note': signingNote,
      if (refusedCovers != null) 'refused_covers': refusedCovers,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i4.ItemsTableCompanion copyWith({
    i0.Value<String>? id,
    i0.Value<String?>? userId,
    i0.Value<DateTime>? createdAt,
    i0.Value<DateTime>? updatedAt,
    i0.Value<DateTime?>? deletedAt,
    i0.Value<bool>? syncPending,
    i0.Value<String?>? seriesId,
    i0.Value<i2.CollectionType>? type,
    i0.Value<String>? title,
    i0.Value<String?>? volumeNumber,
    i0.Value<String?>? volumeTitle,
    i0.Value<String?>? isbn13,
    i0.Value<String?>? upc,
    i0.Value<List<String>>? authors,
    i0.Value<String?>? publisher,
    i0.Value<String?>? edition,
    i0.Value<String?>? format,
    i0.Value<String?>? publishDate,
    i0.Value<int?>? pageCount,
    i0.Value<String?>? language,
    i0.Value<String?>? coverUrl,
    i0.Value<String?>? description,
    i0.Value<i3.Ownership>? ownership,
    i0.Value<i3.ReadingStatus>? readingStatus,
    i0.Value<DateTime?>? readDate,
    i0.Value<int?>? rating,
    i0.Value<bool>? isFirstEdition,
    i0.Value<bool>? isVariant,
    i0.Value<String?>? condition,
    i0.Value<double?>? purchasePrice,
    i0.Value<DateTime?>? purchaseDate,
    i0.Value<double?>? coverPrice,
    i0.Value<double?>? estimatedValue,
    i0.Value<String>? currency,
    i0.Value<int?>? wishlistPriority,
    i0.Value<double?>? wishlistMaxPrice,
    i0.Value<String?>? location,
    i0.Value<String?>? notes,
    i0.Value<String?>? source,
    i0.Value<String?>? sourceId,
    i0.Value<bool>? isSigned,
    i0.Value<String?>? signedBy,
    i0.Value<DateTime?>? signedOn,
    i0.Value<String?>? signedPlace,
    i0.Value<String?>? signingNote,
    i0.Value<List<String>>? refusedCovers,
    i0.Value<int>? rowid,
  }) {
    return i4.ItemsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncPending: syncPending ?? this.syncPending,
      seriesId: seriesId ?? this.seriesId,
      type: type ?? this.type,
      title: title ?? this.title,
      volumeNumber: volumeNumber ?? this.volumeNumber,
      volumeTitle: volumeTitle ?? this.volumeTitle,
      isbn13: isbn13 ?? this.isbn13,
      upc: upc ?? this.upc,
      authors: authors ?? this.authors,
      publisher: publisher ?? this.publisher,
      edition: edition ?? this.edition,
      format: format ?? this.format,
      publishDate: publishDate ?? this.publishDate,
      pageCount: pageCount ?? this.pageCount,
      language: language ?? this.language,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      ownership: ownership ?? this.ownership,
      readingStatus: readingStatus ?? this.readingStatus,
      readDate: readDate ?? this.readDate,
      rating: rating ?? this.rating,
      isFirstEdition: isFirstEdition ?? this.isFirstEdition,
      isVariant: isVariant ?? this.isVariant,
      condition: condition ?? this.condition,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      coverPrice: coverPrice ?? this.coverPrice,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      currency: currency ?? this.currency,
      wishlistPriority: wishlistPriority ?? this.wishlistPriority,
      wishlistMaxPrice: wishlistMaxPrice ?? this.wishlistMaxPrice,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      isSigned: isSigned ?? this.isSigned,
      signedBy: signedBy ?? this.signedBy,
      signedOn: signedOn ?? this.signedOn,
      signedPlace: signedPlace ?? this.signedPlace,
      signingNote: signingNote ?? this.signingNote,
      refusedCovers: refusedCovers ?? this.refusedCovers,
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
    if (seriesId.present) {
      map['series_id'] = i0.Variable<String>(seriesId.value);
    }
    if (type.present) {
      map['type'] = i0.Variable<String>(
        i4.$ItemsTableTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = i0.Variable<String>(title.value);
    }
    if (volumeNumber.present) {
      map['volume_number'] = i0.Variable<String>(volumeNumber.value);
    }
    if (volumeTitle.present) {
      map['volume_title'] = i0.Variable<String>(volumeTitle.value);
    }
    if (isbn13.present) {
      map['isbn13'] = i0.Variable<String>(isbn13.value);
    }
    if (upc.present) {
      map['upc'] = i0.Variable<String>(upc.value);
    }
    if (authors.present) {
      map['authors'] = i0.Variable<String>(
        i4.$ItemsTableTable.$converterauthors.toSql(authors.value),
      );
    }
    if (publisher.present) {
      map['publisher'] = i0.Variable<String>(publisher.value);
    }
    if (edition.present) {
      map['edition'] = i0.Variable<String>(edition.value);
    }
    if (format.present) {
      map['format'] = i0.Variable<String>(format.value);
    }
    if (publishDate.present) {
      map['publish_date'] = i0.Variable<String>(publishDate.value);
    }
    if (pageCount.present) {
      map['page_count'] = i0.Variable<int>(pageCount.value);
    }
    if (language.present) {
      map['language'] = i0.Variable<String>(language.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = i0.Variable<String>(coverUrl.value);
    }
    if (description.present) {
      map['description'] = i0.Variable<String>(description.value);
    }
    if (ownership.present) {
      map['ownership'] = i0.Variable<String>(
        i4.$ItemsTableTable.$converterownership.toSql(ownership.value),
      );
    }
    if (readingStatus.present) {
      map['reading_status'] = i0.Variable<String>(
        i4.$ItemsTableTable.$converterreadingStatus.toSql(readingStatus.value),
      );
    }
    if (readDate.present) {
      map['read_date'] = i0.Variable<DateTime>(readDate.value);
    }
    if (rating.present) {
      map['rating'] = i0.Variable<int>(rating.value);
    }
    if (isFirstEdition.present) {
      map['is_first_edition'] = i0.Variable<bool>(isFirstEdition.value);
    }
    if (isVariant.present) {
      map['is_variant'] = i0.Variable<bool>(isVariant.value);
    }
    if (condition.present) {
      map['condition'] = i0.Variable<String>(condition.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = i0.Variable<double>(purchasePrice.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = i0.Variable<DateTime>(purchaseDate.value);
    }
    if (coverPrice.present) {
      map['cover_price'] = i0.Variable<double>(coverPrice.value);
    }
    if (estimatedValue.present) {
      map['estimated_value'] = i0.Variable<double>(estimatedValue.value);
    }
    if (currency.present) {
      map['currency'] = i0.Variable<String>(currency.value);
    }
    if (wishlistPriority.present) {
      map['wishlist_priority'] = i0.Variable<int>(wishlistPriority.value);
    }
    if (wishlistMaxPrice.present) {
      map['wishlist_max_price'] = i0.Variable<double>(wishlistMaxPrice.value);
    }
    if (location.present) {
      map['location'] = i0.Variable<String>(location.value);
    }
    if (notes.present) {
      map['notes'] = i0.Variable<String>(notes.value);
    }
    if (source.present) {
      map['source'] = i0.Variable<String>(source.value);
    }
    if (sourceId.present) {
      map['source_id'] = i0.Variable<String>(sourceId.value);
    }
    if (isSigned.present) {
      map['is_signed'] = i0.Variable<bool>(isSigned.value);
    }
    if (signedBy.present) {
      map['signed_by'] = i0.Variable<String>(signedBy.value);
    }
    if (signedOn.present) {
      map['signed_on'] = i0.Variable<DateTime>(signedOn.value);
    }
    if (signedPlace.present) {
      map['signed_place'] = i0.Variable<String>(signedPlace.value);
    }
    if (signingNote.present) {
      map['signing_note'] = i0.Variable<String>(signingNote.value);
    }
    if (refusedCovers.present) {
      map['refused_covers'] = i0.Variable<String>(
        i4.$ItemsTableTable.$converterrefusedCovers.toSql(refusedCovers.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncPending: $syncPending, ')
          ..write('seriesId: $seriesId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('volumeNumber: $volumeNumber, ')
          ..write('volumeTitle: $volumeTitle, ')
          ..write('isbn13: $isbn13, ')
          ..write('upc: $upc, ')
          ..write('authors: $authors, ')
          ..write('publisher: $publisher, ')
          ..write('edition: $edition, ')
          ..write('format: $format, ')
          ..write('publishDate: $publishDate, ')
          ..write('pageCount: $pageCount, ')
          ..write('language: $language, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('description: $description, ')
          ..write('ownership: $ownership, ')
          ..write('readingStatus: $readingStatus, ')
          ..write('readDate: $readDate, ')
          ..write('rating: $rating, ')
          ..write('isFirstEdition: $isFirstEdition, ')
          ..write('isVariant: $isVariant, ')
          ..write('condition: $condition, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('coverPrice: $coverPrice, ')
          ..write('estimatedValue: $estimatedValue, ')
          ..write('currency: $currency, ')
          ..write('wishlistPriority: $wishlistPriority, ')
          ..write('wishlistMaxPrice: $wishlistMaxPrice, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('source: $source, ')
          ..write('sourceId: $sourceId, ')
          ..write('isSigned: $isSigned, ')
          ..write('signedBy: $signedBy, ')
          ..write('signedOn: $signedOn, ')
          ..write('signedPlace: $signedPlace, ')
          ..write('signingNote: $signingNote, ')
          ..write('refusedCovers: $refusedCovers, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ItemInsertable implements i0.Insertable<i1.Item> {
  i1.Item _object;
  _$ItemInsertable(this._object);
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    return i4.ItemsTableCompanion(
      id: i0.Value(_object.id),
      userId: i0.Value(_object.userId),
      createdAt: i0.Value(_object.createdAt),
      updatedAt: i0.Value(_object.updatedAt),
      deletedAt: i0.Value(_object.deletedAt),
      syncPending: i0.Value(_object.syncPending),
      seriesId: i0.Value(_object.seriesId),
      type: i0.Value(_object.type),
      title: i0.Value(_object.title),
      volumeNumber: i0.Value(_object.volumeNumber),
      volumeTitle: i0.Value(_object.volumeTitle),
      isbn13: i0.Value(_object.isbn13),
      upc: i0.Value(_object.upc),
      authors: i0.Value(_object.authors),
      publisher: i0.Value(_object.publisher),
      edition: i0.Value(_object.edition),
      format: i0.Value(_object.format),
      publishDate: i0.Value(_object.publishDate),
      pageCount: i0.Value(_object.pageCount),
      language: i0.Value(_object.language),
      coverUrl: i0.Value(_object.coverUrl),
      description: i0.Value(_object.description),
      ownership: i0.Value(_object.ownership),
      readingStatus: i0.Value(_object.readingStatus),
      readDate: i0.Value(_object.readDate),
      rating: i0.Value(_object.rating),
      isFirstEdition: i0.Value(_object.isFirstEdition),
      isVariant: i0.Value(_object.isVariant),
      condition: i0.Value(_object.condition),
      purchasePrice: i0.Value(_object.purchasePrice),
      purchaseDate: i0.Value(_object.purchaseDate),
      coverPrice: i0.Value(_object.coverPrice),
      estimatedValue: i0.Value(_object.estimatedValue),
      currency: i0.Value(_object.currency),
      wishlistPriority: i0.Value(_object.wishlistPriority),
      wishlistMaxPrice: i0.Value(_object.wishlistMaxPrice),
      location: i0.Value(_object.location),
      notes: i0.Value(_object.notes),
      source: i0.Value(_object.source),
      sourceId: i0.Value(_object.sourceId),
      isSigned: i0.Value(_object.isSigned),
      signedBy: i0.Value(_object.signedBy),
      signedOn: i0.Value(_object.signedOn),
      signedPlace: i0.Value(_object.signedPlace),
      signingNote: i0.Value(_object.signingNote),
      refusedCovers: i0.Value(_object.refusedCovers),
    ).toColumns(false);
  }
}

extension ItemToInsertable on i1.Item {
  _$ItemInsertable toInsertable() {
    return _$ItemInsertable(this);
  }
}

i0.Index get itemsSeriesIdIdx => i0.Index(
  'items_series_id_idx',
  'CREATE INDEX items_series_id_idx ON items (series_id)',
);
