import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('VolumeGrid.compute', () {
    test('series of 10 with 7 owned has 3 missing (phase 1 criterion)', () {
      final grid = VolumeGrid.compute(
        items: [for (var n = 1; n <= 7; n++) testItem('i$n', volume: '$n')],
        totalVolumes: 10,
        followed: true,
      );

      expect(grid.slots, hasLength(10));
      expect(grid.ownedCount, 7);
      expect(grid.missingNumbers, [8, 9, 10]);
      expect(grid.isComplete, isFalse);
      expect(
        grid.slots.map((s) => s.status).skip(7),
        everyElement(VolumeSlotStatus.missing),
      );
    });

    test('wished volumes are shown as wished and still count as missing', () {
      final grid = VolumeGrid.compute(
        items: [
          testItem('a', volume: '1'),
          testItem('b', volume: '2', ownership: Ownership.envie),
        ],
        totalVolumes: 3,
        followed: true,
      );

      expect(grid.slots[1].status, VolumeSlotStatus.wished);
      expect(grid.missingNumbers, [2, 3]);
    });

    test('loaned volumes are owned and flagged as loaned', () {
      final grid = VolumeGrid.compute(
        items: [testItem('a', volume: '1')],
        totalVolumes: 1,
        followed: true,
        loanedItemIds: {'a'},
      );

      expect(grid.slots.single.status, VolumeSlotStatus.loaned);
      expect(grid.ownedCount, 1);
      expect(grid.isComplete, isTrue);
    });

    test('unknown total: grid extends to the highest known number', () {
      final grid = VolumeGrid.compute(
        items: [
          testItem('a', volume: '1'),
          testItem('b', volume: '4'),
        ],
        totalVolumes: null,
        followed: true,
      );

      expect(grid.slots.map((s) => s.label), ['1', '2', '3', '4']);
      expect(grid.missingNumbers, [2, 3]);
      expect(grid.isComplete, isFalse);
    });

    test('owned volume beyond total extends the grid without counting', () {
      final grid = VolumeGrid.compute(
        items: [testItem('a', volume: '3')],
        totalVolumes: 2,
        followed: true,
      );

      expect(grid.slots, hasLength(3));
      expect(grid.ownedCount, 0);
      expect(grid.missingNumbers, [1, 2]);
    });

    test('special volumes come after numbered ones in natural order', () {
      final grid = VolumeGrid.compute(
        items: [
          testItem('a', volume: 'HS 2'),
          testItem('b', volume: 'HS 1'),
          testItem('c', volume: '1.5'),
          testItem('d', volume: '01'),
        ],
        totalVolumes: 1,
        followed: true,
      );

      expect(grid.slots.map((s) => s.label), ['1', '1.5', 'HS 1', 'HS 2']);
    });

    test('owned variant wins over a wished duplicate', () {
      final grid = VolumeGrid.compute(
        items: [
          testItem('w', volume: '1', ownership: Ownership.envie),
          testItem('o', volume: '1'),
        ],
        totalVolumes: 1,
        followed: true,
      );

      expect(grid.slots.single.item!.id, 'o');
    });

    test('not followed series report no missing volumes', () {
      final grid = VolumeGrid.compute(
        items: [testItem('a', volume: '1')],
        totalVolumes: 5,
        followed: false,
      );

      expect(grid.missingNumbers, isEmpty);
      expect(grid.slots, hasLength(5));
    });
  });
}
