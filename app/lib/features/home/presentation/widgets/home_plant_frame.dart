import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/core/constants/app_colors.dart';

class HomePlantFrame extends ConsumerWidget {
  final Widget plantWidget;
  final String plantName;
  final double moisture; // 0.0 to 1.0 (or percentage)
  final int growthStage;
  final double stability; // 0.0 to 1.0 (Valence normalized)

  const HomePlantFrame({
    super.key,
    required this.plantWidget,
    required this.plantName,
    required this.moisture,
    required this.growthStage,
    required this.stability,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. The Glass Frame with Plant
        SizedBox(
          height: 380, // Hero size
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Backlight / Aura
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _getStabilityColor(stability).withOpacity(0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.2, 0.8],
                  ),
                ),
              ),

              // Plant Layer
              plantWidget,

              // STABLE Meter (Right Side)
              Positioned(
                right: 20,
                bottom: 60,
                top: 60,
                child: _buildStableMeter(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 2. Info Card (Glass)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("MOISTURE", "${(moisture * 100).toInt()}%"),
              Container(width: 1, height: 24, color: Colors.white12),
              _buildStatItem("GROWTH", "Stage $growthStage"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            fontFamily: 'Roboto', // Or standard sans
          ),
        ),
      ],
    );
  }

  Widget _buildStableMeter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FractionallySizedBox(
                  heightFactor: stability.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getStabilityColor(stability),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: _getStabilityColor(stability).withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "STABLE",
          style: TextStyle(
            color: Colors.white30,
            fontSize: 8,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Color _getStabilityColor(double val) {
    if (val > 0.7) return AppColors.spiritTeal;
    if (val < 0.3) return AppColors.fire;
    return AppColors.lanternGlow;
  }
}
