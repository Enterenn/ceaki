# Céaki

Rendre visible l’entreprise derrière un produit, et son rattachement éventuel à une grande fortune — pour pouvoir s’abstenir.

## Produit (v0.7)

Trois onglets :

1. **Scan** — identité + CTA « On checke », puis caméra / saisie manuelle.
2. **Bibliothèque** — **archive personnelle** des marques déjà croisées en scan (entreprise + label fortune).
3. **Profil** — carnet « Ils n’auront pas », paliers soft 1/10/50, historique, données locales, à propos.

### Identification

- **Livres** (ISBN 978 / 979) : BnF → Open Library → Google Books
- **Hors livre** : Open Food Facts (`product_type=all`)
- Cache produit local 30 jours ; pull-to-refresh sur le résultat ; fallback cache périmé si hors ligne
- Homonymes de marque mémorisés par GTIN
- Paliers soft sur les reposés : 1 / 10 / 50
- **Pas de compte** en 0.x (reporté hors pré-v1) — données locales uniquement

### Archive (labels)

| Couleur | Condition | Libellé |
| --- | --- | --- |
| Rouge | Au moins une fortune sur la chaîne | Rattaché à une grande fortune |
| Vert | Marque résolue → entreprise connue, aucune fortune | Entreprise connue — aucune grande fortune |
| Neutre | Marque absente du noyau | Marque non rattachée |

Le rouge reste vrai même si l’alerte fortune est retirée pour le bandeau au scan : l’exclusion d’alerte n’affecte que le scan, pas l’archive.

### Logos

Chaque marque peut avoir `logoAsset` (fichier local) et/ou `logoUrl` (https, cache disque local, sans tracking).  
Le noyau embarque des **monogrammes géométriques** (`assets/logos/`) — pas des reproductions de marques déposées. Voir `assets/logos/README.md`.

Le JSON embarqué (`assets/library/library.json`) reste le **moteur de résolution**. Les fiches fortune / société restent accessibles **depuis la fiche marque**, plus comme contenu principal de l’onglet.

## Technique

- Flutter, Riverpod, Drift (local), `mobile_scanner`
- Couches : `ui` → `application` → `domain` ← `data`
- Identification livres : BnF → Open Library → Google Books
- Hors-livre : graines locales (`known_products`) → Open Food Facts
- Phase 1 : [`docs/recette-android.md`](docs/recette-android.md) · [`docs/phase-1-journal.md`](docs/phase-1-journal.md)
- Phase 2 : [`docs/phase-2.md`](docs/phase-2.md)
- Phase 3 : [`docs/phase-3.md`](docs/phase-3.md)
- Phase 4 : [`docs/phase-4.md`](docs/phase-4.md)
- Phase 5 : [`docs/phase-5.md`](docs/phase-5.md)
- Probe : `python tools/phase1_probe.py`

```bash
flutter pub get
flutter test
flutter run
```

Version app : voir `pubspec.yaml` et `publishedAppVersion` dans `lib/application/app_version.dart`.
