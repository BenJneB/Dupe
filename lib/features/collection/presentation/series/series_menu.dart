import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/reading_actions.dart';
import 'package:dupe/features/collection/domain/series.dart';
import 'package:dupe/features/collection/domain/volume_grid.dart';
import 'package:dupe/features/collection/presentation/confirm_delete_dialog.dart';
import 'package:dupe/features/collection/presentation/series/mark_read_dialog.dart';
import 'package:dupe/features/collection/presentation/undo_delete.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

enum _Action { markRead, edit, delete }

/// Overflow menu of the series sheet.
class SeriesMenu extends ConsumerWidget {
  const new({required this.series, required this.grid, super.key});

  final Series series;
  final VolumeGrid grid;

  Future<void> _markRead(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final lastOwned = grid.slots
        .where((s) => s.number != null && s.item != null)
        .map((s) => s.number!)
        .fold(0, (a, b) => a > b ? a : b);
    final upTo = await askReadUpTo(
      context,
      suggested: lastOwned > 0 ? lastOwned : 1,
    );
    if (upTo == null) return;
    final changed = await ref
        .read(collectionRepositoryProvider)
        .markReadUpTo(series.id, upTo, today: ref.read(clockProvider)());
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.volumesMarkedRead(changed))),
    );
  }

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    _Action action,
  ) async {
    final l10n = AppLocalizations.of(context);
    switch (action) {
      case _Action.markRead:
        await _markRead(context, ref);
      case _Action.edit:
        await context.push(AppRoutes.seriesEdit(series.type, series.id));
      case _Action.delete:
        final ok = await confirmDelete(
          context,
          l10n.deleteSeriesMessage(series.title),
        );
        if (!ok || !context.mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        final repo = ref.read(collectionRepositoryProvider);
        await repo.deleteSeries(series.id);
        showUndoDelete(
          messenger,
          l10n,
          l10n.seriesDeleted(series.title),
          () => repo.restoreSeries(series.id),
        );
        if (context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<_Action>(
      key: const Key('seriesMenu'),
      onSelected: (a) => unawaited(_onSelected(context, ref, a)),
      itemBuilder: (context) => [
        PopupMenuItem(
          key: const Key('markReadAction'),
          value: _Action.markRead,
          child: Text(l10n.markReadTitle),
        ),
        PopupMenuItem(value: _Action.edit, child: Text(l10n.edit)),
        PopupMenuItem(value: _Action.delete, child: Text(l10n.delete)),
      ],
    );
  }
}
