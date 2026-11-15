import 'package:dupe/core/utils/isbn.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/search/presentation/online_search/isbn_result_view.dart';
import 'package:dupe/features/search/presentation/online_search/text_results_view.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Search external sources by ISBN or text, then add a result.
class OnlineSearchScreen extends StatefulWidget {
  const new({this.initialQuery, this.initialType, super.key});

  final String? initialQuery;
  final CollectionType? initialType;

  @override
  State<OnlineSearchScreen> createState() => _OnlineSearchScreenState();
}

class _OnlineSearchScreenState extends State<OnlineSearchScreen> {
  late final _controller = TextEditingController(text: widget.initialQuery);
  late CollectionType _type = widget.initialType ?? CollectionType.livre;
  late String _submitted = widget.initialQuery?.trim() ?? '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => setState(() => _submitted = _controller.text.trim());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isbn = Isbn.toIsbn13(_submitted);
    final kind = Isbn.classify(_submitted);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onlineSearchTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<CollectionType>(
                showSelectedIcon: false,
                segments: [
                  for (final t in CollectionType.values)
                    ButtonSegment(value: t, label: Text(t.label(l10n))),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const Key('onlineSearchField'),
              controller: _controller,
              autofocus: widget.initialQuery == null,
              decoration: InputDecoration(
                labelText: l10n.onlineSearchHint,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: l10n.onlineSearchTitle,
                  icon: const Icon(Icons.travel_explore),
                  onPressed: _submit,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submit(),
            ),
          ),
          Expanded(
            child: switch (_submitted) {
              '' => Center(child: Text(l10n.onlineSearchPrompt)),
              _ when isbn != null => IsbnResultView(isbn13: isbn, type: _type),
              _ when kind == CodeKind.upc => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.upcNotSupported,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              final query => TextResultsView(query: query, type: _type),
            },
          ),
        ],
      ),
    );
  }
}
