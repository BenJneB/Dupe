import 'dart:async';

import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/reading_actions.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

enum _Scope { books, all }

/// Overflow menu of an author page: mark their books as read in one go.
class AuthorMenu extends ConsumerWidget {
  const new({required this.group, super.key});

  final AuthorGroup group;

  Future<List<Item>> _items(CollectionRepository repo, _Scope scope) async => [
    for (final b in group.books) b.item,
    if (scope == _Scope.all)
      for (final s in group.series) ...await repo.listSeriesItems(s.series.id),
  ];

  Future<void> _markRead(
    BuildContext context,
    WidgetRef ref,
    _Scope scope,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // Read before any await: the menu may be gone after the dialog.
    final repo = ref.read(collectionRepositoryProvider);
    final now = ref.read(clockProvider);
    final items = await _items(repo, scope);
    final count = repo.unreadOwned(items).length;
    if (count > 0) {
      if (!context.mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.authorMarkReadQuestion(count)),
          content: Text(l10n.authorMarkReadHelp),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              key: const Key('confirmAuthorMarkRead'),
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.markReadConfirm),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    final changed = await repo.markOwnedRead(items, today: now());
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.booksMarkedRead(changed))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<_Scope>(
      key: const Key('authorMenu'),
      onSelected: (scope) => unawaited(_markRead(context, ref, scope)),
      itemBuilder: (context) => [
        if (group.books.isNotEmpty)
          PopupMenuItem(
            key: const Key('authorMarkBooksRead'),
            value: _Scope.books,
            child: Text(l10n.authorMarkBooksRead),
          ),
        PopupMenuItem(
          key: const Key('authorMarkAllRead'),
          value: _Scope.all,
          child: Text(l10n.authorMarkAllRead),
        ),
      ],
    );
  }
}
