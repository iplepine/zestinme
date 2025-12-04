import 'package:zestinme/features/onboarding/domain/entities/onboarding_state.dart';

abstract class OnboardingRepository {
  Future<void> completeOnboarding(OnboardingState state);
  Future<bool> checkOnboardingStatus();
}
