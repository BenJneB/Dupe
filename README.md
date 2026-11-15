# Dupe

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
| `COMIC_VINE_API_KEY` | Métadonnées comics (phase 3) | non |
| `OPEN_LIBRARY_CONTACT` | Email envoyé à Open Library dans le User-Agent (limite 3 req/s au lieu de 1) | non |
| `GOOGLE_BOOKS_API_KEY` | Google Books (couvertures, résumés). Sans clé la source est désactivée : le quota anonyme est épuisé (HTTP 429) | recommandée |

## Utilisation du scan
- **Mode Magasin** (par défaut) : vérifie l'ISBN dans ta collection, sans réseau. Les couleurs :
  vert = déjà possédé, jaune = envie, bleu = tome manquant d'une de tes séries, gris = inconnu.
  Les tomes ajoutés sans ISBN (grille, « possédés jusqu'au ») sont reconnus en ligne par série + numéro,
  puis l'ISBN est mémorisé.
- **Mode Rafale** : scanne une étagère à la suite ; les infos sont cherchées en arrière-plan, puis
  « Revoir » permet de corriger et d'ajouter tout en une fois.
- Paramètres → *Sources de données* : activer/désactiver chaque source.

## Synchronisation (Supabase, facultatif)
Sans `SUPABASE_URL`, l'appli fonctionne entièrement en local. Pour synchroniser téléphone et PC :
1. **Schéma** : dans le tableau de bord Supabase → *SQL Editor*, exécuter dans l'ordre
   `supabase/migrations/20261114120000_collection_sync.sql` puis `20261114120100_cover_photos.sql`
   (ou `supabase link` puis `supabase db push` avec la CLI).
2. **Comptes (email + mot de passe)** : fournisseur *Email* activé (*Authentication → Sign In / Providers*).
   Le compte se crée dans l'appli (Paramètres → *Se connecter* → *Créer un compte*). Les inscriptions restent
   ouvertes : quiconque a l'appli peut créer un compte, mais ne voit que ses propres données (RLS).
   Option *Confirm email* du même fournisseur :
   - **activée** (défaut) : Supabase envoie un lien de confirmation. Sans SMTP personnalisé, il n'envoie
     qu'aux membres de l'équipe du projet (2 emails/heure). Ouvrir le lien dans le navigateur (la page
     d'arrivée peut ne pas s'afficher), puis se connecter dans l'appli ;
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
Penser à aligner `AppVersion` de `packaging/windows/dupe.iss` sur `version:` de `pubspec.yaml`.

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
