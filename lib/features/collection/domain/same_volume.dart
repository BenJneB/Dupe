import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Copies of volume [number] among [items]; "07" and "7" are the same
/// volume, other numbers ("HS 1") are compared as typed.
Iterable<Item> copiesOfVolume(Iterable<Item> items, String? number) {
  final wanted = VolumeNumber.key(number);
  if (wanted == null) return const [];
  return items.where((i) => VolumeNumber.key(i.volumeNumber) == wanted);
}

/// Copy of volume [number] in [items]; an owned copy wins over a wish.
Item? sameVolume(Iterable<Item> items, String? number) {
  final copies = copiesOfVolume(items, number);
  return copies.where((i) => i.ownership == Ownership.possede).firstOrNull ??
      copies.firstOrNull;
}
