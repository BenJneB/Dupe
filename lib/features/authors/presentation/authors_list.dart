import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/router.dart';
import 'package:dupe/features/authors/data/author_providers.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// "Par auteur" view of a tab: one row per author, sorted by last name.
class AuthorsList extends ConsumerWidget {
  const new({required this.type, super.key});

  final CollectionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(visibleAuthorGroupsProvider(type))) {
      AsyncData(:final value) => ListView.builder(
        key: const Key('authorsList'),
        itemCount: value.length,
        itemBuilder: (context, i) => AuthorTile(type: type, group: value[i]),
      ),
      AsyncError(:final error) => Center(
        child: Text(l10n.loadError(errorText(l10n, error))),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class AuthorTile extends StatelessWidget {
  const new({required this.type, required this.group, super.key});

  final CollectionType type;
  final AuthorGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = group.isUnknown ? l10n.unknownAuthor : group.name;
    return ListTile(
      key: ValueKey('author-${group.key}'),
      leading: CircleAvatar(
        child: group.isUnknown
            ? const Icon(Icons.person_outline)
            : Text(_initials(group.name)),
      ),
      title: Text(name),
      subtitle: Text(
        l10n.authorSummary(
          group.series.length,
          group.books.length,
          group.volumes,
        ),
      ),
      onTap: () => context.push(AppRoutes.author(type, group.name)),
    );
  }

  static String _initials(String name) => name
      .split(' ')
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w.characters.first.toUpperCase())
      .join();
}
