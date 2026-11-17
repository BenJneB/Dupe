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
  List<int> next(List<String> owned, {String? publisher, int limit = 3}) =>
      nextVolumes(
        [
          for (final n in owned)
            item(
              'Everdark',
              seriesId: 's',
              type: CollectionType.manga,
            ).copyWith(id: n, volumeNumber: n),
        ],
        everdark,
        publisher: publisher,
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
