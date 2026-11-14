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
      'Scanne un code-barres ou ajoute un ouvrage avec le bouton +.';

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

  @override
  String get add => 'Ajouter';

  @override
  String get cancel => 'Annuler';

  @override
  String get clear => 'Effacer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get yes => 'Oui';

  @override
  String get none => '—';

  @override
  String get deleteConfirmTitle => 'Supprimer ?';

  @override
  String deleteSeriesMessage(String title) {
    return 'La série « $title » et tous ses tomes seront supprimés.';
  }

  @override
  String deleteItemMessage(String title) {
    return '« $title » sera supprimé de ta collection.';
  }

  @override
  String loadError(String error) {
    return 'Erreur de chargement : $error';
  }

  @override
  String get notFound => 'Introuvable (peut-être supprimé)';

  @override
  String get newSeries => 'Nouvelle série';

  @override
  String get newCycle => 'Nouveau cycle';

  @override
  String get newBook => 'Nouveau livre';

  @override
  String get newOneShot => 'Ouvrage isolé (one-shot)';

  @override
  String get newItemTitle => 'Nouvel ouvrage';

  @override
  String get editItem => 'Modifier l’ouvrage';

  @override
  String get editSeries => 'Modifier la série';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortTitle => 'Titre';

  @override
  String get sortRecent => 'Ajout récent';

  @override
  String get sortProgress => 'Progression';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterComplete => 'Complètes';

  @override
  String get filterIncomplete => 'Incomplètes';

  @override
  String get noFilterResults => 'Aucun résultat pour ce filtre';

  @override
  String get viewGrid => 'Afficher en grille';

  @override
  String get viewList => 'Afficher en liste';

  @override
  String volumesOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes',
      one: '1 tome',
      zero: 'Aucun tome',
    );
    return '$_temp0';
  }

  @override
  String volumesOwnedOfTotal(int owned, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'tomes',
      one: 'tome',
    );
    return '$owned/$total $_temp0';
  }

  @override
  String missingVolumes(String list) {
    return 'il manque $list';
  }

  @override
  String get rangeWord => 'à';

  @override
  String get seriesComplete => 'série complète';

  @override
  String get noVolumesYet =>
      'Aucun tome. Indique le nombre de tomes de la série ou ajoute-en avec le bouton ⊕.';

  @override
  String get addVolumes => 'Ajouter des tomes';

  @override
  String get rangeFrom => 'Du tome';

  @override
  String get rangeTo => 'Au tome';

  @override
  String volumesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes ajoutés',
      one: '1 tome ajouté',
      zero: 'Aucun tome ajouté (déjà présents)',
    );
    return '$_temp0';
  }

  @override
  String volumeMarkedOwned(String label) {
    return 'Tome $label marqué comme possédé';
  }

  @override
  String volumeTitle(String title, String volume) {
    return '$title – tome $volume';
  }

  @override
  String get slotOwned => 'Possédé';

  @override
  String get slotLoaned => 'Prêté';

  @override
  String get slotWished => 'Envie';

  @override
  String get slotMissing => 'Manquant';

  @override
  String slotSemantics(String label, String status) {
    return 'Tome $label, $status';
  }

  @override
  String get markOwned => 'Je l’ai';

  @override
  String get seeSeries => 'Voir la série';

  @override
  String get ownershipOwned => 'Possédé';

  @override
  String get ownershipWished => 'Envie';

  @override
  String get publicationOngoing => 'En cours de parution';

  @override
  String get publicationFinished => 'Parution terminée';

  @override
  String get publicationUnknown => 'Statut de parution inconnu';

  @override
  String get readingUnread => 'Non lu';

  @override
  String get readingInProgress => 'En cours';

  @override
  String get readingRead => 'Lu';

  @override
  String get readingAbandoned => 'Abandonné';

  @override
  String get sectionGeneral => 'Informations';

  @override
  String get sectionReading => 'Lecture';

  @override
  String get sectionCopy => 'Exemplaire';

  @override
  String get sectionPrice => 'Prix';

  @override
  String get sectionWishlist => 'Liste d’envies';

  @override
  String get fieldTitle => 'Titre';

  @override
  String get fieldOriginalTitle => 'Titre original';

  @override
  String get fieldAuthors => 'Auteurs';

  @override
  String get fieldPublisher => 'Éditeur';

  @override
  String get fieldCollection => 'Collection';

  @override
  String get fieldPublicationStatus => 'Statut de parution';

  @override
  String get fieldTotalVolumes => 'Nombre total de tomes';

  @override
  String get fieldOwnedUpTo => 'Je possède les tomes 1 à…';

  @override
  String get fieldOwnedUpToHelper => 'Crée directement les tomes possédés';

  @override
  String get fieldFollowed => 'Série suivie';

  @override
  String get fieldFollowedHelper =>
      'Les tomes non possédés comptent comme manquants';

  @override
  String get fieldCoverUrl => 'URL de la couverture';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldVolumeNumber => 'Numéro de tome';

  @override
  String get fieldVolumeNumberHelper => 'Ex. 12, 1.5, HS 2, Annual 1';

  @override
  String get fieldEdition => 'Édition';

  @override
  String get fieldFormat => 'Format';

  @override
  String get fieldPublishDate => 'Date de parution';

  @override
  String get fieldPageCount => 'Nombre de pages';

  @override
  String get fieldLanguage => 'Langue';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldUpc => 'UPC';

  @override
  String get fieldReadingStatus => 'Statut de lecture';

  @override
  String get fieldReadDate => 'Date de lecture';

  @override
  String get fieldRating => 'Note';

  @override
  String get fieldFirstEdition => 'Édition originale (EO)';

  @override
  String get fieldVariant => 'Variante';

  @override
  String get fieldCondition => 'État';

  @override
  String get fieldLocation => 'Emplacement';

  @override
  String get fieldLocationHelper => 'Étagère, carton…';

  @override
  String get fieldPurchasePrice => 'Prix payé';

  @override
  String get fieldPurchaseDate => 'Date d’achat';

  @override
  String get fieldCoverPrice => 'Prix éditeur';

  @override
  String get fieldEstimatedValue => 'Valeur estimée';

  @override
  String get fieldCurrency => 'Devise';

  @override
  String get fieldWishlistPriority => 'Priorité (1 = haute)';

  @override
  String get fieldWishlistMaxPrice => 'Prix max';

  @override
  String get commaSeparated => 'Séparés par des virgules';

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get searchPrompt => 'Titre, auteur, éditeur ou ISBN';

  @override
  String searchNoResults(String query) {
    return 'Rien trouvé pour « $query »';
  }

  @override
  String get searchSeriesSection => 'Séries';

  @override
  String get searchItemsSection => 'Ouvrages';

  @override
  String get starterCollectionTitle => 'Importer ma collection de départ';

  @override
  String get starterCollectionSubtitle =>
      'One Piece, Dreamland, Naheulbeuk, Batman, Les Fourmis, Fabien Olicard (sans doublons)';

  @override
  String starterCollectionImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments importés',
      one: '1 élément importé',
      zero: 'Rien à importer : déjà présent',
    );
    return '$_temp0';
  }

  @override
  String get search => 'Rechercher';

  @override
  String get searchOnline => 'Chercher en ligne';

  @override
  String get onlineSearchTitle => 'Rechercher en ligne';

  @override
  String get onlineSearchHint => 'ISBN, titre ou auteur';

  @override
  String get onlineSearchPrompt =>
      'Saisis un ISBN ou un titre, puis lance la recherche.';

  @override
  String get upcNotSupported =>
      'Code UPC (comics US) : cherche plutôt par titre et numéro, par exemple « Batman 3 », dans le type Comics.';

  @override
  String invalidCode(String code) {
    return 'Code « $code » non reconnu comme ISBN';
  }

  @override
  String get alreadyOwned => 'Déjà dans ta collection';

  @override
  String get alreadyWished => 'Déjà dans ta liste d’envies';

  @override
  String isbnNotFound(String isbn) {
    return 'ISBN $isbn introuvable';
  }

  @override
  String get isbnNotFoundHint =>
      'Tu peux l’ajouter à la main avec le bouton +.';

  @override
  String sourcesUsed(String sources) {
    return 'Sources : $sources';
  }

  @override
  String sourcesUnavailable(String sources) {
    return 'Sources indisponibles : $sources';
  }

  @override
  String get addToCollection => 'Ajouter à la collection';

  @override
  String get addToWishlist => 'Ajouter aux envies';

  @override
  String get isbnEntryLabel => 'ISBN';

  @override
  String get isbnEntryHelper =>
      'Tape l’ISBN ou scanne avec une douchette USB, puis Entrée';

  @override
  String get scanDesktopTitle => 'Scanner un code-barres';

  @override
  String get scanHint => 'Vise le code-barres au dos de l’ouvrage';

  @override
  String get typeIsbn => 'Saisir l’ISBN';

  @override
  String cameraUnavailable(String error) {
    return 'Caméra indisponible ($error). Vérifie l’autorisation caméra ou saisis l’ISBN.';
  }

  @override
  String attachedToSeries(String title) {
    return 'Série : $title';
  }

  @override
  String get attachedToSeriesHelper => 'Rangé automatiquement dans cette série';

  @override
  String createSeriesNamed(String title) {
    return 'Créer la série « $title »';
  }

  @override
  String get createSeriesHelper =>
      'Aucune série correspondante dans ta collection';

  @override
  String openOn(String site) {
    return 'Ouvrir sur $site';
  }

  @override
  String completeFrom(String source) {
    return 'Compléter depuis $source';
  }

  @override
  String get seriesLookupHint => 'Titre de la série';
}
