import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/authors/domain/author_groups.dart';
import 'package:dupe/features/recommendations/domain/suggestion.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// "Parce que tu as 12 livres de Larcenet": why [s] is suggested.
String reasonText(AppLocalizations l10n, Suggestion s) {
  final r = s.reason;
  return switch (r.kind) {
    SuggestionKind.sameAuthor => l10n.reasonSameAuthor(r.count, r.label),
    SuggestionKind.community => l10n.reasonCommunity(r.label, s.votes),
    SuggestionKind.related => l10n.reasonRelated(r.label),
  };
}

/// One suggestion: cover, title, authors, reason, and its two actions.
class SuggestionCard extends StatelessWidget {
  const new({
    required this.suggestion,
    required this.onWish,
    required this.onDismiss,
    super.key,
  });

  final Suggestion suggestion;
  final VoidCallback onWish;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final s = suggestion;
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverImage(url: s.coverUrl, width: 72, height: 108),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.title, style: text.titleMedium),
                  if (s.authors.isNotEmpty)
                    Text(
                      s.authors.map(displayAuthorName).join(', '),
                      style: text.bodySmall,
                    ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          reasonText(l10n, s),
                          key: ValueKey('suggestionReason-${s.key}'),
                          style: text.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      FilledButton.tonalIcon(
                        key: ValueKey('wishSuggestion-${s.key}'),
                        onPressed: onWish,
                        icon: const Icon(Icons.favorite_border),
                        label: Text(l10n.suggestionAddWish),
                      ),
                      TextButton(
                        key: ValueKey('dismissSuggestion-${s.key}'),
                        onPressed: onDismiss,
                        child: Text(l10n.suggestionDismiss),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
