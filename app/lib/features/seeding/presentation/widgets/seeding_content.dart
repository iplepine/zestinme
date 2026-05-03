import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/fullcon_brand.dart';
import '../../../../core/widgets/zest_filter_chip.dart';
import '../providers/seeding_provider.dart';

class SeedingContent extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const SeedingContent({super.key, this.onComplete});

  @override
  ConsumerState<SeedingContent> createState() => _SeedingContentState();

  static String _tagLabel(bool isKo, String tag) {
    const ko = {
      'LockedIn': '몰입됨',
      'Sharp': '선명함',
      'Recovered': '회복됨',
      'Grounded': '단단함',
      'Ready': '준비됨',
      'Steady': '무난함',
      'Drained': '지침',
      'Heavy': '무거움',
      'Foggy': '흐릿함',
      'Flat': '무덤덤함',
      'Slipping': '흐트러짐',
      'NeedsReset': '재정비 필요',
      'Wired': '과긴장',
      'Overloaded': '벅참',
      'Tense': '긴장됨',
      'Restless': '가라앉지 않음',
      'Pressed': '쫓기는 느낌',
      'OnEdge': '예민함',
      'Scattered': '산만함',
      'Unfocused': '집중 안 됨',
      'Calm': '차분함',
      'Balanced': '균형 잡힘',
      'Stable': '안정적',
      'Light': '가벼움',
      'Building': '올라오는 중',
      'Recovering': '회복 중',
    };
    const en = {
      'LockedIn': 'Locked in',
      'Sharp': 'Sharp',
      'Recovered': 'Recovered',
      'Grounded': 'Grounded',
      'Ready': 'Ready',
      'Steady': 'Steady',
      'Drained': 'Drained',
      'Heavy': 'Heavy',
      'Foggy': 'Foggy',
      'Flat': 'Flat',
      'Slipping': 'Slipping',
      'NeedsReset': 'Needs reset',
      'Wired': 'Wired',
      'Overloaded': 'Overloaded',
      'Tense': 'Tense',
      'Restless': 'Restless',
      'Pressed': 'Pressed',
      'OnEdge': 'On edge',
      'Scattered': 'Scattered',
      'Unfocused': 'Unfocused',
      'Calm': 'Calm',
      'Balanced': 'Balanced',
      'Stable': 'Stable',
      'Light': 'Light',
      'Building': 'Building',
      'Recovering': 'Recovering',
    };

    return (isKo ? ko : en)[tag] ?? tag;
  }

  static String _contextLabel(bool isKo, String tag) {
    const ko = {
      'Work': '일/공부',
      'Relationship': '인간관계',
      'Family': '가족',
      'Money': '금전',
      'Health': '건강',
      'SleepDebt': '수면 부족',
      'Exercise': '운동',
      'Deadline': '마감',
      'Social': '사람 만남',
      'Travel': '이동',
      'Alone': '혼자 있음',
      'Future': '미래 걱정',
    };
    const en = {
      'Work': 'Work/study',
      'Relationship': 'Relationship',
      'Family': 'Family',
      'Money': 'Money',
      'Health': 'Health',
      'SleepDebt': 'Sleep debt',
      'Exercise': 'Exercise',
      'Deadline': 'Deadline',
      'Social': 'Social',
      'Travel': 'Travel',
      'Alone': 'Alone',
      'Future': 'Future',
    };
    return (isKo ? ko : en)[tag] ?? tag;
  }

  static String _bodyLabel(bool isKo, String tag) {
    const ko = {
      'ChestTight': '가슴 답답함',
      'ShoulderTension': '목/어깨 긴장',
      'Headache': '두통',
      'Stomach': '속 불편함',
      'Heartbeat': '심장 두근거림',
      'Fatigue': '피로감',
      'LowEnergy': '기운 없음',
      'Sleepy': '졸림',
      'EyeStrain': '눈 피로',
      'ShallowBreath': '숨이 얕음',
      'HeavyBody': '몸이 무거움',
      'Restless': '몸이 가라앉지 않음',
    };
    const en = {
      'ChestTight': 'Tight chest',
      'ShoulderTension': 'Shoulder tension',
      'Headache': 'Headache',
      'Stomach': 'Stomach discomfort',
      'Heartbeat': 'Fast heartbeat',
      'Fatigue': 'Fatigue',
      'LowEnergy': 'Low energy',
      'Sleepy': 'Sleepy',
      'EyeStrain': 'Eye strain',
      'ShallowBreath': 'Shallow breath',
      'HeavyBody': 'Heavy body',
      'Restless': 'Restless body',
    };
    return (isKo ? ko : en)[tag] ?? tag;
  }
}

class _SeedingContentState extends ConsumerState<SeedingContent> {
  bool _showDetails = false;

