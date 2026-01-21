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
  final double customOffsetX; // Species-specific horizontal adjustment
  final double customOffsetY; // Species-specific vertical adjustment
  final bool showPot; // New parameter

  const MysteryPlantWidget({
    super.key,
    required this.growthStage,
    required this.isThirsty,
    required this.onPlantTap,
    required this.onWaterTap,
    this.plantName,
    this.potWidth = 100,
    this.plantBaseSize = 120,
    this.plantBottomOffset = 50,
    this.scaleFactorPerStage = 25.0,
    this.category = 'herb',
    this.customOffsetX = 0.0,
    this.customOffsetY = 0.0,
    this.showPot = true, // Default to true for backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 1. Plant Body (Clickable)
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
    // 1. Determine Assets
    const potAsset = 'assets/images/pots/pot_default.png';

    // Asset selection logic
    String filename;
    // Map internal categories to asset filenames we saw in `ls`
    // plant_herb_x.png, plant_tree_x.png, etc.
    if (category.contains('rubber')) {
      filename = 'rubber_plant_small_01.png';
    } else {
      // Temporary Fallback: Use rubber plant for all while other assets are being redesigned
      filename = 'rubber_plant_small_01.png';
    }

    String plantAsset = 'assets/images/plants/$filename';
    final totalSize = plantBaseSize + (stage * scaleFactorPerStage);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Layer 0: Backglow
        Positioned(
          bottom: 40,
          child:
              Container(
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
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                    duration: 4.seconds,
                    curve: Curves.easeInOut,
                  ),
        ),

        // Layer A: Pot (Base) - Conditional
        if (showPot)
          Image.asset(
            potAsset,
            width: potWidth,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),

        // Layer B: Plant (Growth)
        Positioned(
          left: (300 - totalSize) / 2 + (customOffsetX * 100),
          bottom: plantBottomOffset - (customOffsetY * 100),
          child: InteractiveProp(
            animationType: PropAnimationType.swing,
            alignment: const Alignment(0.0, 0.5),
            intensity:
                0.4, // Approx 1.1 degrees from 0.05 rad base, total swing subtler
            duration: const Duration(seconds: 10),
            onTap: onPlantTap,
            child: Image.asset(
              plantAsset,
              width: totalSize,
              height: totalSize,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                // Fallback
                return Image.asset(
                  'assets/images/plants/plant_herb_1.png',
                  width: totalSize,
                  height: totalSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.yard, size: 60, color: Colors.white24),
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
          decoration: const BoxDecoration(
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
