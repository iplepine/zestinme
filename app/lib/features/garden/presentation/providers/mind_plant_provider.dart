import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/features/garden/domain/entities/mind_plant.dart';
import 'package:zestinme/features/onboarding/presentation/providers/onboarding_provider.dart';

part 'mind_plant_provider.g.dart';

@Riverpod(keepAlive: true)
class MindPlantNotifier extends _$MindPlantNotifier {
  @override
  MindPlant? build() {
    // Temporary MVP Logic: Load from Onboarding State
    // Ideally this should load from a dedicated GardenRepository
    _loadFromOnboarding();
    return null;
  }

  Future<void> _loadFromOnboarding() async {
    try {
      final onboardingRepo = ref.read(onboardingRepositoryProvider);
      final obState = await onboardingRepo.getOnboardingState();

      if (obState != null && obState.assignedPlantId != null) {
        // Hydrate MindPlant from Onboarding data
        state = MindPlant(
          id: 'default_plant',
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

  void startGardening({
    required String emotionKey,
    required String nickname,
    int? plantSpeciesId,
  }) {
    // Logic to determine plant species based on emotion
    // Default to the provided species ID, or Olive Tree (ID: 31) as fallback
    final speciesId = plantSpeciesId ?? 31;

    // Create new plant instance (No longer tied to a physical pot)
    final newPlant = MindPlant(
      id: DateTime.now().toIso8601String(),
      plantSpeciesId: speciesId,
      nickname: nickname,
      emotionKey: emotionKey,
      plantedAt: DateTime.now(),
      growthStage: 1, // Start as Sprout (Stage 0 is seed, Stage 1 is sprout)
    );

    state = newPlant;

    // TODO: Save to Repository
  }
}
