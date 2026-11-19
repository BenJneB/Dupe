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
  String get markOwned => 'Je l’ai acheté';

  @override
  String get pressBackAgainToExit =>
      'Appuie de nouveau sur retour pour quitter';

  @override
  String get allRead => 'tout lu';

  @override
  String get scanType => 'Type des livres scannés';

  @override
  String storeInSeries(String title, String series) {
    return '$title — série $series';
  }

  @override
  String previousVolumesOffer(int count, int volume) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Il te manque $count tomes avant le $volume : les ajouter comme possédés ?',
      one: 'Il te manque 1 tome avant le $volume : l’ajouter comme possédé ?',
    );
    return '$_temp0';
  }

  @override
  String get byAuthor => 'Par auteur';

  @override
  String get unknownAuthor => 'Auteur inconnu';

  @override
  String authorSummary(int series, int books, int volumes) {
    String _temp0 = intl.Intl.pluralLogic(
      series,
      locale: localeName,
      other: '$series séries · ',
      one: '1 série · ',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      books,
      locale: localeName,
      other: '$books livres · ',
      one: '1 livre · ',
      zero: '',
    );
    String _temp2 = intl.Intl.pluralLogic(
      volumes,
      locale: localeName,
      other: '$volumes possédés',
      one: '1 possédé',
      zero: 'aucun possédé',
    );
    return '$_temp0$_temp1$_temp2';
  }

  @override
  String get authorSeries => 'Séries';

  @override
  String get authorBooks => 'Livres hors série';

  @override
  String get authorNotFound => 'Plus rien de cet auteur dans cet onglet';

  @override
  String get indicativeProgress =>
      'Progression estimée : nombre total de tomes inconnu';

  @override
  String get authorMarkBooksRead => 'Marquer les livres hors série comme lus';

  @override
  String get authorMarkAllRead => 'Tout marquer comme lu (séries comprises)';

  @override
  String authorMarkReadQuestion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Marquer $count livres comme lus ?',
      one: 'Marquer 1 livre comme lu ?',
    );
    return '$_temp0';
  }

  @override
  String get authorMarkReadHelp =>
      'Seuls les livres possédés et pas encore lus changent ; la date de lecture du jour est mise sur ceux qui n’en ont pas.';

  @override
  String booksMarkedRead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livres marqués comme lus',
      one: '1 livre marqué comme lu',
      zero: 'Rien à marquer : tout est déjà lu',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Plus tard';

  @override
  String totalFromAniList(String title, int count) {
    return 'AniList : « $title », $count tomes (nombre de l’édition japonaise)';
  }

  @override
  String totalFromComicVine(String title, int count) {
    return 'Comic Vine : « $title », $count numéros (édition américaine)';
  }

  @override
  String get seriesTotalHelp =>
      'Les tomes que tu n’as pas apparaîtront en gris dans la série.';

  @override
  String get checkTotalAction => 'Nombre total de tomes…';

  @override
  String get checkTotalTitle => 'Nombre total de tomes';

  @override
  String checkTotalNone(String title) {
    return 'Aucun nombre de tomes trouvé en ligne pour « $title » : saisis-le.';
  }

  @override
  String checkTotalSaved(String title, int count) {
    return '$title : $count tomes';
  }

  @override
  String get nextVolumesTitle => 'Combien de tomes compte la série ?';

  @override
  String get volumeCountsTitle => 'Nombre de tomes des séries';

  @override
  String get volumeCountsTile => 'Vérifier le nombre de tomes des séries';

  @override
  String get volumeCountsTileHelp =>
      'Mangas (AniList) et comics (Comic Vine) sans nombre total : propositions à valider';

  @override
  String get volumeCountsHelp =>
      'Cherche le nombre total de tomes des séries qui n’en ont pas (mangas et comics). Rien n’est modifié avant ta validation.';

  @override
  String get volumeCountsRun => 'Lancer';

  @override
  String volumeCountsProgress(int done, int total) {
    return '$done / $total séries vérifiées';
  }

  @override
  String volumeCountsDone(int total, int found) {
    return '$total séries vérifiées · $found nombre(s) de tomes trouvé(s)';
  }

  @override
  String volumeCountsFailed(int count) {
    return '$count série(s) non vérifiée(s) : source indisponible (détails dans le journal)';
  }

  @override
  String volumeCountsApply(int count) {
    return 'Appliquer ($count)';
  }

  @override
  String volumeCountsApplied(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séries mises à jour',
      one: '1 série mise à jour',
      zero: 'Aucune série modifiée',
    );
    return '$_temp0';
  }

  @override
  String volumeLabel(String label) {
    return 'Tome $label';
  }

  @override
  String get showVolumesAsList => 'Afficher les tomes en liste';

  @override
  String get showVolumesAsGrid => 'Afficher les tomes en pastilles';

  @override
  String get loanReminderNotificationsOff =>
      'Prêt enregistré, mais le rappel ne s’affichera pas : les notifications de Dupe sont désactivées (Paramètres Android → Applications → Dupe → Notifications).';

  @override
  String get totalNoSource =>
      'Aucune source ne donne le nombre de tomes des BD et des livres : saisis-le.';

  @override
  String wishRemoved(String title) {
    return '« $title » retiré des envies';
  }

  @override
  String get volumeTitlesTile => 'Compléter les titres des tomes';

  @override
  String get volumeTitlesHelp =>
      'Cherche par ISBN le titre propre des tomes déjà dans ta collection (sans rien changer d’autre)';

  @override
  String volumeTitlesProgress(int done, int total, int found) {
    return '$done / $total tomes vérifiés · $found titre(s) trouvé(s)';
  }

  @override
  String volumeTitlesDone(int found, int total) {
    return '$found titre(s) ajouté(s) · $total tomes vérifiés';
  }

  @override
  String get qualityTitle => 'Qualité de la collection';

  @override
  String get qualitySubtitle => 'ISBN, couvertures, numéros de tome manquants…';

  @override
  String get qualityHelp =>
      'Ce qui manque dans ta collection. Touche une ligne pour voir les livres concernés et les corriger.';

  @override
  String get qualityNoIsbn => 'Livres possédés sans ISBN';

  @override
  String get qualityNoCover => 'Livres sans couverture';

  @override
  String get qualityNoVolumeNumber => 'Tomes sans numéro dans une série';

  @override
  String get qualityLooksLikeVolume =>
      'Livres isolés qui ressemblent à un tome de série';

  @override
  String get qualitySeriesWithoutTotal => 'Séries sans nombre total de tomes';

  @override
  String get qualityAutomatic => 'Compléter automatiquement';

  @override
  String get missingIsbnInGrid => 'Signaler les ISBN manquants';

  @override
  String get missingIsbnInGridHelp =>
      'Un point sur la pastille des tomes possédés sans ISBN, et une icône sur les séries, livres et auteurs concernés';

  @override
  String missingIsbnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livres possédés sans ISBN',
      one: '1 livre possédé sans ISBN',
    );
    return '$_temp0';
  }

  @override
  String get missingIsbn => 'ISBN manquant · scanner';

  @override
  String get isbnCompletionTitle => 'Compléter les ISBN';

  @override
  String get isbnCompletionStart => 'Compléter par scan';

  @override
  String isbnCompletionProgress(int position, int total) {
    return 'Livre $position sur $total';
  }

  @override
  String get isbnCompletionScanThis =>
      'Scanne le code-barres de ce livre (ou tape son ISBN).';

  @override
  String get isbnCompletionAlsoFill => 'Compléter aussi les infos manquantes';

  @override
  String get isbnCompletionSkip => 'Passer';

  @override
  String isbnCompletionDuplicate(String title) {
    return 'Cet ISBN est déjà celui de « $title ».';
  }

  @override
  String get isbnCompletionSeeDuplicate => 'Voir ce livre';

  @override
  String isbnCompletionMismatch(String found, String mine) {
    return 'Le livre trouvé en ligne est « $found ». Est-ce bien « $mine » ?';
  }

  @override
  String isbnCompletionOtherVolume(String found, String mine) {
    return 'Le livre trouvé en ligne est le tome $found, pas le tome $mine. Garder quand même cet ISBN ?';
  }

  @override
  String get isbnCompletionAssignAnyway => 'Oui, garder cet ISBN';

  @override
  String isbnCompletionSaved(String title) {
    return 'ISBN enregistré pour « $title »';
  }

  @override
  String isbnCompletionDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Terminé : $count ISBN enregistrés.',
      one: 'Terminé : 1 ISBN enregistré.',
      zero: 'Terminé : aucun ISBN enregistré.',
    );
    return '$_temp0';
  }

  @override
  String get coverProposalsTitle => 'Couvertures proposées';

  @override
  String get coverProposalsTileHelp =>
      'Trouvées pour d’autres éditions : à garder ou refuser';

  @override
  String get coverProposalsHelp =>
      'Ces couvertures viennent d’une autre édition du même livre (recherche par titre et auteur). Garde celles qui conviennent ; une couverture refusée n’est plus proposée sur cet appareil.';

  @override
  String get coverProposalsNone => 'Aucune couverture à valider.';

  @override
  String get coverProposalsKeepAll => 'Tout garder';

  @override
  String get coverProposalKeep => 'Garder';

  @override
  String get coverProposalRefuse => 'Refuser';

  @override
  String coverProposalFrom(String source, String title) {
    return 'Trouvée via $source : « $title »';
  }

  @override
  String get storeOtherEditionBook => 'Tu as ce livre dans une autre édition';

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
      'Les tomes non possédés comptent comme manquants ; nouveaux tomes signalés';

  @override
  String get fieldCoverUrl => 'URL de la couverture';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldVolumeTitle => 'Titre du tome';

  @override
  String get fieldVolumeTitleHelper =>
      'Le titre propre de ce tome, s’il en a un (vide sinon)';

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
  String get seriesNone => 'Aucune série';

  @override
  String get seriesPickerHelper => 'Appuie pour choisir la série (ou aucune)';

  @override
  String get seriesPickerTitle => 'Choisir la série';

  @override
  String get seriesPickerHint => 'Chercher une série ou nommer une nouvelle';

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

  @override
  String get storeOwned => 'Déjà possédé';

  @override
  String get storeWished => 'Dans ta liste d’envies';

  @override
  String get storeSeriesNotOwned => 'Pas encore possédé';

  @override
  String get storeUnknown => 'Pas dans ta collection';

  @override
  String storeVolumeOf(String volume, String series) {
    return 'Tome $volume de $series';
  }

  @override
  String storeYouHave(String list) {
    return 'tu as $list';
  }

  @override
  String get storeYouHaveNone => 'tu n’en as aucun';

  @override
  String storePurchasedOn(String date) {
    return 'Acheté le $date';
  }

  @override
  String storeLocation(String location) {
    return 'Emplacement : $location';
  }

  @override
  String storeMaxPrice(String price) {
    return 'Prix max : $price';
  }

  @override
  String get storeSearching => 'Recherche en ligne…';

  @override
  String get storeOffline => 'Hors ligne : seule ta collection a été vérifiée';

  @override
  String get storeIsbnRemembered =>
      'ISBN mémorisé sur ce tome pour les prochains scans';

  @override
  String get storeDetails => 'Détails';

  @override
  String get scanModeStore => 'Magasin';

  @override
  String get scanModeBurst => 'Rafale';

  @override
  String burstQueued(int count) {
    return 'Ajouté à la file ($count)';
  }

  @override
  String get burstAlreadyQueued => 'Déjà dans la file';

  @override
  String get burstHint =>
      'Scanne les ouvrages à la suite : les infos sont cherchées en arrière-plan, tu valides ensuite.';

  @override
  String burstReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Revoir ($count)',
      zero: 'File vide',
    );
    return '$_temp0';
  }

  @override
  String burstProgress(int done, int total) {
    return '$done/$total recherchés';
  }

  @override
  String get scanReviewTitle => 'Revue de la rafale';

  @override
  String get reviewPending => 'Recherche…';

  @override
  String get reviewNotFound => 'Introuvable : appuie pour chercher';

  @override
  String get reviewFailed => 'Échec (hors ligne ?) : appuie pour chercher';

  @override
  String get reviewInCollection => 'Déjà dans ta collection';

  @override
  String reviewNewSeries(String title) {
    return 'Nouvelle série « $title »';
  }

  @override
  String reviewAddAll(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count ouvrages',
      one: 'Ajouter 1 ouvrage',
      zero: 'Rien à ajouter',
    );
    return '$_temp0';
  }

  @override
  String reviewAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ouvrages ajoutés',
      one: '1 ouvrage ajouté',
      zero: 'Aucun ouvrage ajouté',
    );
    return '$_temp0';
  }

  @override
  String get reviewRetry => 'Relancer les échecs';

  @override
  String get reviewEmpty =>
      'La file est vide. Passe en mode Rafale sur l’écran Scanner pour la remplir.';

  @override
  String get reviewRemoved => 'Retiré de la file';

  @override
  String get reviewEditHint =>
      'Appuie sur un ouvrage pour le corriger avant de l’ajouter';

  @override
  String get settingsSources => 'Sources de données';

  @override
  String get sourceNeedsKey => 'Clé requise : saisis-la ci-dessous';

  @override
  String get apiKeyTile => 'Clé API';

  @override
  String get apiKeySaved => 'Clé saisie dans l’appli';

  @override
  String get apiKeyBuiltIn => 'Clé intégrée à cette version (env.json)';

  @override
  String get apiKeyMissing => 'Aucune clé : touche pour en saisir une';

  @override
  String apiKeyTitle(String source) {
    return 'Clé $source';
  }

  @override
  String get apiKeyHelpGoogleBooks =>
      'Crée une clé dans la console Google Cloud (console.cloud.google.com → API et services → Identifiants), avec la « Books API » activée, et restreins-la à cette API.';

  @override
  String get apiKeyHelpComicVine =>
      'Crée un compte Comic Vine, puis copie ta clé depuis comicvine.gamespot.com/api (usage non commercial).';

  @override
  String get apiKeyPrivacy =>
      'La clé reste sur cet appareil : elle n’est ni synchronisée, ni sauvegardée, ni écrite dans le journal.';

  @override
  String get apiKeyTest => 'Tester la clé';

  @override
  String get apiKeyValid => 'Clé valide';

  @override
  String get apiKeyInvalid =>
      'Clé refusée : vérifie-la (pour Google : Books API activée et autorisée pour cette clé)';

  @override
  String get apiKeyQuota => 'Clé valide, mais quota dépassé pour l’instant';

  @override
  String get apiKeyOffline => 'Pas de connexion : impossible de tester la clé';

  @override
  String get apiKeyFailed =>
      'Réponse inattendue du service (réessaie plus tard)';

  @override
  String get apiKeyRemove => 'Effacer';

  @override
  String get apiKeyStored => 'Clé enregistrée';

  @override
  String get apiKeyRemoved => 'Clé effacée';

  @override
  String get sourceBnfHelp =>
      'Catalogue de la BnF : éditions françaises, prix, séries';

  @override
  String get sourceGoogleBooksHelp => 'Couvertures et résumés';

  @override
  String get sourceOpenLibraryHelp => 'Livres, couvertures';

  @override
  String get sourceComicVineHelp => 'Comics US : séries et numéros';

  @override
  String get sourceAnilistHelp =>
      'Mangas : infos de série (nombre de tomes, statut)';

  @override
  String volumeCopiesTitle(String label, int count) {
    return 'Tome $label : $count exemplaires';
  }

  @override
  String copyNumber(int number) {
    return 'Exemplaire $number';
  }

  @override
  String get filterToRead => 'À lire';

  @override
  String get markReadTitle => 'Marquer comme lus…';

  @override
  String get markReadUpTo => 'Lus jusqu’au tome';

  @override
  String get markReadConfirm => 'Marquer comme lus';

  @override
  String volumesMarkedRead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes marqués comme lus',
      one: '1 tome marqué comme lu',
      zero: 'Aucun tome à marquer',
    );
    return '$_temp0';
  }

  @override
  String volumesToRead(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes à lire',
      one: '1 tome à lire',
    );
    return '$_temp0';
  }

  @override
  String get notificationOpen => 'Ouvrir';

  @override
  String get notificationChannelLoans => 'Rappels de retour des prêts';

  @override
  String get loanDueTitle => 'Prêt à récupérer';

  @override
  String loanDueBody(String title, String name) {
    return '$title : prêté à $name';
  }

  @override
  String loansOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prêts en retard',
      one: '1 prêt en retard',
    );
    return '$_temp0';
  }

  @override
  String get lend => 'Prêter';

  @override
  String lendTitle(String title) {
    return 'Prêter « $title »';
  }

  @override
  String get borrowerLabel => 'Emprunteur';

  @override
  String get dueDateOptional => 'Date de retour (facultatif)';

  @override
  String get noDueDate => 'Sans date de retour';

  @override
  String loanedTo(String name) {
    return 'Prêté à $name';
  }

  @override
  String loanedSince(String date) {
    return 'depuis le $date';
  }

  @override
  String loanDueOn(String date) {
    return 'retour prévu le $date';
  }

  @override
  String get loanOverdue => 'En retard';

  @override
  String get markReturned => 'Rendu';

  @override
  String loanReturnedOn(String date) {
    return 'Rendu le $date';
  }

  @override
  String get loansCurrent => 'En cours';

  @override
  String get loansHistory => 'Historique';

  @override
  String get loansEmpty => 'Aucun prêt en cours';

  @override
  String get loansHistoryEmpty => 'Aucun prêt rendu';

  @override
  String get wishlistItems => 'Envies';

  @override
  String get nextVolumes => 'Prochains tomes à acheter';

  @override
  String get wishlistEmpty => 'Ta liste d’envies est vide';

  @override
  String get noNextVolumes => 'Aucun tome manquant dans tes séries suivies';

  @override
  String priorityShort(int priority) {
    return 'Priorité $priority';
  }

  @override
  String get addMissingToWishlist => 'Ajouter aux envies';

  @override
  String missingAddedToWishlist(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes ajoutés aux envies',
      one: '1 tome ajouté aux envies',
      zero: 'Déjà dans tes envies',
    );
    return '$_temp0';
  }

  @override
  String get addCopy => 'Ajouter un exemplaire';

  @override
  String get storeOtherEdition => 'Tu as ce tome dans une autre édition';

  @override
  String get addThisCopy => 'Ajouter cet exemplaire';

  @override
  String get boughtTitle => 'Je l’ai acheté';

  @override
  String get paidPriceOptional => 'Prix payé (facultatif)';

  @override
  String boughtDone(String title) {
    return '« $title » ajouté à ta collection';
  }

  @override
  String get statsSpent => 'Dépensé';

  @override
  String statsSpentCaption(int priced, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'exemplaires sur $total',
      one: 'exemplaire sur 1',
    );
    return 'prix payé saisi pour $priced $_temp0';
  }

  @override
  String get statsValue => 'Valeur';

  @override
  String get statsValueCaption =>
      'valeur estimée, sinon prix éditeur ou prix payé';

  @override
  String get statsVolumes => 'Ouvrages';

  @override
  String statsVolumesCaption(int copies) {
    String _temp0 = intl.Intl.pluralLogic(
      copies,
      locale: localeName,
      other: '$copies exemplaires',
      one: '1 exemplaire',
    );
    return '$_temp0';
  }

  @override
  String statsOtherCurrencies(String list) {
    return 'Hors total (autres devises) : $list';
  }

  @override
  String get statsRead => 'Lus';

  @override
  String get statsComplete => 'Séries complètes';

  @override
  String get statsCompleteCaption =>
      'parmi les séries dont le nombre de tomes est connu';

  @override
  String get statsSpendingByMonth => 'Dépenses des 12 derniers mois';

  @override
  String get statsNoSpending =>
      'Aucun achat daté sur cette période : renseigne la date et le prix d’achat, ou utilise « Je l’ai acheté ».';

  @override
  String get statsVolumesByType => 'Ouvrages par type';

  @override
  String get statsSpendingByType => 'Dépenses par type';

  @override
  String get statsShowTable => 'Voir le tableau';

  @override
  String get statsShowChart => 'Voir le graphique';

  @override
  String get statsMonth => 'Mois';

  @override
  String get statsAmount => 'Montant';

  @override
  String get statsEmpty => 'Ajoute des ouvrages pour voir tes statistiques';

  @override
  String statsRatio(int count, int total) {
    return '$count sur $total';
  }

  @override
  String get accountSection => 'Compte et synchronisation';

  @override
  String get syncLocalOnly => 'Synchronisation non configurée';

  @override
  String get syncLocalOnlyHelp =>
      'Renseigne SUPABASE_URL et SUPABASE_ANON_KEY dans env.json. L’appli fonctionne entièrement sans compte.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInHelp =>
      'Synchronise ta collection entre ton téléphone et ton PC';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signInTitle => 'Connexion';

  @override
  String get emailLabel => 'Adresse email';

  @override
  String signedInAs(String email) {
    return 'Connecté : $email';
  }

  @override
  String get signUp => 'Créer un compte';

  @override
  String get signUpTitle => 'Créer un compte';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordConfirmLabel => 'Confirme le mot de passe';

  @override
  String get passwordsDontMatch => 'Les deux mots de passe sont différents';

  @override
  String get passwordEmpty => 'Saisis un mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get noAccountYet => 'Pas encore de compte ? Créer un compte';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String confirmEmailSent(String email) {
    return 'Compte créé : colle ci-dessous le lien de l’e-mail envoyé à $email (appui long sur le lien → copier, sans l’ouvrir), ou son code s’il en a un.';
  }

  @override
  String get setPassword => 'Mot de passe';

  @override
  String get setPasswordHelp => 'Définir ou changer le mot de passe du compte';

  @override
  String get setPasswordTitle => 'Nouveau mot de passe';

  @override
  String get setPasswordDone => 'Mot de passe enregistré';

  @override
  String get signInDone =>
      'Connecté. Ta collection locale est envoyée sur ton compte.';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get syncIdle => 'Synchronisé';

  @override
  String syncClockSkew(int minutes) {
    return 'Synchronisé, mais l’heure de cet appareil semble fausse (écart de $minutes min avec le serveur) : corrige-la, sinon tes modifications risquent d’être mal départagées';
  }

  @override
  String syncIdleAt(String time) {
    return 'Synchronisé à $time';
  }

  @override
  String get syncRunning => 'Synchronisation…';

  @override
  String get syncOffline =>
      'Hors ligne : les modifications seront envoyées au retour du réseau';

  @override
  String syncFailed(String message) {
    return 'Erreur de synchronisation : $message';
  }

  @override
  String get syncSignedOut =>
      'Non connecté : données sur cet appareil seulement';

  @override
  String get invalidEmail => 'Adresse email invalide';

  @override
  String get moreSuggestions => 'Suggestions';

  @override
  String get moreSuggestionsSubtitle =>
      'Des livres à découvrir, d’après ta collection';

  @override
  String get suggestionsTitle => 'Suggestions';

  @override
  String get suggestionsRefresh => 'Recalculer';

  @override
  String suggestionsProgress(int done, int total) {
    return 'Recherche des suggestions… $done/$total';
  }

  @override
  String suggestionsComputedAt(String date) {
    return 'Calculées le $date (d’après ta collection, tes lectures et tes notes)';
  }

  @override
  String get suggestionsFailed =>
      'Calcul impossible (hors ligne ?) : les suggestions précédentes restent affichées.';

  @override
  String get suggestionsEmpty =>
      'Aucune suggestion pour l’instant. Plus ta collection est riche (lus, notes), plus elles sont précises.';

  @override
  String reasonSameAuthor(int count, String author) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livres',
      one: '1 livre',
    );
    return 'Parce que tu as $_temp0 de $author';
  }

  @override
  String reasonCommunity(String series, int votes) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes avis',
      one: '1 avis',
    );
    return 'Les lecteurs de $series l’apprécient aussi ($_temp0 AniList)';
  }

  @override
  String reasonRelated(String series) {
    return 'Suite ou histoire liée de $series';
  }

  @override
  String get suggestionAddWish => 'Ajouter aux envies';

  @override
  String get suggestionDismiss => 'Pas intéressé';

  @override
  String suggestionWished(String title) {
    return '« $title » ajouté aux envies';
  }

  @override
  String get suggestionDismissed =>
      'Suggestion écartée : ce type de suggestion comptera moins';

  @override
  String get catalogTitle => 'Série complète';

  @override
  String get catalogQuery => 'Titre de la série';

  @override
  String get catalogHelp =>
      'Les tomes et leurs ISBN viennent de la BnF : plus besoin de les scanner.';

  @override
  String get catalogBnfOff => 'La BnF est désactivée (Paramètres → Sources).';

  @override
  String get catalogNone =>
      'Aucun tome numéroté trouvé à la BnF pour ce titre.';

  @override
  String catalogEdition(String publisher, int count) {
    return '$publisher ($count tomes)';
  }

  @override
  String get catalogUpTo => 'Possédés jusqu’au tome (vide : tous)';

  @override
  String get catalogMarkOwned => 'Marquer possédés';

  @override
  String catalogSave(int count) {
    return 'Enregistrer ($count)';
  }

  @override
  String catalogSaved(int created, int updated) {
    String _temp0 = intl.Intl.pluralLogic(
      created,
      locale: localeName,
      other: '$created tomes ajoutés',
      one: '1 tome ajouté',
      zero: 'Aucun tome ajouté',
    );
    String _temp1 = intl.Intl.pluralLogic(
      updated,
      locale: localeName,
      other: '$updated ISBN complétés',
      one: '1 ISBN complété',
      zero: 'aucun ISBN complété',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get catalogComplete => 'Déjà dans la collection';

  @override
  String catalogIsbnAdded(String isbn) {
    return 'Dans la collection sans ISBN → $isbn';
  }

  @override
  String catalogOtherIsbns(int count) {
    return '$count ISBN (réimpressions, éditions)';
  }

  @override
  String get catalogSkip => 'Ignorer';

  @override
  String get addWholeSeries => 'Série complète (BnF)';

  @override
  String get completeFromBnf => 'Compléter depuis la BnF';

  @override
  String get storeWholeSeries => 'Ajouter la série complète';

  @override
  String get seriesIsbnTile => 'Compléter les ISBN des séries (BnF)';

  @override
  String get seriesIsbnHelp =>
      'Les tomes possédés sans ISBN reçoivent celui de la BnF (première impression), sans rien rescanner';

  @override
  String seriesIsbnProgress(int done, int total, int found) {
    return 'Série $done/$total · $found ISBN ajoutés';
  }

  @override
  String seriesIsbnDone(int found, int ambiguous) {
    return '$found ISBN ajoutés · $ambiguous séries à faire depuis leur menu (plusieurs éditions)';
  }

  @override
  String get sectionSigning => 'Dédicace';

  @override
  String get fieldSigned => 'Dédicacé';

  @override
  String get fieldSignedBy => 'Dédicacé par';

  @override
  String get fieldSignedOn => 'Date de la dédicace';

  @override
  String get fieldSignedPlace => 'Lieu';

  @override
  String get fieldSignedPlaceHelper => 'Festival, librairie, salon…';

  @override
  String get fieldSigningNote => 'Texte de la dédicace (à qui…)';

  @override
  String get signedTitle => 'Dédicacé';

  @override
  String get itemPhotosTitle => 'Photos';

  @override
  String get addItemPhoto => 'Ajouter une photo';

  @override
  String get deletePhotoMessage => 'Cette photo sera supprimée.';

  @override
  String get filterSigned => 'Dédicacés';

  @override
  String get statsSigned => 'Dédicacés';

  @override
  String get csvSigned => 'Dédicacé';

  @override
  String get fullArchiveExport => 'Archive complète (avec photos)';

  @override
  String get fullArchiveExportHelp =>
      'Un fichier .zip : la sauvegarde JSON et toutes tes photos (couvertures, dédicaces)';

  @override
  String get fullArchiveImport => 'Restaurer une archive complète';

  @override
  String get fullArchiveImportHelp =>
      'Fusionne la collection et remet les photos (rien n\'est effacé)';

  @override
  String fullArchiveRestored(int rows, int photos) {
    return '$rows lignes et $photos photos restaurées';
  }

  @override
  String fullArchiveSaved(int photos) {
    return 'Archive enregistrée : $photos photos';
  }

  @override
  String signedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count livres dédicacés',
      one: '1 livre dédicacé',
    );
    return '$_temp0';
  }

  @override
  String get sourceMangaUpdatesHelp =>
      'Mangas, y compris français (nombre de tomes parus)';

  @override
  String get sourceMangaDexHelp => 'Couvertures françaises des tomes de manga';

  @override
  String totalFromMangaUpdates(String title, int total) {
    return 'MangaUpdates : « $title », $total tomes';
  }

  @override
  String get releasesTitle => 'Nouveautés';

  @override
  String get releasesSubtitle =>
      'Nouveaux tomes de tes séries et auteurs suivis';

  @override
  String get releasesHelp =>
      'Une nouveauté apparaît dès qu’une source la connaît (souvent à la parution). Vérifié au plus une fois par jour au démarrage.';

  @override
  String get releasesNone => 'Aucune nouveauté pour l’instant.';

  @override
  String get releasesCheckNow => 'Vérifier maintenant';

  @override
  String releasesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouveautés',
      one: '1 nouveauté',
      zero: 'Aucune nouveauté',
    );
    return '$_temp0';
  }

  @override
  String releasesNotificationTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouveautés dans tes séries',
      one: '1 nouveauté dans tes séries',
    );
    return '$_temp0';
  }

  @override
  String get releasesNotificationBody =>
      'Plus → Nouveautés pour les ajouter aux envies';

  @override
  String get notificationChannelReleases =>
      'Nouveaux tomes des séries et auteurs suivis';

  @override
  String releaseVolume(String title, String volume) {
    return '$title, tome $volume';
  }

  @override
  String get releaseNew => 'Nouveau';

  @override
  String releaseByAuthor(String author) {
    return 'de $author';
  }

  @override
  String get releaseIgnore => 'Ignorer';

  @override
  String releaseWished(String title) {
    return '« $title » ajouté aux envies';
  }

  @override
  String releaseAlreadyOwned(String title) {
    return '« $title » est déjà dans ta collection';
  }

  @override
  String releaseWishFailed(String title) {
    return 'Impossible d’ajouter « $title » : sa série n’existe plus';
  }

  @override
  String get releasesEnabled => 'Rechercher les nouveautés';

  @override
  String get releasesEnabledHelp =>
      'Séries suivies et auteurs suivis, une fois par jour';

  @override
  String get releasesNotify => 'Notification des nouveautés';

  @override
  String followedAuthorsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count auteurs suivis',
      one: '1 auteur suivi',
      zero: 'Aucun auteur suivi',
    );
    return '$_temp0';
  }

  @override
  String get followedAuthorsHelp =>
      'Suivre un auteur : cloche sur sa page (vue par auteur)';

  @override
  String get followAuthor => 'Suivre les nouveautés de cet auteur';

  @override
  String get unfollowAuthor => 'Ne plus suivre cet auteur';

  @override
  String get emailCodeLabel => 'Code ou lien reçu par e-mail';

  @override
  String get emailCodeHelp =>
      'Le code à 6 chiffres, ou le lien de l’e-mail copié (appui long, sans l’ouvrir)';

  @override
  String get emailCodeMissing => 'Saisis le code de l’e-mail ou colle son lien';

  @override
  String get confirmCodeAction => 'Confirmer mon adresse';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetHelp =>
      'Saisis l’adresse de ton compte : un e-mail t’y sera envoyé pour choisir un nouveau mot de passe.';

  @override
  String resetCodeSent(String email) {
    return 'Si un compte existe pour $email, un e-mail vient d’y être envoyé : colle son lien (appui long → copier, sans l’ouvrir) ou son code, avec ton nouveau mot de passe.';
  }

  @override
  String get sendResetCode => 'Envoyer l’e-mail';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get resetPasswordAction => 'Changer le mot de passe';

  @override
  String get passwordResetDone => 'Mot de passe changé : tu es connecté';

  @override
  String get errorInvalidCode =>
      'Code incorrect ou expiré : demande un nouveau code';

  @override
  String get coverPhoto => 'Photographier la couverture';

  @override
  String get coverRecrop => 'Recadrer la couverture';

  @override
  String get cropTitle => 'Recadrer';

  @override
  String get cropHelp =>
      'Place les quatre coins sur ceux de la couverture (pince pour zoomer).';

  @override
  String get cropRotate => 'Pivoter d’un quart de tour';

  @override
  String get cropReset => 'Réinitialiser le cadre';

  @override
  String get cropDone => 'Valider';

  @override
  String get cropAspectFree => 'Libre';

  @override
  String get cropAspectPocket => 'Manga / poche';

  @override
  String get cropAspectAlbum => 'Album BD';

  @override
  String get cropAspectComics => 'Comics';

  @override
  String get coverOriginals => 'Photos originales';

  @override
  String get coverOriginalsHelp =>
      'gardées sur cet appareil pour recadrer à nouveau';

  @override
  String get coverOriginalsPurged =>
      'Photos originales supprimées (les couvertures restent)';

  @override
  String coverPhotoError(String message) {
    return 'Photo impossible : $message';
  }

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get backupSection => 'Sauvegarde et import';

  @override
  String get exportJson => 'Exporter une sauvegarde';

  @override
  String get exportJsonHelp => 'Fichier JSON complet : séries, ouvrages, prêts';

  @override
  String get restoreJson => 'Restaurer une sauvegarde';

  @override
  String get restoreJsonHelp =>
      'Fusionner avec la collection, ou revenir exactement à son contenu';

  @override
  String get restoreTitle => 'Restaurer la sauvegarde';

  @override
  String get restoreMerge => 'Fusionner';

  @override
  String get restoreMergeHelp =>
      'Ajoute ce qui manque, garde ce qui est plus récent. Rien n’est effacé.';

  @override
  String get restoreReplace => 'Revenir à cette sauvegarde';

  @override
  String get restoreReplaceHelp =>
      'La collection redevient exactement celle de la sauvegarde, sur tous tes appareils après synchro : ce qui a été ajouté depuis est supprimé. Une sauvegarde automatique est prise juste avant.';

  @override
  String replaceDone(int restored, int removed) {
    return 'Collection restaurée : $restored ouvrages, $removed retirés';
  }

  @override
  String get autoBackups => 'Sauvegardes automatiques';

  @override
  String get autoBackupsHelp =>
      'Chaque semaine, et avant chaque import ou restauration';

  @override
  String get autoBackupsEmpty =>
      'Aucune sauvegarde automatique pour l’instant (collection vide ou première semaine).';

  @override
  String get autoBackupWeekly => 'Hebdomadaire';

  @override
  String get autoBackupBeforeImport => 'Avant import CSV';

  @override
  String get autoBackupBeforeRestore => 'Avant restauration';

  @override
  String autoBackupItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ouvrages',
      one: '1 ouvrage',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupExport => 'Exporter ce fichier';

  @override
  String csvImportFailed(String message) {
    return 'Import interrompu : $message Rien n\'a été ajouté.';
  }

  @override
  String autoBackupFailed(String message) {
    return 'Sauvegarde automatique impossible : import annulé ($message)';
  }

  @override
  String restoreDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments restaurés',
      one: '1 élément restauré',
      zero: 'Rien à restaurer : déjà à jour',
    );
    return '$_temp0';
  }

  @override
  String get restoreInvalid => 'Ce fichier n’est pas une sauvegarde Dupe';

  @override
  String get exportCsv => 'Exporter en CSV';

  @override
  String get exportCsvHelp =>
      'Un tableau par type, lisible dans Excel ou LibreOffice';

  @override
  String get exportCsvAll => 'Tout';

  @override
  String get importCsv => 'Importer un CSV';

  @override
  String get importCsvHelp =>
      'Reprendre une collection (Mangacollec, CLZ, tableur…)';

  @override
  String get exportDone => 'Fichier enregistré';

  @override
  String fileError(String message) {
    return 'Erreur de fichier : $message';
  }

  @override
  String get csvImportTitle => 'Importer un CSV';

  @override
  String csvRows(String file, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes',
      one: '1 ligne',
    );
    return '$file : $_temp0';
  }

  @override
  String get csvDefaults =>
      'Valeurs par défaut (si la colonne est absente ou vide)';

  @override
  String get csvMapping => 'Correspondance des colonnes';

  @override
  String get csvIgnored => '— ignorée —';

  @override
  String get csvPreview => 'Aperçu';

  @override
  String csvImportButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importer $count lignes',
      one: 'Importer 1 ligne',
    );
    return '$_temp0';
  }

  @override
  String get csvTitleRequired => 'Associe au moins la colonne Titre ou Série';

  @override
  String csvImportDone(int created, int series, int duplicates) {
    return '$created ajoutés, $series séries créées, $duplicates déjà présents';
  }

  @override
  String csvInvalidLines(String lines) {
    return 'Lignes ignorées (sans titre) : $lines';
  }

  @override
  String get csvEmpty => 'Fichier vide ou illisible';

  @override
  String get importFieldTitle => 'Titre';

  @override
  String get importFieldSeries => 'Série';

  @override
  String get importFieldVolume => 'Tome / numéro';

  @override
  String get importFieldType => 'Type';

  @override
  String get importFieldAuthors => 'Auteurs';

  @override
  String get importFieldPublisher => 'Éditeur';

  @override
  String get importFieldIsbn => 'ISBN / EAN';

  @override
  String get importFieldOwnership => 'Possédé / envie';

  @override
  String get importFieldReading => 'Statut de lecture';

  @override
  String get importFieldPurchasePrice => 'Prix payé';

  @override
  String get importFieldPurchaseDate => 'Date d’achat';

  @override
  String get importFieldCoverPrice => 'Prix éditeur';

  @override
  String get importFieldLocation => 'Emplacement';

  @override
  String get importFieldNotes => 'Notes';

  @override
  String get moreAbout => 'À propos';

  @override
  String get aboutDescription =>
      'Catalogue personnel de mangas, BD, comics et livres : scanne, vérifie en magasin ce que tu as déjà, suis tes séries.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutSources => 'Sources de données';

  @override
  String get aboutSourcesText =>
      'Bibliothèque nationale de France (catalogue SRU), Open Library, Google Books, AniList, Comic Vine. Les données appartiennent à leurs auteurs ; Dupe ne fait que les consulter.';

  @override
  String get aboutComicVine => 'Données comics fournies par Comic Vine';

  @override
  String get aboutLicenses => 'Licences des composants';

  @override
  String get aboutSourceCode => 'Code source';

  @override
  String get undo => 'Annuler';

  @override
  String itemDeleted(String title) {
    return '« $title » supprimé';
  }

  @override
  String seriesDeleted(String title) {
    return 'Série « $title » supprimée';
  }

  @override
  String get updatesSection => 'Mises à jour';

  @override
  String get updateCheck => 'Signaler les nouvelles versions';

  @override
  String get updateCheckHelp =>
      'Vérifie au plus une fois par jour la dernière version publiée sur GitHub';

  @override
  String get updateCheckNow => 'Rechercher une mise à jour';

  @override
  String get updateUpToDate => 'Dupe est à jour';

  @override
  String updateAvailable(String version) {
    return 'Version $version disponible';
  }

  @override
  String get updateDownload => 'Télécharger';

  @override
  String get torchOn => 'Allumer la lampe';

  @override
  String get torchOff => 'Éteindre la lampe';

  @override
  String get scanSection => 'Scan';

  @override
  String get storeHaptics => 'Vibrer selon le résultat';

  @override
  String get storeHapticsHelp =>
      'Mode Magasin : 1 longue = déjà possédé, 2 = en envie, 3 courtes = tome manquant d’une série, 1 brève = inconnu';

  @override
  String get voiceSearchTitle => 'Recherche vocale';

  @override
  String get voiceSearchExplain =>
      'Dupe va te demander l’accès au micro. Ce que tu dis est transcrit par le service de reconnaissance vocale de ton appareil, puis cherché dans ta collection : Dupe n’enregistre rien. Dis par exemple « One Piece tome 107 » ou « tome 3 de Blacksad ».';

  @override
  String get voiceSearchContinue => 'Continuer';

  @override
  String get voiceSearchListening => 'J’écoute…';

  @override
  String get voiceSearchExample => 'Dis par exemple « One Piece tome 107 »';

  @override
  String get voiceSearchStop => 'Arrêter';

  @override
  String get voiceSearchNothing =>
      'Je n’ai rien entendu (ou le micro n’est pas autorisé)';

  @override
  String voiceVolumeMissing(String volume, String series) {
    return 'Tome $volume de $series : absent de ta collection';
  }

  @override
  String widgetOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ouvrages',
      one: '1 ouvrage',
      zero: 'Collection vide',
    );
    return '$_temp0';
  }

  @override
  String widgetOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prêts en retard',
      one: '1 prêt en retard',
    );
    return '$_temp0';
  }

  @override
  String get errorOffline => 'Pas de connexion internet.';

  @override
  String get errorSession => 'Session expirée : reconnecte-toi.';

  @override
  String get errorUnavailable =>
      'Serveur de synchronisation indisponible. Si l’appli n’a pas servi depuis une semaine, le projet Supabase gratuit est peut-être en pause : le réactiver depuis son tableau de bord.';

  @override
  String get errorServer =>
      'Le serveur a refusé la demande (détails dans À propos → Journal).';

  @override
  String get errorInvalidCredentials => 'Email ou mot de passe incorrect.';

  @override
  String get errorEmailNotConfirmed =>
      'Email pas encore confirmé : ouvre le lien reçu par email, puis reconnecte-toi.';

  @override
  String get errorEmailTaken =>
      'Un compte existe déjà avec cet email : connecte-toi.';

  @override
  String get errorWeakPassword =>
      'Mot de passe refusé : trop court ou trop simple.';

  @override
  String get errorTooManyAttempts =>
      'Trop de tentatives : réessaie dans quelques minutes.';

  @override
  String get errorSignInRefused =>
      'Connexion refusée (détails dans À propos → Journal).';

  @override
  String get errorNotBackup => 'Ce fichier n\'est pas une sauvegarde Dupe.';

  @override
  String get errorFileAccess => 'Fichier inaccessible (droits ou emplacement).';

  @override
  String get errorBadFile => 'Fichier illisible ou mal formé.';

  @override
  String get errorUnknown =>
      'Une erreur est survenue (détails dans À propos → Journal).';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalSubtitle =>
      'Erreurs et événements récents, à copier pour signaler un problème';

  @override
  String get journalEmpty => 'Rien à signaler';

  @override
  String get journalCopy => 'Copier';

  @override
  String get journalCopied => 'Journal copié';

  @override
  String get journalShare => 'Partager';

  @override
  String get journalClear => 'Vider le journal';

  @override
  String get offlineCoversSection => 'Couvertures hors ligne';

  @override
  String get offlineCovers => 'Télécharger toutes les couvertures';

  @override
  String get offlineCoversHelp =>
      'Collection et envies, pour les voir sans connexion (en magasin)';

  @override
  String get offlineCoversWifiOnly => 'Wi-Fi seulement';

  @override
  String get offlineCoversWifiOnlyHelp => 'Jamais sur les données mobiles';

  @override
  String offlineCoversSize(String size) {
    return '$size Mo utilisés';
  }

  @override
  String get offlineCoversRefresh => 'toucher pour vérifier';

  @override
  String get missingCovers => 'Compléter les couvertures manquantes';

  @override
  String get missingCoversHelp =>
      'Cherche par ISBN une couverture pour chaque livre qui n’en a pas ou dont la couverture ne se charge pas (sans rien changer d’autre ; tes photos sont gardées)';

  @override
  String missingCoversProgress(int done, int total, int found) {
    return '$done / $total livres vérifiés · $found trouvée(s)';
  }

  @override
  String missingCoversDone(int found, int total) {
    return '$found couverture(s) ajoutée(s) ou remplacée(s) · $total livres vérifiés';
  }

  @override
  String get offlineCoversClear => 'Vider';

  @override
  String get offlineCoversCleared =>
      'Couvertures téléchargées supprimées (vos photos sont gardées)';

  @override
  String get offlineCoversDisabled => 'Désactivé';

  @override
  String get offlineCoversOffline => 'En attente d’une connexion';

  @override
  String get offlineCoversMetered => 'En attente du Wi-Fi';

  @override
  String offlineCoversProgress(int done, int total) {
    return 'Téléchargement : $done / $total';
  }

  @override
  String get offlineCoversNone => 'Aucune couverture à télécharger';

  @override
  String offlineCoversDone(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total couvertures disponibles hors ligne',
      one: '1 couverture disponible hors ligne',
    );
    return '$_temp0';
  }

  @override
  String offlineCoversDoneWithFailures(int total, int failed) {
    return '$total couvertures, dont $failed introuvables';
  }

  @override
  String get statsReadByMonth => 'Tomes lus par mois';

  @override
  String get statsNoReadDates =>
      'Aucune date de lecture sur les 12 derniers mois.';

  @override
  String get statsReadCount => 'Lus';

  @override
  String statsReadWithoutDate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count tomes lus sans date de lecture ne sont pas comptés par mois.',
      one: '1 tome lu sans date de lecture n’est pas compté par mois.',
    );
    return '$_temp0';
  }

  @override
  String get statsReadByType => 'Lu par type';

  @override
  String get statsPile => 'Pile à lire et habitudes';

  @override
  String statsPileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tomes à lire',
      one: '1 tome à lire',
      zero: 'Pile à lire vide',
    );
    return '$_temp0';
  }

  @override
  String statsPileOldest(String title, String date) {
    return 'Le plus ancien : $title, depuis le $date';
  }

  @override
  String statsDelay(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Lu $days jours après l’achat, en moyenne',
      one: 'Lu 1 jour après l’achat, en moyenne',
      zero: 'Lu le jour de l’achat, en moyenne',
    );
    return '$_temp0';
  }

  @override
  String get statsDelayUnknown => 'Délai entre achat et lecture inconnu';

  @override
  String get statsDelayHelp =>
      'Il faut une date d’achat et une date de lecture.';

  @override
  String statsDelaySamples(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sur $count tomes ayant les deux dates',
      one: 'Sur 1 tome ayant les deux dates',
    );
    return '$_temp0';
  }

  @override
  String statsAbandoned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séries abandonnées',
      one: '1 série abandonnée',
      zero: 'Aucune série abandonnée',
    );
    return '$_temp0';
  }

  @override
  String get shareWishlist => 'Partager mes envies';

  @override
  String shareWishlistHeading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ma liste d’envies ($count)',
      one: 'Ma liste d’envies (1)',
    );
    return '$_temp0';
  }

  @override
  String shareWishlistCaption(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count envies',
      one: '1 envie',
    );
    return '$_temp0 · $date';
  }

  @override
  String get sharePriorityAll => 'Toutes priorités';

  @override
  String sharePriorityUpTo(int max) {
    String _temp0 = intl.Intl.pluralLogic(
      max,
      locale: localeName,
      other: 'Priorités 1 à $max',
      one: 'Priorité 1',
    );
    return '$_temp0';
  }

  @override
  String get shareShowPrice => 'Afficher le prix max';

  @override
  String get shareAsImage => 'Partager l’image';

  @override
  String get shareAsText => 'Partager le texte';

  @override
  String get shareNoWish => 'Aucune envie ne correspond aux filtres.';

  @override
  String get shareFileName => 'envies.png';

  @override
  String get shareImageSaved => 'Image enregistrée';

  @override
  String get shareTextCopied => 'Liste copiée dans le presse-papiers';
}
