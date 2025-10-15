import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';
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
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// Title of the application
  ///
  /// In en, this message translates to:
  /// **'Nost video uploader'**
  String get nostVideoUploader;

  /// Button text for logging in
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Title for the video uploader feature
  ///
  /// In en, this message translates to:
  /// **'Video Uploader'**
  String get videoUploader;

  /// Button text to select a video to upload
  ///
  /// In en, this message translates to:
  /// **'Select Video'**
  String get selectVideo;

  /// Title for the sharing links section
  ///
  /// In en, this message translates to:
  /// **'Sharing Links'**
  String get sharingLinks;

  /// Button text to start a new upload
  ///
  /// In en, this message translates to:
  /// **'New upload'**
  String get newUpload;

  /// Label for the nevent link
  ///
  /// In en, this message translates to:
  /// **'Nevent'**
  String get nevent;

  /// Label for the njump link
  ///
  /// In en, this message translates to:
  /// **'Njump'**
  String get njump;

  /// Label for the yakihonne link
  ///
  /// In en, this message translates to:
  /// **'Yakihonne'**
  String get yakihonne;

  /// Label for the plebs link
  ///
  /// In en, this message translates to:
  /// **'Plebs'**
  String get plebs;

  /// Label for the title input field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Label for the description input field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for the tags input field
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Label for the links input field
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// Label for the participants input field
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// Label for the npub.world link
  ///
  /// In en, this message translates to:
  /// **'Npub.world'**
  String get npubWorld;

  /// Hint text for the npub input field
  ///
  /// In en, this message translates to:
  /// **'npub'**
  String get npub;

  /// Label for the thumbnail section
  ///
  /// In en, this message translates to:
  /// **'Thumbnail'**
  String get thumbnail;

  /// Button text to select a thumbnail
  ///
  /// In en, this message translates to:
  /// **'Select Thumbnail'**
  String get selectThumbnail;

  /// Label for the first time published date picker
  ///
  /// In en, this message translates to:
  /// **'First time the video was published'**
  String get firstTimeTheVideoWasPublished;

  /// Button text to select a date
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Label for the short video switch
  ///
  /// In en, this message translates to:
  /// **'Short Video'**
  String get shortVideo;

  /// Label for the NSFW switch
  ///
  /// In en, this message translates to:
  /// **'NSFW'**
  String get nsfw;

  /// Button text to upload the video
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Status text when fetching blossom servers
  ///
  /// In en, this message translates to:
  /// **'Fetching your blossoms servers'**
  String get fetchingYourBlossomsServers;

  /// Status text when uploading the video
  ///
  /// In en, this message translates to:
  /// **'Uploading video'**
  String get uploadingVideo;

  /// Status text when uploading the thumbnail
  ///
  /// In en, this message translates to:
  /// **'Uploading thumbnail'**
  String get uploadingThumbnail;

  /// Status text when sending the nostr event
  ///
  /// In en, this message translates to:
  /// **'Sending nostr event'**
  String get sendingNostrEvent;

  /// Status text when the upload is done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Title for the discard changes dialog
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get discardChanges;

  /// Content of the discard changes dialog
  ///
  /// In en, this message translates to:
  /// **'Your changes will be lost.'**
  String get yourChangesWillBeLost;

  /// Button text to go back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Button text to reset the form
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Part of the 'Made with love by' text
  ///
  /// In en, this message translates to:
  /// **'Made with'**
  String get madeWith;

  /// Part of the 'Made with love by' text
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// Button text to view the source code on git
  ///
  /// In en, this message translates to:
  /// **'View on git'**
  String get viewOnGit;

  /// Title for the select video dialog
  ///
  /// In en, this message translates to:
  /// **'Select Video'**
  String get selectVideoTitle;

  /// Title for the select thumbnail dialog
  ///
  /// In en, this message translates to:
  /// **'Select Thumbnail'**
  String get selectThumbnailTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'fr',
    'ja',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
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
