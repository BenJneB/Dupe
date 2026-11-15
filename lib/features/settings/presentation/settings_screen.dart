import 'package:dupe/features/collection/data/collection_repository.dart';
import 'package:dupe/features/settings/data/starter_collection.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Settings (account, sync, export/import come in later phases).
class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _seed(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final created = await seedStarterCollection(
      ref.read(collectionRepositoryProvider),
    );
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.starterCollectionImported(created))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moreSettings)),
      body: ListView(
        children: [
          ListTile(
            key: const Key('seedStarterCollection'),
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.starterCollectionTitle),
            subtitle: Text(l10n.starterCollectionSubtitle),
            onTap: () => _seed(context, ref),
          ),
        ],
      ),
    );
  }
}
