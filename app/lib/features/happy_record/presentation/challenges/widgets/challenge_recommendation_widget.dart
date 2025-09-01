import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ChallengeExploreItem 클래스를 직접 정의
class ChallengeExploreItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final String difficulty;
  final int participants;
  final String emoji;

  ChallengeExploreItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.participants,
    required this.emoji,
  });
}

class ChallengeRecommendationWidget extends ConsumerWidget {
  final VoidCallback? onMoreTap;

  const ChallengeRecommendationWidget({super.key, this.onMoreTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // 임시로 더미 데이터 사용 (실제 데이터 연동은 나중에 구현)
    final availableChallenges = <ChallengeExploreItem>[
      ChallengeExploreItem(
        id: '1',
        title: '매일 감정 기록하기',
        description: '30일 동안 매일 감정을 기록하는 챌린지',
        category: '감정 관리',
        duration: '30일',
        difficulty: '쉬움',
        participants: 1250,
        emoji: '📝',
      ),
      ChallengeExploreItem(
        id: '2',
        title: '감사 일기 쓰기',
        description: '매일 감사한 일 3가지를 기록하기',
        category: '습관 형성',
        duration: '21일',
        difficulty: '보통',
        participants: 890,
        emoji: '🙏',
      ),
      ChallengeExploreItem(
        id: '3',
        title: '긍정적 사고 연습',
        description: '부정적인 상황에서 긍정적 관점 찾기',
        category: '자기계발',
        duration: '14일',
        difficulty: '어려움',
        participants: 567,
        emoji: '✨',
      ),
    ];

    // 상위 3개만 추천으로 표시
    final recommendedChallenges = availableChallenges.take(3).toList();

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
              if (onMoreTap != null)
                TextButton(
                  onPressed: onMoreTap,
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
                    // 추천 챌린지를 시작하는 로직을 여기에 추가할 수 있습니다
                    context.push('/challenge-explore');
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
