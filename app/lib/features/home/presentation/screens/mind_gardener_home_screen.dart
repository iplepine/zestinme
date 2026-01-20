import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:zestinme/app/routes/app_router.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import 'package:zestinme/features/caring/presentation/screens/caring_intro_screen.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';
import 'package:zestinme/features/garden/domain/entities/plant_species.dart';
import 'package:zestinme/features/garden/presentation/providers/current_pot_provider.dart';
import 'package:zestinme/features/home/presentation/providers/home_provider.dart';
import 'package:zestinme/features/home/presentation/providers/time_vibe_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/home_bottom_bar.dart';
import 'package:zestinme/features/home/presentation/widgets/mystery_plant_widget.dart';
import 'dart:ui';

class MindGardenerHomeScreen extends ConsumerWidget {
  const MindGardenerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPot = ref.watch(currentPotNotifierProvider);
    final homeState = ref.watch(homeProvider);
    final timeVibe = ref.watch(timeVibeNotifierProvider);

    return Scaffold(
      extendBody: true,
      body: Builder(
        builder: (context) {
          if (currentPot == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.spiritTeal),
            );
          }

          final state = currentPot;
          PlantSpecies? assignedPlant;
          try {
            assignedPlant = PlantDatabase.species.firstWhere(
              (p) => p.id == state.plantSpeciesId,
            );
          } catch (e) {
            // Fallback
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image (Time based)
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  timeVibe.backgroundImage,
                  key: ValueKey(timeVibe.backgroundImage),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              // 2. Plant (Hero)
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.15,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: MysteryPlantWidget(
                      growthStage: state.getDisplayStage(
                        assignedPlant?.assetKey ?? 'herb',
                      ),
                      isThirsty: homeState.isCaringNeeded,
                      plantName: assignedPlant?.name,
                      showPot: false,
                      category: assignedPlant?.assetKey ?? 'herb',
                      onPlantTap: () => context
                          .push(AppRouter.seeding)
                          .then(
                            (_) => ref.read(homeProvider.notifier).refresh(),
                          ),
                      onWaterTap: () {
                        if (homeState.uncaredRecords.isNotEmpty) {
                          final record = homeState.uncaredRecords.first;
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CaringIntroScreen(record: record),
                                ),
                              )
                              .then(
                                (_) =>
                                    ref.read(homeProvider.notifier).refresh(),
                              );
                        }
                      },
                    ),
                  ),
                ),
              ),

              // 3. UI Overlay (Glass)
              SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MIND GARDENER",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white54,
                            ),
                            onPressed: () => context.push(AppRouter.settings),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Floating Stats (Left & Right)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGlassIndicator(
                            icon: Icons.water_drop,
                            label: "MOISTURE",
                            value: "72%",
                          ),
                          _buildGlassIndicator(
                            icon: Icons.eco,
                            label: "GROWTH",
                            value:
                                "Lv.${state.getDisplayStage(assignedPlant?.assetKey ?? 'herb')}",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 120), // Spacer for Bottom Dock
                  ],
                ),
              ),

              // 4. Bottom Dock (Glass)
              Positioned(
                left: 20,
                right: 20,
                bottom: 30,
                child: HomeBottomBar(
                  currentIndex: 0,
                  onTap: (index) {
                    if (index == 0) return;
                    if (index == 1) context.push(AppRouter.history);
                    if (index == 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("인사이트 준비 중")),
                      );
                    }
                    if (index == 4) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text("프로필 준비 중")));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGlassIndicator({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppColors.spiritTeal, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
