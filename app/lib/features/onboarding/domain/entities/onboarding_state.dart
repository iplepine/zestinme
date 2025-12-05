class OnboardingState {
  final String nickname;
  final double waterLevel; // formerly waveHeight (Arousal)
  final double sunlightLevel; // formerly skyBrightness (Valence)
  final int arousalScore;
  final int valenceScore;
  final String activeModuleId;
  final bool isCompleted;

  const OnboardingState({
    required this.nickname,
    required this.waterLevel,
    required this.sunlightLevel,
    required this.arousalScore,
    required this.valenceScore,
    required this.activeModuleId,
    this.isCompleted = false,
  });
}
