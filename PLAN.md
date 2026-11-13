PLAN.md — Application de gestion de collection (Mangas, BD, Comics, Livres)
1. Objectif

Application personnelle, Android et desktop (Windows, Linux), pour cataloguer ma collection de mangas, BD, comics et livres. Usage principal : en magasin, scanner un code-barres ou chercher un titre pour savoir instantanément si je possède déjà l’ouvrage, s’il est dans ma liste d’envies, ou quel tome me manque dans une série.

Principes directeurs :

Offline-first : toute la collection est stockée localement, l’appli fonctionne sans réseau. Le cloud ne sert qu’à synchroniser.
Rapidité en magasin : du lancement au résultat du scan en moins de 3 secondes.
Saisie minimale : les infos viennent de sources externes, l’édition manuelle reste toujours possible.
Interface en français.

Inspirations : Mangacollec (vue série avec grille des tomes possédés/manquants), BDGest/Bdovore (éditions originales, fiches BD détaillées), CLZ (scan en rafale pour cataloguer ses étagères, statistiques), Libib (simplicité, prêts).

2. Stack technique
Besoin	Choix
Framework	Flutter (stable), Dart, cibles android, windows, linux (macOS abandonné pour simplifier)
État	Riverpod (avec riverpod_generator)
Base locale	Drift (SQLite)
Backend / sync / auth	Supabase (Postgres + Auth + Row Level Security + Storage)
Réseau	dio
Modèles	freezed + json_serializable
Navigation	go_router
Scan code-barres	mobile_scanner (Android uniquement)
Images	cached_network_image
Graphiques	fl_chart
Notifications (prêts)	flutter_local_notifications
Liens externes	url_launcher

Sur Windows et Linux, pas de scan caméra : saisie ISBN manuelle, ou douchette USB (elle se comporte comme un clavier, donc un champ texte avec validation sur Entrée suffit).

Secrets : URL et clé anon Supabase, clé Comic Vine, clé Google Books (optionnelle) passées via --dart-define-from-file=env.json, fichier exclu du dépôt git. Un env.example.json est fourni.

3. Navigation et écrans

Structure principale : barre de navigation en bas sur mobile, NavigationRail à gauche sur desktop (layout adaptatif selon la largeur).

Onglets : Mangas · BD · Comics · Livres · Plus. Un bouton flottant Scanner est accessible depuis tous les onglets. Une barre de recherche globale en haut cherche dans toute la collection locale.

Le menu Plus contient : Liste d’envies, Prêts, Statistiques, Paramètres (compte, sync, export/import, sources de données).

Écrans par onglet de type (Mangas, BD, Comics) :

Liste des séries, en grille de couvertures ou en liste, avec tri (titre, ajout récent, progression) et filtres (statut de lecture, série complète/incomplète, éditeur).
Fiche série : couverture, infos, et la grille des tomes façon Mangacollec, chaque numéro étant une pastille colorée (possédé, envie, manquant, prêté). Indication « 12/15 tomes, il manque 13, 14, 15 ». Appui sur une pastille → fiche du tome ; appui long → ajout rapide.
Fiche tome/numéro : toutes les infos, statut de lecture, prix, prêt, notes.

Onglet Livres : liste de livres (pas forcément en série), mêmes filtres. Les cycles (ex. sagas) peuvent utiliser le même mécanisme de série.

Écran Scanner, deux modes :

Mode magasin (par défaut) : un scan affiche un grand bandeau de résultat :
🟢 Déjà possédé — titre, tome, date d’achat, et l’emplacement s’il est renseigné
🟡 Dans ta liste d’envies — avec le prix max que je m’étais fixé
🔵 Pas possédé, série suivie — « Tome 13 de One Piece, tu as 1 à 12 »
⚪ Inconnu — bouton « Ajouter à la collection » ou « Ajouter aux envies »
Cette vérification est 100 % locale (recherche par ISBN dans SQLite), la recherche en ligne n’intervient que pour un ajout.
Mode catalogage en rafale : scans successifs, chaque ISBN est ajouté à une file, les métadonnées sont récupérées en arrière-plan, puis un écran de revue permet de valider/corriger en lot.

Écran Ajout/Recherche en ligne : choix du type, recherche par ISBN ou texte, résultats issus des sources externes, sélection, puis formulaire pré-rempli modifiable. Bouton « Ouvrir sur Bédéthèque / Manga-News / Comic Vine » (url_launcher) quand les sources automatiques ne trouvent rien.

4. Modèle de données

Toutes les tables ont : id (UUID généré côté client), user_id, created_at, updated_at, deleted_at (suppression logique, indispensable pour la sync). Le schéma est identique en local (Drift) et sur Supabase.

series

