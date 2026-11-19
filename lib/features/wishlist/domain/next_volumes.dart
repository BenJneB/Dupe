import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Missing volumes of a followed series that are not wished yet.
typedef NextVolumes = ({Series series, List<int> numbers});

/// "Prochains tomes à acheter": for each followed series, the volumes
/// neither owned nor already in the wishlist (PLAN.md §5).
List<NextVolumes> nextVolumesToBuy(List<Series> series, List<Item> items) {
  final bySeries = <String, List<Item>>{};
  for (final item in items) {
    final id = item.seriesId;
    if (id != null) (bySeries[id] ??= []).add(item);
  }
  return [
    for (final s in series.where((s) => s.followed))
      if (_numbers(s, bySeries[s.id] ?? const []) case final n
          when n.isNotEmpty)
        (series: s, numbers: n),
  ];
}

List<int> _numbers(Series s, List<Item> items) {
  final grid = VolumeGrid.compute(
    items: items,
    totalVolumes: s.totalVolumes,
    followed: true,
  );
  final wished = {
    for (final slot in grid.slots)
      if (slot.status == VolumeSlotStatus.wished) slot.number,
  };
  return [
    for (final n in grid.missingNumbers)
      if (!wished.contains(n)) n,
  ];
}

/// Wishlist order: priority 1 first, no priority last, then title.
int compareWishes(Item a, Item b) {
  final pa = a.wishlistPriority ?? 99;
  final pb = b.wishlistPriority ?? 99;
  if (pa != pb) return pa.compareTo(pb);
  final byTitle = a.title.compareTo(b.title);
  return byTitle != 0
      ? byTitle
      : VolumeNumber.compare(a.volumeNumber, b.volumeNumber);
}
