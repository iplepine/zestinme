import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class EnvironmentBackground extends StatelessWidget {
  final double sunlight; // 0.0 (Night) ~ 1.0 (Day)
  final double temperature; // 0.0 (Cold) ~ 1.0 (Hot)
  final double humidity; // 0.0 (Dry) ~ 1.0 (Wet)

  const EnvironmentBackground({
    super.key,
    required this.sunlight,
    required this.temperature,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Base Gradient (Sunlight & Temperature)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_getSkyColor(), _getAmbientColor()],
            ),
          ),
        ),

        // 2. Sun/Moon Orb
        Positioned(
          top: 50 + (1.0 - sunlight) * 20, // Lower when night
          right: 30,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  sunlight > 0.5
                      ? Colors.orange.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: sunlight > 0.5
                      ? Colors.orangeAccent.withOpacity(0.5)
                      : Colors.blueGrey.withOpacity(0.3),
                  blurRadius: 40 + sunlight * 20,
                  spreadRadius: 10 + temperature * 10,
                ),
              ],
            ),
          ),
        ),

        // 3. Humidity Particles (Fog/Dust)
        // Check for CustomPaint later for animation
      ],
    );
  }

  Color _getSkyColor() {
    // Sunlight: Dark Blue (Night) <-> Light Blue (Day)
    final baseColor = Color.lerp(
      AppColors.voidBlack, // Deep Night (Baseline)
      const Color(0xFF4FC3F7), // Bright Day
      sunlight,
    )!;

    // Temperature tint
    // Cold -> Add Blue/Cyan tint
    // Hot -> Add Orange/Red tint
    if (temperature < 0.5) {
      return Color.lerp(baseColor, Colors.indigoAccent, (0.5 - temperature))!;
    } else {
      return Color.lerp(
        baseColor,
        Colors.orangeAccent,
        (temperature - 0.5) * 0.5,
      )!;
    }
  }

  Color _getAmbientColor() {
    // Ground/Horizon color
    final baseGround = Color.lerp(
      const Color(0xFF1B2631), // Dark Earth
      const Color(0xFFD7CCC8), // Light Earth
      sunlight,
    )!;

    // Humidity affects fog density (whiteness)
    return Color.lerp(
      baseGround,
      Colors.grey.withOpacity(0.5),
      humidity * 0.5,
    )!;
  }
}
