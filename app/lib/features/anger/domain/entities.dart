/// 분노 기록 엔트리
class AngerEntry {
  final String id;
  final DateTime createdAt;
  final int intensityBefore; // 0..10
  final int? intensityAfter; // nullable
  final List<String> triggerTags; // e.g., ["work_meeting"]
  final String? withWhom; // "colleague", "family", etc.
  final String timeOfDay; // "AM" | "PM" | "EVENING" | ...
  final List<String> techniqueUsed; // ["box_breath"]

  const AngerEntry({
    required this.id,
    required this.createdAt,
    required this.intensityBefore,
    this.intensityAfter,
    required this.triggerTags,
    this.withWhom,
    required this.timeOfDay,
    this.techniqueUsed = const [],
  });

  /// 강도 변화 계산 (after - before)
  int? get intensityDelta => intensityAfter != null 
      ? intensityAfter! - intensityBefore 
      : null;

  /// 개선 여부 (강도가 낮아졌는지)
  bool? get isImproved => intensityDelta != null 
      ? intensityDelta! < 0 
      : null;
}

/// 코칭 질문
class CoachQuestion {
  final String category; // Calm, Reappraise, Needs, Boundaries, Pattern, Plan
  final String questionKey; // unique
  final String type; // quick | deep
  final String textKo;
  final String textEn;
  final List<String> placeholders; // ["trigger","withWhom"]
  final Map<String, dynamic> conditions; // {minIntensity:7, tagsAny:[...], timeOfDayAny:[...]}
  final int cooldownDays;
  final double weight;

  const CoachQuestion({
    required this.category,
    required this.questionKey,
    required this.type,
    required this.textKo,
    required this.textEn,
    required this.placeholders,
    required this.conditions,
    required this.cooldownDays,
    required this.weight,
  });

  /// 로케일에 따른 텍스트 반환
  String getLocalizedText(String languageCode) {
    return languageCode == 'ko' ? textKo : textEn;
  }
}

/// 코칭 질문 선택 결과
class CoachSelection {
  final List<CoachQuestion> questions; // 1 for quick, 3 for deep
  final String mode; // "quick" | "deep"

  const CoachSelection({
    required this.questions,
    required this.mode,
  });

  /// 첫 번째 질문 반환 (quick 모드용)
  CoachQuestion? get firstQuestion => questions.isNotEmpty ? questions.first : null;
}

/// 사용자 효과 점수
class UserEffectScore {
  // cumulated effectiveness per category or key, derived from Δ
  final Map<String, double> byCategory; // {"Calm": 1.2, ...}
  final Map<String, double> byQuestionKey;

  const UserEffectScore({
    required this.byCategory,
    required this.byQuestionKey,
  });

  /// 카테고리별 효과 점수 반환 (기본값 1.0)
  double getCategoryScore(String category) {
    return byCategory[category] ?? 1.0;
  }

  /// 질문 키별 효과 점수 반환 (기본값 1.0)
  double getQuestionKeyScore(String questionKey) {
    return byQuestionKey[questionKey] ?? 1.0;
  }
}

/// 코칭 Q&A
class CoachQA {
  final String id;
  final String entryId;
  final String category;
  final String questionKey;
  final Map<String, String> promptVars;
  final String? answerText;
  final DateTime createdAt;

  const CoachQA({
    required this.id,
    required this.entryId,
    required this.category,
    required this.questionKey,
    required this.promptVars,
    this.answerText,
    required this.createdAt,
  });
}
