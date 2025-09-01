import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart';
import '../../domain/models/challenge_progress.dart';
import '../../domain/usecases/get_active_challenges_usecase.dart';
import 'widgets/active_challenge_list_widget.dart';
import 'widgets/challenge_recommendation_widget.dart';
import 'widgets/start_new_challenge_button.dart';

class ChallengesPage extends ConsumerStatefulWidget {
  const ChallengesPage({super.key});

  @override
  ConsumerState<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends ConsumerState<ChallengesPage> {
  late final GetActiveChallengesUseCase _getActiveChallengesUseCase;
  List<ChallengeProgress> _activeChallenges = [];

  @override
  void initState() {
    super.initState();
    _getActiveChallengesUseCase = Injection.getIt<GetActiveChallengesUseCase>();
    _loadActiveChallenges();
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
                  ChallengeRecommendationWidget(
                    onMoreTap: _onMoreChallenges,
                  ),

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
