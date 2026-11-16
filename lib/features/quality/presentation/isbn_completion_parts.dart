import 'package:dupe/app/widgets/cover_image.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/quality/presentation/quality_list_screen.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The book waiting for its ISBN, and the choices of the step.
class IsbnCompletionCard extends StatelessWidget {
  const new({
    required this.item,
    required this.seriesTitle,
    required this.position,
    required this.total,
    required this.complete,
    required this.onComplete,
    required this.onSkip,
    super.key,
  });

  final Item item;
  final String? seriesTitle;
  final int position;
  final int total;
  final bool complete;
  final ValueChanged<bool> onComplete;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.isbnCompletionProgress(position, total)),
            const SizedBox(height: 8),
            Row(
              children: [
                CoverImage(url: item.coverUrl, width: 40, height: 60),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        QualityListScreen.itemTitle(l10n, item),
                        key: const Key('isbnCompletionTitle'),
                        style: text.titleMedium,
                      ),
                      if (seriesTitle case final s? when s != item.title)
                        Text(s, style: text.bodySmall),
                      Text(l10n.isbnCompletionScanThis),
                    ],
                  ),
                ),
              ],
            ),
            SwitchListTile(
              key: const Key('isbnCompleteSwitch'),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.isbnCompletionAlsoFill),
              value: complete,
              onChanged: onComplete,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('isbnSkip'),
                onPressed: onSkip,
                child: Text(l10n.isbnCompletionSkip),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Yes / no question of the completion (duplicate, other title).
Future<bool> askIsbnQuestion(
  BuildContext context, {
  required String message,
  required String yes,
  Key? yesKey,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            key: yesKey,
            onPressed: () => Navigator.pop(context, true),
            child: Text(yes),
          ),
        ],
      ),
    ) ??
    false;
