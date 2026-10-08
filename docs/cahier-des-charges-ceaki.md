# Cahier des charges — céaki (« C'est à qui ? »)

> Version 1.3 — **périmètre resserré** à partir de l'app v0.8.0 (ajout : règle « **société cotée = rouge** » qui remplace la liste de groupes, critères objectifs pour les alternatives ; reste : vocabulaire du contrôle, ligne éditoriale « alerte sans WikiLeaks »).
> Priorités : **P0** = indispensable · **P1** = important · **P2** = souhaitable · **À valider** = dépend d'une décision.
> Principe de rédaction : moins c'est mieux. Ce document liste aussi, en §9, tout ce qui est **explicitement exclu**, pour guider l'agent de code.

---

## 1. But

**céaki** est une app de **prévention** : au moment où l'on tient un produit ou que l'on pense à une enseigne, elle montre en quelques secondes **à qui appartient quoi**, avec ses sources. Rien de plus.

- Ce n'est **pas** un mouvement, un défi de non-achat ni une quête : l'utilisateur vient de lui-même, obtient son information, repart.
- Ce n'est **pas** un outil de peur : on répond à une question posée, on ne fait pas voir des fortunes derrière chaque enseigne.
- Posture : celle d'une **app lanceuse d'alerte**, pas d'un WikiLeaks. On rend visible ce qui est public mais dispersé (structures de propriété et de contrôle), sans fuites, sans accusations, sans opinions.
- Public : Gen Z et millénials, plutôt de gauche ou simplement curieux et ouverts d'esprit, attentifs aux dark patterns. Cela oriente le **ton et les sujets** mis en avant, pas le **niveau de preuve**, qui reste le même pour tous.

---

## 2. Principes directeurs

1. **Prévention, pas mouvement.** Informer, ne pas pousser à l'action.
2. **Zéro dark pattern.** Pas de série, de quête, de relance, de notification, de perte, de rareté ni de culpabilisation. Les récompenses (§4.4) valorisent la curiosité et ne forcent jamais le retour.
3. **L'app n'agit jamais d'elle-même.** L'utilisateur scanne ou cherche. Aucune alerte de lieu.
4. **Aucune géolocalisation.** Pas de permission de localisation, pas de carte.
5. **Sources fiables uniquement.** Aucune contribution d'utilisateur, aucune modération, aucune administration. Chaque lien de propriété cite une source publique et une date.
6. **Tout sur le téléphone.** Pas de compte, pas de serveur de stockage, aucune donnée personnelle collectée.
7. **Flutter / Dart uniquement.** Pas d'extension, de widget, de bot ni d'API.
8. **Deux flux d'argent : le produit et le lieu.** Un livre d'un éditeur indépendant acheté dans une grande enseigne enrichit quand même cette enseigne, et inversement.
9. **Direction artistique conservée** : zine × bento, lime en primaire, ombres décalées. Pas de thèmes.
10. **Formulations nuancées.** « Une partie de ce que tu paies remonte jusqu'à… », jamais d'accusation absolue.
11. **Pas de paranoïa.** Ton factuel et curieux. Chaque verdict rouge est accompagné d'une issue.
12. **Ligne éditoriale : alerte, pas WikiLeaks.** Faits d'intérêt public, vérifiables, sourcés et datés, issus de documents publics. Ni fuites, ni vie privée, ni opinions, ni étiquette politique ou morale sur des personnes. Mêmes règles pour tous les acteurs, quel que soit leur bord (§8).

---

## 3. Existant (v0.8.0)

| Page | Rôle | Contenu |
|---|---|---|
| **Scan** (home) | Point d'entrée | Logo, gros titre, sous-titre, gros bouton « On checke » |
| **Terrain** | Regroupe les groupes **déjà scannés** | Recherche parmi eux ; les entités détenues par des fortunes sont en rouge |
| **Carnet** | Profil | Esquives, historique des scans, suppression des données locales, à propos |

