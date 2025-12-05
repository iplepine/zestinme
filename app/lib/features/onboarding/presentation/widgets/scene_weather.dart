import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

class SceneWeather extends ConsumerWidget {
  final VoidCallback onWeatherSet;

  const SceneWeather({super.key, required this.onWeatherSet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);

    return Stack(
      children: [
        // Dynamic Background based on state
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getSkyColor(state.sunlightLevel),
                _getSoilColor(state.waterLevel),
              ],
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "지금 이 화분에는\n무엇이 필요한가요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              // Sunlight Slider (Valence)
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.nightlight_round,
                      color: Colors.white,
                    ), // Moon
                  ),
                  Expanded(
                    child: Slider(
                      value: state.sunlightLevel,
                      onChanged: (value) {
                        ref
                            .read(onboardingViewModelProvider.notifier)
                            .updateEnvironment(sunlightLevel: value);
                      },
                      activeColor: Colors.amber,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.wb_sunny, color: Colors.amber), // Sun
                  ),
                ],
              ),
              const Text("빛의 양 (기분)", style: TextStyle(color: Colors.white70)),

              const SizedBox(height: 20),

              // Water Slider (Arousal)
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.water_drop_outlined,
                      color: Colors.white,
                    ), // Dry
                  ),
                  Expanded(
                    child: Slider(
                      value: state.waterLevel,
                      onChanged: (value) {
                        ref
                            .read(onboardingViewModelProvider.notifier)
                            .updateEnvironment(waterLevel: value);
                      },
                      activeColor: Colors.blueAccent,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.shower, color: Colors.blueAccent), // Wet
                  ),
                ],
              ),
              const Text("물의 양 (에너지)", style: TextStyle(color: Colors.white70)),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onWeatherSet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("환경 조성 완료"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSkyColor(double brightness) {
    // 0.0 = Night (Dark Blue) -> 1.0 = Sunny (Bright Blue)
    return Color.lerp(
      const Color(0xFF0A101C), // Night
      const Color(0xFF4FC3F7), // Day
      brightness,
    )!;
  }

  Color _getSoilColor(double moisture) {
    // 0.0 = Dry (Sand) -> 1.0 = Wet (Rich Earth)
    return Color.lerp(
      const Color(0xFFD7CCC8), // Sand
      const Color(0xFF3E2723), // Dark Earth
      moisture,
    )!;
  }
}
