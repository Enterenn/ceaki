# Recette appareil Android

Checklist manuelle avant une release 0.x. Appareil réel recommandé.

## Préparation

1. `flutter pub get`
2. `flutter test`
3. Installer le build debug : `flutter run` (ou APK debug)
4. Vérifier que **Profil → À propos** affiche la version courante (`pubspec.yaml` / `publishedAppVersion`)

## Permission caméra

1. Onglet **Scan** → **On checke**
2. Première fois : écran d’explication → autoriser
3. Refus : message + ouverture des réglages fonctionne
4. Autorisation : viseur prêt

## Scan

1. Scanner un ISBN magasin (ou saisir manuellement `978-2-246-80723-0`)
2. Résultat : bandeau fortune si applicable, produit, marque, CTA
3. Pull-to-refresh sur le résultat : rechargement sans planter
4. Scanner un hors-livre connu OFF (ex. alimentaire) : marque/titre renseignés ou état inconnu clair

## Archive

1. Après 1–2 scans, onglet **Bibliothèque**
2. Marques présentes, labels rouge / vert / neutre lisibles
3. Tap fiche marque → chaîne + sources ouvrables

## Repos

1. Sur un résultat avec fortune : **Je le repose**
2. Moment « Reposé… » affiché
3. **Profil** : palier / compteur de reposés mis à jour
4. **Profil → Scans** : ligne avec statut Reposé

## Données locales

1. **Profil → Données locales** : vider le cache produit
2. Vider l’historique : scans et compteur reposés remis à zéro
3. Rescanner un GTIN déjà vu : identification réseau ou cache selon cas

## Compte

Pas de compte en 0.x — reporté hors pré-v1 (voir README / À propos).