**Écran résultat** : carte rouge « GRANDE FORTUNE » avec « Pourquoi ? » dépliable, carte produit, boutons « Je le repose » / « Je l'achète quand même ».
**Fiche entité** : arbre « Comment ça remonte » (pourcentage, nature du lien, date), section « Fortunes ».

> **Chantier ultérieur** : revoir plusieurs wordings de l'app, notamment le rôle affiché de l'onglet Terrain (il n'est pas une bibliothèque de groupes) et les termes « Chez une fortune » / « GRANDE FORTUNE », à remplacer par un vocabulaire fondé sur le **contrôle** (voir §5).

---

## 4. Fonctionnalités retenues

### 4.1 Identifier qui possède quoi

| # | Fonctionnalité | Détail | Prio |
|---|---|---|---|
| F1 | **Scan de code-barres** | Existant : ISBN / EAN. Rapide et fiable | P0 |
| F2 | **Recherche texte** | Champ de recherche sur l'écran Scan pour une **marque, une enseigne, un groupe ou un média**. Remplace le scan de logo / de vitrine et le partage de lien | P0 |
| F3 | **Verdict à trois niveaux** | 1. verdict immédiat (*Sous contrôle de…* / *Cotée en bourse* / *Participation de…* / *Aucun acteur de référence* / *Indépendant* / *Pas encore référencé*). 2. « Pourquoi ? » avec l'arbre. 3. Sources et dates de vérification | P0 |
| F4 | **« Pourquoi ? » sourcé** | Pour chaque lien : pourcentage, nature (contrôle, majoritaire, minoritaire, franchise), **source cliquable, date de vérification** | P0 |
| F5 | **Double détection produit + lieu** | Option **facultative** au scan : l'utilisateur choisit lui-même l'enseigne où il compte acheter. Le verdict s'affiche en deux lignes (produit / lieu) puis le cumul. Aucune détection automatique | P0 |
| F6 | **Fiches enseignes** | Une enseigne est une entité comme une marque : chaîne de propriété jusqu'à la fortune (ex. Relay → Lagardère → Bolloré). Accessible par la recherche texte et via F5 | P0 |
| F7 | **Cas « pas encore référencé »** | Message sobre, sans appel à contribuer. Le périmètre est assumé : seules les entités dotées de sources fiables sont affichées | P0 |
| F8 | **Aide contextuelle** | Info-bulles sur les termes (« contrôle », « actionnaire de référence », « holding ») dans « Pourquoi ? » | P2 |
| F18 | **Points d'attention sourcés** | Sur la fiche d'un acteur, quelques faits **objectifs et sourcés** (voir §8) : contrôle de médias, décisions de justice définitives ou sanctions d'autorités, financements politiques déclarés dans des registres publics, investissements dans des secteurs sensibles selon des documents publics. Aucun adjectif, aucune étiquette | À valider |

### 4.2 Alternatives (la sortie)

| # | Fonctionnalité | Détail | Prio |
|---|---|---|---|
| F9 | **« Je le prends ailleurs »** | Troisième action sur l'écran résultat. Ouvre des alternatives, sans points ni compteur. Le détail dépend de la refonte de l'esquive (§6) | P1 |
| F10 | **Alternatives par catégorie** | Contenu **éditorial embarqué** (écrit par toi, sourcé) : pour une catégorie, des types de lieux (librairie indépendante, médiathèque, occasion, achat direct à l'éditeur) et des éditeurs / marques indépendants connus. Alternative = même catégorie, **non rouge** et d'un type documenté (voir §5) | P1 |
| F11 | **Liens vers annuaires externes** | « Où trouver ? » ouvre un annuaire externe (label LIR, portails de bibliothèques…) dans le navigateur, via `url_launcher`. L'app ne traite aucune position | P1 |

Nuance à afficher dans F9/F10 : « même produit, autre lieu » ne détourne que la marge du lieu de vente, pas la part de l'éditeur ; un emprunt, une occasion ou un produit d'un éditeur indépendant détourne davantage.

### 4.3 Carnet et Terrain

| # | Fonctionnalité | Détail | Prio |
|---|---|---|---|
| F12 | **Historique des scans** | Existant, local | P0 |
| F13 | **Terrain = groupes déjà scannés** | Existant : regroupement et recherche, entités rouges. Ajustement des wordings plus tard | P0 |
| F14 | **Suppression des données locales** | Existant | P0 |
| F15 | **À propos complet** | Méthode, **liste des sources**, date de dernière mise à jour des données, mentions légales, **adresse e-mail de contact pour corrections et droit de réponse** | P0 |
| F16 | **Esquives** | Existant, **à repenser** (voir §6). Pas de second compteur | À valider |
| F17 | **Partage d'une fiche** | Bouton de partage du système (texte ou image d'une fiche), sans compte ni serveur | À valider |

### 4.4 Récompenses légères (gamification simple, sans dark pattern)

**Objectif** : offrir un petit plaisir de curiosité, le « ah ! » de comprendre, sans jamais forcer le retour ni lier la récompense à un achat ou à un non-achat.

**Charte (à respecter par tout ajout)**
- On récompense la **curiosité et la compréhension** (découvrir, lire les sources), jamais l'abstinence ni l'assiduité.
- Tout est **vérifiable par l'app elle-même** (scans effectués, fiches et sources ouvertes), contrairement aux achats.
- La progression **ne baisse jamais** : ni perte, ni série, ni expiration, ni compte à rebours.
- **Aucune relance** : pas de notification, pas de rappel, pas de message « tu nous as manqué ».
- Pas de récompense aléatoire, pas de rareté, pas de comparaison avec d'autres personnes, pas de jauge à remplir du type « 12 / 100 » (elle crée un manque à combler).
- **Discret** : la récompense apparaît à l'instant de l'action, sans bloquer le parcours. Une option « masquer les récompenses » est disponible dans le Carnet.

| # | Fonctionnalité | Détail | Prio |
|---|---|---|---|
| R1 | **Micro-retour à la révélation** | Léger retour haptique et petite transition quand le verdict s'affiche ou que l'arbre se déplie : récompense immédiate, sans texte | P1 |
| R2 | **Badges de découverte** | Attribués à l'instant, jamais perdus, avec un toast discret. Exemples : « Premier scan », « Première remontée » (un premier lien jusqu'à une fortune), « Double lecture » (produit + lieu), « Sources en main » (ouvrir une source), « Pas que des livres » (trois catégories différentes). Affichés dans une section « Découvertes » du Carnet | P2 |
| R3 | **Compteur de découvertes** | Un nombre qui ne fait que croître (« N groupes découverts »), sans objectif ni total à atteindre | P2 |
| R4 | **« Dans le même groupe »** | Dans la fiche d'un groupe, la liste des autres marques, enseignes et médias qu'il détient, tirée du graphe : l'effet de surprise est la récompense, sans contenu éditorial en plus | P2 |
| R5 | **Niveau cumulatif** | Un simple niveau qui monte avec les découvertes et ne baisse jamais | À valider |

