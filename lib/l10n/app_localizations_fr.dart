// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Transparence';

  @override
  String get navScanner => 'Scanner';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navYou => 'Vous';

  @override
  String get scannerPlaceholder =>
      'Saisissez un code, ou lisez-le avec la caméra.';

  @override
  String get cameraReason => 'La caméra sert à lire un code-barres produit.';

  @override
  String get cameraAllow => 'Autoriser la caméra';

  @override
  String get cameraDenied => 'La caméra est refusée. La saisie reste possible.';

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
  String get notebookTitle => 'Ils n’auront pas';

  @override
  String get notebookEmpty => 'Aucun produit reposé.';

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
  String get libraryVersionLabel => 'Version de la bibliothèque';

  @override
  String get aboutPurpose =>
      'Éviter d’acheter un produit rattaché à une grande fortune documentée, et pouvoir privilégier un produit sans ce rattachement.';

  @override
  String get aboutLimit =>
      'L’absence de grande fortune documentée n’est pas un label de petite entreprise.';

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
