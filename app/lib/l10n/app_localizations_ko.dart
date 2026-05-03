// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '풀컨';

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
  String get home_checkIn => '체크인';

  @override
  String get home_reflection => 'Reflection';

  @override
  String get home_letGo => 'Let Go';

  @override
  String get home_history => '타임라인';

  @override
  String get home_caring => '코칭';

  @override
  String get home_seeding => '체크인';

  @override
  String get home_sleep => '회복 로그';

  @override
  String home_garden_title_format(Object user) {
    return '$user의 컨디션 보드';
  }

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
  String get onboarding_step2Subtitle => '짧게 적어주시면 첫 컨디션 신호가 됩니다.';

  @override
  String get onboarding_hint => '이유나 상황을 적어주세요...';

  @override
  String get onboarding_submit => '신호 저장';

  @override
  String onboarding_instructionTitle(String emotion, String particle) {
    return '당신의 \'$emotion\'$particle 이 공간 속에서\n새로운 생명으로 피어납니다.';
  }

  @override
  String get onboarding_instructionSubtitle =>
      '솔직하게 적어주신 그 마음이\n이 아이를 꽃피우게 할 유일한 영양분입니다.';

  @override
  String get onboarding_finish => '코칭 시작';

  @override
  String get onboarding_transition_planted => '첫 체크인을 저장했어요.';

  @override
  String get onboarding_transition_entering => '이제 오늘 제안을 확인하러 이동합니다.';

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
  String get onboarding_identity_label => '풀컨 시작 준비';

  @override
  String get onboarding_identity_question => '어떻게 불러드릴까요?';

  @override
  String get onboarding_identity_hint => '이름이나 닉네임';

  @override
  String get onboarding_identity_submit => '다음';

  @override
  String get seeding_instruction => '지금 컨디션은 어디쯤인가요?';

  @override
  String get seeding_promptTags => '지금 상태를 가장 잘 설명하는 단어';

  @override
  String get seeding_promptNote => '왜 이런 상태인지 짧게 남겨주세요...';

  @override
  String get seeding_buttonPlant => '체크인 저장';

  @override
  String get seeding_messagePlanted => '컨디션 체크인을 저장했어요.';

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
  String get seeding_mood_angry => '분노';

  @override
  String get seeding_mood_anxious => '불안';

  @override
  String get seeding_mood_excited => '신남';

  @override
  String get seeding_mood_joyful => '기쁨';

  @override
  String get seeding_mood_passionate => '열정';

  @override
  String get seeding_mood_surprised => '놀람';

  @override
  String get seeding_mood_relieved => '안도';

  @override
  String get seeding_mood_resentful => '억울함';

  @override
  String get seeding_mood_overwhelmed => '압도됨';

  @override
  String get seeding_mood_jealous => '질투';

  @override
  String get seeding_mood_annoyed => '짜증';

  @override
  String get seeding_mood_sad => '슬픔';

  @override
  String get seeding_mood_disappointed => '실망';

  @override
  String get seeding_mood_bored => '지루함';

  @override
  String get seeding_mood_lonely => '외로움';

  @override
  String get seeding_mood_guilty => '죄책감';

  @override
  String get seeding_mood_envious => '부러움';

  @override
  String get seeding_mood_proud => '뿌듯함';

  @override
  String get seeding_mood_inspired => '영감';

  @override
  String get seeding_mood_enthusiastic => '열의';

  @override
  String get seeding_mood_curious => '호기심';

  @override
  String get seeding_mood_amused => '즐거움';

  @override
  String get seeding_mood_relaxed => '편안함';

  @override
  String get seeding_mood_grateful => '감사';

  @override
  String get seeding_mood_content => '만족';

  @override
  String get seeding_mood_serene => '평온';

  @override
  String get seeding_mood_trusting => '신뢰';

  @override
  String get seeding_mood_reflective => '사색';

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

  @override
  String get onboarding_intro_message => '오늘 컨디션에 맞춰\n하루를 시작하세요.';

  @override
  String get onboarding_found_space_title =>
      '에너지와 회복을 빠르게 체크하고\n지금 필요한 제안을 받아보세요.';

  @override
  String get onboarding_space_cleared => '시작할 준비 완료';

  @override
  String get onboarding_launch_cta => '시작하기';

  @override
  String get onboarding_launch_caption => '이름과 첫 체크인만 마치면 됩니다.';

  @override
  String get onboarding_preview_recovery_title => '회복';

  @override
  String get onboarding_preview_recovery_body => '수면과 기상 상태를 읽어 회복 흐름을 봅니다.';

  @override
  String get onboarding_preview_checkin_title => '체크인';

  @override
  String get onboarding_preview_checkin_body => '에너지와 회복부터 빠르게 체크합니다.';

  @override
  String get onboarding_preview_coaching_title => '제안';

  @override
  String get onboarding_preview_coaching_body => '오늘 먼저 할 일을 바로 제안합니다.';

  @override
  String get sleep_dive_title => '회복 로그';

  @override
  String get sleep_dive_subtitle => '어젯밤 회복 상태를 확인해볼까요?';

  @override
  String get sleep_dive_description =>
      '수면과 기상 상태를 기록하면\n내일 컨디션을 더 정확하게 읽을 수 있어요.';

  @override
  String get sleep_dive_bedtime_label => '침대에 누운 시간';

  @override
  String get sleep_dive_waketime_label => '기상 시간';

  @override
  String get sleep_dive_latency_title => '잠들기까지 걸린 시간';

  @override
  String get sleep_dive_refreshment_title => '아침 컨디션은 어땠나요?';

  @override
  String get sleep_dive_natural_wake => '알람 없이 깼나요?';

  @override
  String get sleep_dive_immediate_wake => '알람을 끄고 바로 일어났나요?';

  @override
  String get sleep_dive_factors_title => '수면에 영향을 준 요인';

  @override
  String get sleep_dive_button_finish => '회복 로그 저장하기';
}
