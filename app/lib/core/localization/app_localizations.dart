import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ko', 'KR'), // Korean
    Locale('en', 'US'), // English
  ];

  // Onboarding Accessor
  late final OnboardingLocalizations onboarding = OnboardingLocalizations(this);

  String _get(String key) => _localizedValues[locale.languageCode]![key] ?? key;

  // Existing getters...
  String get appName => _get('appName');
  String get goodMorning => _get('goodMorning');
  String get recordEmotionToday => _get('recordEmotionToday');
  String get recordEmotionButton => _get('recordEmotionButton');
  String get weeklyStats => _get('weeklyStats');
  String get weeklyStatsInsight => _get('weeklyStatsInsight');
  String get dailyQuestion => _get('dailyQuestion');
  String get dailyQuestionText => _get('dailyQuestionText');
  String get answerButton => _get('answerButton');
  String get activeChallenges => _get('activeChallenges');
  String get noActiveChallenges => _get('noActiveChallenges');
  String get startNewChallenge => _get('startNewChallenge');
  String get moreChallenges => _get('moreChallenges');
  String get progressText => _get('progressText');

  // Dashboard Getters
  String get sunlight => _get('sunlight');
  String get water => _get('water');
  String get temperature => _get('temperature');
  String get giveWaterButton => _get('giveWaterButton');
  String get pruneButton => _get('pruneButton');

  // Home Screen Getters
  // Home Screen Getters
  String get homeCheckIn => _get('home_checkIn');
  String get homeReflection => _get('home_reflection');
  String get homeLetGo => _get('home_letGo');
  String get homeHistory => _get('home_history');
  String get homeSeeding => _get('home_seeding');
  String get homeSleep => _get('home_sleep');
  String get homeCaring => _get('home_caring');
  String get homeGardenTitleFormat => _get('home_garden_title_format');

  // New Home UI (Minimalism)
  String get homeTabHome => _get('home_tab_home');
  String get homeTabLogs => _get('home_tab_logs');
  String get homeTabDiscovery => _get('home_tab_discovery');
  String get homeTabRest => _get('home_tab_rest'); // Changed from Settings

  String get homeFocusTitle => _get('home_focus_title');
  String get homeFocusSleepPattern => _get('home_focus_sleep_pattern');
  String get homeFocusDayCount => _get('home_focus_day_count');
  String get homeCtaRecordEmotion => _get('home_cta_record_emotion');

  // Time/Status Vibe
  String get homeStatusMorning => _get('home_status_morning');
  String get homeStatusAfternoon => _get('home_status_afternoon');
  String get homeStatusEvening => _get('home_status_evening');
  String get homeStatusNight => _get('home_status_night');

  // Sleep Diving
  String get sleepDiveTitle => _get('sleep_dive_title');
  String get sleepDiveSubtitle => _get('sleep_dive_subtitle');
  String get sleepDiveDescription => _get('sleep_dive_description');
  String get sleepDiveBedtimeLabel => _get('sleep_dive_bedtime_label');
  String get sleepDiveWaketimeLabel => _get('sleep_dive_waketime_label');
  String get sleepDiveLatencyTitle => _get('sleep_dive_latency_title');
  String get sleepDiveRefreshmentTitle => _get('sleep_dive_refreshment_title');
  String get sleepDiveNaturalWake => _get('sleep_dive_natural_wake');
  String get sleepDiveImmediateWake => _get('sleep_dive_immediate_wake');
  String get sleepDiveFactorsTitle => _get('sleep_dive_factors_title');
  String get sleepDiveButtonFinish => _get('sleep_dive_button_finish');

  String get homeQuestionDefault => _get('home_question_default');
  String get homeQuestionTired => _get('home_question_tired');
  String get homeQuestionHappy => _get('home_question_happy');

  static Map<String, Map<String, String>> get _localizedValues => {
    'ko': {
      'appName': '풀컨',
      'goodMorning': 'Good Morning, 영도자님 🌞',
      'recordEmotionToday': '오늘의 감정을 기록해볼까요?',
      'recordEmotionButton': '😊 감정 기록하기',
      'weeklyStats': '이번 주: 행복 3, 피곤 2',
      'weeklyStatsInsight': '(가볍게 한눈에 보는 인사이트)',
      'dailyQuestion': '오늘의 질문',
      'dailyQuestionText': '오늘 고마웠던 순간은?',
      'answerButton': '답변하기',
      'activeChallenges': '진행 중인 챌린지 카드',
      'noActiveChallenges': '진행 중인 챌린지가 없습니다',
      'startNewChallenge': '새로운 챌린지를 시작해보세요!',
      'moreChallenges': '더 많은 챌린지 보기',
      'progressText': '진행',

      // Dashboard Keys
      'sunlight': '햇빛',
      'water': '수분',
      'temperature': '온도',
      'giveWaterButton': '물 주기',
      'pruneButton': '가지치기',

      // Home Screen - Insight Tools
      // Home Screen - Insight Tools
      'home_checkIn': '퀵 체크',
      'home_reflection': '깊은 기록',
      'home_letGo': '비워내기',
      'home_history': '아카이브',
      'home_seeding': '마음 기록',
      'home_sleep': '회복 로그',
      'home_caring': '다듬기',
      'home_garden_title_format': '{user}의 내면 정원',

      'home_tab_home': '홈',
      'home_tab_logs': '기록',
      'home_tab_discovery': '발견',
      'home_tab_rest': '휴식', // Changed from 설정
      'home_focus_title': '이번에 살펴보는 것',
      'home_focus_sleep_pattern': '💤 나의 수면 패턴',
      'home_focus_day_count': '4일째 관찰 중',
      'home_cta_record_emotion': '오늘의 기록', // Changed from 감정 기록하기

      'home_status_morning': 'Morning',
      'home_status_afternoon': 'Afternoon',
      'home_status_evening': 'Evening',
      'home_status_night': 'Night',

      'sleep_dive_title': '회복 로그',
      'sleep_dive_subtitle': '어젯밤 회복 상태를 확인해볼까요?',
      'sleep_dive_description': '수면과 기상 상태를 기록하면\n내일 컨디션을 더 정확하게 읽을 수 있어요.',
      'sleep_dive_bedtime_label': '침대에 누운 시간',
      'sleep_dive_waketime_label': '기상 시간',
      'sleep_dive_latency_title': '잠들기까지 걸린 시간',
      'sleep_dive_refreshment_title': '아침 컨디션은 어땠나요?',
      'sleep_dive_natural_wake': '알람 없이 깼나요?',
      'sleep_dive_immediate_wake': '알람을 끄고 바로 일어났나요?',
      'sleep_dive_factors_title': '수면에 영향을 준 요인',
      'sleep_dive_button_finish': '회복 로그 저장하기',

      // Home Screen - Self-Talk Questions
      'home_question_default': '오늘 당신의 마음은 어떤가요?',
      'home_question_tired': '혹시 지금 너무 애쓰고 있지 않나요?',
      'home_question_happy': '이 기쁨을 누구와 나누고 싶나요?',

      // Onboarding
      'onboarding_step1Title': '지금 이 순간,\n당신의 마음은 어떤 이름인가요?',
      'onboarding_step2Title': "그 '{emotion}'{particle}\n어디에서 시작되었나요?",
      'onboarding_step2Subtitle': '짧게 적어주시면, 마음의 씨앗이 됩니다.',
      'onboarding_hint': '이유나 상황을 적어주세요...',
      'onboarding_submit': '마음 담기',
      'onboarding_instructionTitle':
          "당신의 '{emotion}'{particle} 이\n새로운 생명으로 피어납니다.",
      'onboarding_instructionSubtitle':
          '솔직하게 적어주신 그 마음이\n이 아이를 꽃피우게 할 유일한 영양분입니다.',
      'onboarding_finish': '함께 키워가기',
      'onboarding_transition_planted': '마음의 씨앗이 무사히 심어졌습니다.',
      'onboarding_transition_entering': '이제, 당신만의 안식처로 안내합니다.',

      // Emotions
      'onboarding_emotion_joy': '기쁨',
      'onboarding_emotion_sadness': '슬픔',
      'onboarding_emotion_anger': '화남',
      'onboarding_emotion_anxiety': '불안',
      'onboarding_emotion_peace': '평온',
    },
    'en': {
      'appName': 'FullCon',
      'goodMorning': 'Good Morning, User 🌞',
      'recordEmotionToday': 'How about recording your emotions today?',
      'recordEmotionButton': '😊 Record Emotion',
      'weeklyStats': 'This week: Happy 3, Tired 2',
      'weeklyStatsInsight': '(Quick insight at a glance)',
      'dailyQuestion': 'Today\'s Question',
      'dailyQuestionText': 'What moment made you grateful today?',
      'answerButton': 'Answer',
      'activeChallenges': 'Active Challenge Cards',
      'noActiveChallenges': 'No active challenges',
      'startNewChallenge': 'Start a new challenge!',
      'moreChallenges': 'View More Challenges',
      'progressText': 'Progress',

      // Dashboard Keys
      'sunlight': 'Sunlight',
      'water': 'Water',
      'temperature': 'Temperature',
      'giveWaterButton': 'Give Water',
      'pruneButton': 'Prune',

      // Home Screen - Insight Tools
      // Home Screen - Insight Tools
      'home_checkIn': 'Check-in',
      'home_reflection': 'Reflection',
      'home_letGo': 'Let Go',
      'home_history': 'Archive',
      'home_seeding': 'Record Mind',
      'home_sleep': 'Sleep Diving',
      'home_caring': 'Pruning',
      'home_garden_title_format': '{user}\'s Inner Garden',

      'home_tab_home': 'Home',
      'home_tab_logs': 'Logs',
      'home_tab_discovery': 'Discovery',
      'home_tab_rest': 'Rest', // Changed from Settings
      'home_focus_title': 'Currently Focusing On',
      'home_focus_sleep_pattern': '💤 My Sleep Pattern',
      'home_focus_day_count': 'Day 4 of Observation',
      'home_cta_record_emotion': 'Today\'s Log', // Changed from Record Emotion

      'home_status_morning': 'Morning',
      'home_status_afternoon': 'Afternoon',
      'home_status_evening': 'Evening',
      'home_status_night': 'Night',

      'sleep_dive_title': 'Sleep Diving',
      'sleep_dive_subtitle': 'How is my sleep rhythm?',
      'sleep_dive_description':
          'Discover your golden sleep hour\nthrough a week of intentional observation.',
      'sleep_dive_bedtime_label': 'In Bed Time',
      'sleep_dive_waketime_label': 'Wake Up Time',
      'sleep_dive_latency_title': 'Time to Fall Asleep',
      'sleep_dive_refreshment_title': 'How refreshed are you today?',
      'sleep_dive_natural_wake': 'Woke up without alarm?',
      'sleep_dive_immediate_wake': 'Got up right after alarm?',
      'sleep_dive_factors_title': 'Sleep Impact Factors',
      'sleep_dive_button_finish': 'Dive Complete',

      // Home Screen - Self-Talk Questions
      'home_question_default': 'How is your heart today?',
      'home_question_tired': 'Are you pushing yourself too hard?',
      'home_question_happy': 'Who do you want to share this joy with?',

      // Onboarding
      'onboarding_step1Title':
          'At this moment,\nwhat is the name of your heart?',
      'onboarding_step2Title': "Where did that '{emotion}' come from?",
      'onboarding_step2Subtitle': 'Write briefly, it will become a mind seed.',
      'onboarding_hint': 'Situation or reason...',
      'onboarding_submit': 'Plant Mind',
      'onboarding_instructionTitle':
          "Your '{emotion}' will now\nbloom into new life here.",
      'onboarding_instructionSubtitle':
          'The honest heart you wrote\nis the only nutrient to bloom this child.',
      'onboarding_finish': 'Grow Together',
      'onboarding_transition_planted': 'The mind seed has been planted safely.',
      'onboarding_transition_entering': 'Now, guiding you to your sanctuary.',

      // Emotions
      'onboarding_emotion_joy': 'Joy',
      'onboarding_emotion_sadness': 'Sadness',
      'onboarding_emotion_anger': 'Anger',
      'onboarding_emotion_anxiety': 'Anxiety',
      'onboarding_emotion_peace': 'Peace',
    },
  };
}

