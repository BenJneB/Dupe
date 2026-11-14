import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dupe'**
  String get appTitle;

  /// No description provided for @tabMangas.
  ///
  /// In fr, this message translates to:
  /// **'Mangas'**
  String get tabMangas;

  /// No description provided for @tabBd.
  ///
  /// In fr, this message translates to:
  /// **'BD'**
  String get tabBd;

  /// No description provided for @tabComics.
  ///
  /// In fr, this message translates to:
  /// **'Comics'**
  String get tabComics;

  /// No description provided for @tabBooks.
  ///
  /// In fr, this message translates to:
  /// **'Livres'**
  String get tabBooks;

  /// No description provided for @tabMore.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get tabMore;

  /// No description provided for @scan.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get scan;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans ma collection'**
  String get searchHint;

  /// No description provided for @emptyCollectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun ouvrage pour l’instant'**
  String get emptyCollectionTitle;

  /// No description provided for @emptyCollectionBody.
  ///
  /// In fr, this message translates to:
  /// **'Scanne un code-barres ou ajoute un ouvrage avec le bouton +.'**
  String get emptyCollectionBody;

  /// No description provided for @moreWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Liste d’envies'**
  String get moreWishlist;

  /// No description provided for @moreLoans.
  ///
  /// In fr, this message translates to:
  /// **'Prêts'**
  String get moreLoans;

  /// No description provided for @moreStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get moreStats;

  /// No description provided for @moreSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get moreSettings;

  /// No description provided for @moreSettingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte, synchronisation, export/import, sources'**
  String get moreSettingsSubtitle;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get comingSoon;

  /// No description provided for @scanUnavailableDesktop.
  ///
  /// In fr, this message translates to:
  /// **'Pas de caméra sur cette plateforme : saisis l’ISBN ou utilise une douchette USB.'**
  String get scanUnavailableDesktop;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get clear;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @none.
  ///
  /// In fr, this message translates to:
  /// **'—'**
  String get none;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteSeriesMessage.
  ///
  /// In fr, this message translates to:
  /// **'La série « {title} » et tous ses tomes seront supprimés.'**
  String deleteSeriesMessage(String title);

  /// No description provided for @deleteItemMessage.
  ///
  /// In fr, this message translates to:
  /// **'« {title} » sera supprimé de ta collection.'**
  String deleteItemMessage(String title);

  /// No description provided for @loadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement : {error}'**
  String loadError(String error);

  /// No description provided for @notFound.
  ///
  /// In fr, this message translates to:
  /// **'Introuvable (peut-être supprimé)'**
  String get notFound;

  /// No description provided for @newSeries.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle série'**
  String get newSeries;

  /// No description provided for @newCycle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau cycle'**
  String get newCycle;

  /// No description provided for @newBook.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau livre'**
  String get newBook;

  /// No description provided for @newOneShot.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrage isolé (one-shot)'**
  String get newOneShot;

  /// No description provided for @newItemTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel ouvrage'**
  String get newItemTitle;

  /// No description provided for @editItem.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l’ouvrage'**
  String get editItem;

  /// No description provided for @editSeries.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la série'**
  String get editSeries;

  /// No description provided for @sortBy.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get sortBy;

  /// No description provided for @sortTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get sortTitle;

  /// No description provided for @sortRecent.
  ///
  /// In fr, this message translates to:
  /// **'Ajout récent'**
  String get sortRecent;

  /// No description provided for @sortProgress.
  ///
  /// In fr, this message translates to:
  /// **'Progression'**
  String get sortProgress;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get filterAll;

  /// No description provided for @filterComplete.
  ///
  /// In fr, this message translates to:
  /// **'Complètes'**
  String get filterComplete;

  /// No description provided for @filterIncomplete.
  ///
  /// In fr, this message translates to:
  /// **'Incomplètes'**
  String get filterIncomplete;

  /// No description provided for @noFilterResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour ce filtre'**
  String get noFilterResults;

  /// No description provided for @viewGrid.
  ///
  /// In fr, this message translates to:
  /// **'Afficher en grille'**
  String get viewGrid;

  /// No description provided for @viewList.
  ///
  /// In fr, this message translates to:
  /// **'Afficher en liste'**
  String get viewList;

  /// No description provided for @volumesOwned.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun tome} =1{1 tome} other{{count} tomes}}'**
  String volumesOwned(int count);

  /// No description provided for @volumesOwnedOfTotal.
  ///
  /// In fr, this message translates to:
  /// **'{owned}/{total} {total, plural, =1{tome} other{tomes}}'**
  String volumesOwnedOfTotal(int owned, int total);

  /// No description provided for @missingVolumes.
  ///
  /// In fr, this message translates to:
  /// **'il manque {list}'**
  String missingVolumes(String list);

  /// No description provided for @rangeWord.
  ///
  /// In fr, this message translates to:
  /// **'à'**
  String get rangeWord;

  /// No description provided for @seriesComplete.
  ///
  /// In fr, this message translates to:
  /// **'série complète'**
  String get seriesComplete;

  /// No description provided for @noVolumesYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun tome. Indique le nombre de tomes de la série ou ajoute-en avec le bouton ⊕.'**
  String get noVolumesYet;

  /// No description provided for @addVolumes.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter des tomes'**
  String get addVolumes;

  /// No description provided for @rangeFrom.
  ///
  /// In fr, this message translates to:
  /// **'Du tome'**
  String get rangeFrom;

  /// No description provided for @rangeTo.
  ///
  /// In fr, this message translates to:
  /// **'Au tome'**
  String get rangeTo;

  /// No description provided for @volumesAdded.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun tome ajouté (déjà présents)} =1{1 tome ajouté} other{{count} tomes ajoutés}}'**
  String volumesAdded(int count);

  /// No description provided for @volumeMarkedOwned.
  ///
  /// In fr, this message translates to:
  /// **'Tome {label} marqué comme possédé'**
  String volumeMarkedOwned(String label);

  /// No description provided for @volumeTitle.
  ///
  /// In fr, this message translates to:
  /// **'{title} – tome {volume}'**
  String volumeTitle(String title, String volume);

  /// No description provided for @slotOwned.
  ///
  /// In fr, this message translates to:
  /// **'Possédé'**
  String get slotOwned;

  /// No description provided for @slotLoaned.
  ///
  /// In fr, this message translates to:
  /// **'Prêté'**
  String get slotLoaned;

  /// No description provided for @slotWished.
  ///
  /// In fr, this message translates to:
  /// **'Envie'**
  String get slotWished;

  /// No description provided for @slotMissing.
  ///
  /// In fr, this message translates to:
  /// **'Manquant'**
  String get slotMissing;

  /// No description provided for @slotSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Tome {label}, {status}'**
  String slotSemantics(String label, String status);

  /// No description provided for @markOwned.
  ///
  /// In fr, this message translates to:
  /// **'Je l’ai acheté'**
  String get markOwned;

  /// No description provided for @seeSeries.
  ///
  /// In fr, this message translates to:
  /// **'Voir la série'**
  String get seeSeries;

  /// No description provided for @ownershipOwned.
  ///
  /// In fr, this message translates to:
  /// **'Possédé'**
  String get ownershipOwned;

  /// No description provided for @ownershipWished.
  ///
  /// In fr, this message translates to:
  /// **'Envie'**
  String get ownershipWished;

  /// No description provided for @publicationOngoing.
  ///
  /// In fr, this message translates to:
  /// **'En cours de parution'**
  String get publicationOngoing;

  /// No description provided for @publicationFinished.
  ///
  /// In fr, this message translates to:
  /// **'Parution terminée'**
  String get publicationFinished;

  /// No description provided for @publicationUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Statut de parution inconnu'**
  String get publicationUnknown;

  /// No description provided for @readingUnread.
  ///
  /// In fr, this message translates to:
  /// **'Non lu'**
  String get readingUnread;

  /// No description provided for @readingInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get readingInProgress;

  /// No description provided for @readingRead.
  ///
  /// In fr, this message translates to:
  /// **'Lu'**
  String get readingRead;

  /// No description provided for @readingAbandoned.
  ///
  /// In fr, this message translates to:
  /// **'Abandonné'**
  String get readingAbandoned;

  /// No description provided for @sectionGeneral.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get sectionGeneral;

  /// No description provided for @sectionReading.
  ///
  /// In fr, this message translates to:
  /// **'Lecture'**
  String get sectionReading;

  /// No description provided for @sectionCopy.
  ///
  /// In fr, this message translates to:
  /// **'Exemplaire'**
  String get sectionCopy;

  /// No description provided for @sectionPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get sectionPrice;

  /// No description provided for @sectionWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Liste d’envies'**
  String get sectionWishlist;

  /// No description provided for @fieldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get fieldTitle;

  /// No description provided for @fieldOriginalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre original'**
  String get fieldOriginalTitle;

  /// No description provided for @fieldAuthors.
  ///
  /// In fr, this message translates to:
  /// **'Auteurs'**
  String get fieldAuthors;

  /// No description provided for @fieldPublisher.
  ///
  /// In fr, this message translates to:
  /// **'Éditeur'**
  String get fieldPublisher;

  /// No description provided for @fieldCollection.
  ///
  /// In fr, this message translates to:
  /// **'Collection'**
  String get fieldCollection;

  /// No description provided for @fieldPublicationStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut de parution'**
  String get fieldPublicationStatus;

  /// No description provided for @fieldTotalVolumes.
  ///
  /// In fr, this message translates to:
  /// **'Nombre total de tomes'**
  String get fieldTotalVolumes;

  /// No description provided for @fieldOwnedUpTo.
  ///
  /// In fr, this message translates to:
  /// **'Je possède les tomes 1 à…'**
  String get fieldOwnedUpTo;

  /// No description provided for @fieldOwnedUpToHelper.
  ///
  /// In fr, this message translates to:
  /// **'Crée directement les tomes possédés'**
  String get fieldOwnedUpToHelper;

  /// No description provided for @fieldFollowed.
  ///
  /// In fr, this message translates to:
  /// **'Série suivie'**
  String get fieldFollowed;

  /// No description provided for @fieldFollowedHelper.
  ///
  /// In fr, this message translates to:
  /// **'Les tomes non possédés comptent comme manquants'**
  String get fieldFollowedHelper;

  /// No description provided for @fieldCoverUrl.
  ///
  /// In fr, this message translates to:
  /// **'URL de la couverture'**
  String get fieldCoverUrl;

  /// No description provided for @fieldDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @fieldNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @fieldVolumeNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de tome'**
  String get fieldVolumeNumber;

  /// No description provided for @fieldVolumeNumberHelper.
  ///
  /// In fr, this message translates to:
  /// **'Ex. 12, 1.5, HS 2, Annual 1'**
  String get fieldVolumeNumberHelper;

  /// No description provided for @fieldEdition.
  ///
  /// In fr, this message translates to:
  /// **'Édition'**
  String get fieldEdition;

  /// No description provided for @fieldFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format'**
  String get fieldFormat;

  /// No description provided for @fieldPublishDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de parution'**
  String get fieldPublishDate;

  /// No description provided for @fieldPageCount.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de pages'**
  String get fieldPageCount;

  /// No description provided for @fieldLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get fieldLanguage;

  /// No description provided for @fieldIsbn.
  ///
  /// In fr, this message translates to:
  /// **'ISBN'**
  String get fieldIsbn;

  /// No description provided for @fieldUpc.
  ///
  /// In fr, this message translates to:
  /// **'UPC'**
  String get fieldUpc;

  /// No description provided for @fieldReadingStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut de lecture'**
  String get fieldReadingStatus;

  /// No description provided for @fieldReadDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de lecture'**
  String get fieldReadDate;

  /// No description provided for @fieldRating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get fieldRating;

  /// No description provided for @fieldFirstEdition.
  ///
  /// In fr, this message translates to:
  /// **'Édition originale (EO)'**
  String get fieldFirstEdition;

  /// No description provided for @fieldVariant.
  ///
  /// In fr, this message translates to:
  /// **'Variante'**
  String get fieldVariant;

  /// No description provided for @fieldCondition.
  ///
  /// In fr, this message translates to:
  /// **'État'**
  String get fieldCondition;

  /// No description provided for @fieldLocation.
  ///
  /// In fr, this message translates to:
  /// **'Emplacement'**
  String get fieldLocation;

  /// No description provided for @fieldLocationHelper.
  ///
  /// In fr, this message translates to:
  /// **'Étagère, carton…'**
  String get fieldLocationHelper;

  /// No description provided for @fieldPurchasePrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix payé'**
  String get fieldPurchasePrice;

  /// No description provided for @fieldPurchaseDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d’achat'**
  String get fieldPurchaseDate;

  /// No description provided for @fieldCoverPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix éditeur'**
  String get fieldCoverPrice;

  /// No description provided for @fieldEstimatedValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur estimée'**
  String get fieldEstimatedValue;

  /// No description provided for @fieldCurrency.
  ///
  /// In fr, this message translates to:
  /// **'Devise'**
  String get fieldCurrency;

  /// No description provided for @fieldWishlistPriority.
  ///
  /// In fr, this message translates to:
  /// **'Priorité (1 = haute)'**
  String get fieldWishlistPriority;

  /// No description provided for @fieldWishlistMaxPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix max'**
  String get fieldWishlistMaxPrice;

  /// No description provided for @commaSeparated.
  ///
  /// In fr, this message translates to:
  /// **'Séparés par des virgules'**
  String get commaSeparated;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Champ obligatoire'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Nombre invalide'**
  String get invalidNumber;

  /// No description provided for @searchPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Titre, auteur, éditeur ou ISBN'**
  String get searchPrompt;

  /// No description provided for @searchNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Rien trouvé pour « {query} »'**
  String searchNoResults(String query);

  /// No description provided for @searchSeriesSection.
  ///
  /// In fr, this message translates to:
  /// **'Séries'**
  String get searchSeriesSection;

  /// No description provided for @searchItemsSection.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrages'**
  String get searchItemsSection;

  /// No description provided for @starterCollectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Importer ma collection de départ'**
  String get starterCollectionTitle;

  /// No description provided for @starterCollectionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Dreamland, Naheulbeuk, Batman, Les Fourmis, Fabien Olicard (sans doublons, complète les ISBN)'**
  String get starterCollectionSubtitle;

  /// No description provided for @starterCollectionImported.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Rien à faire : déjà à jour} =1{1 modification} other{{count} modifications}}'**
  String starterCollectionImported(int count);

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @searchOnline.
  ///
  /// In fr, this message translates to:
  /// **'Chercher en ligne'**
  String get searchOnline;

  /// No description provided for @onlineSearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher en ligne'**
  String get onlineSearchTitle;

  /// No description provided for @onlineSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'ISBN, titre ou auteur'**
  String get onlineSearchHint;

  /// No description provided for @onlineSearchPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Saisis un ISBN ou un titre, puis lance la recherche.'**
  String get onlineSearchPrompt;

  /// No description provided for @upcNotSupported.
  ///
  /// In fr, this message translates to:
  /// **'Code UPC (comics US) : cherche plutôt par titre et numéro, par exemple « Batman 3 », dans le type Comics.'**
  String get upcNotSupported;

  /// No description provided for @invalidCode.
  ///
  /// In fr, this message translates to:
  /// **'Code « {code} » non reconnu comme ISBN'**
  String invalidCode(String code);

  /// No description provided for @alreadyOwned.
  ///
  /// In fr, this message translates to:
  /// **'Déjà dans ta collection'**
  String get alreadyOwned;

  /// No description provided for @alreadyWished.
  ///
  /// In fr, this message translates to:
  /// **'Déjà dans ta liste d’envies'**
  String get alreadyWished;

  /// No description provided for @isbnNotFound.
  ///
  /// In fr, this message translates to:
  /// **'ISBN {isbn} introuvable'**
  String isbnNotFound(String isbn);

  /// No description provided for @isbnNotFoundHint.
  ///
  /// In fr, this message translates to:
  /// **'Tu peux l’ajouter à la main avec le bouton +.'**
  String get isbnNotFoundHint;

  /// No description provided for @sourcesUsed.
  ///
  /// In fr, this message translates to:
  /// **'Sources : {sources}'**
  String sourcesUsed(String sources);

  /// No description provided for @sourcesUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Sources indisponibles : {sources}'**
  String sourcesUnavailable(String sources);

  /// No description provided for @addToCollection.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la collection'**
  String get addToCollection;

  /// No description provided for @addToWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux envies'**
  String get addToWishlist;

  /// No description provided for @isbnEntryLabel.
  ///
  /// In fr, this message translates to:
  /// **'ISBN'**
  String get isbnEntryLabel;

  /// No description provided for @isbnEntryHelper.
  ///
  /// In fr, this message translates to:
  /// **'Tape l’ISBN ou scanne avec une douchette USB, puis Entrée'**
  String get isbnEntryHelper;

  /// No description provided for @scanDesktopTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner un code-barres'**
  String get scanDesktopTitle;

  /// No description provided for @scanHint.
  ///
  /// In fr, this message translates to:
  /// **'Vise le code-barres au dos de l’ouvrage'**
  String get scanHint;

  /// No description provided for @typeIsbn.
  ///
  /// In fr, this message translates to:
  /// **'Saisir l’ISBN'**
  String get typeIsbn;

  /// No description provided for @cameraUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Caméra indisponible ({error}). Vérifie l’autorisation caméra ou saisis l’ISBN.'**
  String cameraUnavailable(String error);

  /// No description provided for @attachedToSeries.
  ///
  /// In fr, this message translates to:
  /// **'Série : {title}'**
  String attachedToSeries(String title);

  /// No description provided for @attachedToSeriesHelper.
  ///
  /// In fr, this message translates to:
  /// **'Rangé automatiquement dans cette série'**
  String get attachedToSeriesHelper;

  /// No description provided for @createSeriesNamed.
  ///
  /// In fr, this message translates to:
  /// **'Créer la série « {title} »'**
  String createSeriesNamed(String title);

  /// No description provided for @createSeriesHelper.
  ///
  /// In fr, this message translates to:
  /// **'Aucune série correspondante dans ta collection'**
  String get createSeriesHelper;

  /// No description provided for @openOn.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir sur {site}'**
  String openOn(String site);

  /// No description provided for @completeFrom.
  ///
  /// In fr, this message translates to:
  /// **'Compléter depuis {source}'**
  String completeFrom(String source);

  /// No description provided for @seriesLookupHint.
  ///
  /// In fr, this message translates to:
  /// **'Titre de la série'**
  String get seriesLookupHint;

  /// No description provided for @storeOwned.
  ///
  /// In fr, this message translates to:
  /// **'Déjà possédé'**
  String get storeOwned;

  /// No description provided for @storeWished.
  ///
  /// In fr, this message translates to:
  /// **'Dans ta liste d’envies'**
  String get storeWished;

  /// No description provided for @storeSeriesNotOwned.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore possédé'**
  String get storeSeriesNotOwned;

  /// No description provided for @storeUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Pas dans ta collection'**
  String get storeUnknown;

  /// No description provided for @storeVolumeOf.
  ///
  /// In fr, this message translates to:
  /// **'Tome {volume} de {series}'**
  String storeVolumeOf(String volume, String series);

  /// No description provided for @storeYouHave.
  ///
  /// In fr, this message translates to:
  /// **'tu as {list}'**
  String storeYouHave(String list);

  /// No description provided for @storeYouHaveNone.
  ///
  /// In fr, this message translates to:
  /// **'tu n’en as aucun'**
  String get storeYouHaveNone;

  /// No description provided for @storePurchasedOn.
  ///
  /// In fr, this message translates to:
  /// **'Acheté le {date}'**
  String storePurchasedOn(String date);

  /// No description provided for @storeLocation.
  ///
  /// In fr, this message translates to:
  /// **'Emplacement : {location}'**
  String storeLocation(String location);

  /// No description provided for @storeMaxPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix max : {price}'**
  String storeMaxPrice(String price);

  /// No description provided for @storeSearching.
  ///
  /// In fr, this message translates to:
  /// **'Recherche en ligne…'**
  String get storeSearching;

  /// No description provided for @storeOffline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne : seule ta collection a été vérifiée'**
  String get storeOffline;

  /// No description provided for @storeIsbnRemembered.
  ///
  /// In fr, this message translates to:
  /// **'ISBN mémorisé sur ce tome pour les prochains scans'**
  String get storeIsbnRemembered;

  /// No description provided for @storeDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get storeDetails;

  /// No description provided for @scanModeStore.
  ///
  /// In fr, this message translates to:
  /// **'Magasin'**
  String get scanModeStore;

  /// No description provided for @scanModeBurst.
  ///
  /// In fr, this message translates to:
  /// **'Rafale'**
  String get scanModeBurst;

  /// No description provided for @burstQueued.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté à la file ({count})'**
  String burstQueued(int count);

  /// No description provided for @burstAlreadyQueued.
  ///
  /// In fr, this message translates to:
  /// **'Déjà dans la file'**
  String get burstAlreadyQueued;

  /// No description provided for @burstHint.
  ///
  /// In fr, this message translates to:
  /// **'Scanne les ouvrages à la suite : les infos sont cherchées en arrière-plan, tu valides ensuite.'**
  String get burstHint;

  /// No description provided for @burstReview.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{File vide} other{Revoir ({count})}}'**
  String burstReview(int count);

  /// No description provided for @burstProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done}/{total} recherchés'**
  String burstProgress(int done, int total);

  /// No description provided for @scanReviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Revue de la rafale'**
  String get scanReviewTitle;

  /// No description provided for @reviewPending.
  ///
  /// In fr, this message translates to:
  /// **'Recherche…'**
  String get reviewPending;

  /// No description provided for @reviewNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Introuvable : appuie pour chercher'**
  String get reviewNotFound;

  /// No description provided for @reviewFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec (hors ligne ?) : appuie pour chercher'**
  String get reviewFailed;

  /// No description provided for @reviewInCollection.
  ///
  /// In fr, this message translates to:
  /// **'Déjà dans ta collection'**
  String get reviewInCollection;

  /// No description provided for @reviewNewSeries.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle série « {title} »'**
  String reviewNewSeries(String title);

  /// No description provided for @reviewAddAll.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Rien à ajouter} =1{Ajouter 1 ouvrage} other{Ajouter {count} ouvrages}}'**
  String reviewAddAll(int count);

  /// No description provided for @reviewAdded.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun ouvrage ajouté} =1{1 ouvrage ajouté} other{{count} ouvrages ajoutés}}'**
  String reviewAdded(int count);

  /// No description provided for @reviewRetry.
  ///
  /// In fr, this message translates to:
  /// **'Relancer les échecs'**
  String get reviewRetry;

  /// No description provided for @reviewEmpty.
  ///
  /// In fr, this message translates to:
  /// **'La file est vide. Passe en mode Rafale sur l’écran Scanner pour la remplir.'**
  String get reviewEmpty;

  /// No description provided for @reviewRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Retiré de la file'**
  String get reviewRemoved;

  /// No description provided for @reviewEditHint.
  ///
  /// In fr, this message translates to:
  /// **'Appuie sur un ouvrage pour le corriger avant de l’ajouter'**
  String get reviewEditHint;

  /// No description provided for @settingsSources.
  ///
  /// In fr, this message translates to:
  /// **'Sources de données'**
  String get settingsSources;

  /// No description provided for @sourceNeedsKey.
  ///
  /// In fr, this message translates to:
  /// **'Clé API absente de env.json'**
  String get sourceNeedsKey;

  /// No description provided for @sourceBnfHelp.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue de la BnF : éditions françaises, prix, séries'**
  String get sourceBnfHelp;

  /// No description provided for @sourceGoogleBooksHelp.
  ///
  /// In fr, this message translates to:
  /// **'Couvertures et résumés'**
  String get sourceGoogleBooksHelp;

  /// No description provided for @sourceOpenLibraryHelp.
  ///
  /// In fr, this message translates to:
  /// **'Livres, couvertures'**
  String get sourceOpenLibraryHelp;

  /// No description provided for @sourceComicVineHelp.
  ///
  /// In fr, this message translates to:
  /// **'Comics US : séries et numéros'**
  String get sourceComicVineHelp;

  /// No description provided for @sourceAnilistHelp.
  ///
  /// In fr, this message translates to:
  /// **'Mangas : infos de série (nombre de tomes, statut)'**
  String get sourceAnilistHelp;

  /// No description provided for @volumeCopiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tome {label} : {count} exemplaires'**
  String volumeCopiesTitle(String label, int count);

  /// No description provided for @copyNumber.
  ///
  /// In fr, this message translates to:
  /// **'Exemplaire {number}'**
  String copyNumber(int number);

  /// No description provided for @filterToRead.
  ///
  /// In fr, this message translates to:
  /// **'À lire'**
  String get filterToRead;

  /// No description provided for @markReadTitle.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme lus…'**
  String get markReadTitle;

  /// No description provided for @markReadUpTo.
  ///
  /// In fr, this message translates to:
  /// **'Lus jusqu’au tome'**
  String get markReadUpTo;

  /// No description provided for @markReadConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme lus'**
  String get markReadConfirm;

  /// No description provided for @volumesMarkedRead.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun tome à marquer} =1{1 tome marqué comme lu} other{{count} tomes marqués comme lus}}'**
  String volumesMarkedRead(int count);

  /// No description provided for @volumesToRead.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 tome à lire} other{{count} tomes à lire}}'**
  String volumesToRead(int count);

  /// No description provided for @notificationOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir'**
  String get notificationOpen;

  /// No description provided for @notificationChannelLoans.
  ///
  /// In fr, this message translates to:
  /// **'Rappels de retour des prêts'**
  String get notificationChannelLoans;

  /// No description provided for @loanDueTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à récupérer'**
  String get loanDueTitle;

  /// No description provided for @loanDueBody.
  ///
  /// In fr, this message translates to:
  /// **'{title} : prêté à {name}'**
  String loanDueBody(String title, String name);

  /// No description provided for @loansOverdueTitle.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 prêt en retard} other{{count} prêts en retard}}'**
  String loansOverdueTitle(int count);

  /// No description provided for @lend.
  ///
  /// In fr, this message translates to:
  /// **'Prêter'**
  String get lend;

  /// No description provided for @lendTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêter « {title} »'**
  String lendTitle(String title);

  /// No description provided for @borrowerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Emprunteur'**
  String get borrowerLabel;

  /// No description provided for @dueDateOptional.
  ///
  /// In fr, this message translates to:
  /// **'Date de retour (facultatif)'**
  String get dueDateOptional;

  /// No description provided for @noDueDate.
  ///
  /// In fr, this message translates to:
  /// **'Sans date de retour'**
  String get noDueDate;

  /// No description provided for @loanedTo.
  ///
  /// In fr, this message translates to:
  /// **'Prêté à {name}'**
  String loanedTo(String name);

  /// No description provided for @loanedSince.
  ///
  /// In fr, this message translates to:
  /// **'depuis le {date}'**
  String loanedSince(String date);

  /// No description provided for @loanDueOn.
  ///
  /// In fr, this message translates to:
  /// **'retour prévu le {date}'**
  String loanDueOn(String date);

  /// No description provided for @loanOverdue.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get loanOverdue;

  /// No description provided for @markReturned.
  ///
  /// In fr, this message translates to:
  /// **'Rendu'**
  String get markReturned;

  /// No description provided for @loanReturnedOn.
  ///
  /// In fr, this message translates to:
  /// **'Rendu le {date}'**
  String loanReturnedOn(String date);

  /// No description provided for @loansCurrent.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get loansCurrent;

  /// No description provided for @loansHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get loansHistory;

  /// No description provided for @loansEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prêt en cours'**
  String get loansEmpty;

  /// No description provided for @loansHistoryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun prêt rendu'**
  String get loansHistoryEmpty;

  /// No description provided for @loanReturnedSnack.
  ///
  /// In fr, this message translates to:
  /// **'« {title} » marqué comme rendu'**
  String loanReturnedSnack(String title);

  /// No description provided for @wishlistItems.
  ///
  /// In fr, this message translates to:
  /// **'Envies'**
  String get wishlistItems;

  /// No description provided for @nextVolumes.
  ///
  /// In fr, this message translates to:
  /// **'Prochains tomes à acheter'**
  String get nextVolumes;

  /// No description provided for @wishlistEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ta liste d’envies est vide'**
  String get wishlistEmpty;

  /// No description provided for @noNextVolumes.
  ///
  /// In fr, this message translates to:
  /// **'Aucun tome manquant dans tes séries suivies'**
  String get noNextVolumes;

  /// No description provided for @priorityShort.
  ///
  /// In fr, this message translates to:
  /// **'Priorité {priority}'**
  String priorityShort(int priority);

  /// No description provided for @addMissingToWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux envies'**
  String get addMissingToWishlist;

  /// No description provided for @missingAddedToWishlist.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Déjà dans tes envies} =1{1 tome ajouté aux envies} other{{count} tomes ajoutés aux envies}}'**
  String missingAddedToWishlist(int count);

  /// No description provided for @addCopy.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un exemplaire'**
  String get addCopy;

  /// No description provided for @storeOtherEdition.
  ///
  /// In fr, this message translates to:
  /// **'Tu as ce tome dans une autre édition'**
  String get storeOtherEdition;

  /// No description provided for @addThisCopy.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter cet exemplaire'**
  String get addThisCopy;

  /// No description provided for @boughtTitle.
  ///
  /// In fr, this message translates to:
  /// **'Je l’ai acheté'**
  String get boughtTitle;

  /// No description provided for @paidPriceOptional.
  ///
  /// In fr, this message translates to:
  /// **'Prix payé (facultatif)'**
  String get paidPriceOptional;

  /// No description provided for @boughtDone.
  ///
  /// In fr, this message translates to:
  /// **'« {title} » ajouté à ta collection'**
  String boughtDone(String title);

  /// No description provided for @statsSpent.
  ///
  /// In fr, this message translates to:
  /// **'Dépensé'**
  String get statsSpent;

  /// No description provided for @statsSpentCaption.
  ///
  /// In fr, this message translates to:
  /// **'prix payé saisi pour {priced} {total, plural, =1{exemplaire sur 1} other{exemplaires sur {total}}}'**
  String statsSpentCaption(int priced, int total);

  /// No description provided for @statsValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur'**
  String get statsValue;

  /// No description provided for @statsValueCaption.
  ///
  /// In fr, this message translates to:
  /// **'valeur estimée, sinon prix éditeur ou prix payé'**
  String get statsValueCaption;

  /// No description provided for @statsVolumes.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrages'**
  String get statsVolumes;

  /// No description provided for @statsVolumesCaption.
  ///
  /// In fr, this message translates to:
  /// **'{copies, plural, =1{1 exemplaire} other{{copies} exemplaires}}'**
  String statsVolumesCaption(int copies);

  /// No description provided for @statsOtherCurrencies.
  ///
  /// In fr, this message translates to:
  /// **'Hors total (autres devises) : {list}'**
  String statsOtherCurrencies(String list);

  /// No description provided for @statsRead.
  ///
  /// In fr, this message translates to:
  /// **'Lus'**
  String get statsRead;

  /// No description provided for @statsComplete.
  ///
  /// In fr, this message translates to:
  /// **'Séries complètes'**
  String get statsComplete;

  /// No description provided for @statsCompleteCaption.
  ///
  /// In fr, this message translates to:
  /// **'parmi les séries dont le nombre de tomes est connu'**
  String get statsCompleteCaption;

  /// No description provided for @statsSpendingByMonth.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses des 12 derniers mois'**
  String get statsSpendingByMonth;

  /// No description provided for @statsNoSpending.
  ///
  /// In fr, this message translates to:
  /// **'Aucun achat daté sur cette période : renseigne la date et le prix d’achat, ou utilise « Je l’ai acheté ».'**
  String get statsNoSpending;

  /// No description provided for @statsVolumesByType.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrages par type'**
  String get statsVolumesByType;

  /// No description provided for @statsSpendingByType.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses par type'**
  String get statsSpendingByType;

  /// No description provided for @statsShowTable.
  ///
  /// In fr, this message translates to:
  /// **'Voir le tableau'**
  String get statsShowTable;

  /// No description provided for @statsShowChart.
  ///
  /// In fr, this message translates to:
  /// **'Voir le graphique'**
  String get statsShowChart;

  /// No description provided for @statsMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get statsMonth;

  /// No description provided for @statsAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get statsAmount;

  /// No description provided for @statsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute des ouvrages pour voir tes statistiques'**
  String get statsEmpty;

  /// No description provided for @statsRatio.
  ///
  /// In fr, this message translates to:
  /// **'{count} sur {total}'**
  String statsRatio(int count, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