### 4.5 Mascotte (version minimale)

| # | Fonctionnalité | Détail | Prio |
|---|---|---|---|
| M1 | **Widget `MascotView(state)`** | Illustration **statique**, pas de texte, pas d'animation de recherche, pas de rôle de guide. États limités à : `neutral`, `surprised` (fortune), `happy` (indépendant), `confused` (pas référencé) | P2 |
| M2 | **Emplacements** | Écran résultat, états vides, page À propos. Rien d'autre (pas d'onboarding, pas de chargement, pas de répliques) | P2 |

Principe : ce n'est pas un assistant (« pas de Clippy »). Un simple visage qui donne du caractère à l'interface. Le scan étant quasi instantané, la mascotte ne « cherche » rien.

---

## 5. Couverture des données (contenu, pas fonctionnalités)

L'étendue des usages vient de **ce que la base connaît**, accessible par scan ou par recherche texte. Ordre de priorité :

| Domaine | Contenu | Prio |
|---|---|---|
| Livres, jeux de société, grande consommation | Existant (code-barres) | P0 |
| **Enseignes** | Grande distribution, librairies et papeteries (Relay, Fnac, Cultura…), tech, mode | P0 |
| **Médias** | Presse, TV, radio, édition, plateformes d'information | P1 |
| **Services et abonnements** | Streaming vidéo / musique, réseaux sociaux, plateformes de jeux | P1 |
| Jeux vidéo, musique, cinéma | Studios, éditeurs, labels, salles | P2 |

