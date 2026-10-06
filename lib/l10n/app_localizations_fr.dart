// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Céaki';

  @override
  String get navScanner => 'Scan';

  @override
  String get navLibrary => 'Terrain';

  @override
  String get navYou => 'Carnet';

  @override
  String get profileHistorySub => 'Tes checks, recherchables';

  @override
  String get profileDataTitle => 'Données locales';

  @override
  String get profileDataSub => 'Historique et cache produit';

  @override
  String get profileDataBody =>
      'Tout reste sur cet appareil. Vider l’historique remet aussi le compteur de reposés à zéro.';

  @override
  String get profileAboutTitle => 'À propos';

  @override
  String get profileAboutSub => 'Versions et sources';

  @override
  String get aboutSourcesLabel => 'Sources';

  @override
  String get profileCacheLabel => 'Cache produit';

  @override
  String profileScanCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'scans',
      one: 'scan',
      zero: 'scan',
    );
    return '$count $_temp0';
  }

  @override
  String get scannerHeadline => 'Qui est derrière ?';

  @override
  String get scannerSub =>
      'Checke en rayon. On te dit qui tient la marque et si une grande fortune est derrière.';

  @override
  String get scanCta => 'On checke';

  @override
  String get scanTitle => 'Scanner';

  @override
  String get scanHint => 'Cadre le code-barres';

  @override
  String get manualShow => 'Code illisible ?';

  @override
  String get manualHide => 'Masquer la saisie';

  @override
  String get cameraReason =>
      'La caméra sert uniquement à lire un code-barres produit.';

  @override
  String get cameraAllow => 'Autoriser la caméra';

  @override
  String get cameraDenied =>
      'La caméra est bloquée pour Céaki. Active-la dans les réglages du téléphone, ou saisis le code à la main.';

  @override
  String get cameraOpenSettings => 'Ouvrir les réglages';

  @override
  String get alertOff => 'Alerte retirée';

  @override
  String get alertRemove => 'Retirer l’alerte';

  @override
  String get alertRestore => 'Rétablir l’alerte';

  @override
  String get codeHint => 'Code-barres';

  @override
  String get seeAttachment => 'Voir qui tient';

  @override
  String get codeEmpty => 'Saisis un code.';

  @override
  String get codeUnrecognized => 'Ce code n’est pas un code produit.';

  @override
  String get codeInvalidCheck => 'Le chiffre de contrôle est faux.';

  @override
  String get searching => 'Recherche en cours';

  @override
  String get putBack => 'Je le repose';

  @override
  String get buyAnyway => 'Je l’achète quand même';

  @override
  String get notebookTitle => 'Ils n’auront pas';

  @override
  String get notebookSub => 'Ce qu’ils n’ont pas eu, fortune par fortune.';

  @override
  String get notebookEmpty =>
      'Vide. Repose un produit rattaché, ça s’écrit ici.';

  @override
  String notebookLine(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'reposés',
      one: 'reposé',
      zero: 'reposés',
    );
    return '$name, $count $_temp0';
  }

  @override
  String rankEsquives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'esquives',
      one: 'esquive',
      zero: 'esquives',
    );
    return '$count $_temp0';
  }

  @override
  String rankNextAt(int count) {
    return 'Encore jusqu’à $count';
  }

  @override
  String get changeBrandChoice => 'Changer ce choix';

  @override
  String get productUnknown => 'Ce numéro n’est pas dans les sources.';

  @override
  String get offlineProduct =>
      'Hors ligne, les catalogues n’ont pas répondu. Tire pour réessayer.';

  @override
  String get refreshHint => 'Tirer pour actualiser';

  @override
  String get brandUnmatched =>
      'Marque vue, on ne sait pas encore qui tient derrière.';

  @override
  String get gs1Prefix => 'préfixe GS1, titulaire non identifié';

  @override
  String get otherShareholders => 'Voir les autres actionnaires';

  @override
  String get chooseBrand => 'Quelle maison est-ce ?';

  @override
  String get categoryBook => 'Livre';

  @override
  String get categoryGame => 'Jeu de société';

  @override
  String get categoryFood => 'Alimentaire';

  @override
  String get categoryBeauty => 'Beauté';

  @override
  String get categoryPet => 'Animalerie';

  @override
  String get categoryProduct => 'Produit';

  @override
  String get searchHint => 'Fortune, société ou marque';

  @override
  String get archiveSearchHint => 'Cherche une marque';

  @override
  String get archiveBadge => 'Terrain';

  @override
  String get archiveSub => 'Ce que t’as déjà croisé.';

  @override
  String archiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'marques',
      one: 'marque',
      zero: 'marque',
    );
    return '$count $_temp0';
  }

  @override
  String get archiveLegendFortune => 'Fortune';

  @override
  String get archiveLegendClear => 'Entreprise';

  @override
  String get archiveLegendUnknown => 'Inconnu';

  @override
  String get archiveFilterAll => 'Toutes';

  @override
  String get archiveFilterFortune => 'Fortune';

  @override
  String get archiveFilterClear => 'Entreprise';

  @override
  String get archiveFilterUnknown => 'Inconnu';

  @override
  String get archiveEmpty =>
      'Ton terrain est vide.\nPremier check → ça commence.';

  @override
  String get archiveEmptyCta => 'On checke';

  @override
  String get archiveSources => 'Sources';

  @override
  String get archiveUnresolvedBody => 'Pas encore rattaché dans notre base.';

  @override
  String get archiveNoMatch => 'Aucune marque ne correspond.';

  @override
  String get sectorAll => 'Tous';

  @override
  String companyRoleCountry(String role, String country) {
    return '$role · $country';
  }

  @override
  String get sectionFortunes => 'Fortunes';

  @override
  String get sectionCompanies => 'Sociétés';

  @override
  String get sectionBrands => 'Marques';

  @override
  String get noResult => 'Aucun résultat';

  @override
  String get participations => 'Participations actives';

  @override
  String get brandsReached => 'Marques atteintes';

  @override
  String get history => 'Historique';

  @override
  String get noHistory => 'Aucun lien historique';

  @override
  String get shareholders => 'Actionnaires';

  @override
  String get subsidiaries => 'Filiales et participations';

  @override
  String get aliases => 'Alias';

  @override
  String get chain => 'Comment ça remonte';

  @override
  String get noScans => 'Aucun produit scanné sur cet appareil';

  @override
  String get scanHistoryTitle => 'Scans';

  @override
  String get scanHistorySub => 'Tes checks, du plus récent au plus ancien.';

  @override
  String get scanHistorySearch => 'Titre, marque ou code';

  @override
  String get scanHistoryEmpty =>
      'Aucun scan pour l’instant.\nChecke un produit pour commencer.';

  @override
  String get scanHistoryEmptyCta => 'On checke';

  @override
  String get scanHistoryNoMatch => 'Aucun scan ne correspond.';

  @override
  String scanHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'scans',
      one: 'scan',
      zero: 'scan',
    );
    return '$count $_temp0';
  }

  @override
  String get scanHistoryPutBack => 'Reposé';

  @override
  String get scanHistoryBought => 'Acheté';

  @override
  String get clearScanHistory => 'Vider l’historique';

  @override
  String get clearProductCache => 'Vider le cache produit';

  @override
  String productCacheCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'produits en cache',
      one: 'produit en cache',
      zero: 'produit en cache',
    );
    return '$count $_temp0';
  }

  @override
  String get memoryCleared => 'Mémoire locale vidée.';

  @override
  String get cacheCleared => 'Cache produit vidé.';

  @override
  String get alertOn => 'Alerte active';

  @override
  String get appVersionLabel => 'Application';

  @override
  String appVersionValue(String version) {
    return 'Céaki v$version';
  }

  @override
  String get libraryVersionLabel => 'Bibliothèque capitalistique';

  @override
  String libraryVersionValue(String version, String date) {
    return '$version · maj $date';
  }

  @override
  String get aboutPurpose =>
      'On checke un produit pour voir l’entreprise derrière et une grande fortune documentée s’il y en a une. La suite, c’est toi.';

  @override
  String get aboutLimit => 'Pas de grande fortune repérée ≠ petite entreprise.';

  @override
  String get aboutSources =>
      'Identification : BnF, Open Library, Google Books, Open Food Facts. Données capitalistiques embarquées, mises à jour avec l’app.';

  @override
  String get aboutAccount =>
      'Pas de compte en ligne pour l’instant : tout reste sur cet appareil. Un compte facultatif, s’il arrive, sera après la pré-v1.';

  @override
  String get libraryError => 'La bibliothèque n’a pas pu être lue.';

  @override
  String get missingEntry => 'Cette fiche n’est plus dans la bibliothèque.';

  @override
  String get sourceOpenError => 'La source n’a pas pu être ouverte.';

  @override
  String get chainCut =>
      'La chaîne s’arrête ici : la profondeur maximale est atteinte.';

  @override
  String get alreadySeen => 'Société déjà rencontrée.';
}
