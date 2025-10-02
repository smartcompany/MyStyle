import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Style Me'**
  String get appTitle;

  /// No description provided for @findYourStyle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Own Style'**
  String get findYourStyle;

  /// No description provided for @aiAnalysisDescription.
  ///
  /// In en, this message translates to:
  /// **'AI analyzes your face and recommends hairstyles, eyebrows, fashion, and accessories'**
  String get aiAnalysisDescription;

  /// No description provided for @analysisItems.
  ///
  /// In en, this message translates to:
  /// **'Analysis Items'**
  String get analysisItems;

  /// No description provided for @hairstyle.
  ///
  /// In en, this message translates to:
  /// **'💇‍♀️ Hairstyle'**
  String get hairstyle;

  /// No description provided for @eyebrowCare.
  ///
  /// In en, this message translates to:
  /// **'👁️ Eyebrow Care'**
  String get eyebrowCare;

  /// No description provided for @glassesRecommendation.
  ///
  /// In en, this message translates to:
  /// **'👓 Glasses Recommendation'**
  String get glassesRecommendation;

  /// No description provided for @hatStyle.
  ///
  /// In en, this message translates to:
  /// **'🎩 Hat Style'**
  String get hatStyle;

  /// No description provided for @earrings.
  ///
  /// In en, this message translates to:
  /// **'💍 Earrings'**
  String get earrings;

  /// No description provided for @colorPalette.
  ///
  /// In en, this message translates to:
  /// **'🎨 Color Palette'**
  String get colorPalette;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @retakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake Photo'**
  String get retakePhoto;

  /// No description provided for @startAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Start Analysis'**
  String get startAnalysis;

  /// No description provided for @uploadPhotoInstruction.
  ///
  /// In en, this message translates to:
  /// **'Select a photo'**
  String get uploadPhotoInstruction;

  /// No description provided for @supportedFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG formats supported'**
  String get supportedFormats;

  /// No description provided for @styleAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Style Analysis'**
  String get styleAnalysis;

  /// No description provided for @aiStyleAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Style Analysis'**
  String get aiStyleAnalysis;

  /// No description provided for @analyzeAfterAd.
  ///
  /// In en, this message translates to:
  /// **'Analyze your style after watching an ad'**
  String get analyzeAfterAd;

  /// No description provided for @adPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing ad...'**
  String get adPreparing;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing your style...'**
  String get aiAnalyzing;

  /// No description provided for @analysisComplete.
  ///
  /// In en, this message translates to:
  /// **'AI analysis complete...'**
  String get analysisComplete;

  /// No description provided for @styleAnalysisResult.
  ///
  /// In en, this message translates to:
  /// **'Style Analysis Result'**
  String get styleAnalysisResult;

  /// No description provided for @overallAnalysisResult.
  ///
  /// In en, this message translates to:
  /// **'Overall Analysis Result'**
  String get overallAnalysisResult;

  /// No description provided for @aiAnalyzedYourStyle.
  ///
  /// In en, this message translates to:
  /// **'Your style analyzed by AI'**
  String get aiAnalyzedYourStyle;

  /// No description provided for @faceShapeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Face Shape Analysis'**
  String get faceShapeAnalysis;

  /// No description provided for @skinAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Skin Analysis'**
  String get skinAnalysis;

  /// No description provided for @hairStyle.
  ///
  /// In en, this message translates to:
  /// **'Hair Style'**
  String get hairStyle;

  /// No description provided for @eyebrowManagement.
  ///
  /// In en, this message translates to:
  /// **'Eyebrow Management'**
  String get eyebrowManagement;

  /// No description provided for @fashionAccessories.
  ///
  /// In en, this message translates to:
  /// **'Fashion & Accessories'**
  String get fashionAccessories;

  /// No description provided for @lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyle;

  /// No description provided for @analyzeAgain.
  ///
  /// In en, this message translates to:
  /// **'Analyze Again'**
  String get analyzeAgain;

  /// No description provided for @shareResult.
  ///
  /// In en, this message translates to:
  /// **'Share Result'**
  String get shareResult;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTitle;

  /// No description provided for @shareWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Share with friends'**
  String get shareWithFriends;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get copyText;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @saveToFile.
  ///
  /// In en, this message translates to:
  /// **'Save to File'**
  String get saveToFile;

  /// No description provided for @saveToFilesApp.
  ///
  /// In en, this message translates to:
  /// **'Save to Files app'**
  String get saveToFilesApp;

  /// No description provided for @otherShare.
  ///
  /// In en, this message translates to:
  /// **'Other Share'**
  String get otherShare;

  /// No description provided for @defaultShareFunction.
  ///
  /// In en, this message translates to:
  /// **'Default share function'**
  String get defaultShareFunction;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sharedToKakao.
  ///
  /// In en, this message translates to:
  /// **'Shared to KakaoTalk'**
  String get sharedToKakao;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @shareComplete.
  ///
  /// In en, this message translates to:
  /// **'Share completed'**
  String get shareComplete;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sharing'**
  String get shareError;

  /// No description provided for @imageSelectionError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while selecting an image'**
  String get imageSelectionError;

  /// No description provided for @adLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Ad load failed'**
  String get adLoadFailed;

  /// No description provided for @analysisError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during analysis'**
  String get analysisError;

  /// No description provided for @adViewingOrAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Ad viewing or analysis failed'**
  String get adViewingOrAnalysisFailed;

  /// No description provided for @adViewingFailed.
  ///
  /// In en, this message translates to:
  /// **'Ad viewing failed'**
  String get adViewingFailed;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed. Please try again.'**
  String get analysisFailed;

  /// No description provided for @analysisErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during analysis'**
  String get analysisErrorOccurred;

  /// No description provided for @adLoadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Ad Load Failed'**
  String get adLoadFailedTitle;

  /// No description provided for @adLoadFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Would you like to try again after watching an ad?'**
  String get adLoadFailedMessage;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @faceShape.
  ///
  /// In en, this message translates to:
  /// **'Face Shape'**
  String get faceShape;

  /// No description provided for @strengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get strengths;

  /// No description provided for @improvements.
  ///
  /// In en, this message translates to:
  /// **'Improvements'**
  String get improvements;

  /// No description provided for @skinTone.
  ///
  /// In en, this message translates to:
  /// **'Skin Tone'**
  String get skinTone;

  /// No description provided for @skinType.
  ///
  /// In en, this message translates to:
  /// **'Skin Type'**
  String get skinType;

  /// No description provided for @skinIssues.
  ///
  /// In en, this message translates to:
  /// **'Skin Issues'**
  String get skinIssues;

  /// No description provided for @recommendedColors.
  ///
  /// In en, this message translates to:
  /// **'Recommended Colors'**
  String get recommendedColors;

  /// No description provided for @glassesRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Glasses Recommendations'**
  String get glassesRecommendations;

  /// No description provided for @styleGuideDescription.
  ///
  /// In en, this message translates to:
  /// **'Analysis result sharing with friends!'**
  String get styleGuideDescription;

  /// No description provided for @shareResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Result'**
  String get shareResultTitle;

  /// No description provided for @myStyleAnalysisResult.
  ///
  /// In en, this message translates to:
  /// **'Style Me Analysis Result'**
  String get myStyleAnalysisResult;

  /// No description provided for @overallAnalysisResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall Analysis Result'**
  String get overallAnalysisResultTitle;

  /// No description provided for @faceShapeAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Face Shape Analysis'**
  String get faceShapeAnalysisTitle;

  /// No description provided for @skinAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Skin Analysis'**
  String get skinAnalysisTitle;

  /// No description provided for @hairStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Hair Style'**
  String get hairStyleTitle;

  /// No description provided for @eyebrowManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Eyebrow Management'**
  String get eyebrowManagementTitle;

  /// No description provided for @fashionAccessoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fashion & Accessories'**
  String get fashionAccessoriesTitle;

  /// No description provided for @lifestyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyleTitle;

  /// No description provided for @myStyleAppRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Find your own style with Style Me app! ✨'**
  String get myStyleAppRecommendation;

  /// No description provided for @saveAndShare.
  ///
  /// In en, this message translates to:
  /// **'Save & Share'**
  String get saveAndShare;

  /// No description provided for @kakaoTalk.
  ///
  /// In en, this message translates to:
  /// **'KakaoTalk'**
  String get kakaoTalk;

  /// No description provided for @shareWithFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Share with friends'**
  String get shareWithFriendsTitle;

  /// No description provided for @textCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get textCopy;

  /// No description provided for @copyToClipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboardTitle;

  /// No description provided for @saveToFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Save to File'**
  String get saveToFileTitle;

  /// No description provided for @saveToFilesAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Save to Files app'**
  String get saveToFilesAppTitle;

  /// No description provided for @otherShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Other Share'**
  String get otherShareTitle;

  /// No description provided for @defaultShareFunctionTitle.
  ///
  /// In en, this message translates to:
  /// **'Default share function'**
  String get defaultShareFunctionTitle;

  /// No description provided for @cancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelTitle;

  /// No description provided for @sharedToKakaoMessage.
  ///
  /// In en, this message translates to:
  /// **'Shared to KakaoTalk'**
  String get sharedToKakaoMessage;

  /// No description provided for @copiedToClipboardMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboardMessage;

  /// No description provided for @shareCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Share completed'**
  String get shareCompleteMessage;

  /// No description provided for @shareErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sharing'**
  String get shareErrorMessage;

  /// No description provided for @copyErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while copying'**
  String get copyErrorMessage;

  /// No description provided for @saveErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving'**
  String get saveErrorMessage;

  /// No description provided for @myStyleAnalysisResultSubject.
  ///
  /// In en, this message translates to:
  /// **'Style Me Analysis Result'**
  String get myStyleAnalysisResultSubject;

  /// No description provided for @aiStyleDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'AI Style Diagnosis'**
  String get aiStyleDiagnosis;

  /// No description provided for @findYourStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your own style with just one photo'**
  String get findYourStyleSubtitle;

  /// No description provided for @expertLevelAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Expert-level analysis to suggest styles that suit you'**
  String get expertLevelAnalysis;

  /// No description provided for @customizedGuide.
  ///
  /// In en, this message translates to:
  /// **'Customized Guide'**
  String get customizedGuide;

  /// No description provided for @detailedGuidance.
  ///
  /// In en, this message translates to:
  /// **'Detailed guidance on specific implementation methods'**
  String get detailedGuidance;

  /// No description provided for @actionableAdvice.
  ///
  /// In en, this message translates to:
  /// **'Not just simple analysis, but practical advice you can actually apply'**
  String get actionableAdvice;

  /// No description provided for @comprehensiveAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Analysis'**
  String get comprehensiveAnalysis;

  /// No description provided for @detailedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Detailed Analysis'**
  String get detailedAnalysis;

  /// No description provided for @styleGuide.
  ///
  /// In en, this message translates to:
  /// **'Style Guide'**
  String get styleGuide;

  /// No description provided for @analysisInProgress.
  ///
  /// In en, this message translates to:
  /// **'Analysis in progress'**
  String get analysisInProgress;

  /// No description provided for @analysisDescription.
  ///
  /// In en, this message translates to:
  /// **'Through this result, we will tell you what\'s good for hairstyles, makeup, eyebrow grooming, or accessories'**
  String get analysisDescription;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @showOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Show app guide'**
  String get showOnboarding;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInfo;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'View our privacy policy'**
  String get privacyPolicyDescription;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'How we use your data'**
  String get dataUsageDescription;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @helpDescription.
  ///
  /// In en, this message translates to:
  /// **'Get help and support'**
  String get helpDescription;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Send us your feedback'**
  String get feedbackDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;
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
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
