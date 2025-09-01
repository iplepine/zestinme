import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart';
import '../../domain/models/challenge_progress.dart';
import '../../domain/usecases/get_active_challenges_usecase.dart';
import 'widgets/active_challenge_list_widget.dart';
import 'widgets/challenge_recommendation_widget.dart';
import 'widgets/start_new_challenge_button.dart';
import '../../../anger/domain/entities.dart';
import '../../../anger/domain/rule_engine.dart';
import '../../../anger/data/question_bank_loader.dart';
import '../../../anger/data/coach_repository.dart';
import '../../../anger/presentation/widgets/quick_coach_card.dart';
import '../../../anger/presentation/pages/deep_coach_page.dart';

class ChallengesPage extends ConsumerStatefulWidget {
  const ChallengesPage({super.key});

  @override
  ConsumerState<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends ConsumerState<ChallengesPage> {
  late final GetActiveChallengesUseCase _getActiveChallengesUseCase;
  List<ChallengeProgress> _activeChallenges = [];

  // 코칭 관련 변수들
  late final QuestionBankLoader _questionLoader;
  late final CoachRepository _coachRepository;
  List<CoachQuestion> _availableQuestions = [];
  bool _isLoadingQuestions = false;

  @override
  void initState() {
    super.initState();
    _getActiveChallengesUseCase = Injection.getIt<GetActiveChallengesUseCase>();
    _questionLoader = Injection.getIt<QuestionBankLoader>();
    _coachRepository = Injection.getIt<CoachRepository>();
    _loadActiveChallenges();
    _loadCoachingQuestions();
  }

  void _loadActiveChallenges() {
    setState(() {
      _activeChallenges = _getActiveChallengesUseCase.execute();
    });
  }

  void _onChallengeTap(ChallengeProgress challenge) {
    context.push('/challenge-detail', extra: challenge);
  }

  void _onStartNewChallenge() {
    context.push('/challenge-explore');
  }

  void _onMoreChallenges() {
    context.push('/challenge-explore');
  }

  // 코칭 관련 메서드들
  Future<void> _loadCoachingQuestions() async {
    setState(() {
      _isLoadingQuestions = true;
    });

    try {
      final questions = await _questionLoader.loadQuestions();
      setState(() {
        _availableQuestions = questions;
        _isLoadingQuestions = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingQuestions = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('질문 로드 실패: $e')));
      }
    }
  }

  Widget _buildCoachingSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            '코칭',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '상황에 맞는 맞춤형 코칭을 받아보세요',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),

          // 코칭 버튼들
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoadingQuestions ? null : _showQuickCoaching,
                  icon: const Icon(Icons.flash_on, size: 20),
                  label: const Text('빠른 코칭'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[100],
                    foregroundColor: Colors.orange[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoadingQuestions ? null : _showDeepCoaching,
                  icon: const Icon(Icons.psychology, size: 20),
                  label: const Text('딥 코칭'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 로딩 상태 표시
          if (_isLoadingQuestions)
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  void _showQuickCoaching() {
    if (_availableQuestions.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('사용 가능한 코칭 질문이 없습니다.')));
      return;
    }

    // 테스트용 분노 기록 생성
    final testEntry = AngerEntry(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      intensityBefore: 7,
      triggerTags: ['work_meeting'],
      withWhom: 'colleague',
      timeOfDay: 'AM',
      techniqueUsed: [],
    );

    _showQuickCoachingCard(testEntry);
  }

  void _showQuickCoachingCard(AngerEntry entry) async {
    try {
      final recentQAs = await _coachRepository.recentQAs(days: 14);
      final effectScores = await _coachRepository.loadEffectScores();

      final ruleEngine = RuleEngine(
        questions: _availableQuestions,
        recentQAs: recentQAs,
        effect: effectScores,
      );

      final selection = ruleEngine.pickQuick(
        entry,
        Localizations.localeOf(context).languageCode,
      );

      if (selection.questions.isNotEmpty) {
        if (mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => QuickCoachCard(
              question: selection.questions.first,
              entry: entry,
              onSubmit: (answer) async {
                // QA 저장
                final qa = CoachQA(
                  id: 'qa_${DateTime.now().millisecondsSinceEpoch}',
                  entryId: entry.id,
                  category: selection.questions.first.category,
                  questionKey: selection.questions.first.questionKey,
                  promptVars: {},
                  answerText: answer,
                  createdAt: DateTime.now(),
                );

                await _coachRepository.saveQA(qa);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('코칭 답변이 저장되었습니다!')),
                  );
                }
              },
              onSnooze: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('오늘 밤에 다시 알려드릴게요!')),
                );
              },
              onSkip: () {
                Navigator.pop(context);
              },
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('코칭 시작 실패: $e')));
      }
    }
  }

  void _showDeepCoaching() {
    if (_availableQuestions.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('사용 가능한 코칭 질문이 없습니다.')));
      return;
    }

    // 테스트용 분노 기록 생성
    final testEntry = AngerEntry(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      intensityBefore: 5,
      triggerTags: ['traffic'],
      withWhom: null,
      timeOfDay: 'PM',
      techniqueUsed: [],
    );

    _showDeepCoachingPage(testEntry);
  }

  void _showDeepCoachingPage(AngerEntry entry) async {
    try {
      final recentQAs = await _coachRepository.recentQAs(days: 14);
      final effectScores = await _coachRepository.loadEffectScores();

      final ruleEngine = RuleEngine(
        questions: _availableQuestions,
        recentQAs: recentQAs,
        effect: effectScores,
      );

      final selection = ruleEngine.pickDeep(
        entry,
        Localizations.localeOf(context).languageCode,
      );

      if (selection.questions.isNotEmpty && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeepCoachPage(
              questions: selection.questions,
              entry: entry,
              repository: _coachRepository,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('딥 코칭 시작 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text(
                'Challenges',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 진행 중인 챌린지 리스트
                  ActiveChallengeListWidget(
                    challenges: _activeChallenges,
                    onChallengeTap: _onChallengeTap,
                  ),

                  const SizedBox(height: 32),

                  // 새로운 챌린지 추천
                  ChallengeRecommendationWidget(onMoreTap: _onMoreChallenges),

                  const SizedBox(height: 32),

                  // 코칭 섹션
                  _buildCoachingSection(),

                  const SizedBox(height: 24),

                  // 챌린지 시작하기 버튼
                  StartNewChallengeButton(onTap: _onStartNewChallenge),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
