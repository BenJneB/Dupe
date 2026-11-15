import 'package:dupe/app/router.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Author names of a book or series; each opens the author's page.
class AuthorLinks extends StatelessWidget {
  const new({required this.type, required this.authors, super.key});

  final CollectionType type;
  final List<String> authors;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 4,
    children: [
      for (final raw in authors)
        if (raw.trim().isNotEmpty)
          ActionChip(
            key: ValueKey('authorLink-${authorKey(raw)}'),
            avatar: const Icon(Icons.person_outline, size: 18),
            label: Text(displayAuthorName(raw)),
            // go, not push: the stack becomes tab > author, so "back"
            // returns to the tab instead of replaying every page visited.
            onPressed: () =>
                context.go(AppRoutes.author(type, displayAuthorName(raw))),
          ),
    ],
  );
}
