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

  /// Series with their normalized title, sorted once: the sheet is built
  /// anew by [showSeriesPicker] each time, with the list of that moment.
  late final List<({Series series, String key})> _keyed = [
    for (final s in widget.series) (series: s, key: normalizeTitle(s.title)),
  ]..sort((a, b) => a.key.compareTo(b.key));
  late final Set<String> _keys = {for (final e in _keyed) e.key};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wanted = normalizeTitle(_query);
    final shown = [
      for (final e in _keyed)
        if (e.key.contains(wanted)) e.series,
    ];
    final typed = _query.trim();
    final newTitle = typed.isEmpty ? widget.suggestedTitle.trim() : typed;
    final exists = _keys.contains(normalizeTitle(newTitle));
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
                    onTap: () => Navigator.pop(context, CreateSeries(newTitle)),
                  ),
                ListTile(
                  key: const Key('seriesPickerNone'),
                  leading: const Icon(Icons.block),
                  title: Text(l10n.seriesNone),
                  onTap: () =>
                      Navigator.pop(context, SeriesAttachment.detached),
                ),
                const Divider(),
                for (final s in shown)
                  ListTile(
                    key: ValueKey('seriesPick-${s.id}'),
                    leading: const Icon(Icons.collections_bookmark_outlined),
                    title: Text(s.title),
                    subtitle: s.publisher == null ? null : Text(s.publisher!),
                    onTap: () => Navigator.pop(context, AttachToSeries(s)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
