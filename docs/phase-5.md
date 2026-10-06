# Phase 5 — Pré-v1 / release

**Statut :** faite (config + versions + smoke).

## Livré

1. **Versions** — app `0.7.0+8` (`pubspec.yaml` + `publishedAppVersion`) ; noyau `2026.10.5`
2. **À propos** — versions app + bibliothèque affichées ; compte reporté hors 0.x
3. **Signature release** — `android/app/build.gradle.kts` lit `android/key.properties` ; sinon fallback debug
4. **Modèle** — `android/key.properties.example` (ne jamais committer le vrai fichier ni le `.jks`)

## Créer / renouveler le keystore

```bash
keytool -genkeypair -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Puis copier `android/key.properties.example` → `android/key.properties` et renseigner les mots de passe.

**Sauvegarder** le `.jks` + mots de passe hors git : sans eux, impossible de mettre à jour le même appId sur Play.

## Build

```bash
flutter test
flutter build apk --release
# ou
flutter build appbundle --release
```

APK : `build/app/outputs/flutter-apk/app-release.apk`

## Smoke (après install)

1. Profil → À propos : **Céaki v0.7.0** + bibliothèque **2026.10.5**
2. Scan GTIN `978-2-246-80723-0` → fortune + CTA repos
3. Scan `3558380078180` → Asmodee entreprise (vert archive)
4. Bibliothèque : filtres Fortune / Entreprise / Inconnu
5. Fiche marque → société → fortune (chrome unifié)

## Hors scope 0.x

Compte facultatif CDC — documenté dans À propos, pas implémenté.
