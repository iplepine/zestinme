import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/seeding_provider.dart';
import 'seeding_painters.dart';
import 'rolling_hint_text_field.dart';

class SeedingContent extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const SeedingContent({super.key, this.onComplete});

  @override
  ConsumerState<SeedingContent> createState() => _SeedingContentState();
}

class _SeedingContentState extends ConsumerState<SeedingContent> {
  Offset _center = Offset.zero;
  double _radius = 0.0;

  String _getLocalizedTag(AppLocalizations l10n, String tag) {
    switch (tag) {
      // RED (High Energy, Negative)
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

      // BLUE (Low Energy, Negative)
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

      // YELLOW (High Energy, Positive)
      case 'Excited':
        return l10n.seeding_mood_excited;
      case 'Proud': // Replaces Joyful/Passionate
        return l10n.seeding_mood_proud;
      case 'Inspired':
        return l10n.seeding_mood_inspired;
      case 'Enthusiastic':
        return l10n.seeding_mood_enthusiastic;
      case 'Curious':
        return l10n.seeding_mood_curious;
      case 'Amused':
        return l10n.seeding_mood_amused;

      // GREEN (Low Energy, Positive)
      case 'Relaxed': // Replaces Calm
        return l10n.seeding_mood_relaxed;
      case 'Grateful':
        return l10n.seeding_mood_grateful;
      case 'Content':
        return l10n.seeding_mood_content;
      case 'Serene': // Replaces Peaceful
        return l10n.seeding_mood_serene;
      case 'Trusting':
        return l10n.seeding_mood_trusting;
      case 'Reflective':
        return l10n.seeding_mood_reflective;

      // Center
      case 'Neutral':
        return l10n.seeding_mood_neutral;

      default:
        return tag;
    }
  }

  // Calculate pulse duration based on arousal
  Duration _getPulseDuration(double arousal) {
    return (2000 - ((arousal + 1) / 2 * 1500)).round().ms;
  }

