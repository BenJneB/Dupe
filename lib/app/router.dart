import 'package:dupe/app/adaptive_shell.dart';
import 'package:dupe/app/app_routes.dart';
import 'package:dupe/features/about/presentation/about_screen.dart';
import 'package:dupe/features/about/presentation/journal_screen.dart';
import 'package:dupe/features/account/presentation/sign_in_screen.dart';
import 'package:dupe/features/authors/presentation/author_screen.dart';
import 'package:dupe/features/backup/presentation/auto_backups_screen.dart';
import 'package:dupe/features/backup/presentation/csv_import_screen.dart';
import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:dupe/features/collection/domain/metadata_mapping.dart';
import 'package:dupe/features/collection/presentation/collection_tab/collection_tab_screen.dart';
import 'package:dupe/features/collection/presentation/item/item_detail_screen.dart';
import 'package:dupe/features/collection/presentation/item/item_form_screen.dart';
import 'package:dupe/features/collection/presentation/series/series_detail_screen.dart';
import 'package:dupe/features/collection/presentation/series/series_form_screen.dart';
import 'package:dupe/features/loans/presentation/loans_screen.dart';
import 'package:dupe/features/more/presentation/more_screen.dart';
import 'package:dupe/features/scan/presentation/burst/scan_review_screen.dart';
import 'package:dupe/features/scan/presentation/scan_screen.dart';
import 'package:dupe/features/search/presentation/online_search/online_search_screen.dart';
import 'package:dupe/features/search/presentation/search_screen.dart';
import 'package:dupe/features/settings/presentation/settings_screen.dart';
import 'package:dupe/features/stats/presentation/stats_screen.dart';
import 'package:dupe/features/wishlist/presentation/share/wishlist_share_screen.dart';
import 'package:dupe/features/wishlist/presentation/wishlist_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:dupe/app/app_routes.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.base(CollectionType.manga),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdaptiveShell(navigationShell: navigationShell),
        branches: [
          for (final type in CollectionType.values) _collectionBranch(type),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (context, state) => const MoreScreen(),
                routes: [
                  GoRoute(
                    path: 'envies',
                    builder: (context, state) => const WishlistScreen(),
                    routes: [
                      GoRoute(
                        path: 'partager',
                        builder: (context, state) =>
                            const WishlistShareScreen(),
                      ),
                    ],
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
                    routes: [
                      GoRoute(
                        path: 'import-csv',
                        builder: (context, state) =>
                            CsvImportScreen(file: state.extra! as CsvFile),
                      ),
                      GoRoute(
                        path: 'sauvegardes',
                        builder: (context, state) => const AutoBackupsScreen(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'a-propos',
                    builder: (context, state) => const AboutScreen(),
                    routes: [
                      GoRoute(
                        path: 'journal',
                        builder: (context, state) => const JournalScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.signIn,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            SearchScreen(dictate: state.uri.queryParameters['voix'] == '1'),
      ),
      GoRoute(
        path: '/recherche-en-ligne',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => OnlineSearchScreen(
          initialQuery: state.uri.queryParameters['q'],
          initialType: AppRoutes.typeParam(state),
        ),
      ),
      GoRoute(
        path: AppRoutes.scan,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            ScanScreen(type: AppRoutes.typeParam(state)),
        routes: [
          GoRoute(
            path: 'revue',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const ScanReviewScreen(),
            routes: [
              GoRoute(
                path: 'ouvrage',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) => ItemFormScreen(
                  type: AppRoutes.typeParam(state) ?? CollectionType.livre,
                  prefill: state.extra as ItemPrefill?,
                  popOnSave: true,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}

StatefulShellBranch _collectionBranch(CollectionType type) =>
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.base(type),
          builder: (context, state) => CollectionTabScreen(type: type),
          routes: [
            GoRoute(
              path: 'auteur',
              builder: (context, state) => AuthorScreen(
                type: type,
                name: state.uri.queryParameters['nom'] ?? '',
              ),
            ),
            GoRoute(
              path: 'nouvelle-serie',
              builder: (context, state) => SeriesFormScreen(type: type),
            ),
            GoRoute(
              path: 'serie/:seriesId',
              builder: (context, state) => SeriesDetailScreen(
                seriesId: state.pathParameters['seriesId']!,
              ),
              routes: [
                GoRoute(
                  path: 'modifier',
                  builder: (context, state) => SeriesFormScreen(
                    type: type,
                    seriesId: state.pathParameters['seriesId'],
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'nouvel-ouvrage',
              builder: (context, state) => ItemFormScreen(
                type: type,
                seriesId: state.uri.queryParameters['serie'],
                volumeNumber: state.uri.queryParameters['tome'],
                copyOf: state.uri.queryParameters['copie'],
                prefill: state.extra as ItemPrefill?,
              ),
            ),
            GoRoute(
              path: 'ouvrage/:itemId',
              builder: (context, state) =>
                  ItemDetailScreen(itemId: state.pathParameters['itemId']!),
              routes: [
                GoRoute(
                  path: 'modifier',
                  builder: (context, state) => ItemFormScreen(
                    type: type,
                    itemId: state.pathParameters['itemId'],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
