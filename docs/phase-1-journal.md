# Phase 1 — Journal de scans

Remplir pendant / après la recette appareil. Une ligne par code.

Probe machine du 2026-10-06 (`python tools/phase1_probe.py`) — à confirmer sur téléphone.

| # | GTIN | Lieu | Produit (attendu) | Issue app | Marque vue | Entreprise | Fortune | OK ? | Alias / note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 9782246807230 | probe / saisie | Grasset | fortune | Bernard Grasset (Paris) | Lagardère SA | Bolloré | OK probe | |
| 2 | 9782259195409 | probe / saisie | Plon | fortune (Phase 2) | Plon (Paris) | Editis | Křetínský | OK | Vivendi historique ; IMI/CMI actifs |
| 3 | 3558380078180 | seed Phase 2 | Dobble | clear | Asmodee | Asmodee Group | — | OK seed | KnownProductsCatalog |
| 4 | 3017620429484 | probe | Nutella | clear | Nutella (+ Ferrero) | Ferrero | — | OK probe* | *alias Ferrero ajouté après 1er probe |
| 5 | 5449000000996 | probe | Coca-Cola | clear* | COCA-COLA SERVICES… | The Coca-Cola Company | — | OK probe* | *alias OFF ajouté |
| 6 | 3068320111005 | probe | Evian ? | product_unknown | — | — | — | KO | GTIN à vérifier en magasin |
| 7 | 3600523193046 | probe | Garnier ? | product_unknown | — | — | — | KO | GTIN à vérifier |
| 8 | 4005900125963 | probe | Nivea ? | product_unknown | — | — | — | KO | GTIN à vérifier |
| 9 | | magasin | | | | | | | |
| 10 | | magasin | | | | | | | |
| 11 | | magasin | | | | | | | |
| 12 | | magasin | | | | | | | |
| 13 | | magasin | | | | | | | |
| 14 | | magasin | | | | | | | |
| 15 | | magasin | | | | | | | |

## Légende Issue app

- `fortune` — bandeau rouge / archive coral  
- `clear` — entreprise connue, pas de fortune  
- `unknown` — marque API non dans le noyau  
- `product_unknown` — BnF/OFF n’ont pas le produit  
- `offline` — hors ligne sans cache  

## Ratés à traiter en Phase 2

| GTIN | Marque API brute | Action proposée |
| --- | --- | --- |
| 3558380078180 | (vide OFF) | jeux : autre source ou table locale GTIN→marque |
| 3068320111005 | — | trouver un vrai EAN Evian en rayon |
| 3600523193046 | — | vrai EAN Garnier |
| 4005900125963 | — | vrai EAN Nivea |
| *(magasin)* | | |

## Checklist UI (cocher sur téléphone)

- [ ] Permission caméra (autoriser)
- [ ] Permission caméra (refus → réglages)
- [ ] Scan caméra EAN-13 livre
- [ ] Scan caméra hors-livre
- [ ] Saisie manuelle ISBN-10 ou tirets
- [ ] Pull-to-refresh résultat
- [ ] Archive : labels + nom entreprise
- [ ] Je le repose → Profil carnet + palier
- [ ] Je l’achète quand même
- [ ] Vider historique / cache

## Versions testées

- App : 0.6.0+7 (à confirmer À propos)
- Bibliothèque JSON : 2026.10.4
- Appareil / Android :  
- Date :  

## Comment relancer le probe

```bash
python tools/phase1_probe.py
python tools/phase1_probe.py 3017620429484 VOTRE_GTIN
```
