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
                _getSkyColor(state.skyBrightness),
                _getSeaColor(state.waveHeight),
              ],
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "오늘 당신의 바다는 어떤 모습인가요?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              // Sky Slider (Valence)
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.wb_sunny, color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      value: state.skyBrightness,
                      onChanged: (value) {
                        ref
                            .read(onboardingViewModelProvider.notifier)
                            .updateWeather(skyBrightness: value);
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.nightlight_round, color: Colors.white),
                  ),
                ],
              ),

              // Wave Slider (Arousal)
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.waves, color: Colors.white), // Calm
                  ),
                  Expanded(
                    child: Slider(
                      value: state.waveHeight,
                      onChanged: (value) {
                        ref
                            .read(onboardingViewModelProvider.notifier)
                            .updateWeather(waveHeight: value);
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.tsunami, color: Colors.white), // Stormy
                  ),
                ],
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onWeatherSet,
                child: const Text("이대로 결정하기"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSkyColor(double brightness) {
    // 1.0 = Sunny (Blue), 0.0 = Night (Dark Blue/Black)
    return Color.lerp(
      const Color(0xFF0A101C),
      const Color(0xFF4FC3F7),
      brightness,
    )!;
  }

  Color _getSeaColor(double roughness) {
    // 0.0 = Calm (Teal), 1.0 = Stormy (Dark Grey)
    return Color.lerp(
      const Color(0xFF00695C),
      const Color(0xFF37474F),
      roughness,
    )!;
  }
}
