import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/search/presentation/online_search/add_from_result.dart';
import 'package:dupe/features/search/presentation/online_search/online_search_providers.dart';
import 'package:dupe/features/search/presentation/online_search/result_summary.dart';
import 'package:dupe/features/search/presentation/online_search/source_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Results of a free-text search across sources.
class TextResultsView extends ConsumerWidget {
  const new({required this.query, required this.type, super.key});

  final String query;
  final CollectionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(onlineTextSearchProvider(query, type))) {
      AsyncData(:final value) when value.results.isEmpty => PlaceholderBody(
        icon: Icons.search_off,
        title: l10n.searchNoResults(query),
        message: value.failed.isEmpty
            ? null
            : l10n.sourcesUnavailable(
                value.failed.map((s) => s.label).join(', '),
              ),
      ),
      AsyncData(:final value) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount: value.results.length,
        itemBuilder: (context, index) {
          final r = value.results[index];
          return ListTile(
            leading: CoverImage(url: r.coverUrl, width: 40, height: 60),
            title: Text(resultTitle(l10n, r)),
            subtitle: Text(resultSubtitle(r)),
            trailing: const Icon(Icons.add),
            onTap: () => addFromResult(context, r, type),
          );
        },
      ),
      AsyncError(:final error) => Center(child: Text(l10n.loadError('$error'))),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
