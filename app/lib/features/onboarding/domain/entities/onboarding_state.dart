class OnboardingState {
  final String nickname;
  final double temperatureLevel; // Arousal
  final double sunlightLevel; // Valence
  final double humidityLevel; // Immersion
  final int arousalScore;
  final int valenceScore;
  final String activeModuleId;
  final int? assignedPlantId;
  final bool isCompleted;

  const OnboardingState({
    required this.nickname,
    required this.temperatureLevel,
    required this.sunlightLevel,
    required this.humidityLevel,
    required this.arousalScore,
    required this.valenceScore,
    required this.activeModuleId,
    this.assignedPlantId,
    this.isCompleted = false,
  });
}