class OnboardingLocalizations {
  final AppLocalizations _l10n;
  late final EmotionsLocalizations emotions = EmotionsLocalizations(_l10n);

  OnboardingLocalizations(this._l10n);

  String get step1Title => _l10n._get('onboarding_step1Title');
  String get step2Subtitle => _l10n._get('onboarding_step2Subtitle');
  String get hint => _l10n._get('onboarding_hint');
  String get submit => _l10n._get('onboarding_submit');
  String get instructionSubtitle =>
      _l10n._get('onboarding_instructionSubtitle');
  String get finish => _l10n._get('onboarding_finish');
  String get transitionPlanted => _l10n._get('onboarding_transition_planted');
  String get transitionEntering => _l10n._get('onboarding_transition_entering');

  String step2Title(String emotion, String particle) {
    var text = _l10n._get('onboarding_step2Title');
    text = text.replaceAll('{emotion}', emotion);
    text = text.replaceAll('{particle}', particle);
    return text;
  }

  String instructionTitle(String emotion, String particle) {
    var text = _l10n._get('onboarding_instructionTitle');
    text = text.replaceAll('{emotion}', emotion);
    text = text.replaceAll('{particle}', particle);
    return text;
  }
}

class EmotionsLocalizations {
  final AppLocalizations _l10n;
  EmotionsLocalizations(this._l10n);

  String get joy => _l10n._get('onboarding_emotion_joy');
  String get sadness => _l10n._get('onboarding_emotion_sadness');
  String get anger => _l10n._get('onboarding_emotion_anger');
  String get anxiety => _l10n._get('onboarding_emotion_anxiety');
  String get peace => _l10n._get('onboarding_emotion_peace');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ko', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
