import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
        GestureDetector(
          onTap: onPlantTap,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: 200 + (growthStage * 20.0),
            height: 300 + (growthStage * 30.0),
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
    // Placeholder shapes for now
    IconData icon;
    Color color;
    switch (stage) {
      case 0:
        icon = Icons.circle; // Seed
        color = Colors.brown;
        break;
      case 1:
        icon = Icons.grass; // Sprout
        color = Colors.lightGreen;
        break;
      case 2:
        icon = Icons.local_florist; // Growing
        color = Colors.green;
        break;
      case 3:
      default:
        icon = Icons.filter_vintage; // Bloom
        color = Colors.pinkAccent;
        break;
    }

    return Icon(icon, size: 100 + (stage * 30.0), color: color)
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.05,
          duration: 2000.ms,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildWaterDrop() {
    return Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.blue, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: const Icon(Icons.water_drop, color: Colors.white),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -10, duration: 1500.ms, curve: Curves.easeInOut);
  }
}
