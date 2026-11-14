import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Status of one slot (pastille) in the series volume grid.
enum VolumeSlotStatus { owned, loaned, wished, missing }

class VolumeSlot {
  const new({
    required this.label,
    required this.status,
    this.number,
    this.item,
  });

  /// Displayed text ("12", "HS 2").
  final String label;
  final VolumeSlotStatus status;

  /// Integer volume number, when the slot is a plain numbered volume.
  final int? number;

  /// Representative item (best status) for this slot; null when missing.
  final Item? item;
}

/// Mangacollec-like view of a series: one slot per volume number.
class VolumeGrid {
  const new({
    required this.slots,
    required this.ownedCount,
    required this.totalVolumes,
    required this.missingNumbers,
  });

  /// Builds the grid of a series from its (non-deleted) items.
  ///
  /// - Numbered slots go from 1 to max(totalVolumes, highest known number).
  /// - Special volumes ("HS 2", "1.5") follow, in natural order.
  /// - When several items share a number (variants), the best status wins:
  ///   loaned > owned > wished.
  /// - [missingNumbers] lists not-owned volumes up to [totalVolumes] (or up
  ///   to the highest known number when unknown), only for followed series.
  factory compute({
    required List<Item> items,
    required int? totalVolumes,
    required bool followed,
    Set<String> loanedItemIds = const {},
  }) {
    VolumeSlotStatus statusOf(Item item) {
      if (item.ownership == Ownership.envie) return VolumeSlotStatus.wished;
      return loanedItemIds.contains(item.id)
          ? VolumeSlotStatus.loaned
          : VolumeSlotStatus.owned;
    }

    final byLabel = <String, Item>{};
    for (final item in items) {
      final label = item.volumeNumber?.trim() ?? '';
      if (label.isEmpty) continue;
      final key = VolumeNumber.asInt(label)?.toString() ?? label;
      final current = byLabel[key];
      if (current == null || statusOf(item).index < statusOf(current).index) {
        byLabel[key] = item;
      }
    }

    var maxNumber = totalVolumes ?? 0;
    for (final key in byLabel.keys) {
      final n = VolumeNumber.asInt(key);
      if (n != null && n > maxNumber) maxNumber = n;
    }

    final slots = <VolumeSlot>[
      for (var n = 1; n <= maxNumber; n++)
        VolumeSlot(
          label: '$n',
          number: n,
          item: byLabel['$n'],
          status: byLabel['$n'] == null
              ? VolumeSlotStatus.missing
              : statusOf(byLabel['$n']!),
        ),
    ];
    final specials =
        byLabel.keys.where((k) => VolumeNumber.asInt(k) == null).toList()
          ..sort(VolumeNumber.compare);
    for (final key in specials) {
      slots.add(
        VolumeSlot(
          label: key,
          item: byLabel[key],
          status: statusOf(byLabel[key]!),
        ),
      );
    }

    bool isOwned(VolumeSlot s) =>
        s.status == VolumeSlotStatus.owned ||
        s.status == VolumeSlotStatus.loaned;
    final upper = totalVolumes ?? maxNumber;
    final numbered = slots.where((s) => s.number != null && s.number! <= upper);

    return VolumeGrid(
      slots: slots,
      ownedCount: numbered.where(isOwned).length,
      totalVolumes: totalVolumes,
      missingNumbers: followed
          ? [
              for (final s in numbered)
                if (!isOwned(s)) s.number!,
            ]
          : const [],
    );
  }

  final List<VolumeSlot> slots;

  /// Owned (or loaned) numbered volumes within the series range.
  final int ownedCount;
  final int? totalVolumes;
  final List<int> missingNumbers;

  bool get isComplete =>
      totalVolumes != null && totalVolumes! > 0 && ownedCount >= totalVolumes!;
}
