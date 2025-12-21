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
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: seedingState.isSaving
                          ? null
                          : () async {
                              HapticFeedback.mediumImpact();
                              await ref
                                  .read(seedingNotifierProvider.notifier)
                                  .saveRecord();

                              if (context.mounted) {
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
