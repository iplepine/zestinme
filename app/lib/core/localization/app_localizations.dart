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
  String get homeCheckIn => _get('home_checkIn');
  String get homeReflection => _get('home_reflection');
  String get homeLetGo => _get('home_letGo');
  String get homeHistory => _get('home_history');

  String get homeQuestionDefault => _get('home_question_default');
  String get homeQuestionTired => _get('home_question_tired');
  String get homeQuestionHappy => _get('home_question_happy');

  static Map<String, Map<String, String>> get _localizedValues => {
    'ko': {
      'appName': 'ZestInMe',
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
      'home_checkIn': '퀵 체크',
      'home_reflection': '깊은 기록',
      'home_letGo': '비워내기',
      'home_history': '회고',

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
          "당신의 '{emotion}'{particle} 이 화분 속에서\n새로운 생명으로 피어납니다.",
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
      'appName': 'ZestInMe',
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
      'home_checkIn': 'Check-in',
      'home_reflection': 'Reflection',
      'home_letGo': 'Let Go',
      'home_history': 'History',

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
