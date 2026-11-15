import 'package:dupe/core/database/database_provider.dart';
import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/collection/data/reading_actions.dart';
import 'package:dupe/features/collection/domain/enums.dart';
import 'package:dupe/features/collection/domain/item.dart';
import 'package:dupe/features/collection/presentation/labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// One-tap reading status of an item.
class ItemReadingBar extends ConsumerWidget {
  const new({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(collectionRepositoryProvider);
    // Chips wrap on narrow phones (a segmented button would overflow).
    return Wrap(
      key: const Key('readingStatusBar'),
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final s in ReadingStatus.values)
          ChoiceChip(
            key: ValueKey('reading-${s.name}'),
            label: Text(s.label(l10n)),
            selected: item.readingStatus == s,
            onSelected: (_) => repo.setReadingStatus(
              item,
              s,
              today: ref.read(clockProvider)(),
            ),
          ),
      ],
    );
  }
}
