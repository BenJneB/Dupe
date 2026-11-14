import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/search/presentation/search_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Global search over the whole local collection.
class SearchScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
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
    final query = _query.trim();
    final results = query.isEmpty
        ? null
        : ref.watch(localSearchProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const Key('searchField'),
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              tooltip: l10n.clear,
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() {
                _controller.clear();
                _query = '';
              }),
            ),
        ],
      ),
      body: switch (results) {
        null => PlaceholderBody(icon: Icons.search, title: l10n.searchPrompt),
        AsyncValue(:final value?)
            when value.series.isEmpty && value.items.isEmpty =>
          PlaceholderBody(
            icon: Icons.search_off,
            title: l10n.searchNoResults(query),
          ),
        AsyncValue(:final value?) => ListView(
          children: [
            if (value.series.isNotEmpty) _Header(l10n.searchSeriesSection),
            for (final s in value.series)
              ListTile(
                leading: CoverImage(url: s.coverUrl, width: 32, height: 48),
                title: Text(s.title),
                subtitle: Text(s.type.label(l10n)),
                onTap: () => context.go(AppRoutes.series(s.type, s.id)),
              ),
            if (value.items.isNotEmpty) _Header(l10n.searchItemsSection),
            for (final i in value.items)
              ListTile(
                leading: CoverImage(url: i.coverUrl, width: 32, height: 48),
                title: Text(
                  i.volumeNumber == null
                      ? i.title
                      : l10n.volumeTitle(i.title, i.volumeNumber!),
                ),
                subtitle: Text(
                  '${i.type.label(l10n)} · ${i.ownership.label(l10n)}',
                ),
                trailing: i.ownership == Ownership.possede
                    ? Icon(Icons.check_circle, color: Colors.green.shade600)
                    : const Icon(Icons.favorite_border),
                onTap: () => context.go(AppRoutes.item(i.type, i.id)),
              ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Text(l10n.loadError('$error')),
        ),
        _ => const LinearProgressIndicator(),
      },
    );
  }
}

class _Header extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}
