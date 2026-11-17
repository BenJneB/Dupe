import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';

/// Weight of one book in the profile: owned 1, read +1, rating 0-5 adds
/// (rating - 2.5) / 2.5 (a 5/5 counts double, a 0/5 nothing); a wish 0.3.
double bookWeight(Item i) {
  if (i.ownership == Ownership.envie) return 0.3;
  var w = 1.0;
  if (i.readingStatus == ReadingStatus.lu) w += 1;
  if (i.rating case final r?) w += (r - 2.5) / 2.5;
  return w < 0 ? 0 : w;
}

/// One author of the collection.
class AuthorTaste {
  new({required this.key, required this.name, required this.type});

  final String key;
  final String name;

  /// Type of most of their books (tab of the suggestions).
  CollectionType type;
  double weight = 0;
  int count = 0;
  final _types = <CollectionType, int>{};

  void _add(Item i) {
    weight += bookWeight(i);
    if (i.ownership == Ownership.possede) count++;
    _types[i.type] = (_types[i.type] ?? 0) + 1;
    type = _types.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}

/// One series of the collection.
class SeriesTaste {
  new(this.series);

  final Series series;
  double weight = 0;
  int count = 0;
}

/// What the collection says of the user's taste (local, explainable).
class TasteProfile {
  new _(this.authors, this.series);

  /// Authors and series by decreasing weight; deleted rows ignored.
  factory of(List<Item> items, List<Series> series) {
    final authors = <String, AuthorTaste>{};
    final bySeries = {
      for (final s in series)
        if (s.deletedAt == null) s.id: SeriesTaste(s),
    };
    for (final i in items) {
      if (i.deletedAt != null) continue;
      for (final raw in {...i.authors}) {
        final key = authorKey(raw);
        if (key.isEmpty) continue;
        (authors[key] ??= AuthorTaste(
          key: key,
          name: displayAuthorName(raw),
          type: i.type,
        ))._add(i);
      }
      if (bySeries[i.seriesId] case final s?) {
        s.weight += bookWeight(i);
        if (i.ownership == Ownership.possede) s.count++;
      }
    }
    int byWeight(double a, double b) => b.compareTo(a);
    return TasteProfile._(
      authors.values.where((a) => a.count > 0).toList()
        ..sort((a, b) => byWeight(a.weight, b.weight)),
      bySeries.values.where((s) => s.count > 0).toList()
        ..sort((a, b) => byWeight(a.weight, b.weight)),
    );
  }

  final List<AuthorTaste> authors;
  final List<SeriesTaste> series;

  /// Heaviest weight, to bring every reason between 0 and 1.
  double get maxWeight => [
    for (final a in authors) a.weight,
    for (final s in series) s.weight,
    1.0,
  ].reduce((a, b) => a > b ? a : b);

  /// The manga series whose AniList neighbours are looked up.
  List<SeriesTaste> topManga(int n) => series
      .where((s) => s.series.type == CollectionType.manga)
      .take(n)
      .toList();
}
