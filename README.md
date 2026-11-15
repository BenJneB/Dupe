# Dupe

[![CI](https://github.com/BenJneB/Dupe/actions/workflows/ci.yml/badge.svg)](https://github.com/BenJneB/Dupe/actions/workflows/ci.yml)

Application personnelle pour cataloguer une collection de mangas, BD, comics et livres
(Android, Windows, Linux). Spécification : [PLAN.md](PLAN.md).

## Prérequis
- Flutter stable ≥ 3.50 (`flutter doctor` sans erreur)
- Android : SDK Android + téléphone avec le débogage USB activé
- Linux : toolchain desktop Linux (clang, cmake, ninja, GTK 3)
- Windows : Visual Studio avec la charge « Développement Desktop en C++ » (compilation sur Windows uniquement)

## Configuration
Les secrets ne sont jamais dans le code : ils sont injectés à la compilation depuis `env.json`
(ignoré par git).

```sh
cp env.example.json env.json   # puis remplir les vraies valeurs
```

| Clé | Usage | Obligatoire |
|---|---|---|
| `SUPABASE_URL`, `SUPABASE_ANON_KEY` | Synchronisation cloud (phase 7) | non (mode local seul sinon) |
| `COMIC_VINE_API_KEY` | Comics (développement seulement : voir « Clés des sources ») | non |
| `OPEN_LIBRARY_CONTACT` | Email envoyé à Open Library dans le User-Agent (limite 3 req/s au lieu de 1) | non |
| `GOOGLE_BOOKS_API_KEY` | Google Books (développement seulement : voir « Clés des sources ») | non |

### Clés des sources (Google Books, Comic Vine)
Les Releases sont publiques et leurs binaires peuvent être décompilés : les clés de ces deux services ne sont
**pas** compilées dans les versions publiées (`release.yml` refuse de publier si `ENV_JSON` en contient). On les
saisit dans l'appli : **Paramètres → Sources de données → Clé API** sous la source, avec un bouton *Tester la
clé*. Une clé saisie active la source tout de suite ; elle reste sur l'appareil (ni synchronisée, ni dans les
sauvegardes, ni dans le journal) : la saisir sur chaque appareil. En développement, une clé de `env.json` sert
de valeur par défaut (une clé saisie dans l'appli passe devant).
- **Google Books** (couvertures, résumés ; sans clé le quota anonyme est épuisé, HTTP 429) : console Google
  Cloud → *API et services* → activer *Books API* → *Identifiants* → créer une clé API, **restreinte à Books
  API**.
- **Comic Vine** (comics US) : créer un compte sur comicvine.gamespot.com, la clé est sur
  comicvine.gamespot.com/api (usage non commercial). Si une Release publique a déjà contenu une clé,
  la régénérer.

## Utilisation du scan
- **Mode Magasin** (par défaut) : vérifie l'ISBN dans ta collection, sans réseau. Les couleurs :
  vert = déjà possédé, jaune = envie, bleu = tome manquant d'une de tes séries, gris = inconnu.
  Les tomes ajoutés sans ISBN (grille, « possédés jusqu'au ») sont reconnus en ligne par série + numéro,
  puis l'ISBN est mémorisé.
- **Mode Rafale** : scanne une étagère à la suite ; les infos sont cherchées en arrière-plan, puis
  « Revoir » permet de corriger et d'ajouter tout en une fois.
- **Vibrations** (mode Magasin, Android) : 1 forte = possédé, 2 = envie, 3 légères = tome manquant d'une
  série, 1 brève = inconnu ; désactivables dans Paramètres → *Scan* (et muettes si le retour haptique est
  coupé dans les réglages du téléphone).
- **Raccourci** : appui long sur l'icône de l'appli → *Scanner* ; bouton **lampe torche** sur la caméra.
- **Widget** (Android) : ajouter « Dupe » sur l'écran d'accueil : bouton *Scanner* et nombre d'ouvrages / de
  prêts en retard.
- **Recherche vocale** (Android, Windows) : micro de la barre de recherche, puis par exemple « One Piece tome
  107 » ou « tome 3 de Blacksad » : la fiche du tome s'ouvre, ou la série avec « absent de ta collection ».
- Paramètres → *Sources de données* : activer/désactiver chaque source.

## Synchronisation (Supabase, facultatif)
Sans `SUPABASE_URL`, l'appli fonctionne entièrement en local. Pour synchroniser téléphone et PC :
1. **Schéma** : dans le tableau de bord Supabase → *SQL Editor*, exécuter dans l'ordre
   `supabase/migrations/20261114120000_collection_sync.sql`, `20261114120100_cover_photos.sql`, puis
   `20261115090000_keep_alive.sql` (fonction de veille, voir « Supabase gratuit »)
   (ou `supabase link` puis `supabase db push` avec la CLI).
2. **Comptes (email + mot de passe)** : fournisseur *Email* activé (*Authentication → Sign In / Providers*).
   Le compte se crée dans l'appli (Paramètres → *Se connecter* → *Créer un compte*). Les inscriptions restent
   ouvertes : quiconque a l'appli peut créer un compte, mais ne voit que ses propres données (RLS).
   Option *Confirm email* du même fournisseur :
   - **activée** (défaut) : Supabase envoie un lien de confirmation. Sans SMTP personnalisé, il n'envoie
     qu'aux membres de l'équipe du projet (2 emails/heure). Ouvrir le lien dans le navigateur : il confirme
     l'adresse puis redirige vers la *Site URL* du projet (`localhost:3000` par défaut, donc une erreur de
     page — sans conséquence). Revenir ensuite dans l'appli et se connecter. Si l'appli répond « pas encore
     confirmé », le lien a expiré ou a déjà été consommé (certaines messageries l'ouvrent d'avance) ;
   - **désactivée** : le compte est utilisable tout de suite.

   Longueur minimale du mot de passe : réglée par le projet Supabase (6 caractères par défaut).
   **Compte créé avant la v2** (connexion par lien) : il n'a pas de mot de passe. Depuis un appareil encore
   connecté : Paramètres → *Mot de passe*. **Mot de passe oublié** : même chemin depuis un appareil connecté.
   En dernier recours, supprimer l'utilisateur (*Authentication → Users*) efface aussi ses données serveur
   (`on delete cascade`) ; elles sont renvoyées depuis l'appareil à la création du nouveau compte (photos de
   couverture : à vérifier).
3. **env.json** : `SUPABASE_URL` (*Settings → Data API* ou bouton *Connect*) et, dans `SUPABASE_ANON_KEY`,
   la **clé publishable** `sb_publishable_…` (*Settings → API Keys*, onglet *Publishable and secret API
   keys*). L'ancienne clé *anon* (`eyJ…`) marche aussi mais Supabase l'abandonne fin 2026. Jamais la clé
   *secret* / *service_role*.
4. Dans l'appli : Paramètres → *Se connecter* → email + mot de passe. La collection locale est envoyée sur le
   compte ; l'icône nuage dans la barre de recherche indique l'état.

Fonctionnement : SQLite reste la source de vérité ; synchro au lancement, au retour au premier plan,
3 s après une modification, toutes les 30 s au premier plan et à la demande. En cas de conflit, la
modification la plus récente gagne. Les photos de couverture prises dans l'appli vont dans le bucket
privé `covers`.

## Tests de synchro contre un Supabase local
Les tests tagués `supabase` (`test/supabase/`) vérifient la synchro contre un vrai PostgREST/Postgres/GoTrue/
Storage **local** (Docker) : filtre de pagination, égalités d'horodatage, commits tardifs, triggers, suppressions,
isolation entre comptes (RLS), `keep_alive()`, photos privées, comptes par mot de passe. Jamais contre le projet
distant (le script refuse une URL qui n'est pas locale). Ils sont exclus de `flutter test` ; la CI les lance sur
les pull requests et sur `dev` (job `supabase-tests`).

Installation, une fois :
```sh
sudo usermod -aG docker "$USER"     # puis se déconnecter / reconnecter (donne des droits root via Docker)
curl -fLO https://github.com/supabase/cli/releases/download/v2.122.1/supabase_2.122.1_linux_amd64.deb
sudo dpkg -i supabase_2.122.1_linux_amd64.deb   # Supabase CLI épinglée (même version qu'en CI)
```
Sans installer la CLI : `tool/supabase_tests.sh` passe alors par `npx -y supabase@2.122.1` (Node requis).
Juste après `usermod`, sans se reconnecter : `sg docker -c tool/supabase_tests.sh`.
`psql` est aussi nécessaire (paquet `postgresql-client`).

Lancer :
```sh
tool/supabase_tests.sh       # démarre Supabase local si besoin (supabase/config.toml), applique les migrations
supabase stop                # quand on a fini
```
Le premier `supabase start` télécharge les images Docker (plusieurs minutes). Confirmation d'email désactivée
en local (`supabase/config.toml`) : les tests créent un compte neuf chacun.

## Hooks git et messages de commit
Messages de commit **conventionnels** : `type(portée facultative): description`, types `feat`, `fix`, `chore`,
`docs`, `test`, `refactor`, `ci` (`!` après le type pour un changement cassant). Les notes de chaque Release
sont générées depuis ces messages (`tool/ci/release_notes.sh`, groupées par type, depuis le tag stable
précédent).

Hooks avec [lefthook](https://github.com/evilmartians/lefthook) 2.2.2 (`lefthook.yml`), une fois par clone :
```sh
curl -fLO https://github.com/evilmartians/lefthook/releases/download/v2.2.2/lefthook_2.2.2_amd64.deb
sudo dpkg -i lefthook_2.2.2_amd64.deb
lefthook install
```
- avant un commit : `dart format` des fichiers `.dart` stagés (re-stagés automatiquement) et `flutter analyze` ;
- avant un push : `flutter test` ;
- message de commit : `tool/check_commit_msg.sh` (refuse un message non conventionnel).

Exceptionnellement : `LEFTHOOK=0 git commit …`.

## Tests d'intégration
`integration_test/app_flows_test.dart` : parcours clés sur l'appli réelle (ajout d'un tome, mode Magasin pour
les quatre verdicts, prêt puis retour, annulation d'une suppression), sources simulées, sans synchro.
```sh
flutter test integration_test -d linux                 # ouvre une fenêtre ; en CI : xvfb-run -a …
flutter test integration_test -d <id-téléphone>        # le parcours Magasin est sauté (caméra)
```

## Sauvegardes
- **Manuelles** : Paramètres → *Exporter une sauvegarde* (JSON complet) ; *Restaurer* propose de **fusionner**
  (rien n'est effacé) ou de **revenir exactement** à la sauvegarde (ce qui a été ajouté depuis est supprimé, sur
  tous les appareils après synchro).
- **Automatiques** : chaque semaine au lancement, et avant chaque import CSV ou restauration ; les 8 dernières
  de chaque sorte sont gardées dans le dossier de données de l'appli (`backups/`, par exemple
  `~/.local/share/dev.dupe.dupe/backups` sous Linux). Paramètres → *Sauvegardes automatiques* pour les
  restaurer ou les exporter. Elles restent sur l'appareil : sur Android, les exporter pour les garder ailleurs.
- Supprimer un ouvrage ou une série affiche « Annuler » pendant quelques secondes.

## Couvertures hors ligne
Paramètres → *Couvertures hors ligne* : l'appli télécharge en arrière-plan toutes les couvertures de la
collection et des envies (Wi-Fi seulement par défaut) pour les afficher sans réseau, en magasin par exemple.
Elles sont gardées dans le dossier de données de l'appli (`cover_cache/`) ; *Vider* libère la place (les photos
prises soi-même ne sont jamais effacées).

## Développement
```sh
flutter pub get
dart run build_runner build -d   # après modification d'un fichier @riverpod / freezed
flutter gen-l10n                 # après modification de lib/l10n/app_fr.arb
flutter analyze
flutter test
```

## Lancer l'application
```sh
# Android (téléphone branché en USB, débogage activé)
flutter devices
flutter run -d <id-du-téléphone> --dart-define-from-file=env.json

# Linux
flutter run -d linux --dart-define-from-file=env.json

# Windows (sur une machine Windows)
flutter run -d windows --dart-define-from-file=env.json
```

## Installer / distribuer
### Publier une version (GitHub Actions)
`.github/workflows/` :
- `ci.yml` : à chaque push, analyse, tests et compilation Linux, Android et **Windows** (seule vérification
  Windows sans PC Windows) ;
- `release.yml` : pousser un tag `vX.Y.Z` construit les APK signés (un par architecture), l'AppImage et
  l'installateur Windows, puis les publie dans une Release GitHub. La version vient du tag
  (`tool/ci/set_version.sh` : `v1.2.3` → `1.2.3+10203`, mineur et correctif < 100 ; un suffixe `-xxx` ne
  change pas le numéro Android et n'apparaît que dans les noms de fichiers) ;
- `keep-alive.yml` : un appel par jour à la fonction `keep_alive()` de Supabase (voir plus bas) ;
- `.github/dependabot.yml` : mises à jour hebdomadaires des dépendances `pub` et des actions GitHub, en pull
  requests vers `dev` (mineures et correctifs regroupés). Dependabot ne lit ce fichier que sur la **branche par
  défaut** (`main`). Si une mise à jour exige de régénérer du code (freezed, drift, riverpod), l'étape *Generated
  code is up to date* de la CI échoue : lancer `dart run build_runner build -d` sur la branche de la PR.

Contrôles de `ci.yml` : formatage (`dart format --set-exit-if-changed`), code généré à jour (build_runner +
`flutter gen-l10n` ne doivent rien changer), analyse, tests avec couverture (pourcentage hors code généré dans
le récapitulatif du job, `lcov.info` en artefact), builds.

```sh
git tag v1.0.0 && git push origin v1.0.0
```
Un tag avec suffixe (`v0.0.1-test`, `v1.2.0-rc.1`) publie une **pre-release** : mêmes fichiers, mais jamais
proposée comme mise à jour par l'appli. Pour la supprimer : supprimer la Release sur GitHub, puis
`git push --delete origin v0.0.1-test && git tag -d v0.0.1-test`.
L'appli installée signale ensuite la nouvelle version (au plus une fois par jour, désactivable dans
Paramètres → *Mises à jour*) et ouvre le fichier de la plateforme.

**Secrets à créer une fois** (GitHub → *Settings → Secrets and variables → Actions → New repository secret*) :

| Secret | Valeur |
|---|---|
| `ENV_JSON` | le contenu de `env.json` |
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 ~/dupe-release.jks` (la clé créée ci-dessous) |
| `ANDROID_KEYSTORE_PASSWORD` | `storePassword` |
| `ANDROID_KEY_ALIAS` | `dupe` |
| `ANDROID_KEY_PASSWORD` | `keyPassword` |

Le dépôt étant **public**, les Releases aussi : tout ce que contient `ENV_JSON` est compilé dans les binaires
et extractible. La clé Supabase *publishable* est faite pour ça (RLS). `ENV_JSON` ne doit **pas** contenir
`COMIC_VINE_API_KEY` ni `GOOGLE_BOOKS_API_KEY` (le job `check-env` de `release.yml` refuse alors de publier,
sans afficher les valeurs) : ces clés se saisissent dans l'appli. `OPEN_LIBRARY_CONTACT` (un email) y est
aussi lisible : le laisser vide dans `ENV_JSON` pour ne pas publier son adresse.

**Supabase gratuit** : un projet est mis en pause après 7 jours de faible activité
([doc](https://supabase.com/docs/guides/platform/free-project-pausing)), restaurable depuis le tableau de bord
pendant un an. `keep-alive.yml` appelle chaque jour la fonction SQL `keep_alive()` (vraie requête sur la base,
qui ne renvoie que l'heure du serveur ; migration `20261115090000_keep_alive.sql`, à appliquer). Il lit
`SUPABASE_URL` / `SUPABASE_ANON_KEY` dans `ENV_JSON` et échoue — email de GitHub — si la fonction manque ou si
le projet ne répond plus. Dans l'appli, un projet en pause donne « Serveur de synchronisation indisponible… ».

**Tâches planifiées et 60 jours** : GitHub désactive, **sans prévenir**, les workflows planifiés d'un dépôt
public resté 60 jours sans activité ([doc](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/disable-and-enable-workflows)).
Sans commit automatique, `keep-alive.yml` se réactive lui-même à chaque passage par l'API REST
(`PUT …/actions/workflows/keep-alive.yml/enable`, jeton du workflow avec `actions: write`). GitHub ne documente
pas si cet appel remet le compteur à zéro : si le workflow apparaît désactivé dans l'onglet *Actions*, le
réactiver (bouton *Enable workflow*, ou `gh workflow enable keep-alive.yml`). Tout push sur le dépôt remet aussi
le compteur à zéro.

### Android : APK signé
Une seule fois, créer la clé de signature (à garder précieusement **hors du dépôt** : sans elle, impossible
de publier une mise à jour installable par-dessus) :
```sh
/snap/android-studio/current/jbr/bin/keytool -genkey -v -keystore ~/dupe-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias dupe
```
puis créer `android/key.properties` (ignoré par git) :
```properties
storeFile=/home/<toi>/dupe-release.jks
storePassword=...
keyAlias=dupe
keyPassword=...
```
```sh
flutter build apk --release --dart-define-from-file=env.json
# -> build/app/outputs/flutter-apk/app-release.apk (signé avec la clé si key.properties existe,
#    sinon avec la clé de debug)
```

### Windows : installateur Inno Setup (sur un PC Windows)
Installer [Inno Setup 6](https://jrsoftware.org/isdl.php), puis :
```bat
flutter build windows --release --dart-define-from-file=env.json
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" packaging\windows\dupe.iss
```
→ `build\installer\Dupe-1.0.0-setup.exe` (installation par utilisateur, sans droits administrateur).
Version : `ISCC.exe /DAppVersion=1.2.3 …` (la CI passe celle du tag), sinon 1.0.0.

### Linux : AppImage
```sh
packaging/linux/build_appimage.sh            # utilise env.json
# -> build/Dupe-1.0.0-x86_64.AppImage (appimagetool téléchargé une fois dans build/tools/)
```

### Icône
Dessinée en code (`lib/app/widgets/dupe_logo.dart`). Après modification :
```sh
flutter test tool/render_icons_test.dart --update-goldens   # -> assets/icon/*.png
dart run flutter_launcher_icons                              # Android + Windows
```

## Note Linux (GNOME récent / Ubuntu 26.04)
GTK 3 en Wayland plante au démarrage car la clé GNOME `xsettings antialiasing` a disparu.
`linux/runner/main.cc` le détecte et bascule alors automatiquement sur X11 (XWayland).
Pour forcer un backend : `GDK_BACKEND=wayland` ou `GDK_BACKEND=x11`.
