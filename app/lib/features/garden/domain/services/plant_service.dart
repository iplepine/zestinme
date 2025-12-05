import 'dart:math';
import '../entities/plant_species.dart';
import '../../data/plant_database.dart';

class PlantService {
  /// Assigns a plant based on environmental variables.
  ///
  /// [lux]: 0 ~ 100,000
  /// [temp]: 0 ~ 40 (Celsius)
  /// [humidity]: 0 ~ 100 (%)
  PlantSpecies assignPlant({
    required double lux,
    required double temp,
    required double humidity,
  }) {
    List<PlantSpecies> allSpecies = PlantDatabase.species; // Total 50

    // 1. Calculate Suitability Score (Distance)
    // Lower distance is better.
    // Normalized weights: Lux (0-100k), Temp (0-40), Hum (0-100)

    var scoredPlants = allSpecies.map((plant) {
      double dLux = (plant.optimalLux - lux) / 100000.0;
      double dTemp = (plant.optimalTemperature - temp) / 40.0;
      double dHum = (plant.optimalHumidity - humidity) / 100.0;

      double distance = sqrt(dLux * dLux + dTemp * dTemp + dHum * dHum);
      return MapEntry(plant, distance);
    }).toList();

    // 2. Sort by Suitability (Distance ASC)
    scoredPlants.sort((a, b) => a.value.compareTo(b.value));

    // 3. Filter Candidate Pool (Top 20%)
    // Top 20% of 50 = 10 plants.
    int candidateCount = (allSpecies.length * 0.2).ceil();
    if (candidateCount < 1) candidateCount = 1;

    var candidates = scoredPlants
        .take(candidateCount)
        .map((e) => e.key)
        .toList();

    // 4. Weighted Random Selection based on Rarity
    // Rarity 1 (Common) -> Weight 10
    // Rarity 2 -> Weight 8
    // Rarity 3 -> Weight 5
    // Rarity 4 -> Weight 3
    // Rarity 5 (Legendary) -> Weight 1

    Map<PlantSpecies, int> weights = {};
    int totalWeight = 0;

    for (var plant in candidates) {
      int weight;
      switch (plant.rarity) {
        case 1:
          weight = 10;
          break;
        case 2:
          weight = 8;
          break;
        case 3:
          weight = 5;
          break;
        case 4:
          weight = 3;
          break;
        case 5:
          weight = 1;
          break;
        default:
          weight = 1;
      }
      weights[plant] = weight;
      totalWeight += weight;
    }

    final random = Random();
    int randomValue = random.nextInt(totalWeight);

    int currentSum = 0;
    for (var plant in candidates) {
      currentSum += weights[plant]!;
      if (randomValue < currentSum) {
        return plant;
      }
    }

    return candidates.first; // Fallback
  }
}
