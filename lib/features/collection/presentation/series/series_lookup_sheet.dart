import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/core/metadata/series_metadata.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/providers/series_lookup_provider.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Searches a series on AniList / Comic Vine; returns the chosen one.
Future<SeriesMetadata?> showSeriesLookup(
  BuildContext context, {
  required CollectionType type,
  required String initialQuery,
}) => showModalBottomSheet<SeriesMetadata>(
  context: context,
  isScrollControlled: true,
  builder: (_) => FractionallySizedBox(
    heightFactor: 0.85,
    child: _SeriesLookupSheet(type: type, initialQuery: initialQuery),
  ),
);

class _SeriesLookupSheet extends ConsumerStatefulWidget {
  const new({required this.type, required this.initialQuery});

  final CollectionType type;
  final String initialQuery;

  @override
  ConsumerState<_SeriesLookupSheet> createState() => _SeriesLookupSheetState();
}

class _SeriesLookupSheetState extends ConsumerState<_SeriesLookupSheet> {
  late final _controller = TextEditingController(text: widget.initialQuery);
  late String _query = widget.initialQuery.trim();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final results = _query.isEmpty
        ? null
        : ref.watch(seriesLookupResultsProvider(_query, widget.type));
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const Key('seriesLookupField'),
              controller: _controller,
              autofocus: _query.isEmpty,
              decoration: InputDecoration(
                labelText: l10n.seriesLookupHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (v) => setState(() => _query = v.trim()),
            ),
          ),
          Expanded(
            child: switch (results) {
              null => const SizedBox.shrink(),
              AsyncData(:final value) when value.isEmpty => Center(
                child: Text(l10n.searchNoResults(_query)),
              ),
              AsyncData(:final value) => ListView(
                children: [
                  for (final m in value)
                    ListTile(
                      leading: CoverImage(
                        url: m.coverUrl,
                        width: 40,
                        height: 60,
                      ),
                      title: Text(m.title),
                      subtitle: Text(
                        [
                          ?m.originalTitle,
                          if (m.authors.isNotEmpty) m.authors.join(', '),
                          ?m.publisher,
                          ?m.startYear?.toString(),
                          if (m.totalVolumes != null)
                            l10n.volumesOwned(m.totalVolumes!),
                          m.source.label,
                        ].join(' · '),
                      ),
                      onTap: () => Navigator.pop(context, m),
                    ),
                ],
              ),
              AsyncError(:final error) => Center(
                child: Text(l10n.loadError(errorText(l10n, error))),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}
