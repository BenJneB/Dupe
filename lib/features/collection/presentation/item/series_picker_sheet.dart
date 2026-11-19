import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/series_attachment.dart';
import 'package:dupe/features/collection/domain/series_matching.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Lets the user file a book in one of [series], in a new series (typed
/// name, else [suggestedTitle]), or in none. Null when dismissed.
Future<SeriesAttachment?> showSeriesPicker(
  BuildContext context, {
  required List<Series> series,
  required String suggestedTitle,
}) => showModalBottomSheet<SeriesAttachment>(
  context: context,
  isScrollControlled: true,
  builder: (_) => FractionallySizedBox(
    heightFactor: 0.85,
    child: _SeriesPickerSheet(series: series, suggestedTitle: suggestedTitle),
  ),
);

class _SeriesPickerSheet extends StatefulWidget {
  const new({required this.series, required this.suggestedTitle});

  final List<Series> series;
  final String suggestedTitle;

  @override
  State<_SeriesPickerSheet> createState() => _SeriesPickerSheetState();
}

class _SeriesPickerSheetState extends State<_SeriesPickerSheet> {
  final _controller = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wanted = normalizeTitle(_query);
    String key(Series s) => normalizeTitle(s.title);
    final shown = widget.series.where((s) => key(s).contains(wanted)).toList()
      ..sort((a, b) => key(a).compareTo(key(b)));
    final typed = _query.trim();
    final newTitle = typed.isEmpty ? widget.suggestedTitle.trim() : typed;
    final exists = widget.series.any((s) => key(s) == normalizeTitle(newTitle));
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const Key('seriesPickerField'),
              controller: _controller,
              decoration: InputDecoration(
                labelText: l10n.seriesPickerHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (newTitle.isNotEmpty && !exists)
                  ListTile(
                    key: const Key('seriesPickerNew'),
                    leading: const Icon(Icons.library_add_outlined),
                    title: Text(l10n.createSeriesNamed(newTitle)),
                    onTap: () => Navigator.pop(
                      context,
                      SeriesAttachment(newSeriesTitle: newTitle),
                    ),
                  ),
                ListTile(
                  key: const Key('seriesPickerNone'),
                  leading: const Icon(Icons.block),
                  title: Text(l10n.seriesNone),
                  onTap: () => Navigator.pop(context, SeriesAttachment.none),
                ),
                const Divider(),
                for (final s in shown)
                  ListTile(
                    key: ValueKey('seriesPick-${s.id}'),
                    leading: const Icon(Icons.collections_bookmark_outlined),
                    title: Text(s.title),
                    subtitle: s.publisher == null ? null : Text(s.publisher!),
                    onTap: () =>
                        Navigator.pop(context, SeriesAttachment(series: s)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
