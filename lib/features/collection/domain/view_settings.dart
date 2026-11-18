import 'package:dupe/core/utils/text_fold.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_settings.freezed.dart';

/// Per-tab display options.
@freezed
abstract class ViewSettings with _$ViewSettings {
  const factory({
    @Default(CollectionSort.title) CollectionSort sort,
    @Default(CompletionFilter.all) CompletionFilter filter,
    @Default(false) bool grid,

    /// "Ma pile à lire": only what is owned and not read yet.
    @Default(false) bool toReadOnly,

    /// "Par auteur": authors instead of series and books.
    @Default(false) bool byAuthor,
  }) = _ViewSettings;
}

/// Filters and sorts the entries of a tab.
///
/// Completion filters only keep series (standalone items have no
/// completion). Progress sort puts unknown progress and items last.
List<CollectionEntry> applyViewSettings(
  List<CollectionEntry> entries,
  ViewSettings settings,
) {
  final filtered = switch (settings.filter) {
    CompletionFilter.all => entries.toList(),
    CompletionFilter.complete =>
      entries.whereType<SeriesEntry>().where((e) => e.isComplete).toList(),
    CompletionFilter.incomplete =>
      entries.whereType<SeriesEntry>().where((e) => !e.isComplete).toList(),
    CompletionFilter.signed => entries.where((e) => e.signedCount > 0).toList(),
  };
  if (settings.toReadOnly) filtered.retainWhere((e) => e.isToRead);
  int byTitle(CollectionEntry a, CollectionEntry b) =>
      foldForSearch(a.title).compareTo(foldForSearch(b.title));
  double progressOf(CollectionEntry e) =>
      e is SeriesEntry ? e.progress ?? -1 : -2;

  return filtered..sort(switch (settings.sort) {
    CollectionSort.title => byTitle,
    CollectionSort.recent => (a, b) => b.createdAt.compareTo(a.createdAt),
    CollectionSort.progress => (a, b) {
      final cmp = progressOf(b).compareTo(progressOf(a));
      return cmp != 0 ? cmp : byTitle(a, b);
    },
  });
}
