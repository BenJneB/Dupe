import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

final _epoch = DateTime.utc(2026);

SeriesEntry series(String id, String title, List<String> authors, int owned) =>
    SeriesEntry(
      series: Series(
        id: id,
        createdAt: _epoch,
        updatedAt: _epoch,
        type: CollectionType.livre,
        title: title,
        authors: authors,
      ),
      ownedCount: owned,
      itemCount: owned,
    );

ItemEntry book(
  String id,
  List<String> authors, {
  Ownership ownership = Ownership.possede,
}) => ItemEntry(
  testItem(
    id,
    seriesId: null,
    ownership: ownership,
  ).copyWith(title: id, authors: authors),
);

void main() {
  test('names from different sources are the same author', () {
    expect(displayAuthorName('Colfer, Eoin'), 'Eoin Colfer');
    expect(authorKey('Colfer, Eoin'), authorKey('eoin  COLFER'));
    expect(authorKey('Eiichirō Oda'), authorKey('Eiichiro Oda'));
    expect(authorKey('J.R.R. Tolkien'), 'j r r tolkien');
  });

  test('groups series and books by author, sorted by last name', () {
    final groups = groupByAuthor(
      [
        // Created by a scan: no author on the series, only on its volumes.
        series('fowl', 'Les jumeaux Fowl', [], 3),
        series('artemis', 'Artemis Fowl', ['Colfer, Eoin'], 8),
        book('Dune', ['Frank Herbert']),
        book('Wish', ['Eoin Colfer'], ownership: Ownership.envie),
        book('Good Omens', ['Neil Gaiman', 'Terry Pratchett']),
        book('Anonyme', []),
      ],
      seriesItemAuthors: {
        'fowl': {'Eoin Colfer'},
      },
    );

    expect(groups.map((g) => g.name), [
      'Eoin Colfer',
      'Neil Gaiman',
      'Frank Herbert',
      'Terry Pratchett',
      '',
    ]);
    final colfer = groups.first;
    expect(colfer.series.map((s) => s.title), [
      'Les jumeaux Fowl',
      'Artemis Fowl',
    ]);
    expect(colfer.books.map((b) => b.title), ['Wish']);
    // 3 + 8 series volumes; the wished book is not owned.
    expect(colfer.volumes, 11);
    // A book with two authors is under both.
    expect(groups[1].books.single.title, 'Good Omens');
    expect(groups[3].books.single.title, 'Good Omens');
    expect(groups.last.isUnknown, isTrue);
  });
}
