import 'dart:math' as math;

import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// A book proposed by "Que lire maintenant ?"; `continues`: the next volume
/// of a series already started.
typedef NextRead = ({Item item, bool continues});

/// Owned books not started yet, one per series: its first volume not read
/// (never volume 5 while 3 waits), unless that one is being read already.
/// A volume counts as read when one of its owned copies is.
List<NextRead> nextReadCandidates(List<Item> items) {
  final owned = [
    for (final i in items)
      if (i.ownership == Ownership.possede && i.deletedAt == null) i,
  ];
  final bySeries = <String, Map<String, List<Item>>>{};
  final result = <NextRead>[];
  for (final i in owned) {
    if (i.seriesId case final id?) {
      final volume = VolumeNumber.key(i.volumeNumber) ?? 'id:${i.id}';
      ((bySeries[id] ??= {})[volume] ??= []).add(i);
    } else if (i.readingStatus == ReadingStatus.nonLu) {
      result.add((item: i, continues: false));
    }
  }
  for (final volumes in bySeries.values) {
    bool done(List<Item> copies) =>
        copies.any((c) => !toReadStatuses.contains(c.readingStatus));
    final toRead = volumes.values.where((copies) => !done(copies)).toList()
      ..sort(
        (a, b) =>
            VolumeNumber.compare(a.first.volumeNumber, b.first.volumeNumber),
      );
    if (toRead.isEmpty) continue;
    final first = toRead.first;
    // Being read: that is what to read now, no need to propose another.
    if (first.any((c) => c.readingStatus == ReadingStatus.enCours)) continue;
    final started = volumes.values.any(
      (copies) => copies.any((c) => c.readingStatus == ReadingStatus.lu),
    );
    result.add((item: first.first, continues: started));
  }
  return result;
}

/// One of [candidates] at random, the next volume of a started series three
/// times as likely; never [exceptId] when there is another choice.
NextRead? pickNextRead(
  List<NextRead> candidates,
  math.Random random, {
  String? exceptId,
}) {
  final pool = candidates.length > 1
      ? candidates.where((c) => c.item.id != exceptId).toList()
      : candidates;
  if (pool.isEmpty) return null;
  int weight(NextRead c) => c.continues ? 3 : 1;
  var ticket = random.nextInt(pool.fold(0, (sum, c) => sum + weight(c)));
  for (final c in pool) {
    ticket -= weight(c);
    if (ticket < 0) return c;
  }
  return pool.last;
}
