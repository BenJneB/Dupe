import 'package:dupe/features/collection/domain/series_attachment.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Shows which series a new volume goes into, or offers to create it.
class SeriesAttachmentTile extends StatelessWidget {
  const new({required this.attachment, required this.onChanged, super.key});

  final SeriesAttachment attachment;
  final ValueChanged<SeriesAttachment> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (attachment.series case final series?) {
      return ListTile(
        key: const Key('attachedSeries'),
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.collections_bookmark),
        title: Text(l10n.attachedToSeries(series.title)),
        subtitle: Text(l10n.attachedToSeriesHelper),
      );
    }
    if (attachment.newSeriesTitle case final title?) {
      return SwitchListTile(
        key: const Key('createSeriesSwitch'),
        contentPadding: EdgeInsets.zero,
        secondary: const Icon(Icons.library_add_outlined),
        title: Text(l10n.createSeriesNamed(title)),
        subtitle: Text(l10n.createSeriesHelper),
        value: attachment.createNew,
        onChanged: (v) => onChanged(attachment.withCreateNew(v)),
      );
    }
    return const SizedBox.shrink();
  }
}
