import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_pot.freezed.dart';
part 'current_pot.g.dart';

@freezed
class CurrentPot with _$CurrentPot {
  const factory CurrentPot({
    required String id,
    required int plantSpeciesId, // Reference to PlantSpecies
    required String nickname, // From onboarding emotion
    required String emotionKey, // 'joy', 'sadness', etc.
    required DateTime plantedAt,
    required int growthStage, // 0: Seed, 1: Sprout, 2: Growing, ...
    DateTime? lastWateredAt,
    @Default(0.0) double currentXp,
    @Default(100.0) double maxXp, // XP needed for next stage
  }) = _CurrentPot;

  factory CurrentPot.fromJson(Map<String, dynamic> json) =>
      _$CurrentPotFromJson(json);
}
