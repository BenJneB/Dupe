import 'dart:async';

import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Author view: follow [name] for new releases (PLAN_V4 phase 33).
class FollowAuthorButton extends ConsumerWidget {
  const new({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final key = authorKey(name);
    final followed = (ref.watch(followedAuthorsProvider).value ?? const []).any(
      (a) => authorKey(a.name) == key,
    );
    final repo = ref.read(releasesRepositoryProvider);
    return IconButton(
      key: const Key('followAuthor'),
      tooltip: followed ? l10n.unfollowAuthor : l10n.followAuthor,
      isSelected: followed,
      icon: const Icon(Icons.notifications_none),
      selectedIcon: const Icon(Icons.notifications_active),
      onPressed: () =>
          unawaited(followed ? repo.unfollow(name) : repo.follow(name)),
    );
  }
}
