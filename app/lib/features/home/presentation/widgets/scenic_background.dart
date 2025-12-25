import 'dart:ui';
import 'package:flutter/material.dart';

class ScenicBackground extends StatelessWidget {
  final double sunlight; // 0.0 (Night) ~ 1.0 (Day)
  final double offsetY; // Vertical shift
  final String imagePath;

  const ScenicBackground({
    super.key,
    required this.sunlight,
    this.offsetY = 0,
    this.imagePath = 'assets/images/backgrounds/background_night.png',
  });

  @override
  Widget build(BuildContext context) {
    // Atmospheric strengths
    final vignetteStrength = lerpDouble(0.65, 0.15, sunlight)!;
    final fogStrength = lerpDouble(0.20, 0.05, sunlight)!;

    // Subtle overlay tint for blending (Night is deep void, Day is warm air)
    final tintOpacity = lerpDouble(0.40, 0.10, sunlight)!;
    final tintColor = Color.lerp(
      const Color(0xFF07121C), // Night Tint
      const Color(0xFFFFE7C2), // Day Tint
      sunlight,
    )!.withValues(alpha: tintOpacity);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Base Layer
        Transform.translate(
          offset: Offset(0, offsetY),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),

        // 3. Subtle Tint Overlay (Unifies the look)
        Container(color: tintColor),

        // 4. Fog / Glow (Central Bloom)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.2),
                radius: 1.2,
                colors: [
                  Colors.white.withValues(alpha: fogStrength),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.8],
              ),
            ),
          ),
        ),

        // 5. Sun/Moon Glow
        _buildOrbGlow(sunlight),

        // 6. Vignette (Depth)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.3,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: vignetteStrength),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
        ),

        // 7. Extra Atmosphere Gradient (Top-down)
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(
                    Colors.indigo,
                    Colors.orangeAccent,
                    sunlight,
                  )!.withValues(alpha: 0.1),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrbGlow(double sunlight) {
    final orbColor = Color.lerp(
      Colors.blueGrey.shade200, // Moon
      Colors.orangeAccent.shade100, // Sun
      sunlight,
    )!;

    return Positioned(
      top: 80 - (sunlight * 40), // Rises during day
      right: 40,
      child: IgnorePointer(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                orbColor.withValues(alpha: 0.4 * (0.4 + sunlight * 0.4)),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
