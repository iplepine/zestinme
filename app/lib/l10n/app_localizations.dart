import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

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
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ZestInMe'**
  String get appTitle;

  /// No description provided for @coaching_answerNow.
  ///
  /// In en, this message translates to:
  /// **'Answer now'**
  String get coaching_answerNow;

  /// No description provided for @coaching_tonight.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get coaching_tonight;

  /// No description provided for @coaching_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get coaching_skip;

  /// No description provided for @coaching_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get coaching_previous;

  /// No description provided for @coaching_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get coaching_next;

  /// No description provided for @coaching_finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get coaching_finish;

  /// No description provided for @coaching_deepCoaching.
  ///
  /// In en, this message translates to:
  /// **'Deep Coaching'**
  String get coaching_deepCoaching;

  /// No description provided for @coaching_enterAnswer.
  ///
  /// In en, this message translates to:
  /// **'Type your answer...'**
  String get coaching_enterAnswer;

  /// No description provided for @coaching_enterDetailedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Type your detailed answer...'**
  String get coaching_enterDetailedAnswer;

  /// No description provided for @coaching_helpText.
  ///
  /// In en, this message translates to:
  /// **'Express yourself freely. There are no right answers.'**
  String get coaching_helpText;

  /// No description provided for @coaching_errorSaving.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving.'**
  String get coaching_errorSaving;

  /// No description provided for @coaching_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get coaching_progress;

  /// No description provided for @categories_calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get categories_calm;

  /// No description provided for @categories_reappraise.
  ///
  /// In en, this message translates to:
  /// **'Reappraise'**
  String get categories_reappraise;

  /// No description provided for @categories_needs.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get categories_needs;

  /// No description provided for @categories_boundaries.
  ///
  /// In en, this message translates to:
  /// **'Boundaries'**
  String get categories_boundaries;

  /// No description provided for @categories_pattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get categories_pattern;

  /// No description provided for @categories_plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get categories_plan;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error;

  /// No description provided for @common_success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get common_success;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_confirm;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// No description provided for @sunlight.
  ///
  /// In en, this message translates to:
  /// **'Sunlight'**
  String get sunlight;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @giveWaterButton.
  ///
  /// In en, this message translates to:
  /// **'Give Water'**
  String get giveWaterButton;

  /// No description provided for @pruneButton.
  ///
  /// In en, this message translates to:
  /// **'가지치기'**
  String get pruneButton;

  /// No description provided for @home_checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get home_checkIn;

  /// No description provided for @home_reflection.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get home_reflection;

  /// No description provided for @home_letGo.
  ///
  /// In en, this message translates to:
  /// **'Let Go'**
  String get home_letGo;

  /// No description provided for @home_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get home_history;

  /// No description provided for @home_question_default.
  ///
  /// In en, this message translates to:
  /// **'How is your heart today?'**
  String get home_question_default;

  /// No description provided for @home_question_tired.
  ///
  /// In en, this message translates to:
  /// **'Are you pushing yourself too hard?'**
  String get home_question_tired;

  /// No description provided for @home_question_happy.
  ///
  /// In en, this message translates to:
  /// **'Who do you want to share this joy with?'**
  String get home_question_happy;

  /// No description provided for @onboarding_step1Title.
  ///
  /// In en, this message translates to:
  /// **'At this moment,\nwhat is the name of your heart?'**
  String get onboarding_step1Title;

  /// No description provided for @onboarding_step2Title.
  ///
  /// In en, this message translates to:
  /// **'Where did that \'{emotion}\' come from?'**
  String onboarding_step2Title(String emotion, String particle);

  /// No description provided for @onboarding_step2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Write briefly, it will become a mind seed.'**
  String get onboarding_step2Subtitle;

  /// No description provided for @onboarding_hint.
  ///
  /// In en, this message translates to:
  /// **'Situation or reason...'**
  String get onboarding_hint;

  /// No description provided for @onboarding_submit.
  ///
  /// In en, this message translates to:
  /// **'Plant Mind'**
  String get onboarding_submit;

  /// No description provided for @onboarding_instructionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your \'{emotion}\' will now\nbloom into new life here.'**
  String onboarding_instructionTitle(String emotion, String particle);

  /// No description provided for @onboarding_instructionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The honest heart you wrote\nis the only nutrient to bloom this child.'**
  String get onboarding_instructionSubtitle;

  /// No description provided for @onboarding_finish.
  ///
  /// In en, this message translates to:
  /// **'Grow Together'**
  String get onboarding_finish;

  /// No description provided for @onboarding_transition_planted.
  ///
  /// In en, this message translates to:
  /// **'The mind seed has been planted safely.'**
  String get onboarding_transition_planted;

  /// No description provided for @onboarding_transition_entering.
  ///
  /// In en, this message translates to:
  /// **'Now, guiding you to your sanctuary.'**
  String get onboarding_transition_entering;

  /// No description provided for @onboarding_emotions_joy.
  ///
  /// In en, this message translates to:
  /// **'Joy'**
  String get onboarding_emotions_joy;

  /// No description provided for @onboarding_emotions_sadness.
  ///
  /// In en, this message translates to:
  /// **'Sadness'**
  String get onboarding_emotions_sadness;

  /// No description provided for @onboarding_emotions_anger.
  ///
  /// In en, this message translates to:
  /// **'Anger'**
  String get onboarding_emotions_anger;

  /// No description provided for @onboarding_emotions_anxiety.
  ///
  /// In en, this message translates to:
  /// **'Anxiety'**
  String get onboarding_emotions_anxiety;

  /// No description provided for @onboarding_emotions_peace.
  ///
  /// In en, this message translates to:
  /// **'Peace'**
  String get onboarding_emotions_peace;

  /// No description provided for @seeding_instruction.
  ///
  /// In en, this message translates to:
  /// **'Where is your heart?'**
  String get seeding_instruction;

  /// No description provided for @seeding_promptTags.
  ///
  /// In en, this message translates to:
  /// **'This feeling is...'**
  String get seeding_promptTags;

  /// No description provided for @seeding_promptNote.
  ///
  /// In en, this message translates to:
  /// **'Add a note (context)...'**
  String get seeding_promptNote;

  /// No description provided for @seeding_buttonPlant.
  ///
  /// In en, this message translates to:
  /// **'Plant Seed'**
  String get seeding_buttonPlant;

  /// No description provided for @seeding_messagePlanted.
  ///
  /// In en, this message translates to:
  /// **'Seed planted! 🌱'**
  String get seeding_messagePlanted;

  /// No description provided for @seeding_mood_neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get seeding_mood_neutral;

  /// No description provided for @seeding_mood_energized.
  ///
  /// In en, this message translates to:
  /// **'Energized!'**
  String get seeding_mood_energized;

  /// No description provided for @seeding_mood_stressed.
  ///
  /// In en, this message translates to:
  /// **'Stressed!'**
  String get seeding_mood_stressed;

  /// No description provided for @seeding_mood_calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get seeding_mood_calm;

  /// No description provided for @seeding_mood_tired.
  ///
  /// In en, this message translates to:
  /// **'Tired...'**
  String get seeding_mood_tired;

  /// No description provided for @seeding_mood_angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get seeding_mood_angry;

  /// No description provided for @seeding_mood_anxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get seeding_mood_anxious;

  /// No description provided for @seeding_mood_excited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get seeding_mood_excited;

  /// No description provided for @seeding_mood_joyful.
  ///
  /// In en, this message translates to:
  /// **'Joyful'**
  String get seeding_mood_joyful;

  /// No description provided for @seeding_mood_passionate.
  ///
  /// In en, this message translates to:
  /// **'Passionate'**
  String get seeding_mood_passionate;

  /// No description provided for @seeding_mood_surprised.
  ///
  /// In en, this message translates to:
  /// **'Surprised'**
  String get seeding_mood_surprised;

  /// No description provided for @seeding_mood_relieved.
  ///
  /// In en, this message translates to:
  /// **'Relieved'**
  String get seeding_mood_relieved;

  /// No description provided for @seeding_mood_resentful.
  ///
  /// In en, this message translates to:
  /// **'Resentful'**
  String get seeding_mood_resentful;

  /// No description provided for @seeding_mood_overwhelmed.
  ///
  /// In en, this message translates to:
  /// **'Overwhelmed'**
  String get seeding_mood_overwhelmed;

  /// No description provided for @seeding_mood_jealous.
  ///
  /// In en, this message translates to:
  /// **'Jealous'**
  String get seeding_mood_jealous;

  /// No description provided for @seeding_mood_annoyed.
  ///
  /// In en, this message translates to:
  /// **'Annoyed'**
  String get seeding_mood_annoyed;

  /// No description provided for @seeding_mood_sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get seeding_mood_sad;

  /// No description provided for @seeding_mood_disappointed.
  ///
  /// In en, this message translates to:
  /// **'Disappointed'**
  String get seeding_mood_disappointed;

  /// No description provided for @seeding_mood_bored.
  ///
  /// In en, this message translates to:
  /// **'Bored'**
  String get seeding_mood_bored;

  /// No description provided for @seeding_mood_lonely.
  ///
  /// In en, this message translates to:
  /// **'Lonely'**
  String get seeding_mood_lonely;

  /// No description provided for @seeding_mood_guilty.
  ///
  /// In en, this message translates to:
  /// **'Guilty'**
  String get seeding_mood_guilty;

  /// No description provided for @seeding_mood_envious.
  ///
  /// In en, this message translates to:
  /// **'Envious'**
  String get seeding_mood_envious;

  /// No description provided for @seeding_mood_proud.
  ///
  /// In en, this message translates to:
  /// **'Proud'**
  String get seeding_mood_proud;

  /// No description provided for @seeding_mood_inspired.
  ///
  /// In en, this message translates to:
  /// **'Inspired'**
  String get seeding_mood_inspired;

  /// No description provided for @seeding_mood_enthusiastic.
  ///
  /// In en, this message translates to:
  /// **'Enthusiastic'**
  String get seeding_mood_enthusiastic;

  /// No description provided for @seeding_mood_curious.
  ///
  /// In en, this message translates to:
  /// **'Curious'**
  String get seeding_mood_curious;

  /// No description provided for @seeding_mood_amused.
  ///
  /// In en, this message translates to:
  /// **'Amused'**
  String get seeding_mood_amused;

  /// No description provided for @seeding_mood_relaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get seeding_mood_relaxed;

  /// No description provided for @seeding_mood_grateful.
  ///
  /// In en, this message translates to:
  /// **'Grateful'**
  String get seeding_mood_grateful;

  /// No description provided for @seeding_mood_content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get seeding_mood_content;

  /// No description provided for @seeding_mood_serene.
  ///
  /// In en, this message translates to:
  /// **'Serene'**
  String get seeding_mood_serene;

  /// No description provided for @seeding_mood_trusting.
  ///
  /// In en, this message translates to:
  /// **'Trusting'**
  String get seeding_mood_trusting;

  /// No description provided for @seeding_mood_reflective.
  ///
  /// In en, this message translates to:
  /// **'Reflective'**
  String get seeding_mood_reflective;

  /// No description provided for @seeding_hint_trigger.
  ///
  /// In en, this message translates to:
  /// **'What triggered this feeling?'**
  String get seeding_hint_trigger;

  /// No description provided for @seeding_hint_thought.
  ///
  /// In en, this message translates to:
  /// **'What was your thought?'**
  String get seeding_hint_thought;

  /// No description provided for @seeding_hint_tendency.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do now?'**
  String get seeding_hint_tendency;

  /// No description provided for @seeding_quadrant_energized.
  ///
  /// In en, this message translates to:
  /// **'Energized'**
  String get seeding_quadrant_energized;

  /// No description provided for @seeding_quadrant_calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get seeding_quadrant_calm;

  /// No description provided for @seeding_quadrant_tired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get seeding_quadrant_tired;

  /// No description provided for @seeding_quadrant_stress.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get seeding_quadrant_stress;
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
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
