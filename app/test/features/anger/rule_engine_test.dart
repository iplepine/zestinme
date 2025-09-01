import 'package:flutter_test/flutter_test.dart';
import 'package:zestinme/features/anger/domain/entities.dart';
import 'package:zestinme/features/anger/domain/rule_engine.dart';

void main() {
  group('RuleEngine Tests', () {
    late List<CoachQuestion> testQuestions;
    late List<CoachQA> testRecentQAs;
    late UserEffectScore testEffectScore;
    late RuleEngine ruleEngine;

    setUp(() {
      // 테스트용 질문들 생성
      testQuestions = [
        CoachQuestion(
          category: 'Calm',
          questionKey: 'calm.body_signal.v1',
          type: 'quick',
          textKo: '지금 몸에서 가장 강한 신호는 하나만 고르세요.',
          textEn: 'Pick the strongest body signal right now.',
          placeholders: [],
          conditions: {'minIntensity': 7},
          cooldownDays: 14,
          weight: 1.0,
        ),
        CoachQuestion(
          category: 'Boundaries',
          questionKey: 'boundaries.assertive_sentence.v1',
          type: 'deep',
          textKo: '예의 있게 단호한 한 문장을 만들어보세요.',
          textEn: 'Write one polite, assertive sentence.',
          placeholders: [],
          conditions: {'tagsAny': ['work_meeting']},
          cooldownDays: 14,
          weight: 1.0,
        ),
        CoachQuestion(
          category: 'Plan',
          questionKey: 'plan.if_then_when.v1',
          type: 'quick',
          textKo: '만약 {trigger}라면, 즉시 무엇을 하시겠어요? 한 문장으로.',
          textEn: 'If {trigger}, what will you do immediately? One sentence.',
          placeholders: ['trigger'],
          conditions: {},
          cooldownDays: 7,
          weight: 1.2,
        ),
        CoachQuestion(
          category: 'Pattern',
          questionKey: 'pattern.halt_check.v1',
          type: 'quick',
          textKo: 'HALT 체크: 지금 배고픈가요(Hungry)? 화난가요(Angry)? 외로운가요(Lonely)? 피곤한가요(Tired)?',
          textEn: 'HALT check: Are you Hungry, Angry, Lonely, or Tired right now?',
          placeholders: [],
          conditions: {'tagsAny': ['sleep_debt']},
          cooldownDays: 7,
          weight: 1.4,
        ),
      ];

      // 테스트용 최근 QA들 생성
      testRecentQAs = [
        CoachQA(
          id: 'qa1',
          entryId: 'entry1',
          category: 'Calm',
          questionKey: 'calm.body_signal.v1',
          promptVars: {},
          answerText: '답변1',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      // 테스트용 효과 점수 생성
      testEffectScore = const UserEffectScore(
        byCategory: {
          'Calm': 1.2,
          'Boundaries': 1.1,
          'Plan': 1.3,
        },
        byQuestionKey: {
          'calm.body_signal.v1': 1.1,
          'plan.if_then_when.v1': 1.4,
        },
      );

      ruleEngine = RuleEngine(
        questions: testQuestions,
        recentQAs: testRecentQAs,
        effect: testEffectScore,
      );
    });

    group('pickQuick()', () {
      test('강도 8이고 기법을 사용하지 않은 경우 Calm 질문을 반환해야 함', () {
        final entry = AngerEntry(
          id: 'test_entry_1',
          createdAt: DateTime.now(),
          intensityBefore: 8,
          triggerTags: ['work_meeting'],
          withWhom: 'colleague',
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection = ruleEngine.pickQuick(entry, 'ko');

        expect(selection.mode, equals('quick'));
        expect(selection.questions, hasLength(1));
        expect(selection.questions.first.category, equals('Calm'));
        expect(selection.questions.first.questionKey, equals('calm.body_signal.v1'));
      });

      test('work_meeting 태그가 있는 경우 Boundaries/Reappraise를 우선해야 함', () {
        final entry = AngerEntry(
          id: 'test_entry_2',
          createdAt: DateTime.now(),
          intensityBefore: 6,
          triggerTags: ['work_meeting'],
          withWhom: 'colleague',
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection = ruleEngine.pickQuick(entry, 'ko');

        expect(selection.questions, hasLength(1));
        // work_meeting 태그가 있으므로 Boundaries 질문이 선택되어야 함
        expect(selection.questions.first.category, equals('Boundaries'));
      });

      test('같은 questionKey가 7-14일 내에 반복되지 않아야 함', () {
        // 최근에 사용된 질문과 같은 entryId로 테스트
        final entry = AngerEntry(
          id: 'entry1', // 이미 사용된 entryId
          createdAt: DateTime.now(),
          intensityBefore: 8,
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection = ruleEngine.pickQuick(entry, 'ko');

        // 같은 questionKey가 선택되지 않아야 함
        expect(selection.questions.first.questionKey, isNot(equals('calm.body_signal.v1')));
      });

      test('결정적 선택: 같은 entryId는 같은 질문을 반환해야 함', () {
        final entry1 = AngerEntry(
          id: 'deterministic_test_1',
          createdAt: DateTime.now(),
          intensityBefore: 5,
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final entry2 = AngerEntry(
          id: 'deterministic_test_1', // 같은 ID
          createdAt: DateTime.now(),
          intensityBefore: 5,
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection1 = ruleEngine.pickQuick(entry1, 'ko');
        final selection2 = ruleEngine.pickQuick(entry2, 'ko');

        expect(selection1.questions.first.questionKey, equals(selection2.questions.first.questionKey));
      });
    });

    group('pickDeep()', () {
      test('3개의 질문을 반환해야 함', () {
        final entry = AngerEntry(
          id: 'test_deep_entry',
          createdAt: DateTime.now(),
          intensityBefore: 6,
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection = ruleEngine.pickDeep(entry, 'ko');

        expect(selection.mode, equals('deep'));
        expect(selection.questions, hasLength(3));
      });

      test('가능한 한 다른 카테고리에서 선택해야 함', () {
        final entry = AngerEntry(
          id: 'test_deep_diversity',
          createdAt: DateTime.now(),
          intensityBefore: 6,
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection = ruleEngine.pickDeep(entry, 'ko');

        final categories = selection.questions.map((q) => q.category).toSet();
        // 최소 2개 이상의 다른 카테고리가 선택되어야 함
        expect(categories.length, greaterThanOrEqualTo(2));
      });
    });

    group('Utility Methods', () {
      test('daysBetween() should calculate correct days', () {
        final date1 = DateTime(2024, 1, 1);
        final date2 = DateTime(2024, 1, 3);
        
        final days = ruleEngine.daysBetween(date1, date2);
        
        expect(days, equals(2));
      });

      test('applyPlaceholders() should replace placeholders correctly', () {
        final entry = AngerEntry(
          id: 'placeholder_test',
          createdAt: DateTime.now(),
          intensityBefore: 5,
          triggerTags: ['traffic'],
          withWhom: 'driver',
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final text = '만약 {trigger}라면, {withWhom}에게 무엇을 하시겠어요?';
        final result = ruleEngine.applyPlaceholders(text, entry);

        expect(result, equals('만약 traffic라면, driver에게 무엇을 하시겠어요?'));
      });

      test('intensity bands should work correctly', () {
        // 강도별로 적절한 카테고리가 선택되는지 테스트
        final lowIntensityEntry = AngerEntry(
          id: 'low_intensity_test',
          createdAt: DateTime.now(),
          intensityBefore: 2,
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final highIntensityEntry = AngerEntry(
          id: 'high_intensity_test',
          createdAt: DateTime.now(),
          intensityBefore: 9,
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final lowSelection = ruleEngine.pickQuick(lowIntensityEntry, 'ko');
        final highSelection = ruleEngine.pickQuick(highIntensityEntry, 'ko');

        // 높은 강도는 Calm 카테고리를 우선해야 함
        expect(highSelection.questions.first.category, equals('Calm'));
      });
    });

    group('Condition Filtering', () {
      test('minIntensity 조건을 만족해야 함', () {
        final entry = AngerEntry(
          id: 'intensity_test',
          createdAt: DateTime.now(),
          intensityBefore: 3, // minIntensity: 7 조건을 만족하지 않음
          triggerTags: [],
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection = ruleEngine.pickQuick(entry, 'ko');

        // minIntensity: 7 조건을 만족하는 질문만 선택되어야 함
        expect(selection.questions.first.conditions['minIntensity'], lessThanOrEqualTo(entry.intensityBefore));
      });

      test('tagsAny 조건을 만족해야 함', () {
        final entry = AngerEntry(
          id: 'tags_test',
          createdAt: DateTime.now(),
          intensityBefore: 6,
          triggerTags: ['sleep_debt'], // sleep_debt 태그가 있음
          withWhom: null,
          timeOfDay: 'AM',
          techniqueUsed: [],
        );

        final selection = ruleEngine.pickQuick(entry, 'ko');

        // sleep_debt 태그 조건을 만족하는 질문이 선택되어야 함
        expect(selection.questions.first.conditions['tagsAny'], contains('sleep_debt'));
      });
    });
  });
}
