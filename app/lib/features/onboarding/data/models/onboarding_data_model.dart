import 'package:isar/isar.dart';

part 'onboarding_data_model.g.dart';

@collection
class OnboardingDataModel {
  Id id = Isar.autoIncrement;

  late String nickname;

  @Index()
  late DateTime createdAt;

  // Visual Metaphor State
  late double temperatureLevel; // Arousal (Temperature)
  late double sunlightLevel; // Valence (Sunlight)
  late double humidityLevel; // Immersion (Humidity)

  // Derived SAM Scores
  late int arousalScore;
  late int valenceScore;

  // Quest State
  late String activeModuleId;
  late bool tutorialCompleted;

  // Gardening State
  int? assignedPlantId;

  // 0: Seed (Mystery), 1: Sprout, 2: Growing, 3: Bloom (Reveal)
  int? growthStage = 0;
}
