import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/live_collection.dart';
import 'package:dupe/features/quality/data/isbn_assignment.dart';
import 'package:dupe/features/quality/domain/collection_quality.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quality_providers.g.dart';

/// Gaps of the live collection, updated as it changes.
@riverpod
Future<CollectionQuality> collectionQuality(Ref ref) async {
  final c = await ref.watch(liveCollectionProvider.future);
  return computeQuality(c.items, c.series);
}

/// Setting: mark the owned volumes without ISBN (dot on the series grid,
/// icon on series, books and authors in the lists). On by default (user's
/// choice, 2026-11-16).
@Riverpod(keepAlive: true)
class MissingIsbnInGrid extends _$MissingIsbnInGrid {
  static const settingKey = 'grid_missing_isbn';

  @override
  Future<bool> build() async => await ref
      .watch(appSettingsStoreProvider)
      .getBool(settingKey, orElse: true);

  Future<void> set({required bool on}) async {
    state = AsyncData(on);
    await ref.read(appSettingsStoreProvider).setBool(settingKey, value: on);
  }
}

@riverpod
IsbnAssignment isbnAssignment(Ref ref) => IsbnAssignment(
  ref.watch(collectionRepositoryProvider),
  ref.watch(metadataAggregatorProvider),
);
