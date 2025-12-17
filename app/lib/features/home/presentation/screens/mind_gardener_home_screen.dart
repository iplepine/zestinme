import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/features/home/presentation/providers/garden_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/environment_background.dart';
import 'package:zestinme/features/home/presentation/widgets/pot_widget.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';
import 'package:zestinme/features/garden/domain/entities/plant_species.dart';
import 'package:zestinme/app/routes/app_router.dart';
import 'package:zestinme/features/caring/presentation/screens/caring_intro_screen.dart';
import 'package:zestinme/features/home/presentation/providers/home_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/caring_trigger_widget.dart';
import 'package:zestinme/features/sleep_record/presentation/widgets/sleep_battery_widget.dart';
import 'package:zestinme/core/localization/app_localizations.dart';

class MindGardenerHomeScreen extends ConsumerWidget {
  const MindGardenerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenStateAsync = ref.watch(gardenStateProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: gardenStateAsync.when(
          data: (state) => Text(
            AppLocalizations.of(context).home_garden_title_format.replaceAll(
              '{user}',
              state?.nickname ?? 'User',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        actions: [
          // Sleep Battery (Top Right)
          Consumer(
            builder: (context, ref, _) {
              final homeState = ref.watch(homeProvider);
              return Tooltip(
                message: AppLocalizations.of(context).home_sleep,
                child: SleepBatteryWidget(
                  chargeLevel: homeState.sleepEfficiency,
                  onTap: () => context
                      .push(AppRouter.sleep)
                      .then((_) => ref.read(homeProvider.notifier).refresh()),
                ),
              );
            },
          ),
          const SizedBox(
            width: 16,
          ), // Margin provided by Appbar? simpler to add spacing if needed
        ],
      ),
      body: gardenStateAsync.when(
        data: (state) {
          if (state == null) {
            return const Center(child: Text("정원을 찾을 수 없습니다."));
          }

          final sunlight = state.sunlightLevel;
          final temperature = state.temperatureLevel;
          final humidity = state.humidityLevel;

          PlantSpecies? assignedPlant;
          if (state.assignedPlantId != null) {
            try {
              assignedPlant = PlantDatabase.species.firstWhere(
                (p) => p.id == state.assignedPlantId,
              );
            } catch (e) {
              // Fallback if ID invalid
            }
          }

          return Stack(
            children: [
              // 1. Environment Background
              EnvironmentBackground(
                sunlight: sunlight,
                temperature: temperature,
                humidity: humidity,
              ),

              // 2. The Pot and Plant (Center)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Plant
                        if (assignedPlant != null) _buildPlant(assignedPlant),

                        // Caring Trigger (Water Drop) - Conditional
                        Consumer(
                          builder: (context, ref, child) {
                            final homeState = ref.watch(homeProvider);
                            if (!homeState.isCaringNeeded)
                              return const SizedBox.shrink();

                            return Positioned(
                              top: -20,
                              right: -20,
                              child: CaringTriggerWidget(
                                onTap: () {
                                  // Navigate to Caring Flow with the first pending record
                                  if (homeState.uncaredRecords.isNotEmpty) {
                                    final record =
                                        homeState.uncaredRecords.first;
                                    Navigator.of(context)
                                        .push(
                                          MaterialPageRoute(
                                            builder: (_) => CaringIntroScreen(
                                              record: record,
                                            ),
                                          ),
                                        )
                                        .then(
                                          (_) => ref
                                              .read(homeProvider.notifier)
                                              .refresh(),
                                        );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // Pot
                    const PotWidget()
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                          begin: 0,
                          end: -5,
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                        ),

                    // Plant Info
                    if (assignedPlant != null) ...[
                      const SizedBox(height: 20),
                      // Mystery Logic: Reveal only if fully grown (Stage 3)
                      // Default to 0 if not set.
                      if ((state.growthStage) < 3) ...[
                        Text(
                              "이름 없는 씨앗",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 4, color: Colors.black54),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .moveY(begin: 10, end: 0),
                        const SizedBox(height: 8),
                        const Text(
                          "??? (아직 알 수 없음)",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ).animate().fadeIn(delay: 800.ms),
                      ] else ...[
                        // Revealed Info
                        Text(
                              assignedPlant.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 4, color: Colors.black54),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .moveY(begin: 10, end: 0),

                        const SizedBox(height: 8),

                        Text(
                          assignedPlant.flowerLanguage.isNotEmpty
                              ? "꽃말: ${assignedPlant.flowerLanguage}"
                              : assignedPlant.scientificName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black54),
                            ],
                          ),
                        ).animate().fadeIn(delay: 800.ms),
                      ],
                    ],

                    const Spacer(),
                  ],
                ),
              ),

              // 3. Bottom Actions (FABs)
              Positioned(
                bottom: 30,
                left: 20,
                child: FloatingActionButton(
                  heroTag: 'history',
                  onPressed: () => context.push(AppRouter.history),
                  backgroundColor: Colors.white24,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  tooltip: AppLocalizations.of(context).home_history,
                  child: const Icon(Icons.auto_stories), // Alumni/Book concept
                ),
              ),
              Positioned(
                bottom: 30,
                right: 20,
                child: FloatingActionButton.extended(
                  label: Text(AppLocalizations.of(context).home_seeding),
                  heroTag: 'seeding',
                  onPressed: () => context
                      .push(AppRouter.seeding)
                      .then((_) => ref.read(homeProvider.notifier).refresh()),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("오류가 발생했습니다: $err")),
      ),
    );
  }

  Widget _buildPlant(PlantSpecies plant) {
    return Container(
      height: 120,
      alignment: Alignment.bottomCenter,
      child: Icon(Icons.local_florist, size: 80, color: Colors.greenAccent)
          .animate()
          .scale(duration: 1000.ms, curve: Curves.elasticOut)
          .then()
          .shimmer(duration: 2000.ms),
    );
  }
}
