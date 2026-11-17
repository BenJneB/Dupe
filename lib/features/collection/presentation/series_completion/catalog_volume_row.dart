import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/core/metadata/metadata_result.dart';
import 'package:dupe/features/collection/domain/series_catalog.dart';
import 'package:dupe/features/collection/domain/series_completion.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// One volume of the catalog: number, ISBN (several editions: a menu),
/// and what to do with it, or its state when it is already there.
class CatalogVolumeRow extends StatelessWidget {
  const new({
    required this.volume,
    required this.record,
    required this.state,
    required this.choice,
    required this.onChoice,
    required this.onRecord,
    super.key,
  });

  final CatalogVolume volume;
  final MetadataResult record;
  final VolumeState state;
  final VolumeChoice choice;
  final ValueChanged<VolumeChoice> onChoice;
  final ValueChanged<MetadataResult> onRecord;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final n = volume.number;
    return ListTile(
      key: ValueKey('catalogVolume-$n'),
      leading: CoverImage(url: record.coverUrl, width: 32, height: 48),
      title: Text(l10n.volumeLabel('$n')),
      subtitle: Text(switch (state) {
        VolumeState.complete => l10n.catalogComplete,
        VolumeState.missingIsbn => l10n.catalogIsbnAdded(record.isbn13 ?? ''),
        VolumeState.absent => record.isbn13 ?? '',
      }),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (volume.records.length > 1 && state != VolumeState.complete)
            PopupMenuButton<MetadataResult>(
              key: ValueKey('catalogIsbns-$n'),
              tooltip: l10n.catalogOtherIsbns(volume.records.length),
              icon: Badge(
                label: Text('${volume.records.length}'),
                child: const Icon(Icons.layers_outlined),
              ),
              onSelected: onRecord,
              itemBuilder: (_) => [
                for (final r in volume.records)
                  CheckedPopupMenuItem(
                    value: r,
                    checked: r.isbn13 == record.isbn13,
                    child: Text([?r.isbn13, ?r.publishDate].join(' · ')),
                  ),
              ],
            ),
          if (state == VolumeState.absent)
            SegmentedButton<VolumeChoice>(
              key: ValueKey('catalogChoice-$n'),
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: VolumeChoice.owned,
                  icon: const Icon(Icons.check, size: 18),
                  tooltip: l10n.ownershipOwned,
                ),
                ButtonSegment(
                  value: VolumeChoice.wish,
                  icon: const Icon(Icons.favorite_border, size: 18),
                  tooltip: l10n.ownershipWished,
                ),
                ButtonSegment(
                  value: VolumeChoice.skip,
                  icon: const Icon(Icons.remove, size: 18),
                  tooltip: l10n.catalogSkip,
                ),
              ],
              selected: {choice},
              onSelectionChanged: (s) => onChoice(s.single),
            ),
        ],
      ),
    );
  }
}
