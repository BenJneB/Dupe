import 'package:dupe/features/covers/data/cover_proposals.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

void main() {
  const pocket = 'https://covers.openlibrary.org/b/id/12345-L.jpg';
  const other = 'https://covers.openlibrary.org/b/id/678-L.jpg';
  final book = testItem('b1').copyWith(refusedCovers: ['ol:id:12345']);

  test('a refused image is refused in any size, other images are not', () {
    expect(RefusedCovers.refuses({}, book, pocket), isTrue);
    expect(
      RefusedCovers.refuses({}, book, pocket.replaceFirst('-L', '-M')),
      isTrue,
    );
    expect(RefusedCovers.refuses({}, book, other), isFalse);
    expect(RefusedCovers.refuses({}, testItem('b2'), pocket), isFalse);
  });

  test('a device refusal (before 2026-11-20) still counts for its book', () {
    final legacy = {'b1|$pocket'};
    final plain = testItem('b1');
    expect(RefusedCovers.refuses(legacy, plain, pocket), isTrue);
    expect(RefusedCovers.refuses(legacy, plain, other), isFalse);
    expect(RefusedCovers.refuses(legacy, testItem('b10'), pocket), isFalse);
  });
}
