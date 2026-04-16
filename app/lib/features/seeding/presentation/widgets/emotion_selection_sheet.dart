import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/seeding_provider.dart';
import 'rolling_hint_text_field.dart';
import '../../../../core/widgets/zest_filter_chip.dart';
import '../../../../core/widgets/zest_glass_card.dart';

class EmotionSelectionSheet extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const EmotionSelectionSheet({super.key, this.onComplete});

  @override
  ConsumerState<EmotionSelectionSheet> createState() =>
      _EmotionSelectionSheetState();
}

class _EmotionSelectionSheetState extends ConsumerState<EmotionSelectionSheet> {
  static const List<String> _contextTags = [
    'Work',
    'Relationship',
    'Family',
    'Money',
    'Health',
    'SleepDebt',
    'Alone',
    'Future',
    'Mistake',
    'Comparison',
    'Overload',
    'NoRest',
  ];

  static const List<String> _bodyTags = [
    'ChestTight',
    'ShoulderTension',
    'Headache',
    'Stomach',
    'Heartbeat',
    'Fatigue',
    'LowEnergy',
    'Sleepy',
    'EyeStrain',
    'ShallowBreath',
  ];

  String _getLocalizedContextTag(String tag) {
    switch (tag) {
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
        return tag;
    }
  }

  String _getLocalizedBodyTag(String tag) {
    switch (tag) {
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
        return tag;
    }
  }

  String _getLocalizedTag(AppLocalizations l10n, String tag) {
    switch (tag) {
      case 'Angry':
        return l10n.seeding_mood_angry;
      case 'Anxious':
        return l10n.seeding_mood_anxious;
      case 'Resentful':
        return l10n.seeding_mood_resentful;
      case 'Overwhelmed':
        return l10n.seeding_mood_overwhelmed;
      case 'Jealous':
        return l10n.seeding_mood_jealous;
      case 'Annoyed':
        return l10n.seeding_mood_annoyed;
      case 'Sad':
        return l10n.seeding_mood_sad;
      case 'Disappointed':
        return l10n.seeding_mood_disappointed;
      case 'Bored':
        return l10n.seeding_mood_bored;
      case 'Lonely':
        return l10n.seeding_mood_lonely;
      case 'Guilty':
        return l10n.seeding_mood_guilty;
      case 'Envious':
        return l10n.seeding_mood_envious;
      case 'Excited':
        return l10n.seeding_mood_excited;
      case 'Proud':
        return l10n.seeding_mood_proud;
      case 'Inspired':
        return l10n.seeding_mood_inspired;
      case 'Enthusiastic':
        return l10n.seeding_mood_enthusiastic;
      case 'Curious':
        return l10n.seeding_mood_curious;
      case 'Amused':
        return l10n.seeding_mood_amused;
      case 'Relaxed':
        return l10n.seeding_mood_relaxed;
      case 'Grateful':
        return l10n.seeding_mood_grateful;
      case 'Content':
        return l10n.seeding_mood_content;
      case 'Serene':
        return l10n.seeding_mood_serene;
      case 'Trusting':
        return l10n.seeding_mood_trusting;
      case 'Reflective':
        return l10n.seeding_mood_reflective;
      case 'Neutral':
        return l10n.seeding_mood_neutral;
      default:
        return tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final seedingState = ref.watch(seedingNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final recommendedTags = ref
        .read(seedingNotifierProvider.notifier)
        .getRecommendedTags();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return ZestGlassCard(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          showBorder:
              false, // Bottom sheet border usually handled by decoration
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 20, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle space is provided by showDragHandle: true in showModalBottomSheet
                const SizedBox(height: 12),

                // 1. Tags
                Text(
                  l10n.seeding_promptTags,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.start,
                  children: recommendedTags.map((tag) {
                    final localizedTag = _getLocalizedTag(l10n, tag);
                    final isSelected = seedingState.selectedTags.contains(tag);
                    return ZestFilterChip(
                      label: localizedTag,
                      isSelected: isSelected,
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        ref
                            .read(seedingNotifierProvider.notifier)
                            .toggleTag(tag);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                Text(
                  '강도',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${seedingState.intensity}',
                      style: const TextStyle(
                        color: AppColors.spiritTeal,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Slider(
                        value: seedingState.intensity.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: '${seedingState.intensity}',
                        activeColor: AppColors.spiritTeal,
                        inactiveColor: Colors.white24,
                        onChanged: (value) {
                          ref
                              .read(seedingNotifierProvider.notifier)
                              .updateIntensity(value.round());
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  '지금 감정이 얼마나 강한지 1부터 10까지로 남겨요.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  '상황',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '이 감정이 올라온 맥락을 최대 3개까지 골라요.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: _contextTags.map((tag) {
                    final isSelected = seedingState.selectedContextTags
                        .contains(tag);
                    return ZestFilterChip(
                      label: _getLocalizedContextTag(tag),
                      isSelected: isSelected,
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        ref
                            .read(seedingNotifierProvider.notifier)
                            .toggleContextTag(tag);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                Text(
                  '몸 반응',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '몸에서 느껴지는 신호를 최대 3개까지 골라요.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: _bodyTags.map((tag) {
                    final isSelected = seedingState.selectedBodyTags.contains(
                      tag,
                    );
                    return ZestFilterChip(
                      label: _getLocalizedBodyTag(tag),
                      isSelected: isSelected,
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        ref
                            .read(seedingNotifierProvider.notifier)
                            .toggleBodyTag(tag);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // 2. Note
                RollingHintTextField(
                  l10n: l10n,
                  onChanged: (value) {
                    ref
                        .read(seedingNotifierProvider.notifier)
                        .updateNote(value);
                  },
                ),

                const SizedBox(height: 32),

                // 3. Plant Button
                if (seedingState.errorMessage != null) ...[
                  Text(
                    seedingState.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.fire,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: seedingState.isSaving
                          ? null
                          : () async {
                              HapticFeedback.mediumImpact();
                              final saved = await ref
                                  .read(seedingNotifierProvider.notifier)
                                  .saveRecord();

                              if (context.mounted && saved) {
                                Navigator.pop(context); // Close BottomSheet
                                if (widget.onComplete != null) {
                                  widget.onComplete!();
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        foregroundColor: AppColors.primaryButtonText,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: seedingState.isSaving
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              l10n.seeding_buttonPlant,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
