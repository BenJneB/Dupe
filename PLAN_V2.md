# Dupe — Plan v2 et état du projet

> Document autonome, à jour au **2026-11-14**, lisible sans accès à l'historique ni au code. Il sert de base à
> une revue externe : il dit ce qui était prévu, ce qui a été fait (écarts compris), ce qui est vérifié
> automatiquement et ce qui ne l'est pas encore. Les tests à faire à la main sont dans `TESTS_MANUELS.md`.

## 1. Contexte

**Dupe** est une application personnelle (un seul utilisateur, plusieurs appareils) pour cataloguer une
collection de mangas, BD, comics et livres. L'usage principal : en magasin, scanner le code-barres d'un livre
pour savoir s'il est déjà possédé, en liste d'envies, ou s'il manque à une série suivie.

- **Cibles** : Android (téléphone, scan caméra), Linux et Windows (PC). iOS/macOS hors périmètre.
- **Stack** : Flutter 3.50 / Dart 3.14, Riverpod 3, go_router, drift (SQLite local = source de vérité),
  Supabase (synchro optionnelle entre appareils, projet gratuit de l'utilisateur), dio.
- **Métadonnées** : BnF (catalogue SRU), Open Library, Google Books (clé), AniList, Comic Vine (clé). Liens
  seulement vers Bédéthèque / Manga-News (jamais de scraping).
- **Dépôt** : GitHub public (`BenJneB/Dupe`). Secrets dans `env.json` (jamais versionné), injectés à la
  compilation par `--dart-define-from-file`.
- **Méthode** : une phase à la fois ; fin de phase = `flutter analyze` sans remarque, `flutter test` vert,
  builds debug Linux et Android, puis arrêt jusqu'au retour de l'utilisateur. Rien n'est commité par
  l'assistant : l'utilisateur relit le diff et committe.

### Ce que contenait déjà la v1 (`PLAN.md`, phases 0 à 8)
Collection locale (séries, tomes, plusieurs exemplaires/éditions d'un tome), recherche locale et en ligne,
scan caméra (Android) ou clavier/douchette (PC), rattachement automatique d'un tome à sa série, **mode
Magasin** (bandeau vert possédé / jaune envie / bleu tome manquant d'une série / gris inconnu) et **mode
Rafale** (file persistée + écran de revue), statuts de lecture, envies et « prochains tomes à acheter »,
prêts avec rappels, prix et statistiques, synchro Supabase (RLS, dernière écriture gagnante, photos de
couverture dans un bucket privé), export/import JSON et CSV, mode sombre, icône, packaging (APK signé,
Inno Setup, AppImage).

## 2. Objectif de la v2

Rendre l'appli **fiable au quotidien** avant d'ajouter des fonctionnalités : qu'une erreur ne passe pas
inaperçue, ne se propage pas partout sans retour possible, et que chaque plateforme soit vérifiable.

### Constats de départ (relecture du code)
| Constat | Traité en |
|---|---|
| Le pull de la synchro pouvait **perdre des lignes** (horodatage serveur posé à l'écriture mais visible au commit ; égalités d'horodatage coupées entre deux pages) | Phase 9 |
| Erreurs avalées (`debugPrint`) ou affichées brutes ; rien de consultable après coup | Phase 9 |
| Connexion par code / lien d'email collé, jugée bancale (sans SMTP, modèles d'email non modifiables) | Phase 10 |
| Suppression sans annulation ; restauration qui **fusionne** (ne permet pas de revenir en arrière) | Phase 11 |
| Version figée `1.0.0+1`, Windows jamais compilé, pas de CI | Phase 12 |
| Projet Supabase gratuit mis en pause après 7 jours de faible activité | Phase 12 |
| Confort en magasin (accès au scan, résultat sans regarder l'écran, faible lumière) | Phase 13 |

## 3. État des phases

| Phase | Sujet | État | Tests auto | Vérifié en réel |
|---|---|---|---|---|
| 9 | Synchro fiable + journal d'erreurs | ✅ fait | oui | **non** (Supabase réel) |
| 10 | Inscription / connexion par mot de passe | ✅ fait | oui (faux serveur) | **non** |
| 11 | Annulation, sauvegardes auto, restauration complète | ✅ fait | oui | **non** |
| 12 | CI, Releases, versions, veille Supabase, nouvelles versions | ✅ écrit | partiel | **non** (workflows jamais exécutés) |
| 13 | Confort en magasin | ✅ fait | oui (hors caméra) | **non** (téléphone) |

Fin de phase 13 : **168 tests verts** (~20 s), analyse sans remarque, builds debug Linux et Android OK,
APK release `--split-per-abi` OK (28 à 34 Mo par architecture).

**Rien de la v1 ni de la v2 n'a encore été testé par l'utilisateur sur téléphone, sur le vrai Supabase ou
sous Windows.** C'est le principal risque restant (voir `TESTS_MANUELS.md`).

## 4. Détail par phase

### Phase 9 — Synchro fiable et journal d'erreurs
**Réalisé**
- Pull par **pagination sur clé** `(server_updated_at, id)` (filtre PostgREST `or(...)`, valeurs entre
  guillemets, instants UTC `Z`) et **relecture de la dernière minute** avant le curseur à chaque synchro.
  Une ligne déjà identique (même `updated_at` et `user_id`) n'est pas réécrite (pas d'écriture ni de
  rafraîchissement inutiles toutes les 30 s).
- Hypothèse assumée : deux écritures d'une même ligne n'ont jamais le même `updated_at` (horloge en µs).
- **Journal** local : 500 entrées, fichier JSON-lines dans le dossier de l'appli, compacté ; reçoit les
  erreurs Flutter / non attrapées, les échecs de providers, la synchro (une entrée par changement d'état
  d'échec, pas toutes les 30 s), les sources de métadonnées. À propos → Journal : copier, partager, vider.
- **Messages en français** pour les erreurs connues ; le détail technique part au journal.

**Vérifié automatiquement** : test du « commit tardif » (échoue sans la relecture, passe avec), test des
horodatages égaux sur plusieurs pages, journal (rotation, fichier, redémarrage), messages.
**Non vérifié** : la syntaxe exacte du filtre PostgREST contre le vrai Supabase (faux serveur en test).

### Phase 10 — Inscription et connexion par mot de passe
**Réalisé** : connexion email + mot de passe ; écran « Créer un compte » ; fonctionne avec l'option Supabase
*Confirm email* activée (message « ouvre le lien puis connecte-toi ») ou désactivée (connecté tout de suite) ;
messages précis (mauvais mot de passe, email non confirmé, déjà inscrit, mot de passe trop faible, trop de
tentatives). Code à 6 chiffres et lien collé supprimés.
**Écart au plan** : ajout de Paramètres → **Mot de passe** (définir/changer), indispensable car le compte
existant de l'utilisateur a été créé par lien, donc sans mot de passe.
**Limites** : mot de passe oublié = le changer depuis un appareil encore connecté (la réinitialisation
Supabase passe par un lien que l'appli ne reçoit pas). Sans SMTP, Supabase n'envoie d'email qu'aux membres
du projet. Inscriptions ouvertes : un tiers peut créer un compte, mais ne voit que ses données (RLS).
Supprimer un utilisateur Supabase efface ses données serveur (`on delete cascade`).

### Phase 11 — Filets de sécurité
**Réalisé**
- « Supprimé — Annuler » (8 s) après suppression d'un ouvrage ou d'une série (la série restaure les tomes
  supprimés au même instant qu'elle). Propagé par la synchro.
- **Sauvegardes automatiques** JSON : chaque semaine (au lancement), avant chaque import CSV (l'import est
  annulé si la sauvegarde échoue) et avant chaque restauration ; 8 gardées par sorte ; rien si collection vide.
  Paramètres → Sauvegardes automatiques : fusionner, revenir à cet état, exporter.
- **Restauration complète** (« Revenir à cette sauvegarde ») en plus de la fusion : lignes de la sauvegarde
  réécrites datées de maintenant (elles gagnent à la synchro), autres lignes supprimées (logiquement).

**Limites** : sauvegardes locales à l'appareil (sur Android, les exporter pour les garder ailleurs) ; une
restauration ne retire pas ce que l'appareil n'a pas encore reçu de l'autre (synchroniser avant) ; les photos
de couverture ne sont pas dans les sauvegardes (seulement leurs références).

### Phase 12 — CI, versions et distribution
**Réalisé** (`.github/workflows/`)
- `ci.yml` : à chaque push, analyse, tests, builds Linux, Android et **Windows** (+ installateur Inno Setup).
- `release.yml` : sur tag `vX.Y.Z`, version tirée du tag (`1.2.3+10203`), 3 APK signés (un par ABI),
  AppImage, installateur Windows, publiés en Release GitHub ; refuse de publier sans les secrets (jamais
  d'APK signé avec la clé de debug).
- `keep-alive.yml` : une requête par jour sur Supabase ; échoue (email GitHub) sur 5xx ou sans réponse.
- Appli : « Version X disponible — Télécharger » (API GitHub anonyme, au plus 1×/jour, **builds release
  seulement**), qui ouvre le fichier de la plateforme (APK de l'architecture du téléphone, AppImage,
  installateur) ; désactivable ; « Rechercher une mise à jour » dans Paramètres.
- Appli : erreur serveur 5xx → « Serveur de synchronisation indisponible… projet peut-être en pause ».

**Non vérifié** : aucun workflow n'a tourné (premier push à faire). La compilation Windows n'a jamais été
essayée. Inconnu : une requête **refusée** par la RLS compte-t-elle comme « activité » pour Supabase ? (le
schéma n'accorde rien au rôle anonyme). GitHub désactive les tâches planifiées après 60 jours sans commit.
**Sécurité** : les Releases sont publiques, donc tout `ENV_JSON` est extractible des binaires. Clé Supabase
*publishable* : prévue pour (RLS). Google Books : à restreindre dans la console Google. Comic Vine : non
restreignable — décision de l'utilisateur reportée (« on avisera »).

### Phase 13 — Confort en magasin
**Réalisé**
- **Raccourci Android** « Scanner » (appui long sur l'icône) → écran de scan en mode Magasin
  (`quick_actions` 1.1.1, Android seulement, jamais appelé sur PC ni en test).
- **Vibrations par verdict** en mode Magasin, au verdict final (pas pendant la recherche en ligne) :
  1 forte = possédé, 2 moyennes = envie, 3 légères = tome manquant d'une série, 1 brève = inconnu. Rafale :
  1 légère = ajouté à la file, 1 brève = déjà dans la file. Désactivable (Paramètres → Scan).
- **Lampe torche** dans l'écran caméra (bouton masqué si l'appareil n'en a pas).
- **Anti-doublon** : déjà en place (la caméra ne signale un code qu'une fois tant qu'un autre n'a pas été vu ;
  la file Rafale refuse un ISBN déjà présent). Rien ajouté.

**Limites** : les vibrations utilisent le retour haptique système ; s'il est coupé dans les réglages Android,
rien ne vibre. Caméra, torche et raccourci ne sont testables que sur téléphone.

## 5. Décisions de l'utilisateur
- Écran d'inscription **dans l'appli** (inscriptions ouvertes côté Supabase).
- Sauvegardes automatiques : **hebdomadaires, 8 gardées**.
- Dépôt **public**, Releases publiques, **signalement des nouvelles versions : oui**.
- Clé Comic Vine dans les Releases publiques : **reportée** (« on avisera »).
- Collection de départ codée en dur : **supprimée** (la collection passe par l'import CSV / la synchro).

## 6. Risques et questions ouvertes (pour la revue)
1. **Aucun test réel** : synchro Supabase, connexion, caméra, notifications, Windows, workflows. Le premier
   passage de `TESTS_MANUELS.md` révélera sans doute des écarts.
2. **Filtre PostgREST du pull** (phase 9) non vérifié contre le vrai serveur : s'il est faux, la synchro ne
   reçoit plus rien (l'erreur irait au journal).
3. **Migration du compte** : le compte existant n'a pas de mot de passe ; il faut le définir depuis un
   appareil encore connecté, sinon seule la suppression du compte (et de ses données serveur) débloque.
4. **Clés dans les binaires publics** (Comic Vine) : décision en attente avant la première Release.
5. **Veille Supabase** : efficacité du `keep-alive` non prouvée (une requête refusée compte-t-elle ?).
6. **Restauration complète et synchro** : elle gagne grâce à un `updated_at` « maintenant » ; un appareil dont
   l'horloge avance beaucoup pourrait encore l'emporter (dernière écriture gagnante, horloge client).
7. **Taille des fichiers** : convention < 250 lignes par fichier écrit à la main, respectée (maximum : 250).

## 7. Hors périmètre (inchangé)
iOS/macOS, partage de collection, alertes de sortie des nouveaux tomes (aucune source fiable pour les sorties
françaises à venir), scraping, cote automatique.

## 8. Repères dans le dépôt
- `PLAN.md` : spécification v1 (phases 0-8). `README.md` : configuration, Supabase, sauvegardes, publication.
- `TESTS_MANUELS.md` : checklist des tests à faire à la main, avec identifiants.
- `lib/core/sync/` (synchro), `lib/core/logging/` (journal), `lib/app/error_text.dart` (messages),
  `lib/features/backup/` (sauvegardes, CSV), `lib/features/updates/` (nouvelles versions),
  `lib/features/scan/` (scan, vibrations, raccourci), `supabase/migrations/` (schéma + RLS),
  `.github/workflows/` (CI, release, veille), `tool/ci/set_version.sh`.
