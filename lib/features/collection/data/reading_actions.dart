import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Reading status changes (PLAN.md §5: reading).
extension ReadingActions on CollectionRepository {
  /// Sets [status]; reading a volume sets its read date to [today] if empty.
  Future<void> setReadingStatus(
    Item item,
    ReadingStatus status, {
    required DateTime today,
  }) => saveItem(
    item.copyWith(
      readingStatus: status,
      readDate: status == ReadingStatus.lu
          ? item.readDate ?? today
          : item.readDate,
    ),
  );

  /// Marks the owned volumes 1..[upTo] of a series as read. Returns the
  /// number of volumes changed.
  Future<int> markReadUpTo(
    String seriesId,
    int upTo, {
    required DateTime today,
  }) async {
    var changed = 0;
    for (final item in await listSeriesItems(seriesId)) {
      final n = VolumeNumber.asInt(item.volumeNumber);
      if (n == null ||
          n > upTo ||
          item.ownership != Ownership.possede ||
          item.readingStatus == ReadingStatus.lu) {
        continue;
      }
      await setReadingStatus(item, ReadingStatus.lu, today: today);
      changed++;
    }
    return changed;
  }
}
