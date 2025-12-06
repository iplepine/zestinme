import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/environment_state.dart';

part 'environment_provider.g.dart';

@riverpod
class EnvironmentNotifier extends _$EnvironmentNotifier {
  @override
  EnvironmentState build() {
    // TODO: Load from persistence (Repository)
    // For now, return default neutral state
    return const EnvironmentState(sunlight: 0.6, temperature: 0.5, water: 0.4);
  }

  void updateWeather({double? sunlight, double? temperature, double? water}) {
    state = state.copyWith(
      sunlight: sunlight ?? state.sunlight,
      temperature: temperature ?? state.temperature,
      water: water ?? state.water,
      lastCheckIn: DateTime.now(),
    );
    // TODO: Save to persistence
  }

  // Quick Check-in Interaction
  void checkIn(double valence, double arousal) {
    updateWeather(
      sunlight: valence,
      temperature: arousal,
      water: (state.water + 0.2).clamp(0.0, 1.0), // Watering effect
    );
  }
}
