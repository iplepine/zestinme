import 'dart:math';
import 'entities.dart';

/// 코칭 질문 선택을 위한 규칙 엔진
class RuleEngine {
  final List<CoachQuestion> questions;
  final List<CoachQA> recentQAs;
  final UserEffectScore effect;

  RuleEngine({
    required this.questions,
    required this.recentQAs,
    required this.effect,
  });

  /// Quick 모드 질문 선택 (1개)
  CoachSelection pickQuick(AngerEntry entry, String languageCode) {
    final filteredQuestions = _filterQuestions(entry, 'quick');
    final scoredQuestions = _scoreQuestions(filteredQuestions, entry);
    final selectedQuestion = _selectQuestion(scoredQuestions, entry.id);
    
    return CoachSelection(
      questions: selectedQuestion != null ? [selectedQuestion] : [],
      mode: 'quick',
    );
  }

  /// Deep 모드 질문 선택 (3개)
  CoachSelection pickDeep(AngerEntry entry, String languageCode) {
    final filteredQuestions = _filterQuestions(entry, 'deep');
    final scoredQuestions = _scoreQuestions(filteredQuestions, entry);
    final selectedQuestions = _selectMultipleQuestions(scoredQuestions, entry.id, 3);
    
    return CoachSelection(
      questions: selectedQuestions,
      mode: 'deep',
    );
  }

  /// 조건에 맞는 질문들 필터링
  List<CoachQuestion> _filterQuestions(AngerEntry entry, String type) {
    return questions.where((question) {
      // 타입 필터
      if (question.type != type) return false;
      
      // 쿨다운 필터 (최근에 사용된 질문 제외)
      if (_isQuestionInCooldown(question.questionKey)) return false;
      
      // 조건 필터
      return _meetsConditions(question.conditions, entry);
    }).toList();
  }

  /// 질문이 쿨다운 기간에 있는지 확인
  bool _isQuestionInCooldown(String questionKey) {
    final now = DateTime.now();
    final cooldownDays = questions
        .firstWhere((q) => q.questionKey == questionKey)
        .cooldownDays;
    
    return recentQAs.any((qa) {
      if (qa.questionKey != questionKey) return false;
      return daysBetween(qa.createdAt, now) < cooldownDays;
    });
  }

  /// 조건 충족 여부 확인
  bool _meetsConditions(Map<String, dynamic> conditions, AngerEntry entry) {
    // 강도 조건
    if (conditions.containsKey('minIntensity')) {
      final minIntensity = conditions['minIntensity'] as int;
      if (entry.intensityBefore < minIntensity) return false;
    }
    
    if (conditions.containsKey('maxIntensity')) {
      final maxIntensity = conditions['maxIntensity'] as int;
      if (entry.intensityBefore > maxIntensity) return false;
    }
    
    // 태그 조건
    if (conditions.containsKey('tagsAny')) {
      final requiredTags = List<String>.from(conditions['tagsAny']);
      final hasMatchingTag = entry.triggerTags.any((tag) => requiredTags.contains(tag));
      if (!hasMatchingTag) return false;
    }
    
    // 시간대 조건
    if (conditions.containsKey('timeOfDayAny')) {
      final allowedTimes = List<String>.from(conditions['timeOfDayAny']);
      if (!allowedTimes.contains(entry.timeOfDay)) return false;
    }
    
    return true;
  }

  /// 질문들에 점수 부여
  List<ScoredQuestion> _scoreQuestions(List<CoachQuestion> questions, AngerEntry entry) {
    return questions.map((question) {
      double score = question.weight;
      
      // 카테고리 효과 점수 적용
      score *= effect.getCategoryScore(question.category);
      
      // 질문 키 효과 점수 적용
      score *= effect.getQuestionKeyScore(question.questionKey);
      
      // 강도 밴드에 따른 카테고리 우선순위
      score *= _getIntensityBandMultiplier(entry.intensityBefore, question.category);
      
      // 태그 기반 라우팅 점수
      score *= _getTagRoutingMultiplier(entry.triggerTags, question.category);
      
      return ScoredQuestion(question: question, score: score);
    }).toList();
  }

