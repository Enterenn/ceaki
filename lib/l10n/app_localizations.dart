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
  /// **'Transparence'**
  String get appTitle;

  /// No description provided for @navScanner.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
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

  /// No description provided for @scannerPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'La lecture d’un code-barres viendra ensuite. La caméra n’est pas encore demandée.'**
  String get scannerPlaceholder;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Fortune, société ou marque'**
  String get searchHint;

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

  /// No description provided for @libraryVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Version de la bibliothèque'**
  String get libraryVersionLabel;

  /// No description provided for @aboutPurpose.
  ///
  /// In fr, this message translates to:
  /// **'Éviter d’acheter un produit rattaché à une grande fortune documentée, et pouvoir privilégier un produit sans ce rattachement.'**
  String get aboutPurpose;

  /// No description provided for @aboutLimit.
  ///
  /// In fr, this message translates to:
  /// **'L’absence de grande fortune documentée n’est pas un label de petite entreprise.'**
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
