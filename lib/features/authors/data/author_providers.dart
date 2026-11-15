import 'package:drift/drift.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/providers/entries_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'author_providers.g.dart';

/// Authors of the volumes of each series of [type] (series created by a
/// scan or an import may list none themselves).
@riverpod
Stream<Map<String, Set<String>>> seriesItemAuthors(
  Ref ref,
  CollectionType type,
) {
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.itemsTable)
    ..where(
      (t) =>
          t.type.equalsValue(type) &
          t.deletedAt.isNull() &
          t.seriesId.isNotNull(),
    );
  return query.watch().map((items) {
    final bySeries = <String, Set<String>>{};
    for (final item in items) {
      (bySeries[item.seriesId!] ??= {}).addAll(item.authors);
    }
    return bySeries;
  });
}

AsyncValue<List<AuthorGroup>> _groups(
  Ref ref,
  CollectionType type,
  AsyncValue<List<CollectionEntry>> entries,
) {
  final authors = ref.watch(seriesItemAuthorsProvider(type));
  return switch ((entries, authors)) {
    (AsyncData(:final value), AsyncData(value: final bySeries)) => AsyncData(
      groupByAuthor(value, seriesItemAuthors: bySeries),
    ),
    (AsyncError(:final error, :final stackTrace), _) ||
    (
      _,
      AsyncError(:final error, :final stackTrace),
    ) => AsyncError(error, stackTrace),
    _ => const AsyncLoading(),
  };
}

/// "Par auteur" view of a tab: follows its filters ("À lire"…).
@riverpod
AsyncValue<List<AuthorGroup>> visibleAuthorGroups(
  Ref ref,
  CollectionType type,
) => _groups(ref, type, ref.watch(visibleEntriesProvider(type)));

/// One author's page: everything of the tab, unfiltered.
@riverpod
AsyncValue<AuthorGroup?> authorGroup(
  Ref ref,
  CollectionType type,
  String name,
) {
  final key = authorKey(name);
  return _groups(
    ref,
    type,
    ref.watch(collectionEntriesProvider(type)),
  ).whenData((groups) => groups.where((g) => g.key == key).firstOrNull);
}
