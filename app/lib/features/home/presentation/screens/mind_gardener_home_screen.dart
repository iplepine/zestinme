import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:zestinme/app/routes/app_router.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import 'package:zestinme/core/widgets/fullcon_brand.dart';
import 'package:zestinme/core/widgets/zest_glass_card.dart';
import 'package:zestinme/features/history/presentation/providers/self_understanding_provider.dart';
import 'package:zestinme/features/home/presentation/providers/home_provider.dart';
import 'package:zestinme/features/home/presentation/providers/time_vibe_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/home_bottom_bar.dart';

class MindGardenerHomeScreen extends ConsumerWidget {
  const MindGardenerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final summary = ref.watch(weeklySelfUnderstandingProvider);
    final timeVibe = ref.watch(timeVibeNotifierProvider);
    final isKo = Localizations.localeOf(context).languageCode == 'ko';

    final conditionScore = _buildConditionScore(homeState, summary);
    final primaryAction = _buildPrimaryAction(
      isKo: isKo,
      homeState: homeState,
      summary: summary,
    );

    return Scaffold(
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            timeVibe.backgroundImage,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.midnightDeep),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.midnightDeep.withValues(alpha: 0.16),
                  AppColors.midnightDeep.withValues(alpha: 0.8),
                  AppColors.midnightDeep,
                ],
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.lanternGlow,
              onRefresh: () async {
                await ref.read(homeProvider.notifier).refresh();
                ref.invalidate(weeklySelfUnderstandingProvider);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FullConWordmark(
                        fontSize: 10,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isKo
                            ? '${DateFormat('M월 d일 EEEE', 'ko').format(DateTime.now())} · 오늘 컨디션'
                            : '${DateFormat('EEE, MMM d').format(DateTime.now())} · Today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ZestGlassCard(
                    borderRadius: BorderRadius.circular(28),
                    padding: const EdgeInsets.all(22),
                    color: const Color(0xFF111A2C),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isKo ? '오늘 상태' : 'Today’s status',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.64),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ScoreRing(score: conditionScore),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _buildHeroTitle(
                                      isKo: isKo,
                                      homeState: homeState,
                                      summary: summary,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 27,
                                          height: 1.15,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _buildPrimarySuggestion(
                                      isKo: isKo,
                                      homeState: homeState,
                                      summary: summary,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.86,
                                      ),
                                      fontSize: 14,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _buildStatusLine(
                                      isKo: isKo,
                                      homeState: homeState,
                                    ),
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.62,
                                      ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeading(title: isKo ? '지금 할 일' : 'Do this now'),
                  const SizedBox(height: 10),
                  _PrimaryActionCard(
                    action: primaryAction,
                    onTap: () =>
                        _openAndRefresh(context, ref, primaryAction.route),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeading(title: isKo ? '이번 주 한 줄' : 'This week'),
                  const SizedBox(height: 10),
                  summary.when(
                    data: (weekly) => _WeeklyDigestCard(
                      title: isKo
                          ? (weekly.hasEnoughData
                                ? '반복되는 흐름을 한 번에 정리했어요'
                                : '이번 주 데이터가 아직 적어요')
                          : (weekly.hasEnoughData
                                ? 'A quick read on your week'
                                : 'Not enough data this week yet'),
                      body: weekly.insight,
                      highlights: _buildWeeklyHighlights(
                        isKo: isKo,
                        weekly: weekly,
                      ),
                      buttonLabel: isKo ? '타임라인 보기' : 'Open timeline',
                      onTap: () =>
                          _openAndRefresh(context, ref, AppRouter.history),
                    ),
                    loading: () => const _LoadingPanel(height: 156),
                    error: (_, __) => _WeeklyDigestCard(
                      title: isKo
                          ? '이번 주 요약을 불러오지 못했어요'
                          : 'Weekly summary unavailable',
                      body: isKo
                          ? '잠시 후 다시 새로고침해보세요.'
                          : 'Try refreshing again in a moment.',
                      highlights: <String>[isKo ? '요약 없음' : 'No summary'],
                      buttonLabel: isKo ? '오늘 체크인' : 'Check in today',
                      onTap: () =>
                          _openAndRefresh(context, ref, AppRouter.seeding),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 28,
            child: HomeBottomBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) return;
                if (index == 1) {
                  _openAndRefresh(context, ref, AppRouter.history);
                } else if (index == 2) {
                  _openAndRefresh(context, ref, AppRouter.sleep);
                } else if (index == 3) {
                  context.push(AppRouter.settings);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAndRefresh(
    BuildContext context,
    WidgetRef ref,
    String route,
  ) async {
    await context.push(route);
    await ref.read(homeProvider.notifier).refresh();
    ref.invalidate(weeklySelfUnderstandingProvider);
  }

  int _buildConditionScore(
    HomeState homeState,
    AsyncValue<WeeklySelfUnderstanding> summary,
  ) {
    final weekly = summary.valueOrNull;
    var score = homeState.conditionScore > 0 ? homeState.conditionScore : 56.0;

    final sleepSupport =
        homeState.todaySleep?.selfRefreshmentScore?.toDouble() ??
        ((homeState.todaySleep?.qualityScore ?? 3) * 18).toDouble();
    if (homeState.todaySleep != null) {
      score = (score * 0.72) + (sleepSupport * 0.28);
    }

    if (weekly != null && weekly.averageStress > 0) {
      score -= (weekly.averageStress - 5).clamp(0.0, 5.0) * 3.2;
    }

    return score.round().clamp(24, 96);
  }

  String _buildHeroTitle({
    required bool isKo,
    required HomeState homeState,
    required AsyncValue<WeeklySelfUnderstanding> summary,
  }) {
    final latest = homeState.latestCondition;
    final weekly = summary.valueOrNull;

    if (latest == null) {
      return isKo ? '오늘 상태부터\n가볍게 확인하세요' : 'Start with a\nquick check-in';
    }

    if ((latest.recoveryScore ?? 10) <= 4) {
      return isKo ? '오늘은 회복을\n먼저 챙겨야 해요' : 'Recovery comes\nfirst today';
    }

    if ((latest.stressScore ?? 0) >= 8 || homeState.attentionCount > 0) {
      return isKo
          ? '오늘은 무리하지 않고\n범위를 줄이는 편이 좋아요'
          : 'Keep the scope\nsmaller today';
    }

    if ((latest.focusScore ?? 10) <= 4) {
      return isKo ? '한 번에 한 가지에만\n붙는 편이 좋아요' : 'Stick to one\nimportant thing';
    }

    if (weekly != null &&
        weekly.averageSleepHours > 0 &&
        weekly.averageSleepHours < 6.5) {
      return isKo ? '속도보다 회복 여유를\n먼저 확보하세요' : 'Protect recovery\nbefore pace';
    }

    return isKo ? '좋은 흐름을\n이어가면 됩니다' : 'Keep the good\nflow going';
  }

  String _buildPrimarySuggestion({
    required bool isKo,
    required HomeState homeState,
    required AsyncValue<WeeklySelfUnderstanding> summary,
  }) {
    final weekly = summary.valueOrNull;
    final latest = homeState.latestCondition;

    if (latest == null) {
      return isKo
          ? '에너지와 회복만 먼저 남기면 오늘 제안이 바로 정해집니다.'
          : 'Log energy and recovery first to unlock a clearer next move.';
    }

    if ((latest.recoveryScore ?? 10) <= 4) {
      return isKo
          ? '일정 강도를 낮추고 쉬는 블록을 먼저 비워두세요.'
          : 'Lower the load and protect a reset block first.';
    }

    if ((latest.stressScore ?? 0) >= 8 || homeState.attentionCount > 0) {
      return isKo
          ? '오늘은 할 일의 범위를 조금 줄이고 자극부터 낮추세요.'
          : 'Cut the scope a bit and reduce stimulation first.';
    }

    if ((latest.focusScore ?? 10) <= 4) {
      return isKo
          ? '멀티태스킹보다 가장 중요한 한 가지에만 집중하세요.'
          : 'Focus on one important thing instead of multitasking.';
    }

    if (homeState.todaySleep == null) {
      return isKo
          ? '수면 기록을 더하면 컨디션 제안이 훨씬 정확해집니다.'
          : 'Adding sleep data makes the coaching much more specific.';
    }

    if (weekly != null &&
        weekly.averageSleepHours > 0 &&
        weekly.averageSleepHours < 6.5) {
      return isKo
          ? '오늘은 밀어붙이기보다 회복 여유를 남겨두는 편이 좋습니다.'
          : 'Leave recovery margin instead of pushing harder today.';
    }

    if (weekly != null && weekly.averageStress >= 7) {
      return isKo
          ? '일정을 꽉 채우기보다 여백을 남겨두는 편이 더 안정적입니다.'
          : 'Leaving margin in your day will keep things more stable.';
    }

    return isKo
        ? '지금 리듬을 유지하면서 무리만 피하면 충분합니다.'
        : 'Stay with the current rhythm and avoid overreaching.';
  }

  String _buildStatusLine({required bool isKo, required HomeState homeState}) {
    final recovery = _recoveryText(homeState, isKo);
    final attention = homeState.attentionCount == 0
        ? (isKo ? '주의 신호 없음' : 'No attention flags')
        : (isKo
              ? '주의 신호 ${homeState.attentionCount}건'
              : '${homeState.attentionCount} attention flags');
    return isKo
        ? '회복 $recovery · $attention'
        : 'Recovery $recovery · $attention';
  }

  _HomeAction _buildPrimaryAction({
    required bool isKo,
    required HomeState homeState,
    required AsyncValue<WeeklySelfUnderstanding> summary,
  }) {
    final latest = homeState.latestCondition;
    final weekly = summary.valueOrNull;

    if (latest == null) {
      return _HomeAction(
        title: isKo ? '오늘 체크인' : 'Today check-in',
        description: isKo
            ? '지금 상태를 빠르게 남기고 오늘 제안을 받아보세요.'
            : 'Capture your state quickly and get today’s next move.',
        route: AppRouter.seeding,
        icon: Icons.bolt_rounded,
        accent: AppColors.lanternGlow,
      );
    }

    if (homeState.todaySleep == null ||
        (latest.recoveryScore ?? 10) <= 4 ||
        (weekly != null &&
            weekly.averageSleepHours > 0 &&
            weekly.averageSleepHours < 6.5)) {
      return _HomeAction(
        title: isKo ? '회복 로그 남기기' : 'Log recovery',
        description: isKo
            ? '수면과 기상 상태를 더해 회복 흐름을 바로잡아보세요.'
            : 'Add sleep and wake data to correct your recovery rhythm.',
        route: AppRouter.sleep,
        icon: Icons.bedtime_rounded,
        accent: AppColors.spiritTeal,
      );
    }

    return _HomeAction(
      title: isKo ? '다시 체크인하기' : 'Check in again',
      description: isKo
          ? '오늘 상태를 한 번 더 읽고 제안을 조금 더 정교하게 맞춰보세요.'
          : 'Read your state again and sharpen today’s coaching.',
      route: AppRouter.seeding,
      icon: Icons.bolt_rounded,
      accent: AppColors.signalBlue,
    );
  }

  List<String> _buildWeeklyHighlights({
    required bool isKo,
    required WeeklySelfUnderstanding weekly,
  }) {
    if (!weekly.hasEnoughData) {
      return <String>[isKo ? '기록 0개' : '0 logs'];
    }

    final items = <String>[];
    if (weekly.conditionRecordCount > 0) {
      items.add(
        isKo
            ? '체크인 ${weekly.conditionRecordCount}회'
            : '${weekly.conditionRecordCount} check-ins',
      );
      items.add(
        isKo
            ? '안정 ${(weekly.caredRatio * 100).round()}%'
            : '${(weekly.caredRatio * 100).round()}% stable',
      );
    }

    if (weekly.averageSleepHours > 0) {
      items.add(
        isKo
            ? '수면 ${weekly.averageSleepHours.toStringAsFixed(1)}h'
            : 'Sleep ${weekly.averageSleepHours.toStringAsFixed(1)}h',
      );
    }

    return items.take(2).toList();
  }

  String _recoveryText(HomeState homeState, bool isKo) {
    final conditionRecovery = homeState.latestCondition?.recoveryScore;
    if (conditionRecovery != null) {
      if (conditionRecovery >= 8) return isKo ? '좋음' : 'strong';
      if (conditionRecovery >= 5) return isKo ? '보통' : 'steady';
      return isKo ? '낮음' : 'low';
    }

    final sleepRecovery = homeState.todaySleep?.selfRefreshmentScore;
    if (sleepRecovery == null) return isKo ? '기록 필요' : 'needs data';
    if (sleepRecovery >= 75) return isKo ? '좋음' : 'strong';
    if (sleepRecovery >= 50) return isKo ? '보통' : 'steady';
    return isKo ? '낮음' : 'low';
  }
}

class _HomeAction {
  const _HomeAction({
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String description;
  final String route;
  final IconData icon;
  final Color accent;
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: Colors.white, fontSize: 20),
    );
  }
}

class _PrimaryActionCard extends StatelessWidget {
  const _PrimaryActionCard({required this.action, required this.onTap});

  final _HomeAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111A2C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: action.accent.withValues(alpha: 0.32)),
          boxShadow: [
            BoxShadow(
              color: action.accent.withValues(alpha: 0.14),
              blurRadius: 18,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: action.accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(action.icon, color: action.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.68),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyDigestCard extends StatelessWidget {
  const _WeeklyDigestCard({
    required this.title,
    required this.body,
    required this.highlights,
    required this.buttonLabel,
    required this.onTap,
  });

  final String title;
  final String body;
  final List<String> highlights;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.74),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: highlights
                  .map((item) => _MiniHighlightChip(label: item))
                  .toList(),
            ),
          ],
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  buttonLabel,
                  style: const TextStyle(
                    color: AppColors.signalBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.signalBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniHighlightChip extends StatelessWidget {
  const _MiniHighlightChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.86),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final progress = score / 100;
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.lanternGlow,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ConditionArrowMark(
              score: score,
              size: 14,
              padding: const EdgeInsets.all(4),
            ),
          ),
          Center(
            child: Text(
              '$score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.spiritTeal),
      ),
    );
  }
}
