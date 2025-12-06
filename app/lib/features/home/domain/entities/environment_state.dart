import 'package:freezed_annotation/freezed_annotation.dart';

part 'environment_state.freezed.dart';
part 'environment_state.g.dart';

@freezed
class EnvironmentState with _$EnvironmentState {
  // Defines the 3 Mental Weather variables:
  // Sunlight (Valence): 0.0 (Gloomy) to 1.0 (Bright)
  // Temperature (Arousal): 0.0 (Low Energy) to 1.0 (High Energy)
  // Water (Immersion): 0.0 (Thirsty/Dry) to 1.0 (Hydrated/Deep)
  const factory EnvironmentState({
    @Default(0.5) double sunlight,
    @Default(0.5) double temperature,
    @Default(0.5) double water,
    DateTime? lastCheckIn,
  }) = _EnvironmentState;

  factory EnvironmentState.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentStateFromJson(json);
}
