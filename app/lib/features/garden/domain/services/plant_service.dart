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
    List<PlantSpecies> allSpecies = PlantDatabase.species;

    // Calculate Suitability Score (Distance)
    // Normalized weights: Lux (0-100k), Temp (0-40), Hum (0-100)
    var scoredPlants = allSpecies.map((plant) {
      double dLux = (plant.optimalLux - lux) / 100000.0;
      double dTemp = (plant.optimalTemperature - temp) / 40.0;
      double dHum = (plant.optimalHumidity - humidity) / 100.0;

      double distance = sqrt(dLux * dLux + dTemp * dTemp + dHum * dHum);
      return MapEntry(plant, distance);
    }).toList();

    // Sort by Suitability (Distance ASC)
    scoredPlants.sort((a, b) => a.value.compareTo(b.value));

    // Return the best matching plant
    return scoredPlants.first.key;
  }
}
