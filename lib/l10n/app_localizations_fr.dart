// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Céaki?';

  @override
  String get navScanner => 'Scan';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navYou => 'Vous';

  @override
  String get scannerHeadline => 'Qui est derrière ?';

  @override
  String get scannerSub =>
      'Scanne un produit et découvre qui tire les ficelles.';

  @override
  String get scanCta => 'Scannez';

  @override
  String get scanTitle => 'Scanner';

  @override
  String get scanHint => 'Cadrez le code-barres';

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
  String get seeAttachment => 'Voir le rattachement';

  @override
  String get codeEmpty => 'Saisissez un code.';

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
  String get notebookTitle => 'Reposés';

  @override
  String get notebookEmpty => 'Rien pour l’instant.';

  @override
  String notebookLine(String name, int count) {
    return '$name — $count';
  }

  @override
  String rankEsquives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'reposés',
      one: 'reposé',
      zero: 'reposés',
    );
    return '$count $_temp0';
  }

  @override
  String get productUnknown => 'Ce numéro n’est pas dans les sources.';

  @override
  String get notABook =>
      'Les livres sont lus pour l’instant. Ce code n’en est pas un.';

  @override
  String get offlineProduct => 'Le produit n’a pas pu être identifié.';

  @override
  String get brandUnmatched =>
      'La marque est identifiée, le rattachement capitalistique ne l’est pas.';

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
  String get searchHint => 'Fortune, société ou marque';

  @override
  String get sectorAll => 'Tous';

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
  String get chain => 'Chaîne';

  @override
  String get noScans => 'Aucun produit scanné sur cet appareil';

  @override
  String get alertOn => 'Alerte active';

  @override
  String get appVersionLabel => 'Version de l’app';

  @override
  String appVersionValue(String version) {
    return 'Céaki v$version';
  }

  @override
  String get libraryVersionLabel => 'Version de la bibliothèque';

  @override
  String get aboutPurpose =>
      'Tu scannes, on te montre les liens capitalistiques documentés. La suite, c’est toi.';

  @override
  String get aboutLimit =>
      'Pas de grande fortune documentée ≠ petite entreprise.';

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
