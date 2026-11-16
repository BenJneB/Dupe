import 'package:drift/drift.dart';
import 'package:dupe/core/database/app_database.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/utils/isbn.dart';
import 'package:dupe/core/utils/text_fold.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_repository.g.dart';

@Riverpod(keepAlive: true)
SearchRepository searchRepository(Ref ref) =>
    SearchRepository(ref.watch(appDatabaseProvider));

typedef LocalSearchResults = ({List<Series> series, List<Item> items});

/// Accent- and case-insensitive search over the local collection.
class SearchRepository {
  new(this._db);

  final AppDatabase _db;

  static const _limit = 50;

  Future<LocalSearchResults> search(String rawQuery) async {
    final query = foldForSearch(rawQuery.trim());
    if (query.isEmpty) return (series: <Series>[], items: <Item>[]);
    final needle = Variable<String>(query);
    Expression<bool> contains(Expression<String> column) =>
        FunctionCallExpression<int>('instr', [
          fold(column),
          needle,
        ]).isBiggerThanValue(0);

    final s = _db.seriesTable;
    final series =
        await (_db.select(s)
              ..where(
                (t) =>
                    t.deletedAt.isNull() &
                    (contains(t.title) |
                        contains(t.originalTitle) |
                        contains(t.authors.dartCast<String>()) |
                        contains(t.publisher)),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.title)])
              ..limit(_limit))
            .get();

    // ISBN typed with dashes/spaces: compare digits only; a full ISBN-10
    // (back covers of older books) as the ISBN-13 that is stored.
    final typed = rawQuery.replaceAll(RegExp(r'[\s-]'), '');
    final digits = typed.length == 10 ? Isbn.toIsbn13(typed) ?? typed : typed;
    final isIsbnLike = RegExp(r'^\d{4,13}$').hasMatch(digits);
    final i = _db.itemsTable;
    final items =
        await (_db.select(i)
              ..where(
                (t) =>
                    t.deletedAt.isNull() &
                    (contains(t.title) |
                        contains(t.authors.dartCast<String>()) |
                        (isIsbnLike
                            ? t.isbn13.contains(digits)
                            : const Constant(false))),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.title)])
              ..limit(_limit))
            .get();
    return (series: series, items: items);
  }
}
