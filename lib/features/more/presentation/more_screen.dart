import 'package:dupe/app/router.dart';
import 'package:dupe/app/widgets/global_search_bar.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// "Plus" tab: entry points to secondary features.
class MoreScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const GlobalSearchBar()),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: Text(l10n.moreWishlist),
            onTap: () => context.go(AppRoutes.wishlist),
          ),
          ListTile(
            leading: const Icon(Icons.handshake_outlined),
            title: Text(l10n.moreLoans),
            onTap: () => context.go(AppRoutes.loans),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: Text(l10n.moreStats),
            onTap: () => context.go(AppRoutes.stats),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.moreSettings),
            subtitle: Text(l10n.moreSettingsSubtitle),
            onTap: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}
