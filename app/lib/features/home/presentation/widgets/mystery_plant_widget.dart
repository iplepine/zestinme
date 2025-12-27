import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zestinme/core/widgets/interactive_prop.dart';
import 'package:zestinme/core/constants/app_colors.dart';

class MysteryPlantWidget extends StatelessWidget {
  final int growthStage;
  final bool isThirsty; // Caring Needed
  final VoidCallback onPlantTap; // Record Mind
  final VoidCallback onWaterTap; // Pruning
  final String? plantName;
  final double potWidth;
  final double plantBaseSize;
  final double plantBottomOffset;
  final double scaleFactorPerStage;
  final String category; // 'herb', 'leaf', 'succ', 'weired'
  final double customOffsetY; // Species-specific vertical adjustment

  const MysteryPlantWidget({
    super.key,
    required this.growthStage,
    required this.isThirsty,
    required this.onPlantTap,
    required this.onWaterTap,
    this.plantName,
    this.potWidth = 100, // Updated Default
    this.plantBaseSize = 120, // Updated Default
    this.plantBottomOffset = 50, // Updated Default
    this.scaleFactorPerStage = 25.0,
    this.category = 'herb',
    this.customOffsetY = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 1. Plant Body (Clickable implies "Record Mind" or just Interaction)
        GestureDetector(
          onTap: onPlantTap,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 300,
            height: 400,
            alignment: Alignment.bottomCenter,
            child: _buildPlantImage(growthStage),
          ),
        ),

        // 2. Thirsty Indicator (Water Drop) -> Pruning
        if (isThirsty)
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(onTap: onWaterTap, child: _buildWaterDrop()),
          ),

        // 3. Name Label (Only for Stage 3)
        if (growthStage >= 3 && plantName != null)
          Positioned(
            bottom: -40,
            child: Text(
              plantName!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
              ),
            ).animate().fadeIn().moveY(begin: 10, end: 0),
          ),
      ],
    );
  }

  Widget _buildPlantImage(int stage) {
    // 1. Determine Assets (Demo: Crystal Pot & Rosemary)
    const potAsset = 'assets/images/pots/pot_default.png';

    // Mapping category to specific asset filename pattern
    // Assets are named like: plant_herb_1.png, plant_herb_2.png, plant_herb_3.png, etc.

    // Determine max stage for clamp based on category
    int maxStage = 4;
    if (category == 'tree') maxStage = 5;
    if (category == 'leaf') maxStage = 3;
    if (category == 'herb') maxStage = 3;
    if (category == 'flytrap') maxStage = 2;
    if (category == 'succ' || category == 'succulent') maxStage = 4;

    final assetStage = (stage + 1).clamp(1, maxStage);

    String filename;
    switch (category) {
      case 'leaf':
        filename = 'plant_leaf_$assetStage.png';
        break;
      case 'succulent':
        filename = 'plant_succulent_$assetStage.png';
        break;
      case 'weird':
        filename = 'plant_weird_1.png';
        break;
      case 'tree':
        filename = 'plant_tree_$assetStage.png';
        break;
      case 'flytrap':
        filename = 'plant_flytrap_$assetStage.png';
        break;
      case 'herb':
      default:
        filename = 'plant_herb_$assetStage.png';
    }

    String plantAsset = 'assets/images/plants/$filename';

    // Total size = Base Size + (stage * scaleFactor)
    final totalSize = plantBaseSize + (stage * scaleFactorPerStage);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Layer 0: Backglow (Ambient Mist)
        Positioned(
              bottom: 40,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.spiritTeal.withValues(alpha: 0.15),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
              duration: 4.seconds,
              curve: Curves.easeInOut,
            ),

        // Layer A: Pot (Base) - Truly Static
        Image.asset(
          potAsset,
          width: potWidth,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),

        // Layer B: Plant (Growth)
        Positioned(
          bottom:
              plantBottomOffset -
              (customOffsetY * 100), // Adjusted relative to pot
          child: InteractiveProp(
            animationType: PropAnimationType.swing,
            alignment: const Alignment(0.0, 0.5),
            intensity: 0.7, // Approx 2 degrees (0.05 * 0.7 = 0.035 rad)
            duration: const Duration(seconds: 6),
            onTap: onPlantTap,
            child: Image.asset(
              plantAsset,
              width: totalSize,
              height: totalSize,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                // Fallback to first stage if specific stage asset is missing
                return Image.asset(
                  'assets/images/plants/m_${category}_1.png',
                  width: totalSize,
                  height: totalSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterDrop() {
    return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.spiritTeal,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.spiritTeal, blurRadius: 10)],
          ),
          child: const Icon(Icons.water_drop, color: AppColors.midnightDeep),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -10, duration: 1500.ms, curve: Curves.easeInOut);
  }
}
