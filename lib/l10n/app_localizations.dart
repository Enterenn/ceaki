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
  /// **'Céaki'**
  String get appTitle;

  /// No description provided for @navScanner.
  ///
  /// In fr, this message translates to:
  /// **'Scan'**
  String get navScanner;

  /// No description provided for @navLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Terrain'**
  String get navLibrary;

  /// No description provided for @navYou.
  ///
  /// In fr, this message translates to:
  /// **'Carnet'**
  String get navYou;

  /// No description provided for @profileHistorySub.
  ///
  /// In fr, this message translates to:
  /// **'Tes checks, recherchables'**
  String get profileHistorySub;

  /// No description provided for @profileDataTitle.
  ///
  /// In fr, this message translates to:
  /// **'Données locales'**
  String get profileDataTitle;

  /// No description provided for @profileDataSub.
  ///
  /// In fr, this message translates to:
  /// **'Historique et cache produit'**
  String get profileDataSub;

  /// No description provided for @profileDataBody.
  ///
  /// In fr, this message translates to:
  /// **'Tout reste sur cet appareil. Vider l’historique remet aussi le compteur de reposés à zéro.'**
  String get profileDataBody;

  /// No description provided for @profileAboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get profileAboutTitle;

  /// No description provided for @profileAboutSub.
  ///
  /// In fr, this message translates to:
  /// **'Versions et sources'**
  String get profileAboutSub;

  /// No description provided for @aboutSourcesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sources'**
  String get aboutSourcesLabel;

  /// No description provided for @profileCacheLabel.
  ///
  /// In fr, this message translates to:
  /// **'Cache produit'**
  String get profileCacheLabel;

  /// No description provided for @profileScanCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =0{scan} =1{scan} other{scans}}'**
  String profileScanCount(int count);

  /// No description provided for @scannerHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Qui est derrière ?'**
  String get scannerHeadline;

  /// No description provided for @scannerSub.
  ///
  /// In fr, this message translates to:
  /// **'Checke en rayon. On te dit qui tient la marque et si une grande fortune est derrière.'**
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
  /// **'Voir qui tient'**
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

  /// No description provided for @esquiveBadge.
  ///
  /// In fr, this message translates to:
  /// **'Esquive'**
  String get esquiveBadge;

  /// No description provided for @notebookTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ils n’auront pas'**
  String get notebookTitle;

  /// No description provided for @notebookSub.
  ///
  /// In fr, this message translates to:
  /// **'Ce qu’ils n’ont pas eu, fortune par fortune.'**
  String get notebookSub;

  /// No description provided for @notebookEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Vide. Repose un produit rattaché, ça s’écrit ici.'**
  String get notebookEmpty;

  /// No description provided for @notebookLine.
  ///
  /// In fr, this message translates to:
  /// **'{name}, {count} {count, plural, =0{reposés} =1{reposé} other{reposés}}'**
  String notebookLine(String name, int count);

  /// No description provided for @rankEsquives.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =0{esquives} =1{esquive} other{esquives}}'**
  String rankEsquives(int count);

  /// No description provided for @rankNextAt.
  ///
  /// In fr, this message translates to:
  /// **'Encore jusqu’à {count}'**
  String rankNextAt(int count);

  /// No description provided for @changeBrandChoice.
  ///
  /// In fr, this message translates to:
  /// **'Changer ce choix'**
  String get changeBrandChoice;

  /// No description provided for @productUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Ce numéro n’est pas dans les sources.'**
  String get productUnknown;

  /// No description provided for @offlineProduct.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne, les catalogues n’ont pas répondu. Tire pour réessayer.'**
  String get offlineProduct;

  /// No description provided for @refreshHint.
  ///
  /// In fr, this message translates to:
  /// **'Tirer pour actualiser'**
  String get refreshHint;

  /// No description provided for @brandUnmatched.
  ///
  /// In fr, this message translates to:
  /// **'Marque vue, on ne sait pas encore qui tient derrière.'**
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

  /// No description provided for @archiveSub.
  ///
  /// In fr, this message translates to:
  /// **'Ce que t’as déjà croisé.'**
  String get archiveSub;

  /// No description provided for @archiveCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =0{marque} =1{marque} other{marques}}'**
  String archiveCount(int count);

  /// No description provided for @archiveFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get archiveFilterAll;

  /// No description provided for @archiveFilterFortune.
  ///
  /// In fr, this message translates to:
  /// **'Fortune'**
  String get archiveFilterFortune;

  /// No description provided for @archiveFilterClear.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get archiveFilterClear;

  /// No description provided for @archiveFilterUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get archiveFilterUnknown;

  /// No description provided for @archiveEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ton terrain est vide.\nPremier check → ça commence.'**
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
  /// **'Pas encore rattaché dans notre base.'**
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

  /// No description provided for @companyRoleCountry.
  ///
  /// In fr, this message translates to:
  /// **'{role} · {country}'**
  String companyRoleCountry(String role, String country);

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
  /// **'Comment ça remonte'**
  String get chain;

  /// No description provided for @whyDetail.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi ?'**
  String get whyDetail;

  /// No description provided for @whyDetailHide.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le détail'**
  String get whyDetailHide;

  /// No description provided for @noScans.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit scanné sur cet appareil'**
  String get noScans;

  /// No description provided for @scanHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Scans'**
  String get scanHistoryTitle;

  /// No description provided for @scanHistorySub.
  ///
  /// In fr, this message translates to:
  /// **'Tes checks, du plus récent au plus ancien.'**
  String get scanHistorySub;

  /// No description provided for @scanHistorySearch.
  ///
  /// In fr, this message translates to:
  /// **'Titre, marque ou code'**
  String get scanHistorySearch;

  /// No description provided for @scanHistoryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun scan pour l’instant.\nChecke un produit pour commencer.'**
  String get scanHistoryEmpty;

  /// No description provided for @scanHistoryEmptyCta.
  ///
  /// In fr, this message translates to:
  /// **'On checke'**
  String get scanHistoryEmptyCta;

  /// No description provided for @scanHistoryNoMatch.
  ///
  /// In fr, this message translates to:
  /// **'Aucun scan ne correspond.'**
  String get scanHistoryNoMatch;

  /// No description provided for @scanHistoryCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =0{scan} =1{scan} other{scans}}'**
  String scanHistoryCount(int count);

  /// No description provided for @scanHistoryPutBack.
  ///
  /// In fr, this message translates to:
  /// **'Reposé'**
  String get scanHistoryPutBack;

  /// No description provided for @scanHistoryBought.
  ///
  /// In fr, this message translates to:
  /// **'Acheté'**
  String get scanHistoryBought;

  /// No description provided for @clearScanHistory.
  ///
  /// In fr, this message translates to:
  /// **'Vider l’historique'**
  String get clearScanHistory;

  /// No description provided for @clearProductCache.
  ///
  /// In fr, this message translates to:
  /// **'Vider le cache produit'**
  String get clearProductCache;

  /// No description provided for @productCacheCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =0{produit en cache} =1{produit en cache} other{produits en cache}}'**
  String productCacheCount(int count);

  /// No description provided for @memoryCleared.
  ///
  /// In fr, this message translates to:
  /// **'Mémoire locale vidée.'**
  String get memoryCleared;

  /// No description provided for @cacheCleared.
  ///
  /// In fr, this message translates to:
  /// **'Cache produit vidé.'**
  String get cacheCleared;

  /// No description provided for @alertOn.
  ///
  /// In fr, this message translates to:
  /// **'Alerte active'**
  String get alertOn;

  /// No description provided for @appVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Application'**
  String get appVersionLabel;

  /// No description provided for @appVersionValue.
  ///
  /// In fr, this message translates to:
  /// **'Céaki v{version}'**
  String appVersionValue(String version);

  /// No description provided for @libraryVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque capitalistique'**
  String get libraryVersionLabel;

  /// No description provided for @libraryVersionValue.
  ///
  /// In fr, this message translates to:
  /// **'{version} · maj {date}'**
  String libraryVersionValue(String version, String date);

  /// No description provided for @aboutPurpose.
  ///
  /// In fr, this message translates to:
  /// **'On checke un produit pour voir l’entreprise derrière et une grande fortune documentée s’il y en a une. La suite, c’est toi.'**
  String get aboutPurpose;

  /// No description provided for @aboutLimit.
  ///
  /// In fr, this message translates to:
  /// **'Pas de grande fortune repérée ≠ petite entreprise.'**
  String get aboutLimit;

  /// No description provided for @aboutSources.
  ///
  /// In fr, this message translates to:
  /// **'Identification : BnF, Open Library, Google Books, Open Food Facts. Données capitalistiques embarquées, mises à jour avec l’app.'**
  String get aboutSources;

  /// No description provided for @aboutAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas de compte en ligne pour l’instant : tout reste sur cet appareil. Un compte facultatif, s’il arrive, sera après la pré-v1.'**
  String get aboutAccount;

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
