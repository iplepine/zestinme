import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/seeding_provider.dart';
import 'seeding_painters.dart';
import 'emotion_selection_sheet.dart';

class SeedingContent extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const SeedingContent({super.key, this.onComplete});

  @override
  ConsumerState<SeedingContent> createState() => _SeedingContentState();
}

class _SeedingContentState extends ConsumerState<SeedingContent> {
  Offset _center = Offset.zero;
  double _radius = 0.0;
  bool _hasInteracted = false;

  @override
  void dispose() {
    super.dispose();
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

    // Haptic Feedback on Zone Change
    ref.listen(seedingNotifierProvider, (previous, next) {
      if (previous == null) return;

      String getZone(double v, double a) {
        if (v.abs() < 0.2 && a.abs() < 0.2) return 'neutral';
        if (a > 0) return v > 0 ? 'highPos' : 'highNeg';
        return v > 0 ? 'lowPos' : 'lowNeg';
      }

      final prevZone = getZone(previous.valence, previous.arousal);
      final nextZone = getZone(next.valence, next.arousal);

      if (prevZone != nextZone) {
        HapticFeedback.selectionClick();
      }

      // Check for Planted State Transition to show Sheet
      if (!previous.isPlanted && next.isPlanted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showBottomSheet(context);
        });
      }
    });

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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        28 *
                        MediaQuery.textScalerOf(context)
                            .scale(1)
                            .clamp(
                              0.8,
                              1.2,
                            ), // Slightly less aggressive scaling for title
                    fontWeight: FontWeight.bold,
                    shadows: const [
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18 * MediaQuery.textScalerOf(context).scale(1),
                      fontWeight: FontWeight.w300,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms),
              ),

            // 6. Draggable Seed
            Semantics(
              label: "기분 선택 영역",
              value: _getMoodLabel(
                context,
                seedingState.valence,
                seedingState.arousal,
              ),
              hint: "화면을 드래그하여 지금의 기분을 선택하세요. 상단으로 갈수록 활기차고, 우측으로 갈수록 긍정적입니다.",
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _hasInteracted = true;
                  });
                  ref.read(seedingNotifierProvider.notifier).startDrag();
                },
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
                        child:
                            _buildSeedIcon(seedingState.arousal, pulseDuration)
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
            ),

            // 5. Swipe Guide (Only if not interacted yet)
            if (!seedingState.isPlanted &&
                !seedingState.isDragging &&
                !_hasInteracted)
              _buildSwipeGuide(context),

            // 6. Post-Planting Options (Now handled by modal bottom sheet)
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EmotionSelectionSheet(onComplete: widget.onComplete),
      ),
    ).then((_) {
      if (mounted) {
        final state = ref.read(seedingNotifierProvider);
        // If the sheet was dismissed without saving, cancel planting
        if (state.isPlanted && !state.isSaving) {
          ref.read(seedingNotifierProvider.notifier).cancelPlanting();
        }
      }
    });
  }

  Widget _buildSwipeGuide(BuildContext context) {
    return Positioned(
      left:
          _center.dx - 15, // Adjusted to make the fingertip start at the center
      top:
          _center.dy - 15, // Adjusted to make the fingertip start at the center
      child: IgnorePointer(
        child: Column(
          children: [
            const Icon(
                  Icons.touch_app,
                  color: AppColors.primary,
                  size: 50,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                )
                .animate(onPlay: (c) => c.repeat(), delay: 3000.ms)
                .move(
                  begin: const Offset(0, 0),
                  end: const Offset(50, -50),
                  duration: 1500.ms,
                  curve: Curves.easeInOutExpo,
                )
                .fadeIn(duration: 500.ms)
                .then(delay: 500.ms)
                .fadeOut(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
