import 'package:flutter/material.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import 'package:zestinme/core/utils/emotion_localization_utils.dart';
import 'package:zestinme/l10n/app_localizations.dart';

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
                '이번 주의 나',
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
                label: '감정 기록',
                value: '${summary.emotionRecordCount}개',
              ),
              _MetricChip(
                label: '평균 강도',
                value: summary.averageIntensity == 0
                    ? '-'
                    : summary.averageIntensity.toStringAsFixed(1),
              ),
              _MetricChip(
                label: '평균 수면',
                value: summary.averageSleepHours == 0
                    ? '-'
                    : '${summary.averageSleepHours.toStringAsFixed(1)}h',
              ),
              _MetricChip(
                label: '회고',
                value: '${(summary.caredRatio * 100).round()}%',
              ),
              _MetricChip(
                label: '회고 후',
                value: summary.averageCaringIntensityDrop == 0
                    ? '-'
                    : '-${summary.averageCaringIntensityDrop.toStringAsFixed(1)}',
              ),
            ],
          ),
          if (summary.topEmotions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _CountRow(
              title: '자주 나온 감정',
              items: summary.topEmotions,
              labelBuilder: (label) {
                final l10n = AppLocalizations.of(context)!;
                return l10n.getLocalizedEmotion(label);
              },
            ),
          ],
          if (summary.topContexts.isNotEmpty) ...[
            const SizedBox(height: 12),
            _CountRow(
              title: '자주 나온 상황',
              items: summary.topContexts,
              labelBuilder: _contextLabel,
            ),
          ],
          if (summary.topBodySensations.isNotEmpty) ...[
            const SizedBox(height: 12),
            _CountRow(
              title: '자주 나온 몸 반응',
              items: summary.topBodySensations,
              labelBuilder: _bodyLabel,
            ),
          ],
        ],
      ),
    );
  }

  String _contextLabel(String label) {
    switch (label) {
      case 'Work':
        return '일/공부';
      case 'Relationship':
        return '관계';
      case 'Family':
        return '가족';
      case 'Money':
        return '돈';
      case 'Health':
        return '건강';
      case 'SleepDebt':
        return '수면 부족';
      case 'Alone':
        return '혼자 있음';
      case 'Future':
        return '미래 걱정';
      case 'Mistake':
        return '실수/후회';
      case 'Comparison':
        return '비교';
      case 'Overload':
        return '과부하';
      case 'NoRest':
        return '휴식 부족';
      default:
        return label;
    }
  }

  String _bodyLabel(String label) {
    switch (label) {
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
        return '무기력';
      case 'Sleepy':
        return '졸림';
      case 'EyeStrain':
        return '눈 피로';
      case 'ShallowBreath':
        return '숨이 얕음';
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
