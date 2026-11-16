import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/covers/domain/edition_match.dart';
import 'package:flutter_test/flutter_test.dart';

MetadataResult r(
  String title, {
  List<String> authors = const [],
  String? series,
  String? volume,
}) => MetadataResult(
  source: MetadataSource.googleBooks,
  sourceId: title,
  title: title,
  authors: authors,
  seriesTitle: series,
  volumeNumber: volume,
);

void main() {
  test('another edition of the same work, for a cover', () {
    // Pocket edition, subtitle differs: same main title and author.
    expect(
      sameWork(
        r('Dune : le cycle de Dune 1', authors: ['Herbert, Frank']),
        title: 'Dune',
        authors: ['Frank Herbert'],
      ),
      isTrue,
    );
    // Namesake by someone else.
    expect(
      sameWork(
        r('Dune', authors: ['Ann Other']),
        title: 'Dune',
        authors: ['Frank Herbert'],
      ),
      isFalse,
    );
    // A volume: same series and same number only.
    expect(
      sameWork(
        r('Kaamelott', volume: '9'),
        title: 'Kaamelott',
        seriesTitle: 'Kaamelott',
        volume: '9',
      ),
      isTrue,
    );
    expect(
      sameWork(
        r('Kaamelott', volume: '8'),
        title: 'Kaamelott',
        seriesTitle: 'Kaamelott',
        volume: '9',
      ),
      isFalse,
    );
    expect(
      sameWork(
        r('Kaamelott'),
        title: 'Kaamelott',
        seriesTitle: 'Kaamelott',
        volume: '9',
      ),
      isFalse,
    );
  });

  test('store: a standalone book needs title and author', () {
    final pocket = r('Dune', authors: ['Frank Herbert']);
    expect(
      sameStandaloneBook(pocket, title: 'Dune', authors: ['Herbert, Frank']),
      isTrue,
    );
    expect(sameStandaloneBook(pocket, title: 'Dune', authors: []), isFalse);
    expect(
      sameStandaloneBook(r('Dune'), title: 'Dune', authors: ['Frank Herbert']),
      isFalse,
    );
    expect(
      sameStandaloneBook(
        pocket,
        title: 'Dune Messiah',
        authors: ['Frank Herbert'],
      ),
      isFalse,
    );
  });
}
