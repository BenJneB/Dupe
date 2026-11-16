import 'package:dupe/features/quality/data/quality_providers.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Icon on a series, a book or an author in the lists when [count] owned
/// books lack their ISBN (quality setting, on by default). The volumes
/// themselves get a dot on their pastille instead.
class MissingIsbnMark extends ConsumerWidget {
  const new({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(missingIsbnInGridProvider).value ?? true;
    if (!on || count == 0) return const SizedBox.shrink();
    final label = AppLocalizations.of(context).missingIsbnCount(count);
    return Tooltip(
      message: label,
      child: Icon(
        Icons.qr_code_2,
        key: const Key('missingIsbnMark'),
        size: 18,
        color: Theme.of(context).colorScheme.tertiary,
        semanticLabel: label,
      ),
    );
  }
}
