import 'dart:async';

import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/releases/data/release_checker.dart';
import 'package:dupe/features/releases/data/release_wish.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Plus → "Nouveautés" (PLAN_V4 phase 33): new volumes of the followed
/// series and new books of the followed authors, to wish or ignore. The new
/// ones become seen when the screen is left.
class ReleasesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ReleasesScreen> createState() => _ReleasesScreenState();
}

class _ReleasesScreenState extends ConsumerState<ReleasesScreen> {
  // Read now: dispose() must not use ref.
  late final ReleasesRepository _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = ref.read(releasesRepositoryProvider);
  }

  @override
  void dispose() {
    unawaited(_alerts.markAllSeen());
    super.dispose();
  }

  Future<void> _check() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final found = await ref.read(releaseCheckerProvider.notifier).run();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.releasesFound(found))));
  }

  Future<void> _wish(ReleaseAlert a) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await addAlertToWishes(ref.read(collectionRepositoryProvider), _alerts, a);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.releaseWished(a.title))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alerts = ref.watch(releaseAlertsProvider).value ?? const [];
    final running = ref.watch(releaseCheckerProvider).running;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.releasesTitle),
        actions: [
          IconButton(
            key: const Key('checkReleases'),
            tooltip: l10n.releasesCheckNow,
            icon: const Icon(Icons.refresh),
            onPressed: running ? null : () => unawaited(_check()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (running) const LinearProgressIndicator(),
          Text(l10n.releasesHelp, style: Theme.of(context).textTheme.bodySmall),
          if (alerts.isEmpty && !running)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(l10n.releasesNone, textAlign: TextAlign.center),
            ),
          for (final a in alerts)
            Card(
              key: ValueKey('release-${a.key}'),
              margin: const EdgeInsets.only(top: 12),
              child: ListTile(
                leading: CoverImage(url: a.coverUrl),
                title: Text(
                  a.volumeNumber == null
                      ? a.title
                      : l10n.releaseVolume(a.title, a.volumeNumber!),
                ),
                subtitle: Text(
                  [
                    if (a.status == AlertStatus.nouveau) l10n.releaseNew,
                    if (a.kind == AlertKind.auteur)
                      l10n.releaseByAuthor(a.authorName ?? ''),
                    ?a.publisher,
                    ?a.publishDate,
                  ].join(' · '),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: ValueKey('wishRelease-${a.key}'),
                      tooltip: l10n.suggestionAddWish,
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () => unawaited(_wish(a)),
                    ),
                    IconButton(
                      key: ValueKey('ignoreRelease-${a.key}'),
                      tooltip: l10n.releaseIgnore,
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          unawaited(_alerts.setStatus(a, AlertStatus.ignore)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
