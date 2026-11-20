import 'dart:async';

import 'package:dupe/app/error_text.dart';
import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/features/updates/data/update_checker.dart';
import 'package:dupe/features/updates/presentation/update_notice.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updates_section.g.dart';

@riverpod
Future<bool> updateCheckEnabled(Ref ref) =>
    ref.watch(updateCheckerProvider).enabled;

/// Settings section: new version notice on / off, check now.
class UpdatesSection extends ConsumerWidget {
  const new({super.key});

  Future<void> _checkNow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final update = await ref.read(updateCheckerProvider).check(force: true);
      if (update != null) {
        showUpdateNotice(messenger, l10n, update);
      } else {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.updateUpToDate)));
      }
    } on Object catch (e, stack) {
      final text = reportError(l10n, 'update', e, stack);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final enabled = ref.watch(updateCheckEnabledProvider).value ?? true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListSectionHeader(l10n.updatesSection),
        SwitchListTile(
          key: const Key('updateCheckSwitch'),
          secondary: const Icon(Icons.new_releases_outlined),
          title: Text(l10n.updateCheck),
          subtitle: Text(l10n.updateCheckHelp),
          value: enabled,
          onChanged: (value) async {
            await ref.read(updateCheckerProvider).setEnabled(enabled: value);
            ref.invalidate(updateCheckEnabledProvider);
          },
        ),
        ListTile(
          key: const Key('checkUpdateNow'),
          leading: const Icon(Icons.system_update_alt),
          title: Text(l10n.updateCheckNow),
          onTap: () => unawaited(_checkNow(context, ref)),
        ),
      ],
    );
  }
}