type : manga | bd | comic | livre
title, original_title, authors (liste), publisher, collection (ex. « Shonen », « Black Label »)
status_publication : en_cours | terminee | inconnue
total_volumes (nullable, sert au calcul des manquants)
cover_url, description, external_ids (JSON : anilist_id, comicvine_id…)
followed (bool : je suis cette série, donc les tomes non possédés comptent comme « manquants »)
notes

items (un tome, un numéro, un livre)

series_id (nullable pour un livre isolé), type
title, volume_number (texte, pour gérer « 1.5 », « HS 2 », « Annual 1 »), isbn13 (indexé), upc
authors, publisher, edition (ex. « Perfect Edition », « Intégrale »), format (broché, relié, poche, TPB, single issue…)
publish_date, page_count, language, cover_url, description
ownership : possede | envie
reading_status : non_lu | en_cours | lu | abandonne ; read_date, rating (0–5)
is_first_edition (EO, pour les BD), is_variant, condition
purchase_price, purchase_date, cover_price (prix éditeur), estimated_value, currency (EUR par défaut)
wishlist_priority (1–3), wishlist_max_price
location (étagère, carton…), notes
source, source_id (provenance des métadonnées)

loans

item_id, borrower_name, loaned_at, due_at (nullable), returned_at (nullable), notes

La liste d’envies n’est pas une table séparée : ce sont les items avec ownership = envie. Passer un item de « envie » à « possédé » se fait en un appui (« Je l’ai acheté »), avec saisie optionnelle du prix payé.

5. Sources de métadonnées

Architecture : une interface MetadataProvider (supportedTypes, searchByIsbn, searchByText) qui renvoie un MetadataResult normalisé. Un MetadataAggregator interroge les providers selon un ordre de priorité par type, fusionne les résultats (ex. titre de la BnF + couverture d’Open Library) et gère les timeouts (5 s par source) et les échecs sans bloquer.

Type	Par ISBN	Par texte / série	Remarques
Livres	Google Books, Open Library, BnF	Google Books, Open Library	Couvertures Open Library par ISBN
BD	BnF, Google Books	BnF, Google Books	Bédéthèque n’a pas d’API : lien externe uniquement, pas de scraping
Mangas	BnF, Google Books (édition française)	AniList (infos série : synopsis, nb de tomes, statut)	AniList décrit l’œuvre originale, pas l’édition française : ne s’en servir que pour la série
Comics	Google Books, Open Library (TPB, éditions FR)	Comic Vine (volumes et issues), Metron en option	Les single issues US ont un code UPC, pas un ISBN : recherche par titre + numéro

Points d’attention pour l’implémentation :

Vérifier la documentation actuelle de chaque API avant de coder (endpoints, formats, limites). Le catalogue BnF passe par son API SRU (réponse XML, Dublin Core ou UNIMARC). Comic Vine exige une clé et un User-Agent personnalisé, et limite le nombre de requêtes.
Respecter les limites de débit (file d’attente avec délai, surtout en mode rafale) et mettre en cache les réponses.
Utilitaire ISBN : validation ISBN-10/13, conversion 10→13, normalisation (tirets, espaces), distinction ISBN (978/979) / UPC.
Les providers sont activables/désactivables dans les paramètres.
6. Synchronisation (Supabase)
Auth : email + code OTP à 6 chiffres (évite les liens magiques, pénibles à gérer en deep link sur desktop). Session persistée.
RLS sur toutes les tables : user_id = auth.uid().
Stratégie : SQLite est la source de vérité. Chaque modification locale met à jour updated_at et marque la ligne comme « à pousser ». La sync pousse les lignes modifiées (upsert), puis tire les lignes distantes dont updated_at est supérieur au dernier curseur de sync. Conflits : la plus récente gagne (last-write-wins), suffisant pour un usage mono-utilisateur.
Déclenchement : au lancement, au retour au premier plan, après chaque modification (avec un délai de regroupement de quelques secondes), et manuellement via un bouton. Indicateur de statut de sync discret.
L’appli reste pleinement utilisable sans compte (mode local seul) ; la connexion au compte importe les données locales.
Photos de couverture prises par l’utilisateur (ouvrage introuvable) : stockées dans Supabase Storage, bucket privé.
Alternative à évaluer si la sync maison devient complexe : PowerSync (sync SQLite ↔ Supabase clé en main).
7. Fonctionnalités complémentaires

Statut de lecture : non lu / en cours / lu / abandonné, date de lecture, note. Sur la fiche série, action « Marquer les tomes 1 à N comme lus ». Filtre « Ma pile à lire ».

Liste d’envies : vue globale tous types confondus, triée par priorité. Indication des tomes manquants des séries suivies (« prochains tomes à acheter »), générée automatiquement à partir de total_volumes. Prix max par envie, affiché en mode magasin.

