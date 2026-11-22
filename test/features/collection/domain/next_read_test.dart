import 'dart:math' as math;

import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/next_read.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

Item volume(
  String id,
  String n, {
  ReadingStatus status = ReadingStatus.nonLu,
  String seriesId = 's1',
}) =>
    testItem(id, volume: n, seriesId: seriesId).copyWith(readingStatus: status);

void main() {
  test('one candidate per series: its first volume not read', () {
    final picks = nextReadCandidates([
      volume('a1', '1', status: ReadingStatus.lu),
      volume('a2', '2', status: ReadingStatus.lu),
      volume('a5', '5'),
      volume('a3', '03'),
      volume('b1', '1', seriesId: 's2'),
    ]);
    expect(
      {for (final p in picks) p.item.id: p.continues},
      {'a3': true, 'b1': false},
    );
  });

  test('a series being read, wishes, read copies and done books: none', () {
    final picks = nextReadCandidates([
      volume('a1', '1', status: ReadingStatus.enCours),
      volume('a2', '2'),
      // Volume 1 of s2 read in another copy: volume 2 is next.
      volume('b1', '1', seriesId: 's2'),
      volume('b1bis', '1', seriesId: 's2', status: ReadingStatus.lu),
      volume('b2', '2', seriesId: 's2'),
      volume('w', '3', seriesId: 's3').copyWith(ownership: Ownership.envie),
      testItem('book', seriesId: null),
      testItem(
        'read',
        seriesId: null,
      ).copyWith(readingStatus: ReadingStatus.lu),
    ]);
    expect([for (final p in picks) p.item.id], unorderedEquals(['book', 'b2']));
  });

  test('the pick avoids the previous one and favours started series', () {
    final candidates = nextReadCandidates([
      volume('a1', '1', status: ReadingStatus.lu),
      volume('a2', '2'),
      testItem('book', seriesId: null),
    ]);
    final random = math.Random(1);
    final counts = <String, int>{};
    for (var i = 0; i < 400; i++) {
      final id = pickNextRead(candidates, random)!.item.id;
      counts[id] = (counts[id] ?? 0) + 1;
    }
    expect(counts['a2'], greaterThan(counts['book']! * 2));
    expect(pickNextRead(candidates, random, exceptId: 'a2')!.item.id, 'book');
    expect(pickNextRead(const [], random), isNull);
  });
}
