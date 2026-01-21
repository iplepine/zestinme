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

                    const Spacer(),

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
}
