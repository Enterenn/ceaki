# Phase 2 — Couverture utile

**Statut :** faite côté code (noyau `2026.10.4`). Confirmer en magasin.

## Livré

1. **Jeux / EAN stables** — `KnownProductsCatalog` avant OFF  
   Dobble, Evian, Nutella (alt), Nivea, Garnier, Dove  
2. **Editis** — chaîne active IMI → CMI → fortune Daniel Křetínský  
   Vivendi reste `historical` (plus d’alerte Bolloré)  
3. **DV Bolloré → LHG** — `votingPercent` vidé (aligné CDC)  
4. **Marques Editis** — Nathan, Robert Laffont, Bordas, Julliard, Presses de la Cité  
5. **Monogrammes** — logos manquants générés sous `assets/logos/`

## À valider téléphone

| GTIN | Attendu |
| --- | --- |
| `9782259195409` | Plon → bandeau **Křetínský** (plus « propriétaire non documenté ») |
| `3558380078180` | Dobble → Asmodee, vert archive |
| `3068320115257` | Evian → Danone |
| `3600541226481` | Garnier → L'Oréal |
| `4005808819203` | Nivea → Beiersdorf |

Si un EAN seed est faux en rayon : corriger dans `known_products_catalog.dart` et noter le vrai code dans le journal Phase 1.

## Suite → Phase 3

Fortunes supplémentaires (Bettencourt / Arnault…) uniquement avec sources aussi solides qu’Editis/IMI.
