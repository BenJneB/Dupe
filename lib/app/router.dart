import 'package:dupe/app/adaptive_shell.dart';
import 'package:dupe/features/account/presentation/sign_in_screen.dart';
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
import 'package:dupe/features/wishlist/presentation/wishlist_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Route paths, kept in one place to avoid typos.
abstract final class AppRoutes {
  static const search = '/recherche';

  /// Online lookup; [query] is an ISBN or free text.
  static String onlineSearch({String? query, CollectionType? type}) => Uri(
    path: '/recherche-en-ligne',
    queryParameters: {'q': ?query, 'type': ?type?.dbValue},
  ).toString();
  static const more = '/plus';
  static const wishlist = '/plus/envies';
  static const loans = '/plus/prets';
  static const stats = '/plus/statistiques';
  static const settings = '/plus/parametres';
  static const signIn = '/connexion';
  static const scan = '/scan';
  static const scanReview = '/scan/revue';

  /// Item form opened from the burst review (extra: ItemPrefill); returns
  /// to the review on save.
  static String scanReviewItem(CollectionType type) => Uri(
    path: '$scanReview/ouvrage',
    queryParameters: {'type': type.dbValue},
  ).toString();

  /// Scan screen; found codes are looked up as [type].
  static String scanFor(CollectionType? type) =>
      Uri(path: scan, queryParameters: {'type': ?type?.dbValue}).toString();

  static CollectionType? typeParam(GoRouterState state) => CollectionType.values
      .where((t) => t.dbValue == state.uri.queryParameters['type'])
      .firstOrNull;

  /// Root of the tab of [type].
  static String base(CollectionType type) => switch (type) {
    CollectionType.manga => '/mangas',
    CollectionType.bd => '/bd',
    CollectionType.comic => '/comics',
    CollectionType.livre => '/livres',
  };

  static String newSeries(CollectionType type) =>
      '${base(type)}/nouvelle-serie';

  static String series(CollectionType type, String id) =>
      '${base(type)}/serie/$id';

  static String seriesEdit(CollectionType type, String id) =>
      '${series(type, id)}/modifier';

  static String item(CollectionType type, String id) =>
      '${base(type)}/ouvrage/$id';

  static String itemEdit(CollectionType type, String id) =>
      '${item(type, id)}/modifier';

  static String newItem(
    CollectionType type, {
    String? seriesId,
    String? volume,
    String? copyOf,
  }) => Uri(
    path: '${base(type)}/nouvel-ouvrage',
    queryParameters: {'serie': ?seriesId, 'tome': ?volume, 'copie': ?copyOf},
  ).toString();
}

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
        path: AppRoutes.signIn,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
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
