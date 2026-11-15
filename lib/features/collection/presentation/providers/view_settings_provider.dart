import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/view_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'view_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class CollectionViewSettings extends _$CollectionViewSettings {
  @override
  ViewSettings build(CollectionType type) => const ViewSettings();

  void setSort(CollectionSort sort) => state = state.copyWith(sort: sort);

  void setFilter(CompletionFilter filter) =>
      state = state.copyWith(filter: filter);

  void toggleGrid() => state = state.copyWith(grid: !state.grid);

  void toggleToRead() => state = state.copyWith(toReadOnly: !state.toReadOnly);

  void toggleByAuthor() => state = state.copyWith(byAuthor: !state.byAuthor);
}