  Future<void> _saveRecord(BuildContext context, SeedingState state, SeedingNotifier notifier) async {
    if (state.isSaving) return;
    HapticFeedback.mediumImpact();
    final saved = await notifier.saveRecord();
    if (saved && context.mounted) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seedingNotifierProvider);
    final notifier = ref.read(seedingNotifierProvider.notifier);
    final isKo = Localizations.localeOf(context).languageCode == 'ko';
    final recommendedTags = notifier.getRecommendedTags();
    final topSpacing = MediaQuery.viewPaddingOf(context).top >= 40 ? 20.0 : 28.0;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, topSpacing, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isKo ? '오늘 상태' : 'Today',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CompactPill(label: isKo ? '30초 체크' : '30 sec'),
                _CompactPill(label: isKo ? '핵심만' : 'Core only'),
              ],
            ),
            const SizedBox(height: 16),
            _MetricSliderTile(
              title: isKo ? '에너지' : 'Energy',
              value: state.energyScore,
              color: AppColors.lanternGlow,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                notifier.updateEnergy(value);
              },
              lowLabel: isKo ? '바닥' : 'empty',
              highLabel: isKo ? '넘침' : 'full',
            ),
            const SizedBox(height: 12),
            _MetricSliderTile(
              title: isKo ? '회복' : 'Recovery',
              value: state.recoveryScore,
              color: AppColors.spiritTeal,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                notifier.updateRecovery(value);
              },
              lowLabel: isKo ? '방전' : 'drained',
              highLabel: isKo ? '회복' : 'recovered',
            ),
            const SizedBox(height: 18),
            _QuickReadCard(
              score: state.overallConditionScore,
              modeLabel: SeedingContent._tagLabel(isKo, state.primaryTag),
            ),
            const SizedBox(height: 20),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                state.errorMessage!,
                style: const TextStyle(
                  color: AppColors.fire,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (!_showDetails) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isSaving
                      ? null
                      : () => _saveRecord(context, state, notifier),
                  child: state.isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isKo ? '저장' : 'Save',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _showDetails = true);
                  },
                  child: Text(
                    isKo ? '자세히 입력' : 'Add details',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else ...[
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(
                      title: isKo ? '더 자세히' : 'Optional details',
                      subtitle: isKo
                          ? '필요할 때만 추가로 남기세요.'
                          : 'If you want, add a bit more context about what is driving this state.',
                    ),
                    const SizedBox(height: 12),
                    _MetricSliderTile(
                      title: isKo ? '집중' : 'Focus',
                      subtitle: isKo ? '중요한 일에 집중할 수 있나요?' : 'Can you stay on the important thing?',
                      value: state.focusScore,
                      color: AppColors.signalBlue,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        notifier.updateFocus(value);
                      },
                      lowLabel: isKo ? '흐림' : 'foggy',
                      highLabel: isKo ? '선명' : 'sharp',
                    ),
                    const SizedBox(height: 12),
                    _MetricSliderTile(
                      title: isKo ? '스트레스' : 'Stress',
                      subtitle: isKo ? '압박감이나 긴장이 크게 느껴지나요?' : 'How much pressure or tension are you carrying?',
                      value: state.stressScore,
                      color: AppColors.fire,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        notifier.updateStress(value);
                      },
                      lowLabel: isKo ? '차분' : 'calm',
                      highLabel: isKo ? '매우 높음' : 'overloaded',
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: recommendedTags.map((tag) {
                        return ZestFilterChip(
                          label: SeedingContent._tagLabel(isKo, tag),
                          isSelected: state.selectedTags.contains(tag),
                          onSelected: (_) => notifier.toggleTag(tag),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _SectionHeader(
                      title: isKo ? '영향 준 상황' : 'Context signals',
                      subtitle: isKo
                          ? '컨디션에 영향을 준 상황을 최대 3개까지 골라보세요.'
                          : 'Pick up to 3 contexts affecting your state.',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: SeedingNotifier.contextTags.map((tag) {
                        return ZestFilterChip(
                          label: SeedingContent._contextLabel(isKo, tag),
                          isSelected: state.selectedContextTags.contains(tag),
                          onSelected: (_) => notifier.toggleContextTag(tag),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _SectionHeader(
                      title: isKo ? '몸 반응' : 'Body signals',
                      subtitle: isKo
                          ? '몸에서 느껴지는 신호를 최대 3개까지 고르세요.'
                          : 'Pick up to 3 signals coming from your body.',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: SeedingNotifier.bodyTags.map((tag) {
                        return ZestFilterChip(
                          label: SeedingContent._bodyLabel(isKo, tag),
                          isSelected: state.selectedBodyTags.contains(tag),
                          onSelected: (_) => notifier.toggleBodyTag(tag),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _SectionHeader(
                      title: isKo ? '선택 메모' : 'Optional note',
                      subtitle: isKo
                          ? '왜 이런 상태인지 짧게 남겨두면 나중에 흐름을 읽기 쉬워져요.'
                          : 'A single line about why you feel this way is enough.',
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      minLines: 4,
                      maxLines: 6,
                      onChanged: notifier.updateNote,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: isKo
                            ? '예: 수면이 짧고 오전 회의가 길어서 집중이 잘 안 돼요.'
                            : 'Example: Short sleep and back-to-back meetings drained my focus.',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          height: 1.5,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSaving
                            ? null
                            : () => _saveRecord(context, state, notifier),
                        child: state.isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isKo ? '체크인 저장' : 'Save check-in',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompactPill extends StatelessWidget {
  final String label;

  const _CompactPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.78),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _QuickReadCard extends StatelessWidget {
  final int score;
  final String modeLabel;

  const _QuickReadCard({
    required this.score,
    required this.modeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ConditionArrowMark(
                      score: score,
                      size: 16,
                      padding: const EdgeInsets.all(4),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        modeLabel,
                        style: const TextStyle(
                          color: AppColors.lanternGlow,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.lanternGlow.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$score/100',
                  style: const TextStyle(
                    color: AppColors.lanternGlow,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricSliderTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int value;
  final String lowLabel;
  final String highLabel;
  final Color color;
  final ValueChanged<int> onChanged;

  const _MetricSliderTile({
    required this.title,
    this.subtitle,
    required this.value,
    required this.lowLabel,
    required this.highLabel,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '$value/10',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 2),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: color.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$value',
              onChanged: (newValue) => onChanged(newValue.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lowLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.34),
                  fontSize: 11,
                ),
              ),
              Text(
                highLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.34),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.58),
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
