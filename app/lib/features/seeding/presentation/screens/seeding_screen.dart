import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zestinme/features/seeding/presentation/providers/seeding_provider.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart'; // Correct generated import
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

class SeedingScreen extends ConsumerStatefulWidget {
  const SeedingScreen({super.key});

  @override
  ConsumerState<SeedingScreen> createState() => _SeedingScreenState();
}

class _SeedingScreenState extends ConsumerState<SeedingScreen> {
  // Center point of the soil area, calculated in build/layout
  Offset _center = Offset.zero;
  double _radius = 0.0; // Max drag radius

  // Helper to determine mood label based on coordinates
  String _getMoodLabel(BuildContext context, double valence, double arousal) {
    final l10n = AppLocalizations.of(context)!;
    if (valence.abs() < 0.2 && arousal.abs() < 0.2)
      return l10n.seeding_mood_neutral;

    if (arousal > 0) {
      // High Energy
      if (valence > 0) {
        return l10n.seeding_mood_energized; // Top-Right
      }
      return l10n.seeding_mood_stressed; // Top-Left
    } else {
      // Low Energy
      if (valence > 0) return l10n.seeding_mood_calm; // Bottom-Right
      return l10n.seeding_mood_tired; // Bottom-Left
    }
  }

  @override
  Widget build(BuildContext context) {
    final seedingState = ref.watch(seedingNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    // Calculate pulse duration based on arousal (-1.0 to 1.0)
    // Map -1.0 (Slow) -> 2000ms, 1.0 (Fast) -> 500ms
    final pulseDuration = (2000 - ((seedingState.arousal + 1) / 2 * 1500))
        .round()
        .ms;

    // Force Dark Theme for this screen as it has a specific dark aesthetic (Space/Night)
    // This ensures Chips and other widgets inherit dark mode styles (e.g. text colors, chip backgrounds)
    // instead of pulling Light Theme values if the system is in Light Mode.
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset:
            false, // Prevent keyboard from pushing up the background
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate center and radius based on screen size
            _center = Offset(
              constraints.maxWidth / 2,
              constraints.maxHeight / 2,
            );
            _radius =
                constraints.maxWidth * 0.4; // 80% of width is the active area

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

                // 2. Guide Lines (Crosshairs)
                CustomPaint(
                  painter: GuidePainter(
                    center: _center,
                    radius: _radius,
                    l10n: l10n,
                  ),
                  size: Size.infinite,
                ),

                // 3. Dynamic Mood Label (Background text with Shadow)
                if (seedingState.isDragging)
                  Center(
                    child:
                        Text(
                              _getMoodLabel(
                                context,
                                seedingState.valence,
                                seedingState.arousal,
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: AppColors.seedingTextShadow,
                                  ),
                                ],
                              ),
                            )
                            .animate(
                              key: ValueKey(
                                _getMoodLabel(
                                  context,
                                  seedingState.valence,
                                  seedingState.arousal,
                                ),
                              ),
                            )
                            .fadeIn(duration: 300.ms)
                            .scale(begin: const Offset(0.9, 0.9)),
                  ),

                // 4. Instruction Text (Fade out when dragging)
                if (!seedingState.isDragging && !seedingState.isPlanted)
                  Positioned(
                    top:
                        constraints.maxHeight *
                        0.25, // Moved down slightly as requested
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                      ), // Increased padding
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
                  behavior:
                      HitTestBehavior.translucent, // Catch touches everywhere
                  child: SizedBox.expand(
                    child: Stack(
                      children: [
                        // The Seed Visual
                        Positioned(
                          left:
                              _calculateSeedPosition(
                                seedingState.valence,
                                constraints.maxWidth,
                              ).dx -
                              30, // 30 is half size (60/2)
                          top:
                              _calculateSeedPosition(
                                seedingState.arousal,
                                constraints.maxHeight,
                                isY: true,
                              ).dy -
                              30,
                          child:
                              _buildSeedIcon(
                                    seedingState.arousal,
                                    pulseDuration,
                                  )
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
        ),
      ),
    );
  }

  void _handleDrag(Offset position) {
    // Normalize position relative to center
    double dx = (position.dx - _center.dx) / _radius;
    double dy =
        (_center.dy - position.dy) / _radius; // Invert Y so up is positive

    ref.read(seedingNotifierProvider.notifier).updateCoordinates(dx, dy);
  }

  Offset _calculateSeedPosition(
    double normalizedValue,
    double screenSize, {
    bool isY = false,
  }) {
    // Convert normalized (-1 to 1) back to screen coordinates
    if (isY) {
      // Screen Y = Center Y - (Value * Radius)
      return Offset(0, _center.dy - (normalizedValue * _radius));
    } else {
      // Screen X = Center X + (Value * Radius)
      return Offset(_center.dx + (normalizedValue * _radius), 0);
    }
  }

