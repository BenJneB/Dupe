import 'dart:async';
import 'dart:math' as math;

import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/reading_actions.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/next_read.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// "Que lire maintenant ?": a book drawn from the owned books not started
/// yet (`nextReadCandidates`), another one on demand.
Future<void> showNextRead(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) => const NextReadSheet(),
);

class NextReadSheet extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<NextReadSheet> createState() => _NextReadSheetState();
}

class _NextReadSheetState extends ConsumerState<NextReadSheet> {
  final _random = math.Random();
  List<NextRead>? _candidates;
  NextRead? _pick;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final items = await ref.read(collectionRepositoryProvider).listItems();
    if (!mounted) return;
    final candidates = nextReadCandidates(items);
    setState(() {
      _candidates = candidates;
      _pick = pickNextRead(candidates, _random);
    });
  }

  void _another() => setState(
    () => _pick = pickNextRead(_candidates!, _random, exceptId: _pick?.item.id),
  );

  Future<void> _start(NextRead pick) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref
        .read(collectionRepositoryProvider)
        .setReadingStatus(
          pick.item,
          ReadingStatus.enCours,
          today: ref.read(clockProvider)(),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.nextReadStarted)));
  }

  void _open(NextRead pick) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(AppRoutes.item(pick.item.type, pick.item.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final candidates = _candidates;
    final pick = _pick;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.moreNextRead,
              style: text.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (candidates == null)
              const CircularProgressIndicator()
            else if (pick == null)
              Text(l10n.nextReadEmpty, textAlign: TextAlign.center)
            else ...[
              CoverImage(url: pick.item.coverUrl, width: 120, height: 180),
              const SizedBox(height: 12),
              Text(
                pick.item.displayTitle(l10n),
                key: const Key('nextReadTitle'),
                style: text.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (pick.item.authors.isNotEmpty)
                Text(pick.item.authors.join(', '), style: text.bodyMedium),
              if (pick.continues)
                Text(
                  l10n.nextReadContinues,
                  style: text.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  if (candidates.length > 1)
                    OutlinedButton.icon(
                      key: const Key('nextReadAnother'),
                      onPressed: _another,
                      icon: const Icon(Icons.casino_outlined),
                      label: Text(l10n.nextReadAnother),
                    ),
                  OutlinedButton(
                    key: const Key('nextReadOpen'),
                    onPressed: () => _open(pick),
                    child: Text(l10n.nextReadOpen),
                  ),
                  FilledButton.icon(
                    key: const Key('nextReadStart'),
                    onPressed: () => _start(pick),
                    icon: const Icon(Icons.auto_stories_outlined),
                    label: Text(l10n.nextReadStart),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
