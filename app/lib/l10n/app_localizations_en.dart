// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FullCon';

  @override
  String get coaching_answerNow => 'Answer now';

  @override
  String get coaching_tonight => 'Tonight';

  @override
  String get coaching_skip => 'Skip';

  @override
  String get coaching_previous => 'Previous';

  @override
  String get coaching_next => 'Next';

  @override
  String get coaching_finish => 'Finish';

  @override
  String get coaching_deepCoaching => 'Deep Coaching';

  @override
  String get coaching_enterAnswer => 'Type your answer...';

  @override
  String get coaching_enterDetailedAnswer => 'Type your detailed answer...';

  @override
  String get coaching_helpText =>
      'Express yourself freely. There are no right answers.';

  @override
  String get coaching_errorSaving => 'An error occurred while saving.';

  @override
  String get coaching_progress => 'Progress';

  @override
  String get categories_calm => 'Calm';

  @override
  String get categories_reappraise => 'Reappraise';

  @override
  String get categories_needs => 'Needs';

  @override
  String get categories_boundaries => 'Boundaries';

  @override
  String get categories_pattern => 'Pattern';

  @override
  String get categories_plan => 'Plan';

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_error => 'Error';

  @override
  String get common_success => 'Success';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_save => 'Save';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_close => 'Close';

  @override
  String get sunlight => 'Sunlight';

  @override
  String get water => 'Water';

  @override
  String get temperature => 'Temperature';

  @override
  String get giveWaterButton => 'Give Water';

  @override
  String get pruneButton => '가지치기';

  @override
  String get home_checkIn => 'Check-in';

  @override
  String get home_reflection => 'Reflection';

  @override
  String get home_letGo => 'Let Go';

  @override
  String get home_history => 'Archive';

  @override
  String get home_caring => 'Coaching';

  @override
  String get home_seeding => 'Check-in';

  @override
  String get home_sleep => 'Recovery Log';

  @override
  String home_garden_title_format(Object user) {
    return '$user\'s Condition Board';
  }

  @override
  String get home_question_default => 'How is your heart today?';

  @override
  String get home_question_tired => 'Are you pushing yourself too hard?';

  @override
  String get home_question_happy => 'Who do you want to share this joy with?';

  @override
  String get onboarding_step1Title =>
      'At this moment,\nwhat is the name of your heart?';

  @override
  String onboarding_step2Title(String emotion, String particle) {
    return 'Where did that \'$emotion\' come from?';
  }

  @override
  String get onboarding_step2Subtitle =>
      'Write briefly. This becomes your first condition signal.';

  @override
  String get onboarding_hint => 'Situation or reason...';

  @override
  String get onboarding_submit => 'Save signal';

  @override
  String onboarding_instructionTitle(String emotion, String particle) {
    return 'Your \'$emotion\' will now\nbloom into new life in this space.';
  }

  @override
  String get onboarding_instructionSubtitle =>
      'The honest heart you wrote\nis the only nutrient to bloom this child.';

  @override
  String get onboarding_finish => 'Start coaching';

  @override
  String get onboarding_transition_planted => 'Your first check-in is saved.';

  @override
  String get onboarding_transition_entering =>
      'Taking you to today’s guidance.';

  @override
  String get onboarding_emotions_joy => 'Joy';

  @override
  String get onboarding_emotions_sadness => 'Sadness';

  @override
  String get onboarding_emotions_anger => 'Anger';

  @override
  String get onboarding_emotions_anxiety => 'Anxiety';

  @override
  String get onboarding_emotions_peace => 'Peace';

  @override
  String get onboarding_identity_label => 'Ready to start FullCon';

  @override
  String get onboarding_identity_question => 'What should I call you?';

  @override
  String get onboarding_identity_hint => 'Enter name';

  @override
  String get onboarding_identity_submit => 'Next';

  @override
  String get seeding_instruction => 'Where is your condition right now?';

  @override
  String get seeding_promptTags => 'The words that best describe this state';

  @override
  String get seeding_promptNote =>
      'Leave a short note about why you feel this way...';

  @override
  String get seeding_buttonPlant => 'Save check-in';

  @override
  String get seeding_messagePlanted => 'Your condition check-in is saved.';

  @override
  String get seeding_mood_neutral => 'Neutral';

  @override
  String get seeding_mood_energized => 'Energized!';

  @override
  String get seeding_mood_stressed => 'Stressed!';

  @override
  String get seeding_mood_calm => 'Calm';

  @override
  String get seeding_mood_tired => 'Tired...';

  @override
  String get seeding_mood_angry => 'Angry';

  @override
  String get seeding_mood_anxious => 'Anxious';

  @override
  String get seeding_mood_excited => 'Excited';

  @override
  String get seeding_mood_joyful => 'Joyful';

  @override
  String get seeding_mood_passionate => 'Passionate';

  @override
  String get seeding_mood_surprised => 'Surprised';

  @override
  String get seeding_mood_relieved => 'Relieved';

  @override
  String get seeding_mood_resentful => 'Resentful';

  @override
  String get seeding_mood_overwhelmed => 'Overwhelmed';

  @override
  String get seeding_mood_jealous => 'Jealous';

  @override
  String get seeding_mood_annoyed => 'Annoyed';

  @override
  String get seeding_mood_sad => 'Sad';

  @override
  String get seeding_mood_disappointed => 'Disappointed';

  @override
  String get seeding_mood_bored => 'Bored';

  @override
  String get seeding_mood_lonely => 'Lonely';

  @override
  String get seeding_mood_guilty => 'Guilty';

  @override
  String get seeding_mood_envious => 'Envious';

  @override
  String get seeding_mood_proud => 'Proud';

  @override
  String get seeding_mood_inspired => 'Inspired';

  @override
  String get seeding_mood_enthusiastic => 'Enthusiastic';

  @override
  String get seeding_mood_curious => 'Curious';

  @override
  String get seeding_mood_amused => 'Amused';

  @override
  String get seeding_mood_relaxed => 'Relaxed';

  @override
  String get seeding_mood_grateful => 'Grateful';

  @override
  String get seeding_mood_content => 'Content';

  @override
  String get seeding_mood_serene => 'Serene';

  @override
  String get seeding_mood_trusting => 'Trusting';

  @override
  String get seeding_mood_reflective => 'Reflective';

  @override
  String get seeding_hint_trigger => 'What triggered this feeling?';

  @override
  String get seeding_hint_thought => 'What was your thought?';

  @override
  String get seeding_hint_tendency => 'What do you want to do now?';

  @override
  String get seeding_quadrant_energized => 'Energized';

  @override
  String get seeding_quadrant_calm => 'Calm';

  @override
  String get seeding_quadrant_tired => 'Tired';

  @override
  String get seeding_quadrant_stress => 'Stressed';

  @override
  String get onboarding_intro_message =>
      'Start your day\nwith today’s condition.';

  @override
  String get onboarding_found_space_title =>
      'Check energy and recovery fast,\nthen get the next suggestion.';

  @override
  String get onboarding_space_cleared => 'Ready to begin';

  @override
  String get onboarding_launch_cta => 'Start';

  @override
  String get onboarding_launch_caption =>
      'Your name and first check-in are enough to begin.';

  @override
  String get onboarding_preview_recovery_title => 'Recovery';

  @override
  String get onboarding_preview_recovery_body =>
      'Read sleep and wake quality to see your recovery flow.';

  @override
  String get onboarding_preview_checkin_title => 'Check-in';

  @override
  String get onboarding_preview_checkin_body =>
      'Start with fast energy and recovery signals.';

  @override
  String get onboarding_preview_coaching_title => 'Coaching';

  @override
  String get onboarding_preview_coaching_body => 'See what to do first today.';

  @override
  String get sleep_dive_title => 'Recovery Log';

  @override
  String get sleep_dive_subtitle => 'Let’s read today’s recovery state.';

  @override
  String get sleep_dive_description =>
      'Log your sleep and wake quality\nso tomorrow’s condition can be adjusted more precisely.';

  @override
  String get sleep_dive_bedtime_label => 'In Bed Time';

  @override
  String get sleep_dive_waketime_label => 'Wake Up Time';

  @override
  String get sleep_dive_latency_title => 'Time to Fall Asleep';

  @override
  String get sleep_dive_refreshment_title => 'How refreshed are you today?';

  @override
  String get sleep_dive_natural_wake => 'Woke up without alarm?';

  @override
  String get sleep_dive_immediate_wake => 'Got up right after alarm?';

  @override
  String get sleep_dive_factors_title => 'Sleep Impact Factors';

  @override
  String get sleep_dive_button_finish => 'Save recovery log';
}
