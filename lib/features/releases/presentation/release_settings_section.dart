import 'dart:async';

import 'package:dupe/app/widgets/form_helpers.dart';
import 'package:dupe/features/releases/data/release_settings.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Settings: new release checks (PLAN_V4 phase 33).
class ReleaseSettingsSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final o =
        ref.watch(releaseSettingsProvider).value ?? ReleaseSettings.defaults;
    final settings = ref.read(releaseSettingsProvider.notifier);
    final authors = ref.watch(followedAuthorsProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListSectionHeader(l10n.releasesTitle),
        SwitchListTile(
          key: const Key('releasesSwitch'),
          secondary: const Icon(Icons.new_releases_outlined),
          title: Text(l10n.releasesEnabled),
          subtitle: Text(l10n.releasesEnabledHelp),
          value: o.enabled,
          onChanged: (v) => unawaited(settings.set(enabled: v)),
        ),
        SwitchListTile(
          key: const Key('releasesWifiSwitch'),
          secondary: const Icon(Icons.wifi),
          title: Text(l10n.offlineCoversWifiOnly),
          value: o.wifiOnly,
          onChanged: o.enabled
              ? (v) => unawaited(settings.set(wifiOnly: v))
              : null,
        ),
        SwitchListTile(
          key: const Key('releasesNotifySwitch'),
          secondary: const Icon(Icons.notifications_outlined),
          title: Text(l10n.releasesNotify),
          value: o.notify,
          onChanged: o.enabled
              ? (v) => unawaited(settings.set(notify: v))
              : null,
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(l10n.followedAuthorsTitle(authors.length)),
          subtitle: Text(
            authors.isEmpty
                ? l10n.followedAuthorsHelp
                : authors.map((a) => a.name).join(', '),
          ),
        ),
      ],
    );
  }
}