Prêts : prêter depuis la fiche (nom de l’emprunteur avec autocomplétion des noms déjà saisis, date de retour optionnelle), liste des prêts en cours, en retard surlignés, notification locale à l’échéance, historique des prêts. Pastille « prêté » dans la grille des tomes.

Prix et valeur : prix payé, prix éditeur (récupéré automatiquement quand la source le fournit), valeur estimée (manuelle, aucune source fiable n’existe). Statistiques : total dépensé, valeur totale, dépenses par mois et par type, nombre d’ouvrages par type, pourcentage lu, séries complètes vs incomplètes.

Export / import : export JSON complet (sauvegarde) et CSV par type. Import CSV générique avec écran de correspondance des colonnes, pour reprendre une collection existante (ex. un export Mangacollec ou CLZ si l’utilisateur en a un).

8. Architecture du code

Organisation par fonctionnalité :

lib/
  main.dart
  app/            router, thème (clair/sombre), layout adaptatif
  core/
    database/     tables Drift, DAO, migrations
    sync/         moteur de sync Supabase
    network/      client dio, cache, limiteur de débit
    metadata/     interface provider, aggregator, providers (google_books, open_library, bnf, anilist, comicvine)
    utils/        isbn, formatage prix/dates
  features/
    collection/   séries, fiches, formulaires
    scan/         mode magasin, mode rafale
    search/       recherche locale et en ligne
    wishlist/
    loans/
    stats/
    settings/     compte, sources, export/import
test/
supabase/
  migrations/     SQL du schéma + politiques RLS

Conventions : couches data (repositories) / domain (modèles freezed) / presentation (widgets + providers Riverpod). Aucun appel réseau direct depuis les widgets. Code et commentaires en anglais, textes d’interface en français centralisés (fichiers ARB, pour pouvoir traduire plus tard).

Tests : tests unitaires obligatoires pour l’utilitaire ISBN, chaque provider (réponses HTTP simulées à partir de fixtures réelles), l’aggregator, le calcul des tomes manquants et le moteur de sync. Tests de widgets pour l’écran de résultat du scan.

9. Phases de développement

Chaque phase se termine par une appli qui compile et fonctionne sur Android et au moins un desktop, avec tests au vert.

Phase 0 — Mise en place. Création du projet Flutter avec les 4 cibles, dépendances, lints stricts, structure de dossiers, thème, navigation avec les onglets vides, layout adaptatif mobile/desktop, env.example.json, README de build.
Critère : l’appli se lance et on navigue entre les onglets sur Android et desktop.

Phase 1 — Collection locale. Schéma Drift complet (avec UUID, updated_at, deleted_at dès maintenant), CRUD manuel des séries et items, listes par onglet, fiche série avec grille des tomes, recherche locale globale.
Critère : je peux saisir à la main une série de 10 tomes, en posséder 7, et voir les 3 manquants.

Phase 2 — Métadonnées livres et scan. Utilitaire ISBN, providers Google Books, Open Library, BnF, aggregator, écran de recherche en ligne, scan caméra sur Android, saisie/douchette sur desktop, ajout depuis un résultat.
Critère : je scanne un livre, ses infos et sa couverture se remplissent seules.

Phase 3 — Mangas, BD, comics. Providers AniList et Comic Vine, rattachement automatique d’un tome scanné à une série existante (même titre de série + éditeur), création de série depuis les infos AniList/Comic Vine, liens externes de secours.
Critère : je scanne le tome 3 d’un manga, il est rangé dans la bonne série.

Phase 4 — Mode magasin et rafale. Écran de résultat coloré instantané, mode catalogage en rafale avec file d’attente et écran de revue.
Critère : vérification d’un ISBN déjà possédé en moins de 3 s depuis le lancement, sans réseau.

Phase 5 — Lecture, envies, prêts. Statuts de lecture et actions groupées, liste d’envies avec priorités et prix max, tomes manquants suggérés, prêts avec notifications.

Phase 6 — Prix et statistiques. Champs de prix, action « Je l’ai acheté », écran de statistiques avec graphiques.

Phase 7 — Synchronisation Supabase. Migrations SQL et RLS, auth par code OTP, moteur de sync, indicateur de statut, import des données locales à la première connexion, stockage des photos de couverture.
Critère : un ajout sur le téléphone apparaît sur le PC en moins d’une minute ; une modification hors ligne est synchronisée au retour du réseau.

Phase 8 — Export/import et finitions. Export JSON/CSV, import CSV avec correspondance de colonnes, mode sombre, icône, écran « à propos », packaging : APK signé (Android), installeur MSIX ou Inno Setup (Windows), AppImage (Linux).

10. Hors périmètre (pour plus tard)

Versions iOS et macOS, partage de collection avec d’autres personnes, alertes de sortie des nouveaux tomes, scraping de sites sans API, estimation automatique de la cote.
