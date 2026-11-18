import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/domain/same_volume.dart';

/// What to do with a volume of the catalog (PLAN_V4 phase 37).
enum VolumeChoice { owned, wish, skip }

typedef CompletionPlan = ({List<Item> updates, List<Item> creates});

/// How a catalog volume relates to the series in the collection.
enum VolumeState {
  /// Not in the collection: created when chosen.
  absent,

  /// In the collection without ISBN: gets this one and its empty fields.
  missingIsbn,

  /// Already there with an ISBN: left alone.
  complete,
}

VolumeState volumeState(List<Item> existing, int number) {
  final copies = copiesOfVolume(existing, '$number').toList();
  if (copies.isEmpty) return VolumeState.absent;
  return copies.any((c) => c.hasNoIsbn)
      ? VolumeState.missingIsbn
      : VolumeState.complete;
}

/// Writes for [chosen] (number -> record and choice): an existing volume
/// without ISBN is completed (a typed value is never overwritten), an absent
/// one is created with [newItem] when owned or wished, a volume that already
/// has an ISBN is never touched (no duplicate).
CompletionPlan planCompletion({
  required List<Item> existing,
  required Map<int, ({MetadataResult record, VolumeChoice choice})> chosen,
  required String seriesTitle,
  required Item Function(int number) newItem,
}) {
  final updates = <Item>[];
  final creates = <Item>[];
  for (final MapEntry(key: n, value: (:record, :choice)) in chosen.entries) {
    if (choice == VolumeChoice.skip) continue;
    switch (volumeState(existing, n)) {
      case VolumeState.complete:
        break;
      case VolumeState.missingIsbn:
        final copy = copiesOfVolume(
          existing,
          '$n',
        ).firstWhere((c) => c.hasNoIsbn);
        updates.add(
          fillBlanks(
            copy.copyWith(isbn13: record.isbn13),
            record,
            seriesTitle: seriesTitle,
          ),
        );
      case VolumeState.absent:
        creates.add(
          applyMetadata(newItem(n), (
            metadata: record.copyWith(volumeNumber: '$n'),
            ownership: choice == VolumeChoice.wish
                ? Ownership.envie
                : Ownership.possede,
          ), seriesTitle: seriesTitle),
        );
    }
  }
  return (updates: updates, creates: creates);
}
