import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/core/metadata/metadata_providers.dart';
import 'package:dupe/core/utils/streams.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/quality/data/isbn_assignment.dart';
import 'package:dupe/features/quality/domain/collection_quality.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quality_providers.g.dart';

/// Gaps of the live collection, updated as it changes.
@riverpod
Stream<CollectionQuality> collectionQuality(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final items = (db.select(
    db.itemsTable,
  )..where((t) => t.deletedAt.isNull())).watch();
  final series = (db.select(
    db.seriesTable,
  )..where((t) => t.deletedAt.isNull())).watch();
  return combineLatest(items, series, computeQuality);
}

/// Setting: mark the owned volumes without ISBN on the series grid (off by
/// default, not to overload it).
@Riverpod(keepAlive: true)
class MissingIsbnInGrid extends _$MissingIsbnInGrid {
  static const settingKey = 'grid_missing_isbn';

  @override
  Future<bool> build() async =>
      await ref.watch(appSettingsStoreProvider).get(settingKey) == '1';

  Future<void> set({required bool on}) async {
    state = AsyncData(on);
    await ref.read(appSettingsStoreProvider).set(settingKey, on ? '1' : '0');
  }
}

@riverpod
IsbnAssignment isbnAssignment(Ref ref) => IsbnAssignment(
  ref.watch(collectionRepositoryProvider),
  ref.watch(metadataAggregatorProvider),
);
