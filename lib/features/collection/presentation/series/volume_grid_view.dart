import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/series/volume_slot_colors.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Grid of colored pastilles, one per volume.
class VolumeGridView extends StatelessWidget {
  const new({
    required this.grid,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final VolumeGrid grid;
  final ValueChanged<VolumeSlot> onTap;
  final ValueChanged<VolumeSlot> onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final slot in grid.slots)
              _Pastille(
                slot: slot,
                semanticLabel: l10n.slotSemantics(
                  slot.label,
                  [
                    slot.status.label(l10n),
                    if (slot.isRead) ReadingStatus.lu.label(l10n),
                  ].join(', '),
                ),
                onTap: () => onTap(slot),
                onLongPress: () => onLongPress(slot),
              ),
          ],
        ),
        const SizedBox(height: 12),
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
      ],
    );
  }
}

class _Pastille extends StatelessWidget {
  const new({
    required this.slot,
    required this.semanticLabel,
    required this.onTap,
    required this.onLongPress,
  });

  final VolumeSlot slot;
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
