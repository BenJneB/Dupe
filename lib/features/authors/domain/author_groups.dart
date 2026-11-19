import 'package:dupe/core/utils/text_fold.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';

/// "Colfer, Eoin" (library order) -> "Eoin Colfer"; other names unchanged.
String displayAuthorName(String raw) {
  final name = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  final parts = name.split(', ');
  return parts.length == 2 && parts.every((p) => p.isNotEmpty)
      ? '${parts[1]} ${parts[0]}'
      : name;
}

/// Name folded for comparison: accents, case and dots removed.
String _foldName(String raw) =>
    foldForSearch(displayAuthorName(raw))
        .replaceAll(RegExp('[^a-z0-9]+'), ' ')
        .trim();

/// Same author whatever the source wrote: accents, case, dots, and word
/// order ("Federica Di Mio" / "Di Mio Federica", without a comma).
String authorKey(String raw) {
  final words = _foldName(raw).split(' ')..sort();
  return words.join(' ').trim();
}

/// Series and standalone books of one author in a tab.
class AuthorGroup {
  new({required this.key, required this.name});

  final String key;

  /// Display name; empty for the books without author.
  final String name;
  final series = <SeriesEntry>[];
  final books = <ItemEntry>[];

  bool get isUnknown => key.isEmpty;

  /// Owned volumes: series volumes plus owned standalone books.
  int get volumes => ownedVolumes(entries);

  /// Owned books without ISBN among its series and books (quality marker).
  int get missingIsbnCount =>
      entries.fold(0, (sum, e) => sum + e.missingIsbnCount);

  /// Sorted by last name ("Colfer" for "Eoin Colfer").
  String get sortKey => _foldName(name).split(' ').reversed.join(' ');

  List<CollectionEntry> get entries => [...series, ...books];
}

/// Groups the entries of a tab by author. A series counts for the authors
/// it lists and those of its volumes ([seriesItemAuthors]); a book with
/// several authors is under each of them. Authorless entries come last.
List<AuthorGroup> groupByAuthor(
  List<CollectionEntry> entries, {
  Map<String, Set<String>> seriesItemAuthors = const {},
}) {
  final groups = <String, AuthorGroup>{};
  AuthorGroup groupOf(String raw) {
    final key = authorKey(raw);
    return groups[key] ??= AuthorGroup(
      key: key,
      name: key.isEmpty ? '' : displayAuthorName(raw),
    );
  }

  for (final entry in entries) {
    final names = switch (entry) {
      SeriesEntry(:final series) => {
        ...series.authors,
        ...?seriesItemAuthors[series.id],
      },
      ItemEntry(:final item) => item.authors.toSet(),
    };
    final keys = <String>{};
    final targets = [
      for (final name in names)
        if (keys.add(authorKey(name))) groupOf(name),
    ];
    if (targets.isEmpty) targets.add(groupOf(''));
    for (final group in targets) {
      switch (entry) {
        case SeriesEntry():
          group.series.add(entry);
        case ItemEntry():
          group.books.add(entry);
      }
    }
  }
  return groups.values.toList()..sort((a, b) {
    if (a.isUnknown != b.isUnknown) return a.isUnknown ? 1 : -1;
    return a.sortKey.compareTo(b.sortKey);
  });
}
