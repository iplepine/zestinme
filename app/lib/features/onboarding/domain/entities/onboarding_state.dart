class OnboardingState {
  final String nickname;
  final double waveHeight;
  final double skyBrightness;
  final int arousalScore;
  final int valenceScore;
  final String activeModuleId;
  final bool isCompleted;

  const OnboardingState({
    required this.nickname,
    required this.waveHeight,
    required this.skyBrightness,
    required this.arousalScore,
    required this.valenceScore,
    required this.activeModuleId,
    this.isCompleted = false,
  });
}
