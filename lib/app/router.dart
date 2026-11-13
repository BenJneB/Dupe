import 'package:dupe/app/adaptive_shell.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/presentation/collection_tab_screen.dart';
import 'package:dupe/features/loans/presentation/loans_screen.dart';
import 'package:dupe/features/more/presentation/more_screen.dart';
import 'package:dupe/features/scan/presentation/scan_screen.dart';
import 'package:dupe/features/settings/presentation/settings_screen.dart';
import 'package:dupe/features/stats/presentation/stats_screen.dart';
import 'package:dupe/features/wishlist/presentation/wishlist_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Route paths, kept in one place to avoid typos.
abstract final class AppRoutes {
  static const mangas = '/mangas';
  static const bd = '/bd';
  static const comics = '/comics';
  static const books = '/livres';
  static const more = '/plus';
  static const wishlist = '/plus/envies';
  static const loans = '/plus/prets';
  static const stats = '/plus/statistiques';
  static const settings = '/plus/parametres';
  static const scan = '/scan';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.mangas,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdaptiveShell(navigationShell: navigationShell),
        branches: [
          _collectionBranch(AppRoutes.mangas, CollectionType.manga),
          _collectionBranch(AppRoutes.bd, CollectionType.bd),
          _collectionBranch(AppRoutes.comics, CollectionType.comic),
          _collectionBranch(AppRoutes.books, CollectionType.livre),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (context, state) => const MoreScreen(),
                routes: [
                  GoRoute(
                    path: 'envies',
                    builder: (context, state) => const WishlistScreen(),
                  ),
                  GoRoute(
                    path: 'prets',
                    builder: (context, state) => const LoansScreen(),
                  ),
                  GoRoute(
                    path: 'statistiques',
                    builder: (context, state) => const StatsScreen(),
                  ),
                  GoRoute(
                    path: 'parametres',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.scan,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ScanScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}

StatefulShellBranch _collectionBranch(String path, CollectionType type) =>
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          builder: (context, state) => CollectionTabScreen(type: type),
        ),
      ],
    );