  Widget _buildSeedIcon(double arousal, Duration pulseDuration) {
    // A more organic, glowing "Spirit Seed"
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow (Breathing)
          Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(
                        alpha: 0.3 + (arousal * 0.1),
                      ),
                      blurRadius: 20 + (arousal * 10),
                      spreadRadius: 5,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleXY(end: 1.1, duration: pulseDuration),

          // Core Halo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),

          // The Core Seed
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.white, blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: const Icon(
              Icons.spa,
              color: AppColors.seedingGrass,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionChips(BuildContext context, AppLocalizations l10n) {
    final seedingState = ref.watch(seedingNotifierProvider);
    final recommendedTags = ref
        .read(seedingNotifierProvider.notifier)
        .getRecommendedTags();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child:
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              // Increased opacity and used dark grey for better contrast
              color: const Color(0xFF1E1E1E).withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.seeding_promptTags,
                  style: const TextStyle(
                    color: Colors.white, // Increased from white70
                    fontSize: 20, // Slightly larger
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recommendedTags.map((tag) {
                    final isSelected = seedingState.selectedTags.contains(tag);
                    final localizedTag = _getLocalizedTag(l10n, tag);
                    return FilterChip(
                      label: Text(localizedTag),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .read(seedingNotifierProvider.notifier)
                            .toggleTag(tag);
                      },
                      // Fix: Explicitly disable elevation and set dark background to prevent white surface
                      elevation: 0,
                      pressElevation: 0,
                      backgroundColor: Colors
                          .transparent, // Or use dark color if transparent fails
                      surfaceTintColor: Colors.transparent,

                      selectedColor: AppColors.seedingSun,
                      checkmarkColor: Colors.black,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.white.withValues(
                                  alpha: 0.5,
                                ), // Visible white border
                          width: 1.2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (value) => ref
                      .read(seedingNotifierProvider.notifier)
                      .updateNote(value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: l10n.seeding_promptNote,
                    // Much brighter hint text
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    filled: true,
                    // Brighter input field background
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: seedingState.isSaving
                        ? null
                        : () async {
                            await ref
                                .read(seedingNotifierProvider.notifier)
                                .saveRecord();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.seeding_messagePlanted),
                                ),
                              );
                              context.pop(); // Return to Home
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seedingSun,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: seedingState.isSaving
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Text(
                            l10n.seeding_buttonPlant,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20), // Bottom padding
              ],
            ),
          ).animate().moveY(
            begin: 300,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }

  String _getLocalizedTag(AppLocalizations l10n, String tag) {
    switch (tag.toLowerCase()) {
      case 'neutral':
        return l10n.seeding_mood_neutral;
      case 'okay':
        return l10n.seeding_mood_okay;
      case 'so-so':
        return l10n.seeding_mood_soso;
      case 'excited':
        return l10n.seeding_mood_excited;
      case 'joyful':
        return l10n.seeding_mood_joyful;
      case 'passionate':
        return l10n.seeding_mood_passionate;
      case 'surprised':
        return l10n.seeding_mood_surprised;
      case 'angry':
        return l10n.seeding_mood_angry;
      case 'anxious':
        return l10n.seeding_mood_anxious;
      case 'annoyed':
      case 'annoy':
        return l10n.seeding_mood_annoyed;
      case 'stressed':
      case 'stress':
        return l10n.seeding_mood_stressed;
      case 'calm':
        return l10n.seeding_mood_calm;
      case 'relieved':
        return l10n.seeding_mood_relieved;
      case 'grateful':
        return l10n.seeding_mood_grateful;
      case 'peaceful':
        return l10n.seeding_mood_peaceful;
      case 'depressed':
        return l10n.seeding_mood_depressed;
      case 'tired':
        return l10n.seeding_mood_tired;
      case 'sad':
        return l10n.seeding_mood_sad;
      case 'bored':
        return l10n.seeding_mood_bored;
      case 'focused':
        return l10n.seeding_mood_focused;
      case 'melancholy':
        return l10n.seeding_mood_melancholy;
      default:
        return tag;
    }
  }
}

class SoilPainter extends CustomPainter {
  final double valence;
  final double arousal;
  final Offset center;

  SoilPainter({
    required this.valence,
    required this.arousal,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Paint paint = Paint(); // Removed unused variable

    // Base background (Deep neutral to make colors pop)
    canvas.drawRect(
      rect,
      Paint()..color = const Color(0xFF1A1A1A), // Dark charcoal base
    );

    // 1. Draw 4 Corner Radial Gradients (Base Layer)
    // This avoids diagonal lines (Vertices) and angular lines (Sweep)
    // and naturally creates gradients along the axes where they meet.

    // Increased radius and alpha for better visibility "본인의 색상"
    final double radius = size.longestSide; // Full coverage
    final Color cSun = AppColors.seedingSun.withValues(alpha: 0.7);
    final Color cFire = AppColors.seedingFire.withValues(alpha: 0.7);
    final Color cRain = AppColors.seedingRain.withValues(alpha: 0.7);
    final Color cGrass = AppColors.seedingGrass.withValues(alpha: 0.7);
    final Color cTransparent = Colors.transparent;

    // Helper to draw corner gradient
    void drawCorner(Offset center, Color color) {
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius,
          [color, cTransparent],
          [
            0.2,
            1.0,
          ], // Keep color solid for first 20% (as requested), then fade
        )
        ..blendMode = BlendMode.srcOver;
      canvas.drawRect(rect, paint);
    }

    // Order: Draw all 4.
    // They will blend because they have alpha and fade to transparent.
    drawCorner(Offset(size.width, 0), cSun); // Top-Right
    drawCorner(Offset(0, 0), cFire); // Top-Left
    drawCorner(Offset(0, size.height), cRain); // Bottom-Left
    drawCorner(Offset(size.width, size.height), cGrass); // Bottom-Right

    // 2. Dynamic Overlay: Spread active quadrant color based on intensity
    // Calculate intensity (distance from center, normalized 0.0 to 1.0)
    final double intensity = (valence * valence + arousal * arousal).clamp(
      0.0,
      1.0,
    ); // Simple approximation

    // Determine active color
    Color activeColor;
    if (arousal > 0) {
      if (valence > 0) {
        activeColor = AppColors.seedingSun;
      } else {
        activeColor = AppColors.seedingFire;
      }
    } else {
      if (valence > 0) {
        activeColor = AppColors.seedingGrass;
      } else {
        activeColor = AppColors.seedingRain;
      }
    }

    // Apply overlay with smooth fade-in
    // We start showing the color as user moves away from center.
    // At intensity 1.0 (edge), alpha is high (e.g. 0.9) to dominate but keep some texture.
    final overlayPaint = Paint()
      ..color = activeColor.withValues(alpha: intensity * 0.9);
    canvas.drawRect(rect, overlayPaint);

    // 3. Vignette to focus center (kept for aesthetic depth)
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
        stops: const [0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, vignettePaint);
  }

  @override
  bool shouldRepaint(covariant SoilPainter oldDelegate) {
    return oldDelegate.valence != valence ||
        oldDelegate.arousal != arousal ||
        oldDelegate.center != center;
  }
}

class GuidePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final AppLocalizations l10n;

  GuidePainter({
    required this.center,
    required this.radius,
    required this.l10n,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Circle (Thinner, more subtle)
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Dashed effect for circle (simulated with manual implementation or just kept solid but faint)
    // Keeping solid for elegance but very faint
    canvas.drawCircle(center, radius, circlePaint);

    // Draw Crosshairs with Gradient Fades
    // We want the lines to be visible in the quadrants but fade out at the center (to not obstruct the seed)
    // and at the edges (for softness).

    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Colors.white.withValues(alpha: 0.0), // Center: Transparent
          Colors.white.withValues(alpha: 0.2), // Mid: Visible
          Colors.white.withValues(alpha: 0.0), // Edge: Transparent
        ],
        [0.0, 0.5, 1.0], // Stops
      );

    // Horizontal Line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      linePaint,
    );

