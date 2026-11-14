import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/wishlist/domain/next_volumes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_repositories.dart';

void main() {
  late TestEnv env;

  setUp(() => env = TestEnv());
  tearDown(() => env.dispose());

  Series series(String id, {int? total, bool followed = true}) => env.repo
      .newSeries(CollectionType.manga)
      .copyWith(id: id, title: id, totalVolumes: total, followed: followed);

  test('missing volumes of followed series, minus wished ones', () {
    final next = nextVolumesToBuy(
      [
        series('s1', total: 6),
        series('unfollowed', total: 3, followed: false),
        series('noTotal'),
        series('complete', total: 1),
      ],
      [
        testItem('a', volume: '1'),
        testItem('b', volume: '3', ownership: Ownership.envie),
        testItem('c', volume: '1', seriesId: 'noTotal'),
        testItem('d', volume: '4', seriesId: 'noTotal'),
        testItem('e', volume: '1', seriesId: 'complete'),
      ],
    );

    expect(next.map((n) => n.series.id), ['s1', 'noTotal']);
    expect(next[0].numbers, [2, 4, 5, 6]);
    // Unknown total: gaps up to the highest owned volume.
    expect(next[1].numbers, [2, 3]);
  });
}
