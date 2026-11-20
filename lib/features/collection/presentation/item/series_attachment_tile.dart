import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/series_attachment.dart';
import 'package:dupe/features/collection/presentation/item/series_picker_sheet.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Which series the book goes into: the matched or current one, a proposed
/// new one, or none. A tap lets the user file it elsewhere by hand (books
/// the sources do not link, other editions…).
class SeriesAttachmentTile extends ConsumerWidget {
  const new({
    required this.attachment,
    required this.onChanged,
    required this.type,
    required this.suggestedTitle,
    this.linked = false,
    super.key,
  });

  /// The book points to a series this device does not know (not synced
  /// yet): kept on save unless the user chooses otherwise.
  final bool linked;

  final SeriesAttachment attachment;
  final ValueChanged<SeriesAttachment> onChanged;

  /// Type of the book: only series of this type are offered.
  final CollectionType type;

  /// Name proposed for a new series (the book's current title).
  final String Function() suggestedTitle;

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final series = await ref
        .read(collectionRepositoryProvider)
        .listSeries(type: type);
    if (!context.mounted) return;
    final choice = await showSeriesPicker(
      context,
      series: series,
      suggestedTitle: suggestedTitle(),
    );
    if (choice != null) onChanged(choice);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final change = IconButton(
      key: const Key('changeSeries'),
      tooltip: l10n.changeSeriesTooltip,
      icon: const Icon(Icons.edit_outlined),
      onPressed: () => _pick(context, ref),
    );
    if (attachment case CreateSeries(:final title, :final enabled)) {
      return SwitchListTile(
        key: const Key('createSeriesSwitch'),
        contentPadding: EdgeInsets.zero,
        secondary: change,
        title: Text(l10n.createSeriesNamed(title)),
        subtitle: Text(l10n.createSeriesHelper),
        value: enabled,
        onChanged: (v) => onChanged(CreateSeries(title, enabled: v)),
      );
    }
    final series = switch (attachment) {
      AttachToSeries(:final series) => series,
      _ => null,
    };
    return ListTile(
      key: Key(series == null ? 'noSeries' : 'attachedSeries'),
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.collections_bookmark),
      title: Text(switch (series) {
        final s? => l10n.attachedToSeries(s.title),
        null when linked && attachment is KeepSeries => l10n.seriesUnknown,
        null => l10n.seriesNone,
      }),
      subtitle: Text(l10n.seriesPickerHelper),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => _pick(context, ref),
    );
  }
}
