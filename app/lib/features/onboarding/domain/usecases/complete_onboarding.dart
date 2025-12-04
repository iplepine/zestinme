import 'package:zestinme/features/onboarding/domain/entities/onboarding_state.dart';
import 'package:zestinme/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboarding {
  final OnboardingRepository _repository;

  CompleteOnboarding(this._repository);

  Future<void> call(OnboardingState state) async {
    return await _repository.completeOnboarding(state);
  }
}
