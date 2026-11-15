import 'package:dupe/features/account/presentation/account_section.dart';
import 'package:dupe/features/backup/presentation/backup_section.dart';
import 'package:dupe/features/covers/presentation/offline_covers_section.dart';
import 'package:dupe/features/scan/presentation/scan_settings_section.dart';
import 'package:dupe/features/settings/presentation/appearance_section.dart';
import 'package:dupe/features/settings/presentation/sources_section.dart';
import 'package:dupe/features/updates/presentation/updates_section.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Settings: account and sync, appearance, scan, backup and import,
/// offline covers, sources, updates.
class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreSettings)),
      body: ListView(
        children: const [
          AccountSection(),
          Divider(),
          AppearanceSection(),
          Divider(),
          ScanSettingsSection(),
          Divider(),
          BackupSection(),
          Divider(),
          OfflineCoversSection(),
          Divider(),
          SourcesSection(),
          Divider(),
          UpdatesSection(),
        ],
      ),
    );
  }
}
