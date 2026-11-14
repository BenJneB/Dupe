import 'package:dupe/app/router.dart';
import 'package:dupe/core/sync/sync_controller.dart';
import 'package:dupe/features/account/presentation/sync_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Discreet sync status (cloud icon) in the search bar; hidden when the app
/// is used without account. Opens the settings.
class SyncStatusIcon extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(syncControllerProvider);
    if (state.phase == SyncPhase.localOnly ||
        state.phase == SyncPhase.signedOut) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      key: const Key('syncStatus'),
      tooltip: state.label(AppLocalizations.of(context)),
      icon: Icon(
        state.icon,
        size: 20,
        color: state.phase == SyncPhase.failed
            ? scheme.error
            : scheme.onSurfaceVariant,
      ),
      onPressed: () => context.go(AppRoutes.settings),
    );
  }
}
