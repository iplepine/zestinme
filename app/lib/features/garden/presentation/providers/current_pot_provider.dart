import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/features/garden/domain/entities/current_pot.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

part 'current_pot_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentPotNotifier extends _$CurrentPotNotifier {
  @override
  CurrentPot? build() {
    // Temporary MVP Logic: Load from Onboarding State
    // Ideally this should load from a dedicated PotRepository
    _loadFromOnboarding();
    return null;
  }

  Future<void> _loadFromOnboarding() async {
    try {
      final onboardingRepo = ref.read(onboardingRepositoryProvider);
      final obState = await onboardingRepo.getOnboardingState();

      if (obState != null && obState.assignedPlantId != null) {
        // Hydrate CurrentPot from Onboarding data
        state = CurrentPot(
          id: 'default_pot',
          plantSpeciesId: obState.assignedPlantId!,
          nickname: obState.nickname,
          emotionKey: 'joy', // Default fallback
          plantedAt: DateTime.now().subtract(const Duration(days: 0)), // Day 1
          growthStage: obState.growthStage,
        );
      }
    } catch (e) {
      // Handle error
    }
  }

  void plantNewPot({
    required String emotionKey,
    required String nickname,
    int? plantSpeciesId,
  }) {
    // Logic to determine plant species based on emotion
    // Default to the provided species ID, or Olive Tree (ID: 31) as fallback
    final speciesId = plantSpeciesId ?? 31;

    // Create new pot
    final newPot = CurrentPot(
      id: DateTime.now().toIso8601String(),
      plantSpeciesId: speciesId,
      nickname: nickname,
      emotionKey: emotionKey,
      plantedAt: DateTime.now(),
      growthStage: 1, // Start as Sprout (Stage 0 is seed, Stage 1 is sprout)
    );

    state = newPot;

    // TODO: Save to Repository
  }

  // Helper logic moved to MysteryPlantWidget
}
