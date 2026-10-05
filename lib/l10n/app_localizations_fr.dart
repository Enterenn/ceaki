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
      'La lecture d’un code-barres viendra ensuite. La caméra n’est pas encore demandée.';

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
