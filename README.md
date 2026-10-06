# Céaki?

Rendre visible le rattachement d’un produit à une grande fortune — pour pouvoir s’abstenir.

## Produit (v0.2)

Trois onglets :

1. **Scan** — identité + CTA « On checke », puis caméra / saisie manuelle.
2. **Bibliothèque** — **archive personnelle** des marques déjà croisées en scan (pas le référentiel capitalistique).
3. **Vous** — carnet des « reposés », rang soft, à propos.

### Archive (labels)

| Couleur | Condition | Libellé |
| --- | --- | --- |
| Rouge | Au moins une fortune sur la chaîne | Rattaché à une grande fortune |
| Vert | Marque résolue, aucune fortune documentée | Aucune grande fortune documentée |
| Neutre | Marque inconnue / propriétaire non documenté | Rattachement non documenté |

Le rouge reste vrai même si l’alerte fortune est retirée pour le bandeau au scan : l’exclusion d’alerte n’affecte que le scan, pas l’archive.

Le JSON embarqué (`assets/library/library.json`) reste le **moteur de résolution**. Les fiches fortune / société restent accessibles **depuis la fiche marque**, plus comme contenu principal de l’onglet.

## Technique

- Flutter, Riverpod, Drift (local), `mobile_scanner`
- Couches : `ui` → `application` → `domain` ← `data`
- Identification livres : BnF (+ fixtures offline) ; hors-livre : fixtures pour l’instant

```bash
flutter pub get
flutter test
flutter run
```

Version app : voir `pubspec.yaml`.
