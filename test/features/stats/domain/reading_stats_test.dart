import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/stats/domain/reading_stats.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;

  setUp(() => env = TestEnv());
  tearDown(() => env.dispose());

  /// Hand-computed set (PLAN_V3 phase 20 criterion), on 2026-11-14.
  test('reading figures of a hand-computed collection', () {
    final onePiece = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(id: 's1', title: 'One Piece');
    final blacksad = env.repo
        .newSeries(CollectionType.bd)
        .copyWith(id: 's2', title: 'Blacksad');
    final stats = computeReadingStats(
      [
        // Volume 1, two copies, one read 10 days after purchase (November).
        testItem('a', volume: '1').copyWith(
          readingStatus: ReadingStatus.lu,
          readDate: DateTime(2026, 11, 3),
          purchaseDate: DateTime(2026, 10, 24),
        ),
        testItem('b', volume: '1'),
        // Read the day it was bought (September).
        testItem('c', volume: '2').copyWith(
          readingStatus: ReadingStatus.lu,
          readDate: DateTime(2026, 9, 10, 20),
          purchaseDate: DateTime(2026, 9, 10, 9),
        ),
        // Read, no date: not in a month.
        testItem('d', volume: '3').copyWith(readingStatus: ReadingStatus.lu),
        // The pile: e bought in February, f added on 2026-01-01 (oldest).
        testItem('e', volume: '4').copyWith(purchaseDate: DateTime(2026, 2)),
        testItem(
          'f',
          volume: '5',
        ).copyWith(readingStatus: ReadingStatus.enCours),
        testItem(
          'g',
          volume: '6',
        ).copyWith(readingStatus: ReadingStatus.abandonne),
        // Read before being bought, more than a year ago.
        testItem('h', volume: '1', seriesId: 's2').copyWith(
          type: CollectionType.bd,
          readingStatus: ReadingStatus.lu,
          readDate: DateTime(2025, 6),
          purchaseDate: DateTime(2025, 7),
        ),
        // A book outside a series, read 30 days after purchase.
        testItem('j', seriesId: null).copyWith(
          type: CollectionType.livre,
          readingStatus: ReadingStatus.lu,
          readDate: DateTime(2026, 11, 12),
          purchaseDate: DateTime(2026, 10, 13),
        ),
        // Wishes are not read.
        testItem('w', volume: '7', ownership: Ownership.envie),
      ],
      [onePiece, blacksad],
      now: DateTime(2026, 11, 14),
    );

    expect(stats.readByMonth, hasLength(12));
    expect(stats.readByMonth.first.month, DateTime(2025, 12));
    expect(
      {
        for (final m in stats.readByMonth)
          if (m.count > 0) m.month: m.count,
      },
      {DateTime(2026, 9): 1, DateTime(2026, 11): 2},
    );
    expect(stats.readWithoutDate, 1);
    expect(stats.byType, {
      CollectionType.manga: (read: 3, owned: 6),
      CollectionType.bd: (read: 1, owned: 1),
      CollectionType.livre: (read: 1, owned: 1),
    });
    // (10 + 0 + 30) / 3; h (read before buying) and d (no date) left out.
    expect(stats.delaySamples, 3);
    expect(stats.averageDaysToRead, closeTo(40 / 3, 1e-9));
    expect(stats.toRead, 2);
    expect(stats.oldestToRead?.id, 'f');
    expect(stats.oldestToReadSince, DateTime.utc(2026));
    expect(stats.abandonedSeries, ['One Piece']);
  });

  test('nothing read: no delay, empty months', () {
    final stats = computeReadingStats(
      [testItem('a', volume: '1')],
      const [],
      now: DateTime(2026, 11, 14),
    );
    expect(stats.hasReadByMonth, isFalse);
    expect(stats.averageDaysToRead, isNull);
    expect(stats.toRead, 1);
    expect(stats.abandonedSeries, isEmpty);
  });
}
