import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/collection/presentation/series/volume_slot_colors.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The volumes of a series as rows: cover, number, the volume's own title
/// (BnF: "Les renforts maléfiques") and its status. Same taps as the grid.
class VolumeListView extends StatelessWidget {
  const new({
    required this.series,
    required this.grid,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final Series series;
  final VolumeGrid grid;
  final ValueChanged<VolumeSlot> onTap;
  final ValueChanged<VolumeSlot> onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      key: const Key('volumeList'),
      children: [
        for (final slot in grid.slots)
          ListTile(
            key: ValueKey('volumeRow-${slot.label}'),
            contentPadding: EdgeInsets.zero,
            leading: CoverImage(
              url: slot.item?.coverUrl,
              width: 32,
              height: 48,
            ),
            title: Text(l10n.volumeLabel(slot.label)),
            subtitle: Text(
              [
                ?slot.ownTitle(series.title),
                slot.status.label(l10n),
                if (slot.isRead) ReadingStatus.lu.label(l10n),
                if (slot.copies.length > 1) '×${slot.copies.length}',
              ].join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: volumeSlotColors(slot.status, scheme).background,
                shape: BoxShape.circle,
                border: switch (volumeSlotColors(slot.status, scheme).border) {
                  final color? => Border.all(color: color),
                  null => null,
                },
              ),
            ),
            onTap: () => onTap(slot),
            onLongPress: () => onLongPress(slot),
          ),
      ],
    );
  }
}
