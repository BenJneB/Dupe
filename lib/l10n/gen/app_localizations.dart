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

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In fr, this message translates to:
  /// **'Appuie de nouveau sur retour pour quitter'**
  String get pressBackAgainToExit;

  /// No description provided for @allRead.
  ///
  /// In fr, this message translates to:
  /// **'tout lu'**
  String get allRead;

  /// No description provided for @scanType.
  ///
  /// In fr, this message translates to:
  /// **'Type des livres scannés'**
  String get scanType;

  /// No description provided for @storeInSeries.
  ///
  /// In fr, this message translates to:
  /// **'{title} — série {series}'**
  String storeInSeries(String title, String series);

  /// No description provided for @previousVolumesOffer.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Il te manque 1 tome avant le {volume} : l’ajouter comme possédé ?} other{Il te manque {count} tomes avant le {volume} : les ajouter comme possédés ?}}'**
  String previousVolumesOffer(int count, int volume);

  /// No description provided for @byAuthor.
  ///
  /// In fr, this message translates to:
  /// **'Par auteur'**
  String get byAuthor;

  /// No description provided for @unknownAuthor.
  ///
  /// In fr, this message translates to:
  /// **'Auteur inconnu'**
  String get unknownAuthor;

  /// No description provided for @authorSummary.
  ///
  /// In fr, this message translates to:
  /// **'{series, plural, =0{} =1{1 série · } other{{series} séries · }}{books, plural, =0{} =1{1 livre · } other{{books} livres · }}{volumes, plural, =0{aucun possédé} =1{1 possédé} other{{volumes} possédés}}'**
  String authorSummary(int series, int books, int volumes);

  /// No description provided for @authorSeries.
  ///
  /// In fr, this message translates to:
  /// **'Séries'**
  String get authorSeries;

  /// No description provided for @authorBooks.
  ///
  /// In fr, this message translates to:
  /// **'Livres hors série'**
  String get authorBooks;

  /// No description provided for @authorNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Plus rien de cet auteur dans cet onglet'**
  String get authorNotFound;

  /// No description provided for @indicativeProgress.
  ///
  /// In fr, this message translates to:
  /// **'Progression estimée : nombre total de tomes inconnu'**
  String get indicativeProgress;

  /// No description provided for @authorMarkBooksRead.
  ///
  /// In fr, this message translates to:
  /// **'Marquer les livres hors série comme lus'**
  String get authorMarkBooksRead;

  /// No description provided for @authorMarkAllRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu (séries comprises)'**
  String get authorMarkAllRead;

  /// No description provided for @authorMarkReadQuestion.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Marquer 1 livre comme lu ?} other{Marquer {count} livres comme lus ?}}'**
  String authorMarkReadQuestion(int count);

  /// No description provided for @authorMarkReadHelp.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les livres possédés et pas encore lus changent ; la date de lecture du jour est mise sur ceux qui n’en ont pas.'**
  String get authorMarkReadHelp;

  /// No description provided for @booksMarkedRead.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Rien à marquer : tout est déjà lu} =1{1 livre marqué comme lu} other{{count} livres marqués comme lus}}'**
  String booksMarkedRead(int count);

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;

  /// No description provided for @totalFromAniList.
  ///
  /// In fr, this message translates to:
  /// **'AniList : « {title} », {count} tomes (nombre de l’édition japonaise)'**
  String totalFromAniList(String title, int count);

  /// No description provided for @totalFromComicVine.
  ///
  /// In fr, this message translates to:
  /// **'Comic Vine : « {title} », {count} numéros (édition américaine)'**
  String totalFromComicVine(String title, int count);

  /// No description provided for @seriesTotalHelp.
  ///
  /// In fr, this message translates to:
  /// **'Les tomes que tu n’as pas apparaîtront en gris dans la série.'**
  String get seriesTotalHelp;

  /// No description provided for @checkTotalAction.
  ///
  /// In fr, this message translates to:
  /// **'Nombre total de tomes…'**
  String get checkTotalAction;

  /// No description provided for @checkTotalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nombre total de tomes'**
  String get checkTotalTitle;

  /// No description provided for @checkTotalNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun nombre de tomes trouvé en ligne pour « {title} » : saisis-le.'**
  String checkTotalNone(String title);

  /// No description provided for @checkTotalSaved.
  ///
  /// In fr, this message translates to:
  /// **'{title} : {count} tomes'**
  String checkTotalSaved(String title, int count);

  /// No description provided for @nextVolumesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Combien de tomes compte la série ?'**
  String get nextVolumesTitle;

  /// No description provided for @volumeCountsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de tomes des séries'**
  String get volumeCountsTitle;

  /// No description provided for @volumeCountsTile.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier le nombre de tomes des séries'**
  String get volumeCountsTile;

  /// No description provided for @volumeCountsTileHelp.
  ///
  /// In fr, this message translates to:
  /// **'Mangas (AniList) et comics (Comic Vine) sans nombre total : propositions à valider'**
  String get volumeCountsTileHelp;

  /// No description provided for @volumeCountsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Cherche le nombre total de tomes des séries qui n’en ont pas (mangas et comics). Rien n’est modifié avant ta validation.'**
  String get volumeCountsHelp;

  /// No description provided for @volumeCountsRun.
  ///
  /// In fr, this message translates to:
  /// **'Lancer'**
  String get volumeCountsRun;

  /// No description provided for @volumeCountsProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} séries vérifiées'**
  String volumeCountsProgress(int done, int total);

  /// No description provided for @volumeCountsDone.
  ///
  /// In fr, this message translates to:
  /// **'{total} séries vérifiées · {found} nombre(s) de tomes trouvé(s)'**
  String volumeCountsDone(int total, int found);

  /// No description provided for @volumeCountsFailed.
  ///
  /// In fr, this message translates to:
  /// **'{count} série(s) non vérifiée(s) : source indisponible (détails dans le journal)'**
  String volumeCountsFailed(int count);

  /// No description provided for @volumeCountsApply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer ({count})'**
  String volumeCountsApply(int count);

  /// No description provided for @volumeCountsApplied.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune série modifiée} =1{1 série mise à jour} other{{count} séries mises à jour}}'**
  String volumeCountsApplied(int count);

  /// No description provided for @volumeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Tome {label}'**
  String volumeLabel(String label);

  /// No description provided for @showVolumesAsList.
  ///
  /// In fr, this message translates to:
  /// **'Afficher les tomes en liste'**
  String get showVolumesAsList;

  /// No description provided for @showVolumesAsGrid.
  ///
  /// In fr, this message translates to:
  /// **'Afficher les tomes en pastilles'**
  String get showVolumesAsGrid;

  /// No description provided for @loanReminderNotificationsOff.
  ///
  /// In fr, this message translates to:
  /// **'Prêt enregistré, mais le rappel ne s’affichera pas : les notifications de Dupe sont désactivées (Paramètres Android → Applications → Dupe → Notifications).'**
  String get loanReminderNotificationsOff;

  /// No description provided for @totalNoSource.
  ///
  /// In fr, this message translates to:
  /// **'Aucune source ne donne le nombre de tomes des BD et des livres : saisis-le.'**
  String get totalNoSource;

  /// No description provided for @wishRemoved.
  ///
  /// In fr, this message translates to:
  /// **'« {title} » retiré des envies'**
  String wishRemoved(String title);

  /// No description provided for @volumeTitlesTile.
  ///
  /// In fr, this message translates to:
  /// **'Compléter les titres des tomes'**
  String get volumeTitlesTile;

  /// No description provided for @volumeTitlesHelp.
  ///
  /// In fr, this message translates to:
  /// **'Cherche par ISBN le titre propre des tomes déjà dans ta collection (sans rien changer d’autre)'**
  String get volumeTitlesHelp;

  /// No description provided for @volumeTitlesProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} tomes vérifiés · {found} titre(s) trouvé(s)'**
  String volumeTitlesProgress(int done, int total, int found);

  /// No description provided for @volumeTitlesDone.
  ///
  /// In fr, this message translates to:
  /// **'{found} titre(s) ajouté(s) · {total} tomes vérifiés'**
  String volumeTitlesDone(int found, int total);

  /// No description provided for @qualityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Qualité de la collection'**
  String get qualityTitle;

  /// No description provided for @qualitySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'ISBN, couvertures, numéros de tome manquants…'**
  String get qualitySubtitle;

  /// No description provided for @qualityHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui manque dans ta collection. Touche une ligne pour voir les livres concernés et les corriger.'**
  String get qualityHelp;

  /// No description provided for @qualityNoIsbn.
  ///
  /// In fr, this message translates to:
  /// **'Livres possédés sans ISBN'**
  String get qualityNoIsbn;

  /// No description provided for @qualityNoCover.
  ///
  /// In fr, this message translates to:
  /// **'Livres sans couverture'**
  String get qualityNoCover;

  /// No description provided for @qualityNoVolumeNumber.
  ///
  /// In fr, this message translates to:
  /// **'Tomes sans numéro dans une série'**
  String get qualityNoVolumeNumber;

  /// No description provided for @qualityLooksLikeVolume.
  ///
  /// In fr, this message translates to:
  /// **'Livres isolés qui ressemblent à un tome de série'**
  String get qualityLooksLikeVolume;

  /// No description provided for @qualitySeriesWithoutTotal.
  ///
  /// In fr, this message translates to:
  /// **'Séries sans nombre total de tomes'**
  String get qualitySeriesWithoutTotal;

  /// No description provided for @qualityAutomatic.
  ///
  /// In fr, this message translates to:
  /// **'Compléter automatiquement'**
  String get qualityAutomatic;

  /// No description provided for @missingIsbnInGrid.
  ///
  /// In fr, this message translates to:
  /// **'Signaler les ISBN manquants'**
  String get missingIsbnInGrid;

  /// No description provided for @missingIsbnInGridHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un point sur la pastille des tomes possédés sans ISBN, et une icône sur les séries, livres et auteurs concernés'**
  String get missingIsbnInGridHelp;

  /// No description provided for @missingIsbnCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 livre possédé sans ISBN} other{{count} livres possédés sans ISBN}}'**
  String missingIsbnCount(int count);

  /// No description provided for @missingIsbn.
  ///
  /// In fr, this message translates to:
  /// **'ISBN manquant · scanner'**
  String get missingIsbn;

  /// No description provided for @isbnCompletionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compléter les ISBN'**
  String get isbnCompletionTitle;

  /// No description provided for @isbnCompletionStart.
  ///
  /// In fr, this message translates to:
  /// **'Compléter par scan'**
  String get isbnCompletionStart;

  /// No description provided for @isbnCompletionProgress.
  ///
  /// In fr, this message translates to:
  /// **'Livre {position} sur {total}'**
  String isbnCompletionProgress(int position, int total);

  /// No description provided for @isbnCompletionScanThis.
  ///
  /// In fr, this message translates to:
  /// **'Scanne le code-barres de ce livre (ou tape son ISBN).'**
  String get isbnCompletionScanThis;

  /// No description provided for @isbnCompletionAlsoFill.
  ///
  /// In fr, this message translates to:
  /// **'Compléter aussi les infos manquantes'**
  String get isbnCompletionAlsoFill;

  /// No description provided for @isbnCompletionSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get isbnCompletionSkip;

  /// No description provided for @isbnCompletionDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'Cet ISBN est déjà celui de « {title} ».'**
  String isbnCompletionDuplicate(String title);

  /// No description provided for @isbnCompletionSeeDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'Voir ce livre'**
  String get isbnCompletionSeeDuplicate;

  /// No description provided for @isbnCompletionMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Le livre trouvé en ligne est « {found} ». Est-ce bien « {mine} » ?'**
  String isbnCompletionMismatch(String found, String mine);

  /// No description provided for @isbnCompletionAssignAnyway.
  ///
  /// In fr, this message translates to:
  /// **'Oui, garder cet ISBN'**
  String get isbnCompletionAssignAnyway;

  /// No description provided for @isbnCompletionSaved.
  ///
  /// In fr, this message translates to:
  /// **'ISBN enregistré pour « {title} »'**
  String isbnCompletionSaved(String title);

  /// No description provided for @isbnCompletionDone.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Terminé : aucun ISBN enregistré.} =1{Terminé : 1 ISBN enregistré.} other{Terminé : {count} ISBN enregistrés.}}'**
  String isbnCompletionDone(int count);

  /// No description provided for @coverProposalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Couvertures proposées'**
  String get coverProposalsTitle;

  /// No description provided for @coverProposalsTileHelp.
  ///
  /// In fr, this message translates to:
  /// **'Trouvées pour d’autres éditions : à garder ou refuser'**
  String get coverProposalsTileHelp;

  /// No description provided for @coverProposalsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ces couvertures viennent d’une autre édition du même livre (recherche par titre et auteur). Garde celles qui conviennent ; une couverture refusée n’est plus proposée sur cet appareil.'**
  String get coverProposalsHelp;

  /// No description provided for @coverProposalsNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune couverture à valider.'**
  String get coverProposalsNone;

  /// No description provided for @coverProposalsKeepAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout garder'**
  String get coverProposalsKeepAll;

  /// No description provided for @coverProposalKeep.
  ///
  /// In fr, this message translates to:
  /// **'Garder'**
  String get coverProposalKeep;

  /// No description provided for @coverProposalRefuse.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get coverProposalRefuse;

  /// No description provided for @coverProposalFrom.
  ///
  /// In fr, this message translates to:
  /// **'Trouvée via {source} : « {title} »'**
  String coverProposalFrom(String source, String title);

  /// No description provided for @storeOtherEditionBook.
  ///
  /// In fr, this message translates to:
  /// **'Tu as ce livre dans une autre édition'**
  String get storeOtherEditionBook;

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

  /// No description provided for @fieldVolumeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre du tome'**
  String get fieldVolumeTitle;

  /// No description provided for @fieldVolumeTitleHelper.
  ///
  /// In fr, this message translates to:
  /// **'Le titre propre de ce tome, s’il en a un (vide sinon)'**
  String get fieldVolumeTitleHelper;

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
  /// **'Clé requise : saisis-la ci-dessous'**
  String get sourceNeedsKey;

  /// No description provided for @apiKeyTile.
  ///
  /// In fr, this message translates to:
  /// **'Clé API'**
  String get apiKeyTile;

  /// No description provided for @apiKeySaved.
  ///
  /// In fr, this message translates to:
  /// **'Clé saisie dans l’appli'**
  String get apiKeySaved;

  /// No description provided for @apiKeyBuiltIn.
  ///
  /// In fr, this message translates to:
  /// **'Clé intégrée à cette version (env.json)'**
  String get apiKeyBuiltIn;

  /// No description provided for @apiKeyMissing.
  ///
  /// In fr, this message translates to:
  /// **'Aucune clé : touche pour en saisir une'**
  String get apiKeyMissing;

  /// No description provided for @apiKeyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Clé {source}'**
  String apiKeyTitle(String source);

  /// No description provided for @apiKeyHelpGoogleBooks.
  ///
  /// In fr, this message translates to:
  /// **'Crée une clé dans la console Google Cloud (console.cloud.google.com → API et services → Identifiants), avec la « Books API » activée, et restreins-la à cette API.'**
  String get apiKeyHelpGoogleBooks;

  /// No description provided for @apiKeyHelpComicVine.
  ///
  /// In fr, this message translates to:
  /// **'Crée un compte Comic Vine, puis copie ta clé depuis comicvine.gamespot.com/api (usage non commercial).'**
  String get apiKeyHelpComicVine;

  /// No description provided for @apiKeyPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'La clé reste sur cet appareil : elle n’est ni synchronisée, ni sauvegardée, ni écrite dans le journal.'**
  String get apiKeyPrivacy;

  /// No description provided for @apiKeyTest.
  ///
  /// In fr, this message translates to:
  /// **'Tester la clé'**
  String get apiKeyTest;

  /// No description provided for @apiKeyValid.
  ///
  /// In fr, this message translates to:
  /// **'Clé valide'**
  String get apiKeyValid;

  /// No description provided for @apiKeyInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Clé refusée : vérifie-la (pour Google : Books API activée et autorisée pour cette clé)'**
  String get apiKeyInvalid;

  /// No description provided for @apiKeyQuota.
  ///
  /// In fr, this message translates to:
  /// **'Clé valide, mais quota dépassé pour l’instant'**
  String get apiKeyQuota;

  /// No description provided for @apiKeyOffline.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion : impossible de tester la clé'**
  String get apiKeyOffline;

  /// No description provided for @apiKeyFailed.
  ///
  /// In fr, this message translates to:
  /// **'Réponse inattendue du service (réessaie plus tard)'**
  String get apiKeyFailed;

  /// No description provided for @apiKeyRemove.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get apiKeyRemove;

  /// No description provided for @apiKeyStored.
  ///
  /// In fr, this message translates to:
  /// **'Clé enregistrée'**
  String get apiKeyStored;

  /// No description provided for @apiKeyRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Clé effacée'**
  String get apiKeyRemoved;

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

  /// No description provided for @accountSection.
  ///
  /// In fr, this message translates to:
  /// **'Compte et synchronisation'**
  String get accountSection;

  /// No description provided for @syncLocalOnly.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation non configurée'**
  String get syncLocalOnly;

  /// No description provided for @syncLocalOnlyHelp.
  ///
  /// In fr, this message translates to:
  /// **'Renseigne SUPABASE_URL et SUPABASE_ANON_KEY dans env.json. L’appli fonctionne entièrement sans compte.'**
  String get syncLocalOnlyHelp;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @signInHelp.
  ///
  /// In fr, this message translates to:
  /// **'Synchronise ta collection entre ton téléphone et ton PC'**
  String get signInHelp;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @signInTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get signInTitle;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email'**
  String get emailLabel;

  /// No description provided for @signedInAs.
  ///
  /// In fr, this message translates to:
  /// **'Connecté : {email}'**
  String signedInAs(String email);

  /// No description provided for @signUp.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get signUp;

  /// No description provided for @signUpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get signUpTitle;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @passwordConfirmLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirme le mot de passe'**
  String get passwordConfirmLabel;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les deux mots de passe sont différents'**
  String get passwordsDontMatch;

  /// No description provided for @passwordEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Saisis un mot de passe'**
  String get passwordEmpty;

  /// No description provided for @showPassword.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// No description provided for @noAccountYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? Créer un compte'**
  String get noAccountYet;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Se connecter'**
  String get alreadyHaveAccount;

  /// No description provided for @confirmEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé. Ouvre le lien envoyé à {email} pour confirmer ton adresse (la page qui s’ouvre ensuite peut afficher une erreur « localhost » : c’est normal, l’adresse est confirmée), puis reviens ici et touche « Se connecter ».'**
  String confirmEmailSent(String email);

  /// No description provided for @forgotPasswordHelp.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié : change-le depuis un appareil encore connecté (Paramètres → Mot de passe).'**
  String get forgotPasswordHelp;

  /// No description provided for @setPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get setPassword;

  /// No description provided for @setPasswordHelp.
  ///
  /// In fr, this message translates to:
  /// **'Définir ou changer le mot de passe du compte'**
  String get setPasswordHelp;

  /// No description provided for @setPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get setPasswordTitle;

  /// No description provided for @setPasswordDone.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe enregistré'**
  String get setPasswordDone;

  /// No description provided for @signInDone.
  ///
  /// In fr, this message translates to:
  /// **'Connecté. Ta collection locale est envoyée sur ton compte.'**
  String get signInDone;

  /// No description provided for @syncNow.
  ///
  /// In fr, this message translates to:
  /// **'Synchroniser maintenant'**
  String get syncNow;

  /// No description provided for @syncIdle.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisé'**
  String get syncIdle;

  /// No description provided for @syncClockSkew.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisé, mais l’heure de cet appareil semble fausse (écart de {minutes} min avec le serveur) : corrige-la, sinon tes modifications risquent d’être mal départagées'**
  String syncClockSkew(int minutes);

  /// No description provided for @syncIdleAt.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisé à {time}'**
  String syncIdleAt(String time);

  /// No description provided for @syncRunning.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation…'**
  String get syncRunning;

  /// No description provided for @syncOffline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne : les modifications seront envoyées au retour du réseau'**
  String get syncOffline;

  /// No description provided for @syncFailed.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de synchronisation : {message}'**
  String syncFailed(String message);

  /// No description provided for @syncSignedOut.
  ///
  /// In fr, this message translates to:
  /// **'Non connecté : données sur cet appareil seulement'**
  String get syncSignedOut;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email invalide'**
  String get invalidEmail;

  /// No description provided for @coverPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Photographier la couverture'**
  String get coverPhoto;

  /// No description provided for @coverPhotoError.
  ///
  /// In fr, this message translates to:
  /// **'Photo impossible : {message}'**
  String coverPhotoError(String message);

  /// No description provided for @appearanceSection.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get appearanceSection;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @backupSection.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde et import'**
  String get backupSection;

  /// No description provided for @exportJson.
  ///
  /// In fr, this message translates to:
  /// **'Exporter une sauvegarde'**
  String get exportJson;

  /// No description provided for @exportJsonHelp.
  ///
  /// In fr, this message translates to:
  /// **'Fichier JSON complet : séries, ouvrages, prêts'**
  String get exportJsonHelp;

  /// No description provided for @restoreJson.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer une sauvegarde'**
  String get restoreJson;

  /// No description provided for @restoreJsonHelp.
  ///
  /// In fr, this message translates to:
  /// **'Fusionner avec la collection, ou revenir exactement à son contenu'**
  String get restoreJsonHelp;

  /// No description provided for @restoreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Restaurer la sauvegarde'**
  String get restoreTitle;

  /// No description provided for @restoreMerge.
  ///
  /// In fr, this message translates to:
  /// **'Fusionner'**
  String get restoreMerge;

  /// No description provided for @restoreMergeHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute ce qui manque, garde ce qui est plus récent. Rien n’est effacé.'**
  String get restoreMergeHelp;

  /// No description provided for @restoreReplace.
  ///
  /// In fr, this message translates to:
  /// **'Revenir à cette sauvegarde'**
  String get restoreReplace;

  /// No description provided for @restoreReplaceHelp.
  ///
  /// In fr, this message translates to:
  /// **'La collection redevient exactement celle de la sauvegarde, sur tous tes appareils après synchro : ce qui a été ajouté depuis est supprimé. Une sauvegarde automatique est prise juste avant.'**
  String get restoreReplaceHelp;

  /// No description provided for @replaceDone.
  ///
  /// In fr, this message translates to:
  /// **'Collection restaurée : {restored} ouvrages, {removed} retirés'**
  String replaceDone(int restored, int removed);

  /// No description provided for @autoBackups.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardes automatiques'**
  String get autoBackups;

  /// No description provided for @autoBackupsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Chaque semaine, et avant chaque import ou restauration'**
  String get autoBackupsHelp;

  /// No description provided for @autoBackupsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sauvegarde automatique pour l’instant (collection vide ou première semaine).'**
  String get autoBackupsEmpty;

  /// No description provided for @autoBackupWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire'**
  String get autoBackupWeekly;

  /// No description provided for @autoBackupBeforeImport.
  ///
  /// In fr, this message translates to:
  /// **'Avant import CSV'**
  String get autoBackupBeforeImport;

  /// No description provided for @autoBackupBeforeRestore.
  ///
  /// In fr, this message translates to:
  /// **'Avant restauration'**
  String get autoBackupBeforeRestore;

  /// No description provided for @autoBackupItems.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 ouvrage} other{{count} ouvrages}}'**
  String autoBackupItems(int count);

  /// No description provided for @autoBackupExport.
  ///
  /// In fr, this message translates to:
  /// **'Exporter ce fichier'**
  String get autoBackupExport;

  /// No description provided for @autoBackupFailed.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde automatique impossible : import annulé ({message})'**
  String autoBackupFailed(String message);

  /// No description provided for @restoreDone.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Rien à restaurer : déjà à jour} =1{1 élément restauré} other{{count} éléments restaurés}}'**
  String restoreDone(int count);

  /// No description provided for @restoreInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier n’est pas une sauvegarde Dupe'**
  String get restoreInvalid;

  /// No description provided for @exportCsv.
  ///
  /// In fr, this message translates to:
  /// **'Exporter en CSV'**
  String get exportCsv;

  /// No description provided for @exportCsvHelp.
  ///
  /// In fr, this message translates to:
  /// **'Un tableau par type, lisible dans Excel ou LibreOffice'**
  String get exportCsvHelp;

  /// No description provided for @exportCsvAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get exportCsvAll;

  /// No description provided for @importCsv.
  ///
  /// In fr, this message translates to:
  /// **'Importer un CSV'**
  String get importCsv;

  /// No description provided for @importCsvHelp.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre une collection (Mangacollec, CLZ, tableur…)'**
  String get importCsvHelp;

  /// No description provided for @exportDone.
  ///
  /// In fr, this message translates to:
  /// **'Fichier enregistré'**
  String get exportDone;

  /// No description provided for @fileError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de fichier : {message}'**
  String fileError(String message);

  /// No description provided for @csvImportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Importer un CSV'**
  String get csvImportTitle;

  /// No description provided for @csvRows.
  ///
  /// In fr, this message translates to:
  /// **'{file} : {count, plural, =1{1 ligne} other{{count} lignes}}'**
  String csvRows(String file, int count);

  /// No description provided for @csvDefaults.
  ///
  /// In fr, this message translates to:
  /// **'Valeurs par défaut (si la colonne est absente ou vide)'**
  String get csvDefaults;

  /// No description provided for @csvMapping.
  ///
  /// In fr, this message translates to:
  /// **'Correspondance des colonnes'**
  String get csvMapping;

  /// No description provided for @csvIgnored.
  ///
  /// In fr, this message translates to:
  /// **'— ignorée —'**
  String get csvIgnored;

  /// No description provided for @csvPreview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu'**
  String get csvPreview;

  /// No description provided for @csvImportButton.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Importer 1 ligne} other{Importer {count} lignes}}'**
  String csvImportButton(int count);

  /// No description provided for @csvTitleRequired.
  ///
  /// In fr, this message translates to:
  /// **'Associe au moins la colonne Titre ou Série'**
  String get csvTitleRequired;

  /// No description provided for @csvImportDone.
  ///
  /// In fr, this message translates to:
  /// **'{created} ajoutés, {series} séries créées, {duplicates} déjà présents'**
  String csvImportDone(int created, int series, int duplicates);

  /// No description provided for @csvInvalidLines.
  ///
  /// In fr, this message translates to:
  /// **'Lignes ignorées (sans titre) : {lines}'**
  String csvInvalidLines(String lines);

  /// No description provided for @csvEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Fichier vide ou illisible'**
  String get csvEmpty;

  /// No description provided for @importFieldTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get importFieldTitle;

  /// No description provided for @importFieldSeries.
  ///
  /// In fr, this message translates to:
  /// **'Série'**
  String get importFieldSeries;

  /// No description provided for @importFieldVolume.
  ///
  /// In fr, this message translates to:
  /// **'Tome / numéro'**
  String get importFieldVolume;

  /// No description provided for @importFieldType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get importFieldType;

  /// No description provided for @importFieldAuthors.
  ///
  /// In fr, this message translates to:
  /// **'Auteurs'**
  String get importFieldAuthors;

  /// No description provided for @importFieldPublisher.
  ///
  /// In fr, this message translates to:
  /// **'Éditeur'**
  String get importFieldPublisher;

  /// No description provided for @importFieldIsbn.
  ///
  /// In fr, this message translates to:
  /// **'ISBN / EAN'**
  String get importFieldIsbn;

  /// No description provided for @importFieldOwnership.
  ///
  /// In fr, this message translates to:
  /// **'Possédé / envie'**
  String get importFieldOwnership;

  /// No description provided for @importFieldReading.
  ///
  /// In fr, this message translates to:
  /// **'Statut de lecture'**
  String get importFieldReading;

  /// No description provided for @importFieldPurchasePrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix payé'**
  String get importFieldPurchasePrice;

  /// No description provided for @importFieldPurchaseDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d’achat'**
  String get importFieldPurchaseDate;

  /// No description provided for @importFieldCoverPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix éditeur'**
  String get importFieldCoverPrice;

  /// No description provided for @importFieldLocation.
  ///
  /// In fr, this message translates to:
  /// **'Emplacement'**
  String get importFieldLocation;

  /// No description provided for @importFieldNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get importFieldNotes;

  /// No description provided for @moreAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get moreAbout;

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue personnel de mangas, BD, comics et livres : scanne, vérifie en magasin ce que tu as déjà, suis tes séries.'**
  String get aboutDescription;

  /// No description provided for @aboutVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutSources.
  ///
  /// In fr, this message translates to:
  /// **'Sources de données'**
  String get aboutSources;

  /// No description provided for @aboutSourcesText.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque nationale de France (catalogue SRU), Open Library, Google Books, AniList, Comic Vine. Les données appartiennent à leurs auteurs ; Dupe ne fait que les consulter.'**
  String get aboutSourcesText;

  /// No description provided for @aboutComicVine.
  ///
  /// In fr, this message translates to:
  /// **'Données comics fournies par Comic Vine'**
  String get aboutComicVine;

  /// No description provided for @aboutLicenses.
  ///
  /// In fr, this message translates to:
  /// **'Licences des composants'**
  String get aboutLicenses;

  /// No description provided for @aboutSourceCode.
  ///
  /// In fr, this message translates to:
  /// **'Code source'**
  String get aboutSourceCode;

  /// No description provided for @undo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get undo;

  /// No description provided for @itemDeleted.
  ///
  /// In fr, this message translates to:
  /// **'« {title} » supprimé'**
  String itemDeleted(String title);

  /// No description provided for @seriesDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Série « {title} » supprimée'**
  String seriesDeleted(String title);

  /// No description provided for @updatesSection.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour'**
  String get updatesSection;

  /// No description provided for @updateCheck.
  ///
  /// In fr, this message translates to:
  /// **'Signaler les nouvelles versions'**
  String get updateCheck;

  /// No description provided for @updateCheckHelp.
  ///
  /// In fr, this message translates to:
  /// **'Vérifie au plus une fois par jour la dernière version publiée sur GitHub'**
  String get updateCheckHelp;

  /// No description provided for @updateCheckNow.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une mise à jour'**
  String get updateCheckNow;

  /// No description provided for @updateUpToDate.
  ///
  /// In fr, this message translates to:
  /// **'Dupe est à jour'**
  String get updateUpToDate;

  /// No description provided for @updateAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Version {version} disponible'**
  String updateAvailable(String version);

  /// No description provided for @updateDownload.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get updateDownload;

  /// No description provided for @torchOn.
  ///
  /// In fr, this message translates to:
  /// **'Allumer la lampe'**
  String get torchOn;

  /// No description provided for @torchOff.
  ///
  /// In fr, this message translates to:
  /// **'Éteindre la lampe'**
  String get torchOff;

  /// No description provided for @scanSection.
  ///
  /// In fr, this message translates to:
  /// **'Scan'**
  String get scanSection;

  /// No description provided for @storeHaptics.
  ///
  /// In fr, this message translates to:
  /// **'Vibrer selon le résultat'**
  String get storeHaptics;

  /// No description provided for @storeHapticsHelp.
  ///
  /// In fr, this message translates to:
  /// **'Mode Magasin : 1 forte = déjà possédé, 2 = en envie, 3 légères = tome manquant d’une série, 1 brève = inconnu'**
  String get storeHapticsHelp;

  /// No description provided for @voiceSearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche vocale'**
  String get voiceSearchTitle;

  /// No description provided for @voiceSearchExplain.
  ///
  /// In fr, this message translates to:
  /// **'Dupe va te demander l’accès au micro. Ce que tu dis est transcrit par le service de reconnaissance vocale de ton appareil, puis cherché dans ta collection : Dupe n’enregistre rien. Dis par exemple « One Piece tome 107 » ou « tome 3 de Blacksad ».'**
  String get voiceSearchExplain;

  /// No description provided for @voiceSearchContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get voiceSearchContinue;

  /// No description provided for @voiceSearchListening.
  ///
  /// In fr, this message translates to:
  /// **'J’écoute…'**
  String get voiceSearchListening;

  /// No description provided for @voiceSearchExample.
  ///
  /// In fr, this message translates to:
  /// **'Dis par exemple « One Piece tome 107 »'**
  String get voiceSearchExample;

  /// No description provided for @voiceSearchStop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter'**
  String get voiceSearchStop;

  /// No description provided for @voiceSearchNothing.
  ///
  /// In fr, this message translates to:
  /// **'Je n’ai rien entendu (ou le micro n’est pas autorisé)'**
  String get voiceSearchNothing;

  /// No description provided for @voiceVolumeMissing.
  ///
  /// In fr, this message translates to:
  /// **'Tome {volume} de {series} : absent de ta collection'**
  String voiceVolumeMissing(String volume, String series);

  /// No description provided for @widgetOwned.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Collection vide} =1{1 ouvrage} other{{count} ouvrages}}'**
  String widgetOwned(int count);

  /// No description provided for @widgetOverdue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 prêt en retard} other{{count} prêts en retard}}'**
  String widgetOverdue(int count);

  /// No description provided for @errorOffline.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet.'**
  String get errorOffline;

  /// No description provided for @errorSession.
  ///
  /// In fr, this message translates to:
  /// **'Session expirée : reconnecte-toi.'**
  String get errorSession;

  /// No description provided for @errorUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Serveur de synchronisation indisponible. Si l’appli n’a pas servi depuis une semaine, le projet Supabase gratuit est peut-être en pause : le réactiver depuis son tableau de bord.'**
  String get errorUnavailable;

  /// No description provided for @errorServer.
  ///
  /// In fr, this message translates to:
  /// **'Le serveur a refusé la demande (détails dans À propos → Journal).'**
  String get errorServer;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Email pas encore confirmé : ouvre le lien reçu par email, puis reconnecte-toi.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorEmailTaken.
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cet email : connecte-toi.'**
  String get errorEmailTaken;

  /// No description provided for @errorWeakPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe refusé : trop court ou trop simple.'**
  String get errorWeakPassword;

  /// No description provided for @errorTooManyAttempts.
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives : réessaie dans quelques minutes.'**
  String get errorTooManyAttempts;

  /// No description provided for @errorSignInRefused.
  ///
  /// In fr, this message translates to:
  /// **'Connexion refusée (détails dans À propos → Journal).'**
  String get errorSignInRefused;

  /// No description provided for @errorNotBackup.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier n\'est pas une sauvegarde Dupe.'**
  String get errorNotBackup;

  /// No description provided for @errorFileAccess.
  ///
  /// In fr, this message translates to:
  /// **'Fichier inaccessible (droits ou emplacement).'**
  String get errorFileAccess;

  /// No description provided for @errorBadFile.
  ///
  /// In fr, this message translates to:
  /// **'Fichier illisible ou mal formé.'**
  String get errorBadFile;

  /// No description provided for @errorUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue (détails dans À propos → Journal).'**
  String get errorUnknown;

  /// No description provided for @journalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Journal'**
  String get journalTitle;

  /// No description provided for @journalSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreurs et événements récents, à copier pour signaler un problème'**
  String get journalSubtitle;

  /// No description provided for @journalEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien à signaler'**
  String get journalEmpty;

  /// No description provided for @journalCopy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get journalCopy;

  /// No description provided for @journalCopied.
  ///
  /// In fr, this message translates to:
  /// **'Journal copié'**
  String get journalCopied;

  /// No description provided for @journalShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get journalShare;

  /// No description provided for @journalClear.
  ///
  /// In fr, this message translates to:
  /// **'Vider le journal'**
  String get journalClear;

  /// No description provided for @offlineCoversSection.
  ///
  /// In fr, this message translates to:
  /// **'Couvertures hors ligne'**
  String get offlineCoversSection;

  /// No description provided for @offlineCovers.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger toutes les couvertures'**
  String get offlineCovers;

  /// No description provided for @offlineCoversHelp.
  ///
  /// In fr, this message translates to:
  /// **'Collection et envies, pour les voir sans connexion (en magasin)'**
  String get offlineCoversHelp;

  /// No description provided for @offlineCoversWifiOnly.
  ///
  /// In fr, this message translates to:
  /// **'Wi-Fi seulement'**
  String get offlineCoversWifiOnly;

  /// No description provided for @offlineCoversWifiOnlyHelp.
  ///
  /// In fr, this message translates to:
  /// **'Jamais sur les données mobiles'**
  String get offlineCoversWifiOnlyHelp;

  /// No description provided for @offlineCoversSize.
  ///
  /// In fr, this message translates to:
  /// **'{size} Mo utilisés'**
  String offlineCoversSize(String size);

  /// No description provided for @offlineCoversRefresh.
  ///
  /// In fr, this message translates to:
  /// **'toucher pour vérifier'**
  String get offlineCoversRefresh;

  /// No description provided for @missingCovers.
  ///
  /// In fr, this message translates to:
  /// **'Compléter les couvertures manquantes'**
  String get missingCovers;

  /// No description provided for @missingCoversHelp.
  ///
  /// In fr, this message translates to:
  /// **'Cherche par ISBN une couverture pour chaque livre qui n’en a pas ou dont la couverture ne se charge pas (sans rien changer d’autre ; tes photos sont gardées)'**
  String get missingCoversHelp;

  /// No description provided for @missingCoversProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total} livres vérifiés · {found} trouvée(s)'**
  String missingCoversProgress(int done, int total, int found);

  /// No description provided for @missingCoversDone.
  ///
  /// In fr, this message translates to:
  /// **'{found} couverture(s) ajoutée(s) ou remplacée(s) · {total} livres vérifiés'**
  String missingCoversDone(int found, int total);

  /// No description provided for @offlineCoversClear.
  ///
  /// In fr, this message translates to:
  /// **'Vider'**
  String get offlineCoversClear;

  /// No description provided for @offlineCoversCleared.
  ///
  /// In fr, this message translates to:
  /// **'Couvertures téléchargées supprimées (vos photos sont gardées)'**
  String get offlineCoversCleared;

  /// No description provided for @offlineCoversDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Désactivé'**
  String get offlineCoversDisabled;

  /// No description provided for @offlineCoversOffline.
  ///
  /// In fr, this message translates to:
  /// **'En attente d’une connexion'**
  String get offlineCoversOffline;

  /// No description provided for @offlineCoversMetered.
  ///
  /// In fr, this message translates to:
  /// **'En attente du Wi-Fi'**
  String get offlineCoversMetered;

  /// No description provided for @offlineCoversProgress.
  ///
  /// In fr, this message translates to:
  /// **'Téléchargement : {done} / {total}'**
  String offlineCoversProgress(int done, int total);

  /// No description provided for @offlineCoversNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune couverture à télécharger'**
  String get offlineCoversNone;

  /// No description provided for @offlineCoversDone.
  ///
  /// In fr, this message translates to:
  /// **'{total, plural, =1{1 couverture disponible hors ligne} other{{total} couvertures disponibles hors ligne}}'**
  String offlineCoversDone(int total);

  /// No description provided for @offlineCoversDoneWithFailures.
  ///
  /// In fr, this message translates to:
  /// **'{total} couvertures, dont {failed} introuvables'**
  String offlineCoversDoneWithFailures(int total, int failed);

  /// No description provided for @statsReadByMonth.
  ///
  /// In fr, this message translates to:
  /// **'Tomes lus par mois'**
  String get statsReadByMonth;

  /// No description provided for @statsNoReadDates.
  ///
  /// In fr, this message translates to:
  /// **'Aucune date de lecture sur les 12 derniers mois.'**
  String get statsNoReadDates;

  /// No description provided for @statsReadCount.
  ///
  /// In fr, this message translates to:
  /// **'Lus'**
  String get statsReadCount;

  /// No description provided for @statsReadWithoutDate.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 tome lu sans date de lecture n’est pas compté par mois.} other{{count} tomes lus sans date de lecture ne sont pas comptés par mois.}}'**
  String statsReadWithoutDate(int count);

  /// No description provided for @statsReadByType.
  ///
  /// In fr, this message translates to:
  /// **'Lu par type'**
  String get statsReadByType;

  /// No description provided for @statsPile.
  ///
  /// In fr, this message translates to:
  /// **'Pile à lire et habitudes'**
  String get statsPile;

  /// No description provided for @statsPileCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Pile à lire vide} =1{1 tome à lire} other{{count} tomes à lire}}'**
  String statsPileCount(int count);

  /// No description provided for @statsPileOldest.
  ///
  /// In fr, this message translates to:
  /// **'Le plus ancien : {title}, depuis le {date}'**
  String statsPileOldest(String title, String date);

  /// No description provided for @statsDelay.
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =0{Lu le jour de l’achat, en moyenne} =1{Lu 1 jour après l’achat, en moyenne} other{Lu {days} jours après l’achat, en moyenne}}'**
  String statsDelay(int days);

  /// No description provided for @statsDelayUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Délai entre achat et lecture inconnu'**
  String get statsDelayUnknown;

  /// No description provided for @statsDelayHelp.
  ///
  /// In fr, this message translates to:
  /// **'Il faut une date d’achat et une date de lecture.'**
  String get statsDelayHelp;

  /// No description provided for @statsDelaySamples.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Sur 1 tome ayant les deux dates} other{Sur {count} tomes ayant les deux dates}}'**
  String statsDelaySamples(int count);

  /// No description provided for @statsAbandoned.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune série abandonnée} =1{1 série abandonnée} other{{count} séries abandonnées}}'**
  String statsAbandoned(int count);

  /// No description provided for @shareWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Partager mes envies'**
  String get shareWishlist;

  /// No description provided for @shareWishlistHeading.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Ma liste d’envies (1)} other{Ma liste d’envies ({count})}}'**
  String shareWishlistHeading(int count);

  /// No description provided for @shareWishlistCaption.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 envie} other{{count} envies}} · {date}'**
  String shareWishlistCaption(int count, String date);

  /// No description provided for @sharePriorityAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes priorités'**
  String get sharePriorityAll;

  /// No description provided for @sharePriorityUpTo.
  ///
  /// In fr, this message translates to:
  /// **'{max, plural, =1{Priorité 1} other{Priorités 1 à {max}}}'**
  String sharePriorityUpTo(int max);

  /// No description provided for @shareShowPrice.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le prix max'**
  String get shareShowPrice;

  /// No description provided for @shareAsImage.
  ///
  /// In fr, this message translates to:
  /// **'Partager l’image'**
  String get shareAsImage;

  /// No description provided for @shareAsText.
  ///
  /// In fr, this message translates to:
  /// **'Partager le texte'**
  String get shareAsText;

  /// No description provided for @shareNoWish.
  ///
  /// In fr, this message translates to:
  /// **'Aucune envie ne correspond aux filtres.'**
  String get shareNoWish;

  /// No description provided for @shareFileName.
  ///
  /// In fr, this message translates to:
  /// **'envies.png'**
  String get shareFileName;

  /// No description provided for @shareImageSaved.
  ///
  /// In fr, this message translates to:
  /// **'Image enregistrée'**
  String get shareImageSaved;

  /// No description provided for @shareTextCopied.
  ///
  /// In fr, this message translates to:
  /// **'Liste copiée dans le presse-papiers'**
  String get shareTextCopied;
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
