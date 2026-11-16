import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/quality/data/quality_providers.dart';
import 'package:dupe/features/quality/domain/collection_quality.dart';
import 'package:dupe/features/quality/presentation/isbn_completion_parts.dart';
import 'package:dupe/features/scan/presentation/camera_scanner_view.dart';
import 'package:dupe/features/scan/presentation/code_entry_field.dart';
import 'package:dupe/features/scan/presentation/parse_scanned_code.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// "Compléter par scan" (phase 22): the owned books without ISBN one by
/// one (or only [itemId]); each scanned code is checked, then saved.
class IsbnCompletionScreen extends ConsumerStatefulWidget {
  const new({this.itemId, super.key});

  final String? itemId;

  @override
  ConsumerState<IsbnCompletionScreen> createState() => _State();
}

class _State extends ConsumerState<IsbnCompletionScreen> {
  List<Item>? _queue;
  final _seriesTitles = <String, String>{};
  var _index = 0;
  var _assigned = 0;
  var _complete = true;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final repo = ref.read(collectionRepositoryProvider);
    final id = widget.itemId;
    final queue = id == null
        ? (await ref.read(collectionQualityProvider.future))
                  .items[QualityIssue.noIsbn] ??
              const <Item>[]
        : [?await repo.getItem(id)];
    for (final s in await repo.listSeries()) {
      _seriesTitles[s.id] = s.title;
    }
    if (mounted) setState(() => _queue = queue);
  }

  Item? get _current {
    final queue = _queue;
    return queue == null || _index >= queue.length ? null : queue[_index];
  }

  void _next() => setState(() => _index++);

  Future<void> _onCode(String raw) async {
    final item = _current;
    final isbn = parseScannedCode(context, raw);
    if (item == null || isbn == null || _busy) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final assignment = ref.read(isbnAssignmentProvider);
    final seriesTitle = _seriesTitles[item.seriesId];
    setState(() => _busy = true);
    try {
      final check = await assignment.check(
        item,
        isbn,
        seriesTitle: seriesTitle,
      );
      if (!mounted) return;
      if (check.duplicate case final other?) {
        final see = await askIsbnQuestion(
          context,
          message: l10n.isbnCompletionDuplicate(other.title),
          yes: l10n.isbnCompletionSeeDuplicate,
        );
        if (see && mounted) {
          unawaited(context.push(AppRoutes.item(other.type, other.id)));
        }
        return;
      }
      if (!check.coherent) {
        final ok = await askIsbnQuestion(
          context,
          message: l10n.isbnCompletionMismatch(check.found!.title, item.title),
          yes: l10n.isbnCompletionAssignAnyway,
          yesKey: const Key('isbnAssignAnyway'),
        );
        if (!ok) return;
      }
      await assignment.assign(
        item,
        isbn,
        found: check.found,
        complete: _complete,
        seriesTitle: seriesTitle,
      );
      _assigned++;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.isbnCompletionSaved(item.title))),
        );
      if (mounted) _next();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final queue = _queue;
    final item = _current;
    final panel = switch ((queue, item)) {
      (null, _) => const Center(child: CircularProgressIndicator()),
      (_, null) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.isbnCompletionDone(_assigned),
          key: const Key('isbnCompletionDone'),
        ),
      ),
      (final q?, final current?) => IsbnCompletionCard(
        item: current,
        seriesTitle: _seriesTitles[current.seriesId],
        position: _index + 1,
        total: q.length,
        complete: _complete,
        onComplete: (v) => setState(() => _complete = v),
        onSkip: _next,
      ),
    };
    final camera = defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.isbnCompletionTitle)),
      body: camera && item != null
          ? CameraScannerView(onCode: _onCode, panel: panel)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                panel,
                if (item != null) ...[
                  const SizedBox(height: 16),
                  CodeEntryField(onSubmitted: _onCode),
                ],
              ],
            ),
    );
  }
}
