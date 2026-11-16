import 'dart:async';

import 'package:dupe/core/utils/formatters.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/features/recommendations/data/suggestions_controller.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';
import 'package:dupe/features/recommendations/presentation/suggestion_card.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Plus → "Suggestions" (PLAN_V4 phase 30): works to discover from the
/// collection, each with its reason; computed locally, cached a week.
class SuggestionsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends ConsumerState<SuggestionsScreen> {
  CollectionType? _type;

  @override
  void initState() {
    super.initState();
    unawaited(ref.read(suggestionsProvider.notifier).ensureFresh());
  }

  Future<void> _act(
    Suggestion s,
    Future<void> Function(Suggestion) action,
    String message,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    await action(s);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(suggestionsProvider);
    final notifier = ref.read(suggestionsProvider.notifier);
    final types = {for (final s in state.suggestions) s.type};
    final shown = [
      for (final s in state.suggestions)
        if (_type == null || s.type == _type) s,
    ];
    final at = state.computedAt;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.suggestionsTitle),
        actions: [
          IconButton(
            key: const Key('refreshSuggestions'),
            tooltip: l10n.suggestionsRefresh,
            icon: const Icon(Icons.refresh),
            onPressed: state.running
                ? null
                : () => unawaited(notifier.refresh()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (state.running) ...[
            LinearProgressIndicator(
              value: state.total == 0 ? null : state.done / state.total,
            ),
            const SizedBox(height: 8),
            Text(l10n.suggestionsProgress(state.done, state.total)),
          ] else if (at != null)
            Text(
              l10n.suggestionsComputedAt(
                Formatters.date(at.toLocal(), l10n.localeName),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (state.failed)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.suggestionsFailed,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (types.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.filterAll),
                    selected: _type == null,
                    onSelected: (_) => setState(() => _type = null),
                  ),
                  for (final t in CollectionType.values)
                    if (types.contains(t))
                      ChoiceChip(
                        key: ValueKey('suggestionType-${t.name}'),
                        label: Text(t.label(l10n)),
                        selected: _type == t,
                        onSelected: (_) => setState(() => _type = t),
                      ),
                ],
              ),
            ),
          if (shown.isEmpty && state.loaded && !state.running)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(l10n.suggestionsEmpty, textAlign: TextAlign.center),
            ),
          for (final s in shown)
            SuggestionCard(
              key: ValueKey('suggestion-${s.key}'),
              suggestion: s,
              onWish: () => unawaited(
                _act(s, notifier.addToWishes, l10n.suggestionWished(s.title)),
              ),
              onDismiss: () => unawaited(
                _act(s, notifier.dismiss, l10n.suggestionDismissed),
              ),
            ),
        ],
      ),
    );
  }
}
