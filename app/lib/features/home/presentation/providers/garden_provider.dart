import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/features/onboarding/domain/entities/onboarding_state.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

part 'garden_provider.g.dart';

@riverpod
Future<OnboardingState?> gardenState(GardenStateRef ref) async {
  return await ref.watch(onboardingRepositoryProvider).getOnboardingState();
}
