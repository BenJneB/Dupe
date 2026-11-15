import 'dart:async';

import 'package:dupe/app/router.dart';
import 'package:dupe/core/sync/sync_controller.dart';
import 'package:dupe/core/sync/sync_providers.dart';
import 'package:dupe/features/account/presentation/set_password_dialog.dart';
import 'package:dupe/features/account/presentation/sync_labels.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Settings section: account and sync status.
class AccountSection extends ConsumerWidget {
  const new({super.key});

  Future<void> _setPassword(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final done = AppLocalizations.of(context).setPasswordDone;
    if (await showSetPasswordDialog(context) ?? false) {
      messenger.showSnackBar(SnackBar(content: Text(done)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(syncControllerProvider);
    final controller = ref.read(syncControllerProvider.notifier);
    final email = ref.watch(syncAuthProvider).email;
    final tiles = switch (state.phase) {
      SyncPhase.localOnly => [
        ListTile(
          leading: const Icon(Icons.cloud_off_outlined),
          title: Text(l10n.syncLocalOnly),
          subtitle: Text(l10n.syncLocalOnlyHelp),
        ),
      ],
      SyncPhase.signedOut => [
        ListTile(
          key: const Key('signInTile'),
          leading: const Icon(Icons.login),
          title: Text(l10n.signIn),
          subtitle: Text(l10n.signInHelp),
          onTap: () => context.push(AppRoutes.signIn),
        ),
      ],
      _ => [
        ListTile(
          key: const Key('syncStatusTile'),
          leading: Icon(state.icon),
          title: Text(l10n.signedInAs(email ?? '')),
          subtitle: Text(state.label(l10n)),
        ),
        ListTile(
          key: const Key('syncNowTile'),
          leading: const Icon(Icons.sync),
          title: Text(l10n.syncNow),
          enabled: state.phase != SyncPhase.syncing,
          onTap: () => unawaited(controller.syncNow()),
        ),
        ListTile(
          key: const Key('setPasswordTile'),
          leading: const Icon(Icons.password),
          title: Text(l10n.setPassword),
          subtitle: Text(l10n.setPasswordHelp),
          onTap: () => unawaited(_setPassword(context)),
        ),
        ListTile(
          key: const Key('signOutTile'),
          leading: const Icon(Icons.logout),
          title: Text(l10n.signOut),
          onTap: () => unawaited(controller.signOut()),
        ),
      ],
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            l10n.accountSection,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...tiles,
      ],
    );
  }
}
