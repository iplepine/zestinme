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

  const MysteryPlantWidget({
    super.key,
    required this.growthStage,
    required this.isThirsty,
    required this.onPlantTap,
    required this.onWaterTap,
    this.plantName,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 1. Plant Body (Clickable implies "Record Mind" or just Interaction)
        // Spec says: Center Object -> Function: Seeding (Record).
        // Spec says: Idle -> Tap Interaction -> [Record Sheet]
        // Spec says: Idle -> Tap Interaction -> [Record Sheet]
        GestureDetector(
          // Outer hit box if needed, or rely on children
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
    const potAsset = 'assets/images/pots/pot_crystal.png';
    String plantAsset;

    // Map stage to asset
    // Demo: Show Rosemary Full for ALL stages so user can see the asset
    // (In production, replace with proper stage assets)
    plantAsset = 'assets/images/plants/rosemary_full.png';

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // Layer A: Pot (Base) - Truly Static
        Image.asset(
          potAsset,
          width: 180,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),

        // Layer B: Plant (Growth)
        Positioned(
          bottom: 60, // Align with pot rim
          child: InteractiveProp(
            animationType: PropAnimationType.swing,
            // Image has padding, so root is likely near center-bottom, not absolute bottom.
            // (0.0, 0.5) roughly pivots around the lower-mid section (stem).
            alignment: const Alignment(0.0, 0.5),
            intensity: 1.8, // Reduced sway (~5 deg)
            duration: const Duration(seconds: 6), // Slower, more relaxing
            onTap: onPlantTap,
            child: Image.asset(
              plantAsset,
              width: 180 + (stage * 15.0),
              height: 180 + (stage * 15.0),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
            color: AppColors.ocean,
            shape: BoxShape.circle,
            boxShadow: AppColors.ambientGlow(AppColors.ocean),
          ),
          child: const Icon(Icons.water_drop, color: Colors.white),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -10, duration: 1500.ms, curve: Curves.easeInOut);
  }
}
