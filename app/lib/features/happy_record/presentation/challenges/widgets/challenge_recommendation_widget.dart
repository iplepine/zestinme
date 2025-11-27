import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/usecases/get_available_challenges_usecase.dart';
import '../../../../../di/injection.dart';

class ChallengeRecommendationWidget extends ConsumerStatefulWidget {
  final VoidCallback? onMoreTap;

  const ChallengeRecommendationWidget({super.key, this.onMoreTap});

  @override
  ConsumerState<ChallengeRecommendationWidget> createState() =>
      _ChallengeRecommendationWidgetState();
}

class _ChallengeRecommendationWidgetState
    extends ConsumerState<ChallengeRecommendationWidget> {
  List<ChallengeExploreItem> _availableChallenges = [];
  bool _isLoading = true;

  final GetAvailableChallengesUseCase _getAvailableChallengesUseCase =
      Injection.getIt<GetAvailableChallengesUseCase>();

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  void _loadChallenges() {
    setState(() {
      _isLoading = true;
    });

    try {
      // 실제 사용 가능한 챌린지 데이터를 불러옵니다
      _availableChallenges = _getAvailableChallengesUseCase.execute();
      
      // 수면 챌린지를 추가합니다 (수면 기록 기능과 연동)
      _availableChallenges.insert(
        0,
        ChallengeExploreItem(
          id: 'sleep',
          title: '수면 패턴 개선하기',
          description: '규칙적인 수면으로 컨디션 향상하기',
          category: '건강 관리',
          duration: '30일',
          difficulty: '보통',
          participants: 2100,
          emoji: '🌙',
        ),
      );
    } catch (e) {
      // 에러 발생 시 빈 리스트로 설정
      _availableChallenges = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 상위 3개만 추천으로 표시
    final recommendedChallenges = _availableChallenges.take(3).toList();

    if (recommendedChallenges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '추천 챌린지',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.onMoreTap != null)
                TextButton(
                  onPressed: widget.onMoreTap,
                  child: Text(
                    '더보기',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recommendedChallenges.length,
            itemBuilder: (context, index) {
              final challenge = recommendedChallenges[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right: index < recommendedChallenges.length - 1 ? 12 : 0,
                ),
                child: _RecommendedChallengeCard(
                  challenge: challenge,
                  onTap: () {
                    if (challenge.id == 'sleep') {
                      // 수면 챌린지인 경우 수면 기록 화면으로 이동
                      context.push('/sleep-record');
                    } else {
                      // 다른 챌린지인 경우 기존 로직
                      context.push('/challenge-explore');
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecommendedChallengeCard extends StatelessWidget {
  final ChallengeExploreItem challenge;
  final VoidCallback onTap;

  const _RecommendedChallengeCard({
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(challenge.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    challenge.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    challenge.difficulty,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${challenge.participants}명 참여',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
