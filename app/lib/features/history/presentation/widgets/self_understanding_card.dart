import 'package:flutter/material.dart';
import 'package:zestinme/core/constants/app_colors.dart';

import '../providers/self_understanding_provider.dart';

class SelfUnderstandingCard extends StatelessWidget {
  final WeeklySelfUnderstanding summary;

  const SelfUnderstandingCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.spiritTeal.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insights_outlined,
                color: AppColors.spiritTeal,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '이번 주 컨디션 요약',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            summary.insight,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.78),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetricChip(
                label: '체크인',
                value: '${summary.conditionRecordCount}개',
              ),
              _MetricChip(
                label: '컨디션 점수',
                value: summary.averageConditionScore == 0
                    ? '-'
                    : summary.averageConditionScore.toStringAsFixed(0),
              ),
              _MetricChip(
                label: '에너지',
                value: summary.averageEnergy == 0
                    ? '-'
                    : summary.averageEnergy.toStringAsFixed(1),
              ),
              _MetricChip(
                label: '집중',
                value: summary.averageFocus == 0
                    ? '-'
                    : summary.averageFocus.toStringAsFixed(1),
              ),
              _MetricChip(
                label: '회복',
                value: summary.averageRecovery == 0
                    ? '-'
                    : summary.averageRecovery.toStringAsFixed(1),
              ),
              _MetricChip(
                label: '스트레스',
                value: summary.averageStress == 0
                    ? '-'
                    : summary.averageStress.toStringAsFixed(1),
              ),
              _MetricChip(
                label: '평균 수면',
                value: summary.averageSleepHours == 0
                    ? '-'
                    : '${summary.averageSleepHours.toStringAsFixed(1)}h',
              ),
              _MetricChip(
                label: '수면 효율',
                value: summary.averageSleepEfficiency == 0
                    ? '-'
                    : '${summary.averageSleepEfficiency.toStringAsFixed(0)}%',
              ),
              _MetricChip(
                label: '안정 비율',
                value: '${(summary.caredRatio * 100).round()}%',
              ),
            ],
          ),
          if (summary.topSignals.isNotEmpty) ...[
            const SizedBox(height: 16),
            _CountRow(
              title: '자주 보인 신호',
              items: summary.topSignals,
              labelBuilder: _signalLabel,
            ),
          ],
        ],
      ),
    );
  }

  String _signalLabel(String label) {
    if (label.startsWith('stress:')) {
      return '스트레스 ${label.split(':').last}';
    }
    if (label.startsWith('efficiency:')) {
      return '수면 효율 ${label.split(':').last}';
    }
    if (label.startsWith('refreshment:')) {
      return '회복감 ${label.split(':').last}';
    }
    if (label.startsWith('recovery:')) {
      return '회복 ${label.split(':').last}';
    }
    if (label.startsWith('sleep-latency:')) {
      return '입면 ${label.split(':').last}';
    }
    if (label.startsWith('snooze:')) {
      return '스누즈 ${label.split(':').last}회';
    }
    switch (label) {
      case 'LockedIn':
        return '몰입됨';
      case 'Drained':
        return '지침';
      case 'Wired':
        return '과긴장';
      case 'Foggy':
        return '흐릿함';
      case 'Overloaded':
        return '벅참';
      case 'Steady':
        return '무난함';
      case 'Heavy':
        return '무거움';
      case 'Flat':
        return '무덤덤함';
      case 'Slipping':
        return '흐트러짐';
      case 'NeedsReset':
        return '재정비 필요';
      case 'Tense':
        return '긴장됨';
      case 'Restless':
        return '가라앉지 않음';
      case 'Pressed':
        return '쫓기는 느낌';
      case 'OnEdge':
        return '예민함';
      case 'Scattered':
        return '산만함';
      case 'Unfocused':
        return '집중 저하';
      case 'Sharp':
        return '선명함';
      case 'Recovered':
        return '회복됨';
      case 'Grounded':
        return '단단함';
      case 'Ready':
        return '준비됨';
      case 'Calm':
        return '차분함';
      case 'Balanced':
        return '균형 잡힘';
      case 'Stable':
        return '안정적';
      case 'Light':
        return '가벼움';
      case 'Building':
        return '올라오는 중';
      case 'Recovering':
        return '회복 중';
      case 'Work':
        return '일/업무';
      case 'Relationship':
        return '인간관계';
      case 'Family':
        return '가족';
      case 'Money':
        return '금전';
      case 'Health':
        return '건강';
      case 'SleepDebt':
        return '수면 부족';
      case 'Exercise':
        return '운동';
      case 'Deadline':
        return '마감';
      case 'Social':
        return '사람 만남';
      case 'Travel':
        return '이동';
      case 'Alone':
        return '혼자 있음';
      case 'Future':
        return '미래 걱정';
      case 'ChestTight':
        return '가슴 답답함';
      case 'ShoulderTension':
        return '목/어깨 긴장';
      case 'Headache':
        return '두통';
      case 'Stomach':
        return '속 불편함';
      case 'Heartbeat':
        return '심장 두근거림';
      case 'Fatigue':
        return '피로감';
      case 'LowEnergy':
        return '기운 없음';
      case 'Sleepy':
        return '졸림';
      case 'EyeStrain':
        return '눈 피로';
      case 'ShallowBreath':
        return '얕은 호흡';
      case 'HeavyBody':
        return '몸이 무거움';
      case 'sleep':
        return '수면';
      case 'natural-wake':
        return '자연 기상';
      case 'fast-rise':
        return '개운한 기상';
      case 'condition-checkin':
        return '컨디션 체크인';
      case 'caffeine':
        return '카페인';
      case 'alcohol':
        return '알코올';
      case 'late-night-snack':
        return '야식';
      case 'fasting':
        return '공복';
      case 'screen-time':
        return '스크린타임';
      case 'intense-workout':
        return '격한 운동';
      case 'reading':
        return '명상/독서';
      case 'nap':
        return '낮잠';
      case 'noise':
        return '소음';
      case 'light':
        return '빛';
      case 'temperature':
        return '온도';
      case 'bed-change':
        return '잠자리 변경';
      case 'stress':
        return '스트레스';
      case 'hormone':
        return '호르몬';
      case 'pain':
        return '통증/질병';
      case 'nightmare':
        return '악몽';
      default:
        return label;
    }
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;

  const _MetricChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        '$label $value',
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  final String title;
  final List<WeeklyCount> items;
  final String Function(String label) labelBuilder;

  const _CountRow({
    required this.title,
    required this.items,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.spiritTeal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${labelBuilder(item.label)} ${item.count}',
                    style: const TextStyle(
                      color: AppColors.spiritTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
