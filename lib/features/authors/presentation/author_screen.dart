import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/app/widgets/load_error_view.dart';
import 'package:dupe/app/widgets/placeholder_body.dart';
import 'package:dupe/features/authors/data/author_providers.dart';
import 'package:dupe/features/authors/presentation/author_menu.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/collection_tab/entries_list.dart';
import 'package:dupe/features/releases/presentation/follow_author_button.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Everything of one author in a tab: series, then standalone books.
class AuthorScreen extends ConsumerWidget {
  const new({required this.type, required this.name, super.key});

  final CollectionType type;

  /// Author name; empty for the books without author.
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final group = ref.watch(authorGroupProvider(type, name));
    return Scaffold(
      appBar: AppBar(
        title: Text(name.isEmpty ? l10n.unknownAuthor : name),
        actions: [
          if (name.isNotEmpty) FollowAuthorButton(name: name),
          if (group case AsyncData(value: final g?)) AuthorMenu(group: g),
        ],
      ),
      body: switch (group) {
        AsyncData(value: final group?) => ListView(
          key: const Key('authorPage'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                l10n.authorSummary(
                  group.series.length,
                  group.books.length,
                  group.volumes,
                ),
              ),
            ),
            if (group.series.isNotEmpty) ListSectionHeader(l10n.authorSeries),
            for (final s in group.series) EntryTile(type: type, entry: s),
            if (group.books.isNotEmpty) ListSectionHeader(l10n.authorBooks),
            for (final b in group.books) EntryTile(type: type, entry: b),
          ],
        ),
        AsyncData() => PlaceholderBody(
          icon: Icons.person_off_outlined,
          title: l10n.authorNotFound,
        ),
        AsyncError(:final error) => LoadErrorView(error),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