    // Vertical Line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      linePaint,
    );

    // Draw Quadrant Labels (Corners of the map)
    // Using screen coordinates for balanced quadrant placement
    // Horizontal: Centered in each column (25% and 75%)
    // Vertical: Pushed towards top/bottom (18% and 82%)
    final double leftX = size.width * 0.25;
    final double rightX = size.width * 0.75;
    final double topY = size.height * 0.18;
    final double bottomY = size.height * 0.82;

    // Top-Right: Energized
    _drawText(
      canvas,
      l10n.seeding_quadrant_energized,
      Offset(rightX, topY),
      isLarge: true,
    );

    // Top-Left: Stressed
    _drawText(
      canvas,
      l10n.seeding_quadrant_stress,
      Offset(leftX, topY),
      isLarge: true,
    );

    // Bottom-Left: Tired
    _drawText(
      canvas,
      l10n.seeding_quadrant_tired,
      Offset(leftX, bottomY),
      isLarge: true,
    );

    // Bottom-Right: Calm
    _drawText(
      canvas,
      l10n.seeding_quadrant_calm,
      Offset(rightX, bottomY),
      isLarge: true,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position, {
    bool isLarge = false,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.8), // High readability
        fontSize: isLarge ? 20 : 12, // Significant size increase
        fontWeight: isLarge ? FontWeight.bold : FontWeight.w500,
        letterSpacing: isLarge ? 1.2 : 0,
        shadows: const [
          Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
        ],
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant GuidePainter oldDelegate) {
    return oldDelegate.center != center || oldDelegate.radius != radius;
  }
}
