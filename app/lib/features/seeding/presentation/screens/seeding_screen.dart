import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zestinme/features/seeding/presentation/providers/seeding_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final seedingState = ref.watch(seedingNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate center and radius based on screen size
          _center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
          _radius =
              constraints.maxWidth * 0.4; // 80% of width is the active area

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background: Dynamic Soil
              CustomPaint(
                painter: SoilPainter(
                  valence: seedingState.valence,
                  arousal: seedingState.arousal,
                ),
                size: Size.infinite,
              ),

              // 2. Guide Lines (Optional, subtle)
              Center(
                child: Container(
                  width: _radius * 2,
                  height: _radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
              ),

              // 3. Instruction Text (Fade out when dragging)
              if (!seedingState.isDragging && !seedingState.isPlanted)
                Positioned(
                  top: constraints.maxHeight * 0.2,
                  left: 0,
                  right: 0,
                  child: const Text(
                    "Where is your heart?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ).animate().fadeIn(duration: 800.ms),
                ),

              // 4. Draggable Seed
              // We use a simplified connection to gesture detector directly on the stack
              // to allow "drag anywhere" mapped to the seed.
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
                            24, // 24 is half size
                        top:
                            _calculateSeedPosition(
                              seedingState.arousal,
                              constraints.maxHeight,
                              isY: true,
                            ).dy -
                            24,
                        child: _buildSeedIcon(seedingState),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Post-Planting Options (Chips)
              if (seedingState.isPlanted) _buildEmotionChips(context),
            ],
          );
        },
      ),
    );
  }

  void _handleDrag(Offset position) {
    // Normalize position relative to center
    // X: -1 (Left) to 1 (Right)
    // Y: 1 (Top) to -1 (Bottom) -> Note: Screen Y is down-positive, Graph Y is up-positive

    // We want Y up (High Energy) to be negative screen coordinates relative to center?
    // No, standard graph: Up is positive Y. Screen: Up is negative Y.
    // Let's stick to standard map: Top is High Arousal (Positive), Right is Pleasant (Positive).

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
    // If isY: 1.0 -> Center - Radius
    //         -1.0 -> Center + Radius

    if (isY) {
      // Screen Y = Center Y - (Value * Radius)
      return Offset(0, _center.dy - (normalizedValue * _radius));
    } else {
      // Screen X = Center X + (Value * Radius)
      return Offset(_center.dx + (normalizedValue * _radius), 0);
    }
  }

  Widget _buildSeedIcon(SeedingState state) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.spa, color: Colors.green, size: 24),
    );
  }

  Widget _buildEmotionChips(BuildContext context) {
    // Placeholder for chips
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton(
          onPressed: () {}, // TODO: Finish
          child: const Text("Plant this seed"),
        ).animate().fadeIn().moveY(begin: 20, end: 0),
      ),
    );
  }
}

class SoilPainter extends CustomPainter {
  final double valence;
  final double arousal;

  SoilPainter({required this.valence, required this.arousal});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base colors for 4 quadrants
    // Top-Right (High V, High A): Warm Sunny (Orange/Yellow)
    // Top-Left (Low V, High A): Intense Volcanic (Red/Dark Grey)
    // Bottom-Left (Low V, Low A): Depressive Swamp (Dark Blue/Grey)
    // Bottom-Right (High V, Low A): Calm Forest (Green/Teal)

    // Interpolate based on Valence and Arousal
    // We interpret V/A as weights to blend these colors.

    // Simple approach: Radial gradient that shifts center or colors based on position?
    // Let's try blending 4 colors based on distance to corners.

    // Just a placeholder dynamic background for now
    // We shift the color temperature based on Valence (-1 Cold -> 1 Warm)
    // And brightness/intensity based on Arousal (-1 Dark/Dull -> 1 Bright/Intense)

    Color baseColor;
    if (valence >= 0 && arousal >= 0) {
      baseColor = Color.lerp(Colors.yellow, Colors.orange, arousal)!;
    } else if (valence < 0 && arousal >= 0) {
      baseColor = Color.lerp(Colors.grey, Colors.red, arousal)!;
    } else if (valence < 0 && arousal < 0) {
      baseColor = Color.lerp(Colors.black, Colors.blueGrey, arousal.abs())!;
    } else {
      // V > 0, A < 0
      baseColor = Color.lerp(Colors.greenAccent, Colors.teal, arousal.abs())!;
    }

    // Creating a rich soil gradient
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 0),
        radius: 1.5,
        colors: [
          baseColor.withOpacity(0.8),
          const Color(0xFF1a1a1a), // Dark edge
        ],
        stops: const [0.2, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant SoilPainter oldDelegate) {
    return oldDelegate.valence != valence || oldDelegate.arousal != arousal;
  }
}