  @override
  Widget build(BuildContext context) {
    final seedingState = ref.watch(seedingNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final pulseDuration = _getPulseDuration(seedingState.arousal);

    return LayoutBuilder(
      builder: (context, constraints) {
        _center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        _radius = constraints.maxWidth * 0.4;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background: 4-Quadrant Soil
            CustomPaint(
              painter: SoilPainter(
                valence: seedingState.valence,
                arousal: seedingState.arousal,
                center: _center,
              ),
              size: Size.infinite,
            ),

            // 2. Guide Lines
            CustomPaint(
              painter: GuidePainter(
                center: _center,
                radius: _radius,
                l10n: l10n,
              ),
            ),

            // 3. Dynamic Mood Label
            if (seedingState.isDragging)
              Positioned(
                top: _center.dy - _radius - 60,
                left: 0,
                right: 0,
                child: Text(
                  _getMoodLabel(
                    context,
                    seedingState.valence,
                    seedingState.arousal,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ),

            // 4. Instructions (Fade out when dragging)
            if (!seedingState.isDragging && !seedingState.isPlanted)
              Positioned(
                top: _center.dy - _radius - 60,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    l10n.seeding_instruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: AppColors.seedingTextShadow,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms),
              ),

            // 5. Draggable Seed
            GestureDetector(
              onPanStart: (details) =>
                  ref.read(seedingNotifierProvider.notifier).startDrag(),
              onPanUpdate: (details) {
                _handleDrag(details.globalPosition);
              },
              onPanEnd: (details) =>
                  ref.read(seedingNotifierProvider.notifier).endDrag(),
              behavior: HitTestBehavior.translucent,
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned(
                      left:
                          _calculateSeedPosition(
                            seedingState.valence,
                            constraints.maxWidth,
                          ).dx -
                          30,
                      top:
                          _calculateSeedPosition(
                            seedingState.arousal,
                            constraints.maxHeight,
                            isY: true,
                          ).dy -
                          30,
                      child: _buildSeedIcon(seedingState.arousal, pulseDuration)
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .scaleXY(
                            end: 1.2,
                            duration: pulseDuration,
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // 6. Post-Planting Options (Chips)
            if (seedingState.isPlanted) _buildEmotionChips(context, l10n),
          ],
        );
      },
    );
  }

  void _handleDrag(Offset position) {
    double dx = (position.dx - _center.dx) / _radius;
    double dy = (_center.dy - position.dy) / _radius;
    ref.read(seedingNotifierProvider.notifier).updateCoordinates(dx, dy);
  }

  Offset _calculateSeedPosition(
    double normalizedValue,
    double screenSize, {
    bool isY = false,
  }) {
    if (isY) {
      double screenCenter = screenSize / 2;
      return Offset(0, screenCenter - (normalizedValue * _radius));
    } else {
      double screenCenter = screenSize / 2;
      return Offset(screenCenter + (normalizedValue * _radius), 0);
    }
  }

  String _getMoodLabel(BuildContext context, double valence, double arousal) {
    final l10n = AppLocalizations.of(context)!;
    if (valence.abs() < 0.2 && arousal.abs() < 0.2) {
      return l10n.seeding_mood_neutral;
    }
    if (arousal > 0) {
      if (valence > 0) return l10n.seeding_mood_energized;
      return l10n.seeding_mood_stressed;
    } else {
      if (valence > 0) return l10n.seeding_mood_calm;
      return l10n.seeding_mood_tired;
    }
  }

  Widget _buildSeedIcon(double arousal, Duration pulseDuration) {
    Color seedColor;
    final seedingState = ref.read(seedingNotifierProvider);

    if (seedingState.arousal > 0) {
      if (seedingState.valence > 0) {
        seedColor = AppColors.seedingSun;
      } else {
        seedColor = AppColors.seedingFire;
      }
    } else {
      if (seedingState.valence > 0) {
        seedColor = AppColors.seedingGrass;
      } else {
        seedColor = AppColors.seedingRain;
      }
    }
    // Neutral override
    if (seedingState.valence.abs() < 0.2 && seedingState.arousal.abs() < 0.2) {
      seedColor = Colors.white;
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: seedColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: seedColor.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.spa, color: Colors.black54, size: 30),
      ),
    );
  }

  Widget _buildEmotionChips(BuildContext context, AppLocalizations l10n) {
    final seedingState = ref.watch(seedingNotifierProvider);
    final recommendedTags = ref
        .read(seedingNotifierProvider.notifier)
        .getRecommendedTags();

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = MediaQuery.of(context).size.height - bottomInset;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child:
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: availableHeight * 0.85),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.seedingCardBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // 1. Tags
                    Text(
                      l10n.seeding_promptTags,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: recommendedTags.map((tag) {
                        final localizedTag = _getLocalizedTag(l10n, tag);
                        final isSelected = seedingState.selectedTags.contains(
                          tag,
                        );
                        return FilterChip(
                          label: Text(localizedTag),
                          selected: isSelected,
                          onSelected: (selected) {
                            ref
                                .read(seedingNotifierProvider.notifier)
                                .toggleTag(tag);
                            HapticFeedback.selectionClick();
                          },
                          elevation: 0,
                          pressElevation: 0,
                          showCheckmark: false,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          selectedColor: AppColors.seedingChipSelected,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.seedingChipTextSelected
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.white.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
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
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: seedingState.isSaving
                            ? null
                            : () async {
                                HapticFeedback.mediumImpact();
                                await ref
                                    .read(seedingNotifierProvider.notifier)
                                    .saveRecord();

                                if (widget.onComplete != null) {
                                  widget.onComplete!();
                                } else {
                                  // Default behavior
                                  // NOTE: We cannot use context.go here easily if this widget is decoupled.
                                  // But assuming typical usage, we can leave it to caller or use a callback.
                                  // For now, I will NOT include context.go here.
                                  // I will assume SeedingScreen wraps this and passes onComplete = context.go(...).
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: seedingState.isSaving
                            ? const CircularProgressIndicator()
                            : Text(
                                l10n.seeding_buttonPlant,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slideY(
              begin: 1.0,
              end: 0.0,
              duration: 500.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }
}
