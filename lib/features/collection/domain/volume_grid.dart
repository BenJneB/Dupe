import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/features/collection/domain/volume_number.dart';

/// Status of one slot (pastille) in the series volume grid.
enum VolumeSlotStatus { owned, loaned, wished, missing }

class VolumeSlot {
  const new({
    required this.label,
    required this.status,
    this.number,
    this.item,
    this.copies = const [],
  });

  /// Displayed text ("12", "HS 2").
  final String label;
  final VolumeSlotStatus status;

  /// Integer volume number, when the slot is a plain numbered volume.
  final int? number;

  /// Representative item (best status) for this slot; null when missing.
  final Item? item;

  /// Every copy of this volume (editions, variants), best status first.
  final List<Item> copies;

  /// An owned copy of this volume has been read.
  bool get isRead => copies.any(
    (i) =>
        i.ownership == Ownership.possede && i.readingStatus == ReadingStatus.lu,
  );
}

/// Mangacollec-like view of a series: one slot per volume number.
class VolumeGrid {
  const new({
    required this.slots,
    required this.ownedCount,
    required this.totalVolumes,
    required this.missingNumbers,
    this.toReadCount = 0,
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

    final copies = <String, List<Item>>{};
    final unnumbered = <Item>[];
    for (final item in items) {
      final key = VolumeNumber.key(item.volumeNumber);
      if (key == null) {
        unnumbered.add(item);
        continue;
      }
      (copies[key] ??= []).add(item);
    }
    for (final list in copies.values) {
      list.sort((a, b) => statusOf(a).index.compareTo(statusOf(b).index));
    }
    final byLabel = {
      for (final MapEntry(:key, :value) in copies.entries) key: value.first,
    };

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
          copies: copies['$n'] ?? const [],
          status: byLabel['$n'] == null
              ? VolumeSlotStatus.missing
              : statusOf(byLabel['$n']!),
        ),
    ];
    final specials =
        // "0" is not in 1..max: shown with the specials ("HS 1").
        byLabel.keys.where((k) => (VolumeNumber.asInt(k) ?? 0) < 1).toList()
          ..sort(VolumeNumber.compare);
    for (final key in specials) {
      slots.add(
        VolumeSlot(
          label: key,
          item: byLabel[key],
          copies: copies[key]!,
          status: statusOf(byLabel[key]!),
        ),
      );
    }
    // Volumes without number (source without one): shown last as "?", so
    // that they can be opened and numbered.
    for (final item in unnumbered) {
      slots.add(
        VolumeSlot(
          label: '?',
          item: item,
          copies: [item],
          status: statusOf(item),
        ),
      );
    }

    bool isOwned(VolumeSlot s) =>
        s.status == VolumeSlotStatus.owned ||
        s.status == VolumeSlotStatus.loaned;
    final upper = totalVolumes ?? maxNumber;
    final numbered = slots.where((s) => s.number != null && s.number! <= upper);

    // A volume is to read when no owned copy of it has been read.
    bool isToRead(VolumeSlot s) =>
        isOwned(s) &&
        s.copies.every(
          (i) =>
              i.ownership != Ownership.possede ||
              toReadStatuses.contains(i.readingStatus),
        );

    return VolumeGrid(
      slots: slots,
      toReadCount: slots.where(isToRead).length,
      // Without a total, every owned volume counts ("3,5", "HS 1", "?").
      ownedCount: totalVolumes == null
          ? slots.where(isOwned).length
          : numbered.where(isOwned).length,
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

  /// Owned (or loaned) numbered volumes within the series total, or every
  /// owned volume when the total is unknown.
  final int ownedCount;
  final int? totalVolumes;
  final List<int> missingNumbers;

  /// Owned volumes not read yet ("Ma pile à lire").
  final int toReadCount;

  bool get isComplete =>
      totalVolumes != null && totalVolumes! > 0 && ownedCount >= totalVolumes!;
}

extension VolumeGridRange on VolumeGrid {
  /// Last volume proposed by "Ajouter des tomes": the total when known;
  /// otherwise the highest volume present when there are gaps to fill
  /// (1 and 3 -> 3, never an unknown 4), else the next volume.
  int get suggestedRangeEnd {
    if (totalVolumes case final total? when total > 0) return total;
    final present = {
      for (final s in slots)
        if (s.number != null && s.item != null) s.number!,
    };
    if (present.isEmpty) return 1;
    final highest = present.reduce((a, b) => a > b ? a : b);
    return present.length < highest ? highest : highest + 1;
  }
}

extension VolumeGridCover on VolumeGrid {
  /// Cover of the first volume that has one: stands for a series without
  /// its own cover (series created while scanning).
  String? get firstCover {
    for (final slot in slots) {
      for (final copy in slot.copies) {
        final url = copy.coverUrl;
        if (url != null && url.isNotEmpty) return url;
      }
    }
    return null;
  }
}

extension VolumeSlotTitle on VolumeSlot {
  /// The volume's own title: its `volumeTitle`, else (volumes added before
  /// that field) its title when it is not the series title.
  String? ownTitle(String seriesTitle) {
    for (final copy in copies) {
      final own = copy.volumeTitle?.trim();
      if (own != null && own.isNotEmpty) return own;
    }
    final title = item?.title.trim();
    if (title == null || title.isEmpty) return null;
    return normalizeTitle(title) == normalizeTitle(seriesTitle) ? null : title;
  }
}
