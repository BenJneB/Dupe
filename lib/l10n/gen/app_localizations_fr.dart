// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dupe';

  @override
  String get tabMangas => 'Mangas';

  @override
  String get tabBd => 'BD';

  @override
  String get tabComics => 'Comics';

  @override
  String get tabBooks => 'Livres';

  @override
  String get tabMore => 'Plus';

  @override
  String get scan => 'Scanner';

  @override
  String get searchHint => 'Rechercher dans ma collection';

  @override
  String get emptyCollectionTitle => 'Aucun ouvrage pour l’instant';

  @override
  String get emptyCollectionBody =>
      'Scanne un code-barres ou ajoute un ouvrage pour commencer.';

  @override
  String get moreWishlist => 'Liste d’envies';

  @override
  String get moreLoans => 'Prêts';

  @override
  String get moreStats => 'Statistiques';

  @override
  String get moreSettings => 'Paramètres';

  @override
  String get moreSettingsSubtitle =>
      'Compte, synchronisation, export/import, sources';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get scanUnavailableDesktop =>
      'Pas de caméra sur cette plateforme : saisis l’ISBN ou utilise une douchette USB.';
}
