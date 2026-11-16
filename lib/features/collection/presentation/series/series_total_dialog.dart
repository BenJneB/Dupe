import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/volume_count.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// "AniList : « One Piece », 107 tomes (édition japonaise)".
String volumeCountHint(AppLocalizations l10n, VolumeCountProposal p) =>
    switch (p.match.source) {
      SeriesSource.anilist => l10n.totalFromAniList(p.match.title, p.total),
      SeriesSource.comicVine => l10n.totalFromComicVine(p.match.title, p.total),
    };

/// Asks for the total number of volumes of a series, prefilled with
/// [suggested] ([hint] says where it comes from). Null when dismissed.
Future<int?> askSeriesTotal(
  BuildContext context, {
  required String title,
  int? suggested,
  String? hint,
}) => showDialog<int>(
  context: context,
  builder: (context) =>
      _SeriesTotalDialog(title: title, suggested: suggested, hint: hint),
);

class _SeriesTotalDialog extends StatefulWidget {
  const new({required this.title, this.suggested, this.hint});

  final String title;
  final int? suggested;
  final String? hint;

  @override
  State<_SeriesTotalDialog> createState() => _SeriesTotalDialogState();
}

class _SeriesTotalDialogState extends State<_SeriesTotalDialog> {
  late final _total = TextEditingController(
    text: widget.suggested?.toString() ?? '',
  );

  @override
  void dispose() {
    _total.dispose();
    super.dispose();
  }

  int? get _value {
    final n = int.tryParse(_total.text.trim());
    return n == null || n <= 0 ? null : n;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hint = widget.hint;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hint != null) ...[Text(hint), const SizedBox(height: 12)],
          TextField(
            key: const Key('seriesTotalField'),
            controller: _total,
            autofocus: hint == null,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: l10n.fieldTotalVolumes),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.seriesTotalHelp,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.later),
        ),
        FilledButton(
          key: const Key('saveSeriesTotal'),
          onPressed: _value == null
              ? null
              : () => Navigator.pop(context, _value),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
