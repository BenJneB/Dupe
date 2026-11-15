import 'package:dupe/features/search/data/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_providers.g.dart';

@riverpod
Future<LocalSearchResults> localSearch(Ref ref, String query) =>
    ref.watch(searchRepositoryProvider).search(query);
