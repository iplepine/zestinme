import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zestinme/features/garden/domain/entities/current_pot.dart';

part 'current_pot_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentPotNotifier extends _$CurrentPotNotifier {
  @override
  CurrentPot? build() {
    // TODO: Load from Repository
    return null;
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

  // Helper to get image asset based on current state
  String get currentAssetPath {
    final pot = state;
    if (pot == null) return '';

    // Naming convention: {species_name}_{stage}.png
    // e.g. basil_1.png
    // We need a way to map speciesId to species name.
    // For MVP, simple switch or map.
    String speciesName = 'basil';
    if (pot.plantSpeciesId == 1) speciesName = 'basil';

    return 'assets/images/plants/plant_${speciesName}_${pot.growthStage}.png';
  }
}
