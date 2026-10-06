# Phase 1 — Recette appareil Android

Checklist manuelle avant d’ouvrir la Phase 2 (couverture noyau).  
Appareil réel recommandé. Journal : [`phase-1-journal.md`](phase-1-journal.md).

## Objectif

Savoir, en conditions réelles :

1. ce qui s’identifie (BnF / OFF) ;
2. ce qui se rattache au noyau (fortune / entreprise / inconnu) ;
3. si Scan → Archive → Repos → Profil tient la route.

**Done Phase 1 :** checklist UI cochée + ≥ 15 lignes dans le journal + liste des ratés pour la Phase 2.

## 0. Préparation machine

```bash
flutter pub get
flutter test
python tools/phase1_probe.py
```

Le probe interroge les catalogues (réseau) et croise le noyau embarqué.  
Il ne remplace pas la caméra : il valide la batterie de codes connus.

Installer ensuite :

```bash
flutter run
```

Vérifier **Profil → À propos** : version app + version bibliothèque (`2026.10.3` ou plus).

## 1. Permission caméra

1. Onglet **Scan** → **On checke**
2. Autoriser → viseur prêt
3. (Optionnel) Refuser / révoquer → message + **Ouvrir les réglages** fonctionne
4. Saisie manuelle toujours accessible (**Code illisible ?**)

## 2. Batterie de codes (saisie ou scan)

Remplir le [journal](phase-1-journal.md). Minimum :

| GTIN | Attendu métier |
| --- | --- |
| `978-2-246-80723-0` | Livre Grasset → **fortune** Bolloré, CTA repos |
| `978-2-259-19540-9` | Plon → **entreprise** Editis, pas de bandeau fortune |
| `3558380078180` | Dobble / Asmodee → **entreprise** (vert archive) |
| `3017620429484` | Nutella → Ferrero si OFF OK |
| + 10 codes magasin | mélange livre / alimentaire / hygiène |

Pour chaque code, noter :

- titre / marque renvoyés ;
- tone : fortune / clear / unknown / product_unknown ;
- bug UI éventuel.

Sur un résultat fortune :

1. Pull-to-refresh sans crash
2. **Je le repose** → texte « n’aura pas celui-ci »
3. **Profil** : compteur + ligne carnet « Ils n’auront pas »
4. Rescanner le même code : pas de double recherche tant que le résultat est ouvert (revenir d’abord)

Sur un résultat sans fortune mais avec entreprise : pas de CTA repos (comportement voulu).

## 3. Archive

Après ≥ 3 scans distincts :

1. Onglet **Bibliothèque**
2. Marques présentes, **nom d’entreprise** sous la marque si connue
3. Labels lisibles (légende + pastille)
4. Tap fiche → chaîne / historique / sources ouvrables

## 4. Profil & données

1. Carnet non vide après un repos
2. **Scans** : recherche + statuts Reposé / Acheté
3. **Données locales** : vider le cache produit
4. Vider l’historique → carnet et scans à zéro
5. Rescanner un GTIN connu → réseau ou cache selon cas

## 5. Compte

Pas de compte en 0.x — hors Phase 1.

## 6. Clôture Phase 1

- [ ] `flutter test` encore vert
- [ ] Journal ≥ 15 lignes
- [ ] Checklist UI cochée
- [ ] Tableau « Ratés à traiter en Phase 2 » rempli (même s’il est court)

Ensuite seulement : Phase 2 (aliases, marques, monogrammes, Editis, DV Bolloré).
