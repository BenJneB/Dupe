import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/view_settings.dart';
import 'package:dupe/features/collection/presentation/providers/view_settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entries_providers.g.dart';

@riverpod
Stream<List<CollectionEntry>> collectionEntries(Ref ref, CollectionType type) =>
    ref.watch(collectionRepositoryProvider).watchEntries(type);

/// Entries of a tab after filtering and sorting.
@riverpod
AsyncValue<List<CollectionEntry>> visibleEntries(Ref ref, CollectionType type) {
  final settings = ref.watch(collectionViewSettingsProvider(type));
  return ref
      .watch(collectionEntriesProvider(type))
      .whenData((entries) => applyViewSettings(entries, settings));
}
