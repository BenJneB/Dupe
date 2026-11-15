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
  String get markOwned => 'Je l’ai acheté';

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
  String get sourceNeedsKey => 'Clé API absente de env.json';

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
  String loanReturnedSnack(String title) {
    return '« $title » marqué comme rendu';
  }

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
    return 'Compte créé. Ouvre le lien envoyé à $email pour confirmer ton adresse, puis connecte-toi ici.';
  }

  @override
  String get forgotPasswordHelp =>
      'Mot de passe oublié : change-le depuis un appareil encore connecté (Paramètres → Mot de passe).';

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
  String get coverPhoto => 'Photographier la couverture';

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
      'Ajoute ce qui manque, met à jour ce qui est plus récent ; rien n’est effacé';

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
  String get errorOffline => 'Pas de connexion internet.';

  @override
  String get errorSession => 'Session expirée : reconnecte-toi.';

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
}
