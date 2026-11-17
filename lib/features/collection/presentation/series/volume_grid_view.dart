import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item_checks.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/series/volume_slot_colors.dart';
import 'package:dupe/features/quality/data/quality_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Grid of colored pastilles, one per volume, under its legend (visible
/// without scrolling through a long series).
class VolumeGridView extends ConsumerWidget {
  const new({
    required this.grid,
    required this.onTap,
    required this.onLongPress,
    this.seriesTitle,
    super.key,
  });

  final VolumeGrid grid;

  /// To show each volume's own title under its pastille (phase 24).
  final String? seriesTitle;
  final ValueChanged<VolumeSlot> onTap;
  final ValueChanged<VolumeSlot> onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Quality setting (phase 22): dot on owned volumes without ISBN.
    final markIsbn = ref.watch(missingIsbnInGridProvider).value ?? false;
    final series = seriesTitle;
    final titles = {
      for (final slot in grid.slots)
        if (series != null) slot: slot.ownTitle(series),
    };
    // Same column width for every volume once one has a title.
    final titled = titles.values.any((t) => t != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            for (final status in VolumeSlotStatus.values)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Dot(colors: volumeSlotColors(status, scheme)),
                  const SizedBox(width: 6),
                  Text(
                    status.label(l10n),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check, size: 14),
                const SizedBox(width: 4),
                Text(
                  ReadingStatus.lu.label(l10n),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final slot in grid.slots)
              if (!titled)
                _pastille(context, slot, markIsbn: markIsbn)
              else
                SizedBox(
                  width: 76,
                  child: Column(
                    children: [
                      _pastille(context, slot, markIsbn: markIsbn),
                      if (titles[slot] case final title?)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            title,
                            key: ValueKey('volumeTitle-${slot.label}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                    ],
                  ),
                ),
          ],
        ),
      ],
    );
  }

  Widget _pastille(
    BuildContext context,
    VolumeSlot slot, {
    required bool markIsbn,
  }) {
    final l10n = AppLocalizations.of(context);
    return _Pastille(
      slot: slot,
      missingIsbn: markIsbn && slot.copies.any((c) => c.lacksIsbn),
      semanticLabel: l10n.slotSemantics(
        slot.label,
        [
          slot.status.label(l10n),
          if (slot.isRead) ReadingStatus.lu.label(l10n),
        ].join(', '),
      ),
      onTap: () => onTap(slot),
      onLongPress: () => onLongPress(slot),
    );
  }
}

class _Pastille extends StatelessWidget {
  const new({
    required this.slot,
    required this.semanticLabel,
    required this.onTap,
    required this.onLongPress,
    this.missingIsbn = false,
  });

  final VolumeSlot slot;

  /// Owned without ISBN (quality setting): small dot at the bottom.
  final bool missingIsbn;
  final String semanticLabel;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = volumeSlotColors(slot.status, Theme.of(context).colorScheme);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: colors.border == null
          ? BorderSide.none
          : BorderSide(color: colors.border!),
    );
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Badge(
        // Several copies of this volume (editions).
        isLabelVisible: slot.copies.length > 1,
        label: Text('×${slot.copies.length}'),
        child: Badge(
          key: missingIsbn ? ValueKey('noIsbn-${slot.label}') : null,
          isLabelVisible: missingIsbn,
          smallSize: 9,
          alignment: AlignmentDirectional.bottomEnd,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: Material(
            key: ValueKey('slot-${slot.label}'),
            color: colors.background,
            shape: shape,
            child: InkWell(
              customBorder: shape,
              onTap: onTap,
              onLongPress: onLongPress,
              child: Container(
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (slot.isRead)
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.check,
                          key: ValueKey('read-${slot.label}'),
                          size: 14,
                          color: colors.foreground,
                        ),
                      ),
                    if (slot.copies.any((c) => c.isSigned))
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.draw,
                          key: ValueKey('signed-${slot.label}'),
                          size: 14,
                          color: colors.foreground,
                        ),
                      ),
                    Text(
                      slot.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const new({required this.colors});

  final ({Color background, Color foreground, Color? border}) colors;

  @override
  Widget build(BuildContext context) => Container(
    width: 12,
    height: 12,
    decoration: BoxDecoration(
      color: colors.background,
      shape: BoxShape.circle,
      border: colors.border == null ? null : Border.all(color: colors.border!),
    ),
  );
}
