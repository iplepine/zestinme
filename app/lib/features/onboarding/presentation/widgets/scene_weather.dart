import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

class SceneEnvironment extends ConsumerWidget {
  final VoidCallback onEnvironmentSet;

  const SceneEnvironment({super.key, required this.onEnvironmentSet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);

    return Stack(
      children: [
        // Dynamic Background (Simplified visualization for onboarding)
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getSkyColor(state.sunlightLevel),
                _getSoilColor(
                  state.humidityLevel,
                ), // Humidity affects visual "wetness"
              ],
            ),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "당신의\n마음 날씨는 어떤가요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

              // 1. Sunlight (Valence)
              _buildSliderRow(
                context,
                iconStart: Icons.nightlight_round,
                iconEnd: Icons.wb_sunny,
                label: "오늘의 기분",
                value: state.sunlightLevel,
                color: Colors.amber,
                onChanged: (v) => ref
                    .read(onboardingViewModelProvider.notifier)
                    .updateEnvironment(sunlightLevel: v),
              ),

              // 2. Temperature (Arousal)
              _buildSliderRow(
                context,
                iconStart: Icons.ac_unit,
                iconEnd: Icons.local_fire_department,
                label: "나의 에너지",
                value: state.temperatureLevel,
                color: Colors.orangeAccent,
                onChanged: (v) => ref
                    .read(onboardingViewModelProvider.notifier)
                    .updateEnvironment(temperatureLevel: v),
              ),

              // 3. Humidity (Immersion)
              _buildSliderRow(
                context,
                iconStart: Icons.water_drop_outlined,
                iconEnd: Icons.water_drop,
                label: "감정의 몰입도",
                value: state.humidityLevel,
                color: Colors.blueAccent,
                onChanged: (v) => ref
                    .read(onboardingViewModelProvider.notifier)
                    .updateEnvironment(humidityLevel: v),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onEnvironmentSet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("준비되었습니다"),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliderRow(
    BuildContext context, {
    required IconData iconStart,
    required IconData iconEnd,
    required String label,
    required double value,
    required Color color,
    required Function(double) onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(iconStart, color: Colors.white70),
            ),
            Expanded(
              child: Slider(
                value: value,
                onChanged: onChanged,
                activeColor: color,
                inactiveColor: Colors.white24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(iconEnd, color: color),
            ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Color _getSkyColor(double brightness) {
    return Color.lerp(
      const Color(0xFF0A101C), // Night
      const Color(0xFF4FC3F7), // Day
      brightness,
    )!;
  }

  Color _getSoilColor(double humidity) {
    return Color.lerp(
      const Color(0xFFE0E0E0), // Dry/Mist
      const Color(0xFF263238), // Wet/Dark
      humidity,
    )!;
  }
}
