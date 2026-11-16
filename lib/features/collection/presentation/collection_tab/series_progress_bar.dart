import 'package:dupe/features/collection/domain/collection_entry.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Progress of a series in a list or grid: the real one (owned / total), or,
/// when the total is unknown, a grey hint (owned / highest known volume).
/// Nothing for standalone books or series without numbered volumes.
class SeriesProgressBar extends StatelessWidget {
  const new({required this.entry, super.key});

  final CollectionEntry entry;

  static bool shows(CollectionEntry entry) =>
      entry is SeriesEntry &&
      (entry.progress ?? entry.indicativeProgress) != null;

  @override
  Widget build(BuildContext context) {
    final entry = this.entry;
    if (entry is! SeriesEntry) return const SizedBox.shrink();
    if (entry.progress case final value?) {
      return LinearProgressIndicator(value: value);
    }
    final hint = entry.indicativeProgress;
    if (hint == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: AppLocalizations.of(context).indicativeProgress,
      child: LinearProgressIndicator(
        key: const Key('indicativeProgress'),
        value: hint,
        color: scheme.outline,
        backgroundColor: scheme.surfaceContainerHighest,
        semanticsLabel: AppLocalizations.of(context).indicativeProgress,
      ),
    );
  }
}
