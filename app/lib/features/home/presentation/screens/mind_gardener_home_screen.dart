import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:zestinme/features/home/presentation/providers/garden_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/scenic_background.dart';
import 'package:zestinme/features/home/presentation/widgets/mystery_plant_widget.dart';
import 'package:zestinme/features/home/presentation/widgets/small_pond_widget.dart';
import 'package:zestinme/features/home/presentation/widgets/wind_chime_widget.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';
import 'package:zestinme/features/garden/domain/entities/plant_species.dart';
import 'package:zestinme/app/routes/app_router.dart';
import 'package:zestinme/features/caring/presentation/screens/caring_intro_screen.dart';
import 'package:zestinme/features/home/presentation/providers/home_provider.dart';
import 'package:zestinme/features/sleep_record/presentation/widgets/sleep_battery_widget.dart';
import 'package:zestinme/core/localization/app_localizations.dart';

class MindGardenerHomeScreen extends ConsumerWidget {
  const MindGardenerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenStateAsync = ref.watch(gardenStateProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: gardenStateAsync.when(
        data: (state) {
          if (state == null) {
            return const Center(child: Text("정원을 찾을 수 없습니다."));
          }

          final homeState = ref.watch(homeProvider);

          PlantSpecies? assignedPlant;
          if (state.assignedPlantId != null) {
            try {
              assignedPlant = PlantDatabase.species.firstWhere(
                (p) => p.id == state.assignedPlantId,
              );
            } catch (e) {
              // Fallback
            }
          }

          return GestureDetector(
            onVerticalDragUpdate: (details) {
              final delta = -details.primaryDelta! * 0.002;
              ref
                  .read(homeProvider.notifier)
                  .updateSunlight(homeState.sunlightLevel + delta);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                // --- Layer 0: Background ---
                ScenicBackground(
                  sunlight: homeState.sunlightLevel,
                  imagePath: homeState.backgroundImagePath,
                ),

                // --- Layer 1: Mid-Ground ---
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: MysteryPlantWidget(
                    growthStage: state.growthStage,
                    isThirsty: homeState.isCaringNeeded,
                    plantName: assignedPlant?.name,
                    onPlantTap: () => context
                        .push(AppRouter.seeding)
                        .then((_) => ref.read(homeProvider.notifier).refresh()),
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
                              (_) => ref.read(homeProvider.notifier).refresh(),
                            );
                      }
                    },
                  ),
                ),

                // Small Pond
                Positioned(
                  bottom: 40 + MediaQuery.of(context).padding.bottom,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmallPondWidget(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("자아의 거울은 준비 중입니다.")),
                        );
                      },
                    ),
                  ),
                ),

                // --- Layer 2: UI ---
                Positioned(
                  top: 60 + MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).homeGardenTitleFormat
                          .replaceAll('{user}', state.nickname),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                      ),
                    ),
                  ),
                ),

                // Moon Lantern
                Positioned(
                  top: 60 + MediaQuery.of(context).padding.top,
                  left: 20,
                  child: Tooltip(
                    message: AppLocalizations.of(context).homeSleep,
                    child: SleepBatteryWidget(
                      chargeLevel: homeState.sleepEfficiency,
                      onTap: () => context
                          .push(AppRouter.sleep)
                          .then(
                            (_) => ref.read(homeProvider.notifier).refresh(),
                          ),
                    ),
                  ),
                ),

                // Wind Chime
                Positioned(
                  top: 150 + MediaQuery.of(context).padding.top,
                  right: 20,
                  child: WindChimeWidget(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("마음 환기는 준비 중입니다.")),
                      );
                    },
                  ),
                ),

                // History Button
                Positioned(
                  bottom: 40 + MediaQuery.of(context).padding.bottom,
                  left: 20,
                  child: FloatingActionButton(
                    heroTag: 'history',
                    mini: true,
                    onPressed: () => context.push(AppRouter.history),
                    backgroundColor: Colors.white12,
                    elevation: 0,
                    foregroundColor: Colors.white70,
                    tooltip: AppLocalizations.of(context).homeHistory,
                    child: const Icon(Icons.history),
                  ),
                ),

                // Seeding Button
                Positioned(
                  bottom: 40 + MediaQuery.of(context).padding.bottom,
                  right: 20,
                  child: FloatingActionButton.extended(
                    label: Text(AppLocalizations.of(context).homeSeeding),
                    heroTag: 'seeding',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    onPressed: () => context
                        .push(AppRouter.seeding)
                        .then((_) => ref.read(homeProvider.notifier).refresh()),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("오류가 발생했습니다: $err")),
      ),
    );
  }
}
