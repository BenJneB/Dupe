import 'package:dupe/features/collection/data/completed_series.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

void main() {
  final epoch = DateTime.utc(2026);
  Series series(String id, int? total) => Series(
    id: id,
    createdAt: epoch,
    updatedAt: epoch,
    type: testItem('x').type,
    title: 'Série $id',
    totalVolumes: total,
  );

  test('complete: every volume up to the known total owned', () {
    final done = completeSeries(
      [series('s1', 2), series('s2', 3), series('s3', null)],
      [
        testItem('a', volume: '1').copyWith(syncPending: false),
        testItem('b', volume: '2'),
        testItem('c', volume: '1', seriesId: 's2'),
        testItem('d', volume: '1', seriesId: 's3'),
      ],
    );
    expect(done, {'s1': (title: 'Série s1', local: true)});
  });

  test('news: completed here only, never a sync or a bulk change', () {
    const before = <String, CompleteSeries>{};
    expect(
      newlyCompleted(before, {
        's1': (title: 'Naruto', local: true),
        's2': (title: 'Synced', local: false),
      }),
      ['Naruto'],
    );
    // Already complete before: not news again.
    expect(
      newlyCompleted(
        {'s1': (title: 'Naruto', local: true)},
        {'s1': (title: 'Naruto', local: true)},
      ),
      isEmpty,
    );
    expect(
      newlyCompleted(before, {
        for (var i = 0; i < 6; i++) 's$i': (title: 'S$i', local: true),
      }),
      isEmpty,
    );
  });
}
