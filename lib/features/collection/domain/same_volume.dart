import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Copies of volume [number] among [items]; "07" and "7" are the same
/// volume, other numbers ("HS 1") are compared as typed.
Iterable<Item> copiesOfVolume(Iterable<Item> items, String? number) {
  if (number == null || number.trim().isEmpty) return const [];
  final wanted = _key(number);
  return items.where((i) => _key(i.volumeNumber) == wanted);
}

/// Copy of volume [number] in [items]; an owned copy wins over a wish.
Item? sameVolume(Iterable<Item> items, String? number) {
  final copies = copiesOfVolume(items, number);
  return copies.where((i) => i.ownership == Ownership.possede).firstOrNull ??
      copies.firstOrNull;
}

String? _key(String? number) =>
    VolumeNumber.asInt(number)?.toString() ?? number?.trim();
