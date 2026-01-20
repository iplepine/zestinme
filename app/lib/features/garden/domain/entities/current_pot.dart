import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/plant_static_data.dart';

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

  const CurrentPot._(); // Required for custom methods/getters in Freezed

  factory CurrentPot.fromJson(Map<String, dynamic> json) =>
      _$CurrentPotFromJson(json);

  String get speciesName {
    return PlantStaticData.getById(plantSpeciesId).assetKey;
  }

  int get daysSincePlanted {
    return DateTime.now().difference(plantedAt).inDays + 1;
  }

  /// Calculates the visual stage based on the 7-Day Logic
  int getDisplayStage(String category) {
    final day = daysSincePlanted;

    if (day <= 1) return 1; // Day 1: Sprout
    if (day <= 4) return 2; // Day 2,3,4: Seedling (Small)

    // Day 5+: Sudden Growth
    if (day == 5) return 3;

    // Day 6+
    if (category == 'tree') {
      if (day == 6) return 4;
      return 5; // Day 7+
    } else {
      // Herbs/Leaves usually cap at 3 in current assets
      return 3;
    }
  }

  /// Returns a poetic message based on the growth day
  String get growthMessage {
    final day = daysSincePlanted;

    if (day <= 1) return "새로운 생명이 시작되었어요";
    if (day == 2) return "작은 잎이 돋아나고 있어요";
    if (day <= 4) return "보이지 않는 곳에서 뿌리를 내리고 있어요"; // Rooting phase
    if (day == 5) return "와! 식물이 훌쩍 자랐어요";

    // Day 6+ (General)
    return "당신의 마음과 함께 무럭무럭 자라요";
  }
}
