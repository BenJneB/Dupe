import 'package:dupe/features/scan/presentation/store/store_haptics.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_settings_section.g.dart';

@riverpod
Future<bool> storeHapticsEnabled(Ref ref) =>
    ref.watch(storeHapticsProvider).enabled;

/// Settings section: store-mode vibrations on / off.
class ScanSettingsSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            l10n.scanSection,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SwitchListTile(
          key: const Key('storeHapticsSwitch'),
          secondary: const Icon(Icons.vibration),
          title: Text(l10n.storeHaptics),
          subtitle: Text(l10n.storeHapticsHelp),
          value: ref.watch(storeHapticsEnabledProvider).value ?? true,
          onChanged: (value) async {
            await ref.read(storeHapticsProvider).setEnabled(enabled: value);
            ref.invalidate(storeHapticsEnabledProvider);
          },
        ),
      ],
    );
  }
}
