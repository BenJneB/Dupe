import 'package:dupe/app/router.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/l10n/gen/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Width breakpoints for the adaptive layout.
abstract final class Breakpoints {
  /// From this width, a NavigationRail replaces the bottom bar.
  static const rail = 600.0;

  /// From this width, the NavigationRail shows its labels next to icons.
  static const extendedRail = 1100.0;
}

/// Main scaffold: bottom navigation on narrow screens, rail on wide ones.
/// The scan action is reachable from every tab.
class AdaptiveShell extends StatelessWidget {
  const new({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Scanning from a collection tab looks codes up as that type.
  String get _scanRoute => AppRoutes.scanFor(
    navigationShell.currentIndex < CollectionType.values.length
        ? CollectionType.values[navigationShell.currentIndex]
        : null,
  );

  void _onDestinationSelected(int index) => navigationShell.goBranch(
    index,
    // Tapping the current tab again goes back to its root.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = <({IconData icon, IconData selected, String label})>[
      (
        icon: Icons.menu_book_outlined,
        selected: Icons.menu_book,
        label: l10n.tabMangas,
      ),
      (
        icon: Icons.auto_stories_outlined,
        selected: Icons.auto_stories,
        label: l10n.tabBd,
      ),
      (icon: Icons.bolt_outlined, selected: Icons.bolt, label: l10n.tabComics),
      (icon: Icons.book_outlined, selected: Icons.book, label: l10n.tabBooks),
      (
        icon: Icons.more_horiz_outlined,
        selected: Icons.more_horiz,
        label: l10n.tabMore,
      ),
    ];
    final width = MediaQuery.sizeOf(context).width;

    if (width < Breakpoints.rail) {
      return Scaffold(
        body: navigationShell,
        floatingActionButton: FloatingActionButton(
          key: const Key('scanFab'),
          tooltip: l10n.scan,
          onPressed: () => context.push(_scanRoute),
          child: const Icon(Icons.qr_code_scanner),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: [
            for (final d in destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selected),
                label: d.label,
              ),
          ],
        ),
      );
    }

    final extended = width >= Breakpoints.extendedRail;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: extended
                  ? FloatingActionButton.extended(
                      key: const Key('scanFab'),
                      onPressed: () => context.push(_scanRoute),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(l10n.scan),
                    )
                  : FloatingActionButton(
                      key: const Key('scanFab'),
                      tooltip: l10n.scan,
                      onPressed: () => context.push(_scanRoute),
                      child: const Icon(Icons.qr_code_scanner),
                    ),
            ),
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selected),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
