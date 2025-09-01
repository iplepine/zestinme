import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../di/injection.dart';
import '../data/question_bank_loader.dart';
import '../data/coach_repository.dart';
import '../domain/entities.dart';
import '../domain/rule_engine.dart';
import 'widgets/quick_coach_card.dart';
import 'pages/deep_coach_page.dart';

/// 코칭 시스템 사용 예시
class CoachingUsageExample {
  /// 분노 기록 저장 후 Quick 코칭 카드 표시
  static void showQuickCoachingAfterSave(
    BuildContext context,
    AngerEntry entry,
  ) async {
    final loader = Injection.getIt<QuestionBankLoader>();
    final repository = Injection.getIt<CoachRepository>();
    try {
      // 1. 질문 뱅크 로드
      final questions = await loader.loadQuestions();

      // 2. 최근 QA와 효과 점수 로드
      final recentQAs = await repository.recentQAs(days: 14);
      final effectScores = await repository.loadEffectScores();

      // 3. 규칙 엔진으로 질문 선택
      final ruleEngine = RuleEngine(
        questions: questions,
        recentQAs: recentQAs,
        effect: effectScores,
      );

      final selection = ruleEngine.pickQuick(
        entry,
        Localizations.localeOf(context).languageCode,
      );

      if (selection.firstQuestion != null) {
        // 4. Quick 코칭 카드를 모달로 표시
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => QuickCoachCard(
            question: selection.firstQuestion!,
            entry: entry,
            onSubmit: (answer) async {
              // 답변 저장
              final qa = CoachQA(
                id: '${entry.id}_${selection.firstQuestion!.questionKey}_${DateTime.now().millisecondsSinceEpoch}',
                entryId: entry.id,
                category: selection.firstQuestion!.category,
                questionKey: selection.firstQuestion!.questionKey,
                promptVars: _extractPromptVars(entry),
                answerText: answer,
                createdAt: DateTime.now(),
              );

              await repository.saveQA(qa);

              // 토스트 메시지 표시
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('답변이 저장되었습니다.'),
                  duration: const Duration(seconds: 2),
                ),
              );

              // 모달 닫기
              Navigator.of(context).pop();
            },
            onSnooze: () {
              // 오늘 밤 알림 스케줄링
              _scheduleEveningReminder(context, entry);
              Navigator.of(context).pop();
            },
            onSkip: () {
              Navigator.of(context).pop();
            },
          ),
        );
      }
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('코칭 질문을 불러오는 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Deep 코칭 페이지로 이동
  static void navigateToDeepCoaching(
    BuildContext context,
    AngerEntry entry,
  ) async {
    final loader = Injection.getIt<QuestionBankLoader>();
    final repository = Injection.getIt<CoachRepository>();
    try {
      // 1. 질문 뱅크 로드
      final questions = await loader.loadQuestions();

      // 2. 최근 QA와 효과 점수 로드
      final recentQAs = await repository.recentQAs(days: 14);
      final effectScores = await repository.loadEffectScores();

      // 3. 규칙 엔진으로 Deep 질문 선택
      final ruleEngine = RuleEngine(
        questions: questions,
        recentQAs: recentQAs,
        effect: effectScores,
      );

      final selection = ruleEngine.pickDeep(
        entry,
        Localizations.localeOf(context).languageCode,
      );

      if (selection.questions.isNotEmpty) {
        // 4. Deep 코칭 페이지로 이동
        final result = await context.push<bool>(
          '/deep-coaching',
          extra: {
            'questions': selection.questions,
            'entry': entry,
            'repository': repository,
          },
        );

        // 완료 시 처리
        if (result == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('심화 코칭이 완료되었습니다.'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('심화 코칭을 불러오는 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 프롬프트 변수 추출
  static Map<String, String> _extractPromptVars(AngerEntry entry) {
    return {
      'trigger': entry.triggerTags.isNotEmpty
          ? entry.triggerTags.first
          : '이 상황',
      'withWhom': entry.withWhom ?? '상대방',
      'timeOfDay': entry.timeOfDay,
      'intensity': entry.intensityBefore.toString(),
    };
  }

  /// 오늘 밤 알림 스케줄링
  static void _scheduleEveningReminder(BuildContext context, AngerEntry entry) {
    // 실제 구현에서는 로컬 알림이나 푸시 알림을 사용
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('오늘 밤 8시에 코칭 알림을 설정했습니다.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// 통합 예시: 분노 기록 저장 후 자동으로 코칭 시작
class AngerRecordIntegrationExample {
  static void saveAngerRecordAndStartCoaching(
    BuildContext context,
    AngerEntry entry,
  ) async {
    try {
      // 1. 분노 기록 저장 (실제 구현에서는 별도 repository 사용)
      // await angerRepository.saveEntry(entry);

      // 2. Quick 코칭 시작
      CoachingUsageExample.showQuickCoachingAfterSave(context, entry);

      // 3. Deep 코칭은 사용자가 선택할 수 있도록 버튼 제공
      // 또는 자동으로 밤에 푸시 알림
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('분노 기록 저장 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
