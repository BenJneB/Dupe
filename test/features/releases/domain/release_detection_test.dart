import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/core/metadata/providers/bnf/unimarc_parser.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_detection.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/collection_builders.dart';
import '../../../helpers/fake_http.dart';

void main() {
  final everdark = buildCatalog(
    'Everdark',
    parseUnimarcResponse(fixture('bnf/series_everdark.xml')),
  );
  List<int> next(
    List<String> owned, {
    String? publisher,
    int baseline = 0,
    Set<int> alerted = const {},
    int limit = 3,
  }) => nextVolumes(
    [
      for (final n in owned)
        item(
          'Everdark',
          seriesId: 's',
          type: CollectionType.manga,
        ).copyWith(id: n, volumeNumber: n),
    ],
    editionOf(everdark, publisher),
    baseline: baseline,
    alerted: alerted,
    limit: limit,
  ).map((v) => v.number).toList();

  test('the volumes after the last one known (real BnF records)', () {
    expect(next(['1', '2', '3', '4', '5'], publisher: 'Pika'), [6, 7]);
    expect(next(['1', '2']), [3, 4, 5]);
    expect(next(['1', '2'], limit: 1), [3]);
    expect(next(['7']), isEmpty);
    // Nothing numbered: no reference, no alert.
    expect(next([]), isEmpty);
    // Another publisher's edition does not count.
    expect(next(['1'], publisher: 'Glénat'), isEmpty);
  });

  test('after the first check reference, skipping handled alerts', () {
    // Volumes out at the first check are not new releases.
    expect(next(['1', '2'], baseline: 4), [5, 6, 7]);
    expect(next(['1', '2'], baseline: 7), isEmpty);
    // Alerts already seen or ignored do not hide the next volumes.
    expect(next(['1', '2'], alerted: {3, 4}), [5, 6, 7]);
    expect(next(['1', '2'], alerted: {3, 4}, limit: 1), [5]);
  });

  test('a first check shows only the volumes out lately', () {
    // Real records: Everdark 6 (DL 2023) and 7 (DL 2024).
    List<int> recent(DateTime now) => nextVolumes(
      [
        item(
          'Everdark',
          seriesId: 's',
          type: CollectionType.manga,
        ).copyWith(id: '5', volumeNumber: '5'),
      ],
      editionOf(everdark, 'Pika'),
      where: (v) => isRecentRelease(v.preferred, now),
    ).map((v) => v.number).toList();
    expect(recent(DateTime(2024, 6)), [6, 7]);
    expect(recent(DateTime(2025, 3)), [7]);
    expect(recent(DateTime(2026, 11)), isEmpty);
  });

  test('new books of an author: unseen, not owned, really theirs', () {
    MetadataResult book(String isbn, {String author = 'Manu Larcenet'}) =>
        MetadataResult(
          source: MetadataSource.bnf,
          sourceId: isbn,
          title: 'Livre $isbn',
          isbn13: isbn,
          authors: [author],
        );
    final found = newBooks(
      [
        book('1'),
        book('1'),
        book('2'),
        book('3'),
        book('4', author: 'Someone Else'),
      ],
      author: 'Larcenet, Manu',
      seen: {'2'},
      owned: {'3'},
    );
    expect(found.map((b) => b.isbn13), ['1']);
  });

  test('an alert has the same id on every device', () {
    expect(
      ReleasesRepository.alertId('series:s1:6'),
      ReleasesRepository.alertId('series:s1:6'),
    );
    expect(
      ReleasesRepository.alertId('series:s1:6'),
      isNot(ReleasesRepository.alertId('series:s1:7')),
    );
  });
}
