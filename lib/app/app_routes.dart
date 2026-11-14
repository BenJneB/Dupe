import 'package:dupe/features/collection/domain/collection_type.dart';
import 'package:go_router/go_router.dart';

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
  static const csvImport = '/plus/parametres/import-csv';
  static const autoBackups = '/plus/parametres/sauvegardes';
  static const about = '/plus/a-propos';
  static const journal = '/plus/a-propos/journal';
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
