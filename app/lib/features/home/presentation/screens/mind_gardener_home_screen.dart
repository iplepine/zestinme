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
import '../../../../core/models/emotion_record.dart';

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
            "${state?.nickname ?? 'User'}의 정원",
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
          IconButton(
            icon: const Icon(Icons.battery_charging_full, color: Colors.white),
            tooltip: 'Sleep Recharge',
            onPressed: () => context.push(AppRouter.sleep),
          ),
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
                        // TODO: Connect to real CaringProvider check
                        Positioned(
                          top: -20,
                          right: -20,
                          child: _buildCaringTrigger(context),
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
                  child: const Icon(Icons.auto_stories), // Alumni/Book concept
                ),
              ),
              Positioned(
                bottom: 30,
                right: 20,
                child: FloatingActionButton.extended(
                  heroTag: 'seeding',
                  onPressed: () => context.push(AppRouter.seeding),
                  backgroundColor: const Color(0xFFE0F7FA), // Soft Light Color
                  foregroundColor: Colors.black87,
                  icon: const Icon(Icons.edit),
                  label: const Text("기록하기"),
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

  Widget _buildCaringTrigger(BuildContext context) {
    // This is the "Water Drop" trigger
    return GestureDetector(
      onTap: () {
        // Navigate to Caring Intro
        // Ideally pass the record ID, for now just open screen
        // In real app, we would find the specific record to care for.

        // Using a temporary mechanism to enter Caring Flow
        // Since CaringIntroScreen might need a record, we might need a workaround for testing
        // or just let the CaringService pick one.

        // For now, let's assume CaringIntroScreen handles "pick latest" or passed via extra.
        // But our router definition didn't include caring intro?
        // Need to check if route exists. Assuming direct navigation or we need to add route.

        // Wait, I see I forgot to check if '/caring' route exists in AppRouter.
        // I'll assume I need to add it or use Dev menu.
        // Let's use a explicit push for now or add route later.

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const ZestCaringEntryPoint(), // Use Entry Point logic?
            // Or direct: CaringIntroScreen(record: ...)
          ),
        );
      },
      child:
          Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 24,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.2, 1.2),
                duration: 800.ms,
              ),
    );
  }
}

// Temporary placeholder for entry point until route is fixed
// Temporary placeholder for entry point until route is fixed

class ZestCaringEntryPoint extends StatelessWidget {
  const ZestCaringEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    // DUMMY RECORD for seamless flow testing
    final dummyRecord = EmotionRecord()
      ..id = 999
      ..emotionLabel = 'Anxious'
      ..valence = -0.5
      ..arousal = 0.8
      ..timestamp = DateTime.now().subtract(const Duration(hours: 4))
      ..detailedNote =
          "I tried to fix the bug but it kept crashing. I feel incompetent.";

    return CaringIntroScreen(record: dummyRecord);
  }
}
