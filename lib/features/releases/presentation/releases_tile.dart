import 'package:dupe/app/router.dart';
import 'package:dupe/features/releases/data/releases_repository.dart';
import 'package:dupe/features/releases/domain/release_alert.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Plus: "Nouveautés", with the number of new ones.
class ReleasesTile extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final fresh = (ref.watch(releaseAlertsProvider).value ?? const [])
        .where((a) => a.status == AlertStatus.nouveau)
        .length;
    return ListTile(
      key: const Key('moreReleases'),
      leading: Badge(
        isLabelVisible: fresh > 0,
        label: Text('$fresh'),
        child: const Icon(Icons.new_releases_outlined),
      ),
      title: Text(l10n.releasesTitle),
      subtitle: Text(l10n.releasesSubtitle),
      onTap: () => context.go(AppRoutes.releases),
    );
  }
}