### Acteurs de référence : qui peut apparaître derrière une marque

Le verdict ne raisonne plus seulement en « fortunes » (personnes, familles) : il remonte jusqu'à des **acteurs de référence** de trois types, indiqués par une pastille.

| Type | Contenu | Liste de référence (aucun seuil de montant : on prend les N premiers) |
|---|---|---|
| **Fortune** | Personne ou famille (une famille = une entrée, comme « famille Bolloré ») | Top 50 → 100 des fortunes de France ; top 50 → 100 mondial uniquement pour les produits et services d'envergure mondiale. Classement public, cité et daté |
| **Société cotée** | Entreprise dont les actions sont admises à la négociation sur un marché boursier, ou entité **contrôlée** par une telle société (ex. une plateforme de streaming ou un géant de la tech) | Aucun classement : critère **objectif et vérifiable** (admission à la cote d'une place boursière), cité et daté |
| **Fonds** | Gestionnaires d'actifs, fonds d'investissement, fonds souverains | Pas de liste de verdict : affichés comme actionnaires dans « Pourquoi ? », sans déclencher le verdict principal |

Chaque **fortune** porte : portée (France / Monde), rang, année du classement, source ; les classements sont **figés à une date** et mis à jour une fois par an, la date étant affichée dans « Pourquoi ? ». Une même personne présente dans deux classements n'apparaît qu'une fois. Chaque **société cotée** porte : place boursière, identifiant (ISIN), date de vérification, source.

### Contrôle et capital : deux questions distinctes

Dire qu'une marque « appartient » à quelqu'un est souvent inexact : le capital peut être dispersé, ou le contrôle passer par des **droits de vote** supérieurs à la part du capital (actions à vote multiple). « Pourquoi ? » répond donc à deux questions :
- **Qui contrôle ?** majorité du capital ou des droits de vote, ou contrôle de fait.
- **Qui détient le capital ?** principaux actionnaires, en pourcentage, y compris les participations minoritaires significatives et les fonds.

Exemple de structure (illustratif, les chiffres réels se lisent dans les documents réglementaires de la société) : des fondateurs contrôlent par leurs droits de vote plus que ne le laisse penser leur part du capital, tandis qu'un grand groupe étranger et plusieurs fonds détiennent des participations minoritaires.

### Vocabulaire des verdicts

| Situation | Affichage proposé |
|---|---|
| Une **fortune de référence contrôle** l'entité | Carte rouge, pastille FORTUNE, titre = nom, mention « **Sous contrôle de** [X] », puis « Une partie de ce que tu paies remonte jusqu'à… » |
| L'entité est **cotée en bourse**, ou **contrôlée par une société cotée** | Carte rouge, pastille COTÉE, mention « **Cotée en bourse** » (ou « **Contrôlée par** [X], cotée en bourse »), puis « Une partie de ce que tu paies remonte vers ses actionnaires » |
| Une fortune de référence ou une société cotée détient une **participation minoritaire significative** (sans contrôle) | « **Participation de** [X] », traitement visuel plus léger que le rouge, détail dans « Pourquoi ? » |
| Ni fortune de référence ni cotation dans la **chaîne de contrôle** | « **Aucun acteur de référence** » avec la date de vérification ; ne vaut pas « Indépendant » |
| Entité non rouge dont l'**indépendance est documentée** (critères ci-dessous) | « **Indépendant** » (par exemple un éditeur ou une librairie indépendants) |
| Entité absente de la base | « **Pas encore référencé** » |

### Règle « société cotée = rouge »

**Principe** : une entreprise cotée en bourse a son capital ouvert à des actionnaires multiples (fonds, holdings, fondateurs) et doit répondre aux marchés. Pour pouvoir proposer de vraies alternatives (indépendantes, coopératives, open source), **toute entité cotée, ou contrôlée par une société cotée, est en rouge**, sans seuil de montant ni liste de groupes à tenir à jour.

**Intérêts** : critère objectif, vérifiable et daté ; règle simple à expliquer ; couvre les cas où le capital est dispersé (streaming, grande distribution, tech) ; supprime la liste « Groupe » à maintenir.

**Garde-fous**
- **Le rouge dit sa raison** : la pastille COTÉE précise que le capital est en bourse. Ce n'est ni une faute ni une accusation, et le mot « fortune » n'est pas utilisé.
- **Contrôle, pas simple participation** : une entité n'est rouge par cotation que si elle est cotée elle-même ou **contrôlée** par une société cotée. Une participation minoritaire donne « Participation de… », pas le rouge.
- **Cas limites à trancher** : très petites sociétés cotées, sociétés d'État cotées en partie, coopératives et mutuelles ayant des filiales cotées, double cotation, sociétés récemment sorties de la cote, filiale cotée d'un groupe non coté. Règle par défaut : la **chaîne de contrôle** décide, avec la date de vérification affichée.
- **Risque de saturation** : si presque tout est rouge, le rouge perd son sens et nourrit la paranoïa. Parades : la pastille donne la raison (FORTUNE / COTÉE), une issue est toujours proposée (F9 à F11), le ton reste factuel (principe 11).
- **Couverture des alternatives** : chaque catégorie en rouge doit avoir au moins une alternative non rouge dans le contenu embarqué (F10) ; sinon, l'écran indique « pas encore d'alternative référencée ».

### Critères des alternatives (objectifs, sans jugement de valeur)

« Respectable » est un jugement de valeur : l'app s'appuie sur des critères vérifiables. Une alternative est proposée si l'entité **n'est pas rouge** (ni cotée, ni contrôlée par une société cotée ou une fortune de référence) **et** relève d'un type documenté :
- **Indépendante** : non cotée, capital non contrôlé par un acteur de référence.
- **Coopérative ou économie sociale** : statut documenté (SCOP, SCIC, association, fondation).
- **Open source** : licence libre **et** gouvernance non contrôlée par une société cotée (une licence libre ne suffit pas : un projet libre peut être piloté par un grand groupe).
- **Public ou communautaire** : bibliothèque, médiathèque, ludothèque.
- **Emprunt ou occasion** (voir F9).

Le type est affiché avec sa source. Une alternative est vérifiée avec les mêmes règles que les autres entités (propriétaire, investisseurs, date) avant d'être étiquetée.

Les contrôleurs sont **toujours affichés** dans « Pourquoi ? », qu'ils figurent ou non dans les listes de référence. Les formules « appartient à » et « chez une fortune » sont à éviter dans toute l'interface.
---

## 6. Esquives : chantier à part

La mécanique actuelle (compter les produits « reposés ») pose problème :
- rien ne garantit que l'utilisateur ait vraiment reposé ou renoncé : un compteur ne mesure que des déclarations ;
- tout compteur invite à « faire monter le chiffre », c'est-à-dire à une quête de non-achat, ce qu'on ne veut pas ;
- il ne doit y avoir **aucun** second compteur (pas de « redirections » comptées) ; les récompenses légères du §4.4 ne portent jamais sur un achat ni sur un non-achat.

Pistes à trancher dans ce chantier :
1. **Mémo neutre** : le Carnet liste simplement les produits consultés et le choix noté (reposé / acheté / pris ailleurs), sans total ni score.
2. **Historique seul** : suppression de la notion d'esquive ; l'historique des scans suffit.
3. **Statu quo allégé** : conserver l'affichage actuel sans rien y ajouter.

Tant que ce choix n'est pas fait, **ne rien ajouter** autour des esquives.

---

## 7. Données, architecture et sources

### 7.1 Contraintes

- **Flutter / Dart uniquement.** Aucun serveur de stockage ; tout est conservé sur le téléphone (base locale, par exemple SQLite). Aucun compte, aucun tracking, aucune statistique d'usage.
- Seule permission nécessaire : la **caméra** pour le scan.

### 7.2 Modèle de données (proposition)

- `Entity` : id, nom, alias, type (`marque`, `enseigne`, `groupe`, `holding`, `média`, `service`, `fortune`), catégories, monogramme.
- `Cotation` (si applicable) : place boursière, identifiant (ISIN), date de vérification, source.
- `Product` : code-barres, nom, marque.
- `Ownership` : source, cible, nature (`contrôle`, `majoritaire`, `minoritaire`, `franchise`…), pourcentage de capital, **pourcentage de droits de vote**, **source(s)**, **date de vérification**, niveau de confiance.
- `Acteur de référence` : type (`fortune`, `groupe`, `fonds`), nom (personne, famille ou groupe), portée (France / Monde), rang, année du classement, source.
- `Alternative` : contenu éditorial par catégorie (F10).
- Distinguer détention directe, contrôle et influence ; gérer un **graphe** (participations croisées), pas un arbre ; conserver la date de chaque lien.

### 7.3 Sources

| Besoin | Sources possibles |
|---|---|
| Relations de propriété | Documents publiés par les sociétés (rapports annuels, documents d'enregistrement), déclarations de franchissement de seuils, formulaires réglementaires des sociétés cotées (capital et droits de vote), Wikidata, Sirene / data.gouv |
| Fortunes | Classements publiés (France et monde), choisis une fois, cités et datés comme estimations (par exemple les classements annuels de la presse économique) |
| Cotation | Sites des places boursières (Euronext, NYSE, Nasdaq…), documents réglementaires des sociétés |
| Produits | Open Food Facts, Open Library, BnF |
| Enseignes | Wikidata, OpenStreetMap (tags `brand`, `brand:wikidata`) pour identifier les enseignes, sans usage de la position |

Vigilance :
- Certaines APIs de registres sont payantes ; l'API Sirene est gratuite.
- L'accès public aux registres de bénéficiaires effectifs est restreint en Europe depuis 2022.
- Vérifier les CGU avant tout scraping ; privilégier des APIs et des jeux de données ouverts.
- Licences : ODbL (OpenStreetMap, Open Food Facts) avec attribution, CC0 (Wikidata).

### 7.4 Mise à jour et usage sans réseau

Le graphe de 50 à 100 fortunes est **petit** : il peut être **embarqué dans l'app** (mis à jour à chaque version). Dans ce cas, les verdicts fonctionnent sans réseau, ce qui est utile en magasin quand le signal est faible, sans développement spécifique. Seule la recherche d'un produit inconnu à partir de son code-barres nécessite le réseau, sauf si le résultat est déjà dans le cache local (historique). **Il n'y a pas de « mode hors ligne » à construire** : c'est une conséquence de l'architecture. Choix à faire en §10.

---

## 8. Juridique, éthique et vie privée

### Ligne éditoriale : alerte, pas WikiLeaks

Une app lanceuse d'alerte rend **visible** ce qui est public mais éparpillé. Elle ne devient pas un outil de fuite ni de procès d'intention.

| On publie | On ne publie pas |
|---|---|
| Structures de propriété et de **contrôle** | Documents fuités ou obtenus de façon non publique |
| Faits documentés d'intérêt public, issus de sources publiques : rapports annuels, registres, décisions de justice **définitives**, sanctions d'autorités de régulation, presse de référence | Vie privée, adresses, famille, santé |
| Faits datés, avec le lien vers la source | Opinions, rumeurs, insinuations, accusations non tranchées par une décision |
| Les mêmes règles pour tous les acteurs | **Étiquettes politiques ou morales sur des personnes** (« extrême droite », « raciste »…), même si elles circulent ailleurs |

- Le public visé étant plutôt de gauche ou curieux, l'app peut assumer un ton engagé et choisir ses sujets (concentration des médias, des loisirs, de la richesse). **Le standard de preuve ne change pas** : sa crédibilité et sa sécurité juridique en dépendent.
- Un fait sensible n'apparaît que s'il est sourcé, daté et formulé sans adjectif (« a investi dans… », « a été condamné par… (décision du…) »).
- Droit de réponse et de correction par l'adresse de contact (F15).

### Cadre juridique, éthique et vie privée

- **Faits sourcés et datés**, vocabulaire précis (contrôle / majoritaire / minoritaire / franchise). Mention : « Données indicatives issues de sources publiques, susceptibles d'évoluer ».
- **Verdict nuancé** : « Une partie de ce que tu paies remonte jusqu'à… ». Les fortunes sont des estimations sourcées et datées.
- **Mentions légales et contact** dans À propos (F15), qui servent aussi de **droit de réponse et de correction** : une adresse e-mail suffit, sans outil de modération.
- **Marques** : monogrammes génériques, pas de logos déposés.
- **Vie privée** : aucune donnée personnelle collectée, aucune géolocalisation, suppression des données locales possible. Il reste à vérifier la classification d'âge sur les stores.
- **Éthique** : on cible le système, jamais des personnes ; pas de culpabilisation ; pas de vocabulaire d'encerclement ; neutralité de méthode (mêmes règles pour tous les groupes).

---

## 9. Hors périmètre (décisions prises)

| Exclu | Raison |
|---|---|
| Scan de logo ou de vitrine | Trop complexe ; la recherche texte suffit |
| Partage d'un lien vers l'app | Un lien (ex. Amazon) ne contient pas de code-barres : le relier à un produit demande du scraping ou des APIs payantes |
| Géolocalisation, cartes, alertes de lieu | Contraire aux principes 3 et 4 |
| Contribution, proposition d'ajout, modération, administration | Fausse bonne idée : risque de fausses informations ; on s'en tient à des sources fiables |
| Comptes, amis, groupes, classements, défis collectifs | Nécessiteraient un serveur et de la modération, sans valeur pour le but de prévention |
| Séries (streaks), quêtes, saisons, défis | Dark patterns, et aucune garantie de réalité |
| Collection, cartes, boss, récompenses réelles | Hors direction |
| Récompenses aléatoires, rareté, compte à rebours, jauge de complétion « x / 100 », classements entre personnes | Mécaniques de dark pattern ; la gamification retenue est celle du §4.4 |
| Double compteur esquive / redirection | Esquives à repenser d'abord |
| Bilan, objectifs, estimation d'argent redirigé | Le but est la prévention, pas une quête de non-achat |
| OCR de tickets, import bancaire | Aucun stockage serveur ; traitement non nécessaire |
| Widgets, notifications, extension navigateur, bot, API publique, version web | On ne fait qu'une app Flutter / Dart |
| Thèmes ou personnalisation | La direction artistique est un parti pris |
| Mascotte animée, guide, onboarding, répliques, mini-jeux | Mascotte minimale (§4.4) |
| Mode hors ligne comme fonctionnalité | Conséquence de l'architecture (§7.4) |
| Mode « discret », multilingue, mode voyage | Non prioritaires |
| Fuites, documents non publics, vie privée | Hors ligne éditoriale (« pas WikiLeaks », §8) |
| Étiquettes politiques ou morales sur des personnes | Risque juridique et contraire à l'éthique de méthode (§8) |
| Liste de « groupes » à maintenir | Remplacée par le critère objectif « société cotée » (§5) |

---

## 10. Feuille de route

### v0.9 — Consolider le cœur
1. Reformulation du verdict et « Pourquoi ? » avec sources et dates (F3, F4)
2. Recherche texte sur l'écran Scan (F2)
3. Entité « Enseigne » + 30 à 50 enseignes majeures (F6), sélecteur d'enseigne facultatif (F5)
4. Cas « pas encore référencé » (F7)
5. À propos : sources, mentions légales, contact (F15)
6. Base de départ : top 50 des fortunes de France et marquage des sociétés cotées (§5)

### v1.0 — Sortie et couverture
1. « Je le prends ailleurs » et alternatives par catégorie (F9–F11)
2. Extension de la base : médias, services et abonnements (§5)
3. Mascotte minimale (M1, M2)
4. Récompenses légères (R1–R4)
5. Chantier wordings (Terrain, verdict) et refonte des esquives (§6)

### Plus tard
Jeux vidéo, musique, cinéma ; aide contextuelle (F8) ; partage de fiche (F17) si validé.

---

## 11. Risques

| Risque | Parade |
|---|---|
| Information fausse ou obsolète | Sources et dates affichées, mise à jour régulière, contact de correction |
| Couverture insuffisante (« pas référencé » trop fréquent) | Prioriser les grandes enseignes et marques ; ne rien afficher plutôt que mal afficher |
| Recours juridique d'un groupe | Formulations prudentes, sources publiques, mentions légales, droit de réponse par e-mail |
| Effet anxiogène | Ton factuel, pas de cartographie de l'environnement, chaque verdict avec une issue |
| Dépendance à des sources externes | Embarquer le graphe, sources multiples, licences ouvertes |
| Dérive de périmètre pendant le vibe coding | Se référer au §9 avant d'ajouter quoi que ce soit |

---

## 12. Questions ouvertes

1. **Seuils** : verdict principal = **contrôle** (majorité du capital ou des droits de vote, ou contrôle de fait). À partir de quel pourcentage une participation minoritaire d'un acteur de référence devient-elle visible comme « Participation de… » ?
2. **Choix des classements** (France et monde) et rythme de mise à jour : que devient une fortune qui sort du classement ? (proposition : classement figé à une date, mise à jour annuelle)
3. **Esquives** : mémo neutre, historique seul ou statu quo allégé ? (§6)
4. **Mise à jour des données** : embarquées dans l'app (une nouvelle version à chaque mise à jour) ou fichier statique téléchargé ? (§7.4)
5. **Récompenses** : badges de découverte seuls, ou aussi un niveau cumulatif et un compteur ? (§4.4)
6. **Mascotte** : la taupe est-elle conservée comme simple personnage statique ? Illustrateur·rice humain·e ou création assistée par IA retravaillée ?
7. **Nom « céaki »** : vérifier INPI, domaines et noms des stores.
8. **Partage d'une fiche** (F17) : utile ou superflu ?
9. **Fonds d'investissement** : exclus du verdict rouge comme proposé ?
10. **Société cotée = rouge** : cas limites (très petites cotées, sociétés d'État, coopératives avec filiales cotées, double cotation) et seuil de contrôle d'une filiale (majorité du capital ? des droits de vote ? contrôle de fait ?).
11. **Points d'attention** (F18) : oui ou non, et quels critères exacts.
12. **Vocabulaire du rouge « coté »** : « Cotée en bourse » est-il assez parlant pour la cible, ou préfères-tu une formule plus directe (« Capital en bourse ») ?