  /// 강도 밴드에 따른 카테고리 우선순위
  double _getIntensityBandMultiplier(int intensity, String category) {
    final band = _getIntensityBand(intensity);
    
    switch (band) {
      case 2: // 높은 강도 (7-10)
        switch (category) {
          case 'Calm': return 1.5;
          case 'Reappraise': return 1.3;
          case 'Needs': return 1.2;
          default: return 1.0;
        }
      case 1: // 중간 강도 (4-6)
        switch (category) {
          case 'Needs': return 1.4;
          case 'Boundaries': return 1.3;
          case 'Plan': return 1.2;
          default: return 1.0;
        }
      case 0: // 낮은 강도 (1-3)
        switch (category) {
          case 'Pattern': return 1.4;
          case 'Plan': return 1.3;
          default: return 1.0;
        }
      default:
        return 1.0;
    }
  }

  /// 태그 기반 라우팅 점수
  double _getTagRoutingMultiplier(List<String> tags, String category) {
    for (final tag in tags) {
      switch (tag) {
        case 'work_meeting':
          if (category == 'Boundaries' || category == 'Reappraise') return 1.3;
          break;
        case 'traffic':
          if (category == 'Plan' || category == 'Calm') return 1.2;
          break;
        case 'sleep_debt':
          if (category == 'Calm' || category == 'Pattern') return 1.2;
          break;
      }
    }
    return 1.0;
  }

  /// 단일 질문 선택
  CoachQuestion? _selectQuestion(List<ScoredQuestion> scoredQuestions, String entryId) {
    if (scoredQuestions.isEmpty) return null;
    
    // 결정적 샘플링을 위한 시드 생성
    final seed = entryId.hashCode;
    final random = Random(seed);
    
    // 가중치 기반 선택
    final totalWeight = scoredQuestions.fold(0.0, (sum, sq) => sum + sq.score);
    var randomValue = random.nextDouble() * totalWeight;
    
    for (final scoredQuestion in scoredQuestions) {
      randomValue -= scoredQuestion.score;
      if (randomValue <= 0) {
        return scoredQuestion.question;
      }
    }
    
    // 마지막 질문 반환 (부동소수점 오차 방지)
    return scoredQuestions.last.question;
  }

  /// 여러 질문 선택 (Deep 모드용)
  List<CoachQuestion> _selectMultipleQuestions(
    List<ScoredQuestion> scoredQuestions,
    String entryId,
    int count,
  ) {
    if (scoredQuestions.isEmpty) return [];
    
    final selectedQuestions = <CoachQuestion>[];
    final selectedCategories = <String>{};
    final seed = entryId.hashCode;
    final random = Random(seed);
    
    // 점수 순으로 정렬
    scoredQuestions.sort((a, b) => b.score.compareTo(a.score));
    
    // 최대한 다른 카테고리에서 선택
    for (final scoredQuestion in scoredQuestions) {
      if (selectedQuestions.length >= count) break;
      
      final category = scoredQuestion.question.category;
      
      // 이미 선택된 카테고리면 건너뛰기 (다양성 확보)
      if (selectedCategories.contains(category)) {
        // 30% 확률로 선택 (다양성과 품질의 균형)
        if (random.nextDouble() < 0.3) {
          selectedQuestions.add(scoredQuestion.question);
          selectedCategories.add(category);
        }
      } else {
        selectedQuestions.add(scoredQuestion.question);
        selectedCategories.add(category);
      }
    }
    
    return selectedQuestions;
  }

  /// 강도 밴드 반환 (0: 낮음, 1: 중간, 2: 높음)
  int _getIntensityBand(int intensity) {
    if (intensity >= 7) return 2;
    if (intensity >= 4) return 1;
    return 0;
  }

  /// 두 날짜 사이의 일수 계산
  int daysBetween(DateTime a, DateTime b) {
    return (b.difference(a).inHours / 24).round();
  }

  /// 플레이스홀더 적용
  String applyPlaceholders(String text, AngerEntry entry) {
    var result = text;
    
    // {trigger} 플레이스홀더
    if (result.contains('{trigger}')) {
      final trigger = entry.triggerTags.isNotEmpty 
          ? entry.triggerTags.first 
          : '이 상황';
      result = result.replaceAll('{trigger}', trigger);
    }
    
    // {withWhom} 플레이스홀더
    if (result.contains('{withWhom}')) {
      final withWhom = entry.withWhom ?? '상대방';
      result = result.replaceAll('{withWhom}', withWhom);
    }
    
    return result;
  }
}

/// 점수가 매겨진 질문
class ScoredQuestion {
  final CoachQuestion question;
  final double score;

  ScoredQuestion({
    required this.question,
    required this.score,
  });
}
