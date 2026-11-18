import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Pen icon on what holds signed books (PLAN_V4 phase 31); nothing at 0.
class SignedMark extends StatelessWidget {
  const new({required this.count, this.size = 18, super.key});

  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Tooltip(
      message: AppLocalizations.of(context).signedCount(count),
      child: Icon(
        Icons.draw,
        key: const Key('signedMark'),
        size: size,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
