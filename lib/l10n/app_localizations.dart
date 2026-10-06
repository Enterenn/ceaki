import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Céaki?'**
  String get appTitle;

  /// No description provided for @navScanner.
  ///
  /// In fr, this message translates to:
  /// **'Scan'**
  String get navScanner;

  /// No description provided for @navLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque'**
  String get navLibrary;

  /// No description provided for @navYou.
  ///
  /// In fr, this message translates to:
  /// **'Vous'**
  String get navYou;

  /// No description provided for @scannerHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Qui est derrière ?'**
  String get scannerHeadline;

  /// No description provided for @scannerSub.
  ///
  /// In fr, this message translates to:
  /// **'On checke un produit et on voit qui tire les ficelles.'**
  String get scannerSub;

  /// No description provided for @scanCta.
  ///
  /// In fr, this message translates to:
  /// **'On checke'**
  String get scanCta;

  /// No description provided for @scanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get scanTitle;

  /// No description provided for @scanHint.
  ///
  /// In fr, this message translates to:
  /// **'Cadre le code-barres'**
  String get scanHint;

  /// No description provided for @manualShow.
  ///
  /// In fr, this message translates to:
  /// **'Code illisible ?'**
  String get manualShow;

  /// No description provided for @manualHide.
  ///
  /// In fr, this message translates to:
  /// **'Masquer la saisie'**
  String get manualHide;

  /// No description provided for @cameraReason.
  ///
  /// In fr, this message translates to:
  /// **'La caméra sert uniquement à lire un code-barres produit.'**
  String get cameraReason;

  /// No description provided for @cameraAllow.
  ///
  /// In fr, this message translates to:
  /// **'Autoriser la caméra'**
  String get cameraAllow;

  /// No description provided for @cameraDenied.
  ///
  /// In fr, this message translates to:
  /// **'La caméra est bloquée pour Céaki. Active-la dans les réglages du téléphone, ou saisis le code à la main.'**
  String get cameraDenied;

  /// No description provided for @cameraOpenSettings.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir les réglages'**
  String get cameraOpenSettings;

  /// No description provided for @alertOff.
  ///
  /// In fr, this message translates to:
  /// **'Alerte retirée'**
  String get alertOff;

  /// No description provided for @alertRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer l’alerte'**
  String get alertRemove;

  /// No description provided for @alertRestore.
  ///
  /// In fr, this message translates to:
  /// **'Rétablir l’alerte'**
  String get alertRestore;

  /// No description provided for @codeHint.
  ///
  /// In fr, this message translates to:
  /// **'Code-barres'**
  String get codeHint;

  /// No description provided for @seeAttachment.
  ///
  /// In fr, this message translates to:
  /// **'Voir le rattachement'**
  String get seeAttachment;

  /// No description provided for @codeEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Saisis un code.'**
  String get codeEmpty;

  /// No description provided for @codeUnrecognized.
  ///
  /// In fr, this message translates to:
  /// **'Ce code n’est pas un code produit.'**
  String get codeUnrecognized;

  /// No description provided for @codeInvalidCheck.
  ///
  /// In fr, this message translates to:
  /// **'Le chiffre de contrôle est faux.'**
  String get codeInvalidCheck;

  /// No description provided for @searching.
  ///
  /// In fr, this message translates to:
  /// **'Recherche en cours'**
  String get searching;

  /// No description provided for @putBack.
  ///
  /// In fr, this message translates to:
  /// **'Je le repose'**
  String get putBack;

  /// No description provided for @buyAnyway.
  ///
  /// In fr, this message translates to:
  /// **'Je l’achète quand même'**
  String get buyAnyway;

  /// No description provided for @notebookTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reposés'**
  String get notebookTitle;

  /// No description provided for @notebookEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien pour l’instant.'**
  String get notebookEmpty;

  /// No description provided for @notebookLine.
  ///
  /// In fr, this message translates to:
  /// **'{name} — {count}'**
  String notebookLine(String name, int count);

  /// No description provided for @rankEsquives.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =0{reposés} =1{reposé} other{reposés}}'**
  String rankEsquives(int count);

  /// No description provided for @productUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Ce numéro n’est pas dans les sources.'**
  String get productUnknown;

  /// No description provided for @offlineProduct.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne — les catalogues n’ont pas répondu. Tire pour réessayer.'**
  String get offlineProduct;

  /// No description provided for @refreshHint.
  ///
  /// In fr, this message translates to:
  /// **'Tirer pour actualiser'**
  String get refreshHint;

  /// No description provided for @brandUnmatched.
  ///
  /// In fr, this message translates to:
  /// **'La marque est identifiée, le rattachement capitalistique ne l’est pas.'**
  String get brandUnmatched;

  /// No description provided for @gs1Prefix.
  ///
  /// In fr, this message translates to:
  /// **'préfixe GS1, titulaire non identifié'**
  String get gs1Prefix;

  /// No description provided for @otherShareholders.
  ///
  /// In fr, this message translates to:
  /// **'Voir les autres actionnaires'**
  String get otherShareholders;

  /// No description provided for @chooseBrand.
  ///
  /// In fr, this message translates to:
  /// **'Quelle maison est-ce ?'**
  String get chooseBrand;

  /// No description provided for @categoryBook.
  ///
  /// In fr, this message translates to:
  /// **'Livre'**
  String get categoryBook;

  /// No description provided for @categoryGame.
  ///
  /// In fr, this message translates to:
  /// **'Jeu de société'**
  String get categoryGame;

  /// No description provided for @categoryFood.
  ///
  /// In fr, this message translates to:
  /// **'Alimentaire'**
  String get categoryFood;

  /// No description provided for @categoryBeauty.
  ///
  /// In fr, this message translates to:
  /// **'Beauté'**
  String get categoryBeauty;

  /// No description provided for @categoryPet.
  ///
  /// In fr, this message translates to:
  /// **'Animalerie'**
  String get categoryPet;

  /// No description provided for @categoryProduct.
  ///
  /// In fr, this message translates to:
  /// **'Produit'**
  String get categoryProduct;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Fortune, société ou marque'**
  String get searchHint;

  /// No description provided for @archiveSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Cherche une marque'**
  String get archiveSearchHint;

  /// No description provided for @archiveBadge.
  ///
  /// In fr, this message translates to:
  /// **'Archive'**
  String get archiveBadge;

  /// No description provided for @archiveSub.
  ///
  /// In fr, this message translates to:
  /// **'Tes marques déjà checkées en rayon.'**
  String get archiveSub;

  /// No description provided for @archiveCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =0{marque} =1{marque} other{marques}}'**
  String archiveCount(int count);

  /// No description provided for @archiveLegendFortune.
  ///
  /// In fr, this message translates to:
  /// **'Fortune'**
  String get archiveLegendFortune;

  /// No description provided for @archiveLegendClear.
  ///
  /// In fr, this message translates to:
  /// **'Sans fortune'**
  String get archiveLegendClear;

  /// No description provided for @archiveLegendUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get archiveLegendUnknown;

  /// No description provided for @archiveEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien ici pour l’instant.\nChecke un produit : les marques croisées s’archivent.'**
  String get archiveEmpty;

  /// No description provided for @archiveEmptyCta.
  ///
  /// In fr, this message translates to:
  /// **'On checke'**
  String get archiveEmptyCta;

  /// No description provided for @archiveSources.
  ///
  /// In fr, this message translates to:
  /// **'Sources'**
  String get archiveSources;

  /// No description provided for @archiveUnresolvedBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette marque n’est pas encore rattachée dans la bibliothèque documentée.'**
  String get archiveUnresolvedBody;

  /// No description provided for @archiveNoMatch.
  ///
  /// In fr, this message translates to:
  /// **'Aucune marque ne correspond.'**
  String get archiveNoMatch;

  /// No description provided for @sectorAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get sectorAll;

  /// No description provided for @sectionFortunes.
  ///
  /// In fr, this message translates to:
  /// **'Fortunes'**
  String get sectionFortunes;

  /// No description provided for @sectionCompanies.
  ///
  /// In fr, this message translates to:
  /// **'Sociétés'**
  String get sectionCompanies;

  /// No description provided for @sectionBrands.
  ///
  /// In fr, this message translates to:
  /// **'Marques'**
  String get sectionBrands;

  /// No description provided for @noResult.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get noResult;

  /// No description provided for @participations.
  ///
  /// In fr, this message translates to:
  /// **'Participations actives'**
  String get participations;

  /// No description provided for @brandsReached.
  ///
  /// In fr, this message translates to:
  /// **'Marques atteintes'**
  String get brandsReached;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @noHistory.
  ///
  /// In fr, this message translates to:
  /// **'Aucun lien historique'**
  String get noHistory;

  /// No description provided for @shareholders.
  ///
  /// In fr, this message translates to:
  /// **'Actionnaires'**
  String get shareholders;

  /// No description provided for @subsidiaries.
  ///
  /// In fr, this message translates to:
  /// **'Filiales et participations'**
  String get subsidiaries;

  /// No description provided for @aliases.
  ///
  /// In fr, this message translates to:
  /// **'Alias'**
  String get aliases;

  /// No description provided for @chain.
  ///
  /// In fr, this message translates to:
  /// **'Chaîne'**
  String get chain;

  /// No description provided for @noScans.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit scanné sur cet appareil'**
  String get noScans;

  /// No description provided for @alertOn.
  ///
  /// In fr, this message translates to:
  /// **'Alerte active'**
  String get alertOn;

  /// No description provided for @appVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Version de l’app'**
  String get appVersionLabel;

  /// No description provided for @appVersionValue.
  ///
  /// In fr, this message translates to:
  /// **'Céaki v{version}'**
  String appVersionValue(String version);

  /// No description provided for @libraryVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Version de la bibliothèque'**
  String get libraryVersionLabel;

  /// No description provided for @aboutPurpose.
  ///
  /// In fr, this message translates to:
  /// **'Tu scannes, on te montre les liens capitalistiques documentés. La suite, c’est toi.'**
  String get aboutPurpose;

  /// No description provided for @aboutLimit.
  ///
  /// In fr, this message translates to:
  /// **'Pas de grande fortune documentée ≠ petite entreprise.'**
  String get aboutLimit;

  /// No description provided for @libraryError.
  ///
  /// In fr, this message translates to:
  /// **'La bibliothèque n’a pas pu être lue.'**
  String get libraryError;

  /// No description provided for @missingEntry.
  ///
  /// In fr, this message translates to:
  /// **'Cette fiche n’est plus dans la bibliothèque.'**
  String get missingEntry;

  /// No description provided for @sourceOpenError.
  ///
  /// In fr, this message translates to:
  /// **'La source n’a pas pu être ouverte.'**
  String get sourceOpenError;

  /// No description provided for @chainCut.
  ///
  /// In fr, this message translates to:
  /// **'La chaîne s’arrête ici : la profondeur maximale est atteinte.'**
  String get chainCut;

  /// No description provided for @alreadySeen.
  ///
  /// In fr, this message translates to:
  /// **'Société déjà rencontrée.'**
  String get alreadySeen;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
