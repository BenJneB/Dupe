import 'package:dupe/core/metadata/metadata_aggregator.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'online_search_providers.g.dart';

@riverpod
Future<IsbnLookup> isbnLookup(Ref ref, String isbn13, CollectionType type) =>
    ref.watch(metadataAggregatorProvider).lookupIsbn(isbn13, type);

@riverpod
Future<TextSearch> onlineTextSearch(
  Ref ref,
  String query,
  CollectionType type,
) => ref.watch(metadataAggregatorProvider).searchText(query, type);

/// Local copy of a scanned ISBN, if any (100 % offline check).
@riverpod
Future<Item?> localItemByIsbn(Ref ref, String isbn13) =>
    ref.watch(collectionRepositoryProvider).findItemByIsbn(isbn13);
