// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'ZestInMe';

  @override
  String get coaching_answerNow => '지금 답변하기';

  @override
  String get coaching_tonight => '오늘 밤에';

  @override
  String get coaching_skip => '건너뛰기';

  @override
  String get coaching_previous => '이전';

  @override
  String get coaching_next => '다음';

  @override
  String get coaching_finish => '완료';

  @override
  String get coaching_deepCoaching => '심화 코칭';

  @override
  String get coaching_enterAnswer => '답변을 입력해주세요...';

  @override
  String get coaching_enterDetailedAnswer => '자세한 답변을 입력해주세요...';

  @override
  String get coaching_helpText => '마음껏 표현해보세요. 정답은 없습니다.';

  @override
  String get coaching_errorSaving => '저장 중 오류가 발생했습니다.';

  @override
  String get coaching_progress => '진행률';

  @override
  String get categories_calm => '진정';

  @override
  String get categories_reappraise => '재평가';

  @override
  String get categories_needs => '욕구';

  @override
  String get categories_boundaries => '경계';

  @override
  String get categories_pattern => '패턴';

  @override
  String get categories_plan => '계획';

  @override
  String get common_loading => '로딩 중...';

  @override
  String get common_error => '오류';

  @override
  String get common_success => '성공';

  @override
  String get common_cancel => '취소';

  @override
  String get common_confirm => '확인';

  @override
  String get common_save => '저장';

  @override
  String get common_delete => '삭제';

  @override
  String get common_edit => '편집';

  @override
  String get common_close => '닫기';

  @override
  String get sunlight => '햇빛';

  @override
  String get water => '수분';

  @override
  String get temperature => '온도';

  @override
  String get giveWaterButton => '물 주기';

  @override
  String get pruneButton => '가지치기';

  @override
  String get home_checkIn => 'Check-in';

  @override
  String get home_reflection => 'Reflection';

  @override
  String get home_letGo => 'Let Go';

  @override
  String get home_history => 'History';

  @override
  String get home_question_default => 'How is your heart today?';

  @override
  String get home_question_tired => 'Are you pushing yourself too hard?';

  @override
  String get home_question_happy => 'Who do you want to share this joy with?';

  @override
  String get onboarding_step1Title => '지금 이 순간,\n당신의 마음은 어떤 이름인가요?';

  @override
  String onboarding_step2Title(String emotion, String particle) {
    return '그 \'$emotion\'$particle\n어디에서 시작되었나요?';
  }

  @override
  String get onboarding_step2Subtitle => '짧게 적어주시면, 마음의 씨앗이 됩니다.';

  @override
  String get onboarding_hint => '이유나 상황을 적어주세요...';

  @override
  String get onboarding_submit => '마음 담기';

  @override
  String onboarding_instructionTitle(String emotion, String particle) {
    return '당신의 \'$emotion\'$particle 이 화분 속에서\n새로운 생명으로 피어납니다.';
  }

  @override
  String get onboarding_instructionSubtitle =>
      '솔직하게 적어주신 그 마음이\n이 아이를 꽃피우게 할 유일한 영양분입니다.';

  @override
  String get onboarding_finish => '함께 키워가기';

  @override
  String get onboarding_transition_planted => '마음의 씨앗이 무사히 심어졌습니다.';

  @override
  String get onboarding_transition_entering => '이제, 당신만의 안식처로 안내합니다.';

  @override
  String get onboarding_emotions_joy => '기쁨';

  @override
  String get onboarding_emotions_sadness => '슬픔';

  @override
  String get onboarding_emotions_anger => '화남';

  @override
  String get onboarding_emotions_anxiety => '불안';

  @override
  String get onboarding_emotions_peace => '평온';

  @override
  String get seeding_instruction => '지금 당신의 마음은\n어디에 있나요?';

  @override
  String get seeding_promptTags => '이 감정은 마치...';

  @override
  String get seeding_promptNote => '어떤 상황인지 기록해주세요...';

  @override
  String get seeding_buttonPlant => '씨앗 심기';

  @override
  String get seeding_messagePlanted => '마음의 씨앗을 심었습니다! 🌱';

  @override
  String get seeding_mood_neutral => '중립';

  @override
  String get seeding_mood_energized => '활기참!';

  @override
  String get seeding_mood_stressed => '스트레스!';

  @override
  String get seeding_mood_calm => '차분함';

  @override
  String get seeding_mood_tired => '지침...';

  @override
  String get seeding_mood_angry => '화난';

  @override
  String get seeding_mood_anxious => '불안한';

  @override
  String get seeding_mood_excited => '신나는';

  @override
  String get seeding_mood_joyful => '기쁨';

  @override
  String get seeding_mood_passionate => '열정';

  @override
  String get seeding_mood_surprised => '놀람';

  @override
  String get seeding_mood_relieved => '안도';

  @override
  String get seeding_mood_resentful => '억울한';

  @override
  String get seeding_mood_overwhelmed => '압도된';

  @override
  String get seeding_mood_jealous => '질투나는';

  @override
  String get seeding_mood_annoyed => '짜증난';

  @override
  String get seeding_mood_sad => '슬픈';

  @override
  String get seeding_mood_disappointed => '실망한';

  @override
  String get seeding_mood_bored => '지루한';

  @override
  String get seeding_mood_lonely => '외로운';

  @override
  String get seeding_mood_guilty => '죄책감';

  @override
  String get seeding_mood_envious => '부러운';

  @override
  String get seeding_mood_proud => '자랑스러운';

  @override
  String get seeding_mood_inspired => '영감 받은';

  @override
  String get seeding_mood_enthusiastic => '열정적인';

  @override
  String get seeding_mood_curious => '호기심 찬';

  @override
  String get seeding_mood_amused => '유쾌한';

  @override
  String get seeding_mood_relaxed => '편안한';

  @override
  String get seeding_mood_grateful => '감사하는';

  @override
  String get seeding_mood_content => '만족스러운';

  @override
  String get seeding_mood_serene => '평온한';

  @override
  String get seeding_mood_trusting => '신뢰하는';

  @override
  String get seeding_mood_reflective => '사색적인';

  @override
  String get seeding_hint_trigger => '무엇이 이 기분을 만들었나요?';

  @override
  String get seeding_hint_thought => '그 순간 어떤 생각이 들었나요?';

  @override
  String get seeding_hint_tendency => '지금 하고 싶은 것이 있나요?';

  @override
  String get seeding_quadrant_energized => '활기참';

  @override
  String get seeding_quadrant_calm => '차분함';

  @override
  String get seeding_quadrant_tired => '지침';

  @override
  String get seeding_quadrant_stress => '스트레스';
}
