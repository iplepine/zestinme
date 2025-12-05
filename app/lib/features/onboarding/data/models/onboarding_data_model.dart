import 'package:isar/isar.dart';

part 'onboarding_data_model.g.dart';

@collection
class OnboardingDataModel {
  Id id = Isar.autoIncrement;

  late String nickname;

  @Index()
  late DateTime createdAt;

  // Visual Metaphor State
  late double waterLevel; // Arousal (Water amount)
  late double sunlightLevel; // Valence (Sunlight amount)

  // Derived SAM Scores
  late int arousalScore;
  late int valenceScore;

  // Quest State
  late String activeModuleId;
  late bool tutorialCompleted;
}
