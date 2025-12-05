import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zestinme/features/home/presentation/providers/garden_provider.dart';
import 'package:zestinme/features/home/presentation/widgets/environment_background.dart';
import 'package:zestinme/features/home/presentation/widgets/pot_widget.dart';
import 'package:zestinme/features/garden/data/plant_database.dart';
import 'package:zestinme/features/garden/domain/entities/plant_species.dart';

class MindGardenerHomeScreen extends ConsumerWidget {
  const MindGardenerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenStateAsync = ref.watch(gardenStateProvider);

    return Scaffold(
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

              // 2. The Pot and Plant
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Plant
                    if (assignedPlant != null) _buildPlant(assignedPlant),

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

                    const Spacer(),
                  ],
                ),
              ),

              // 3. HUD (Overlay)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${state.nickname}의 정원",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                assignedPlant != null
                                    ? "새로운 생명이 자라고 있어요."
                                    : "오늘도 싹 틔우기 좋은 날이에요.",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Bottom Action Bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildActionButton(Icons.water_drop, "물주기", () {}),
                            const SizedBox(width: 20),
                            _buildActionButton(Icons.cut, "다듬기", () {}),
                            const SizedBox(width: 20),
                            _buildActionButton(Icons.book, "관찰일지", () {}),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    // Eventually use plant.assetPath
    // For now, mapping plant ID to generic icons or colors if assets not ready
    // Or just show text/icon

    return Container(
      height: 120,
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.local_florist, size: 80, color: Colors.greenAccent)
              .animate()
              .scale(duration: 1000.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 2000.ms),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
