import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/stats/domain/collection_stats.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;

  setUp(() => env = TestEnv());
  tearDown(() => env.dispose());

  final now = DateTime(2026, 11, 14);

  test('volumes count once, money counts every copy', () {
    final series = env.repo
        .newSeries(CollectionType.manga)
        .copyWith(id: 's1', title: 'Dreamland', totalVolumes: 2);
    final stats = computeCollectionStats(
      [
        // Volume 1 in two editions, one read.
        testItem('a', volume: '1').copyWith(
          purchasePrice: 7,
          purchaseDate: DateTime(2026, 11, 2),
          readingStatus: ReadingStatus.lu,
        ),
        testItem(
          'b',
          volume: '1',
        ).copyWith(purchasePrice: 8, purchaseDate: DateTime(2026, 10, 20)),
        testItem('c', volume: '2').copyWith(coverPrice: 6.9),
        // Wishes are not part of the collection.
        testItem(
          'd',
          volume: '3',
          ownership: Ownership.envie,
        ).copyWith(purchasePrice: 100),
        // Bought more than a year ago: in the total, not in the chart.
        testItem('e', seriesId: null).copyWith(
          type: CollectionType.livre,
          purchasePrice: 20,
          estimatedValue: 30,
          purchaseDate: DateTime(2025, 6),
        ),
        // Another currency is never added to euros.
        testItem('f', seriesId: null).copyWith(
          type: CollectionType.comic,
          purchasePrice: 4.99,
          currency: 'USD',
        ),
      ],
      [series],
      now: now,
    );

    expect(stats.currency, 'EUR');
    expect(stats.ownedVolumes, 4);
    expect(stats.ownedCopies, 5);
    expect(stats.readVolumes, 1);
    expect(stats.readShare, 0.25);
    expect(stats.spent, 35);
    // Estimated value, else cover price, else price paid.
    expect(stats.value, closeTo(51.9, 1e-9));
    expect(stats.otherCurrencies, {'USD': 4.99});
    expect(stats.pricedCopies, 4);
    expect(stats.volumesByType, {
      CollectionType.manga: 2,
      CollectionType.livre: 1,
      CollectionType.comic: 1,
    });
    expect(stats.spentByType, {
      CollectionType.manga: 15,
      CollectionType.livre: 20,
    });
    expect(stats.spentByMonth, hasLength(12));
    expect(stats.spentByMonth.first.month, DateTime(2025, 12));
    expect(stats.spentByMonth.last.amount, 7);
    expect(stats.spentByMonth[10].amount, 8);
    expect(stats.completeSeries, 1);
    expect(stats.seriesWithTotal, 1);
  });
}
