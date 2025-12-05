import 'package:flutter_test/flutter_test.dart';
import 'package:zestinme/features/garden/domain/services/plant_service.dart';
import 'package:zestinme/features/garden/domain/entities/plant_species.dart';

void main() {
  late PlantService plantService;

  setUp(() {
    plantService = PlantService();
  });

  group('PlantService Assignment Logic', () {
    test(
      'High Lux & Temp & Low Humidity (Desert) should return heat tolerant plants',
      () {
        // 90,000 Lux, 35 C, 20% Humidity
        final plant = plantService.assignPlant(
          lux: 90000,
          temp: 35,
          humidity: 20,
        );

        print(
          'Desert Preset assigned: ${plant.name} (${plant.optimalLux}Lx, ${plant.optimalTemperature}C, ${plant.optimalHumidity}%)',
        );

        // Expecting Cactus, Succulents, or similar
        // Candidates likely: Lithops (ID 23), Welwitschia (34), Stapelia (26), Olive (31)
        expect(plant.optimalTemperature, greaterThanOrEqualTo(25));
        expect(plant.optimalHumidity, lessThan(50));
      },
    );

    test(
      'Low Lux & High Humidity (Rainforest/Shade) should return shade plants',
      () {
        // 5,000 Lux, 25 C, 80% Humidity
        final plant = plantService.assignPlant(
          lux: 5000,
          temp: 25,
          humidity: 80,
        );

        print(
          'Rainforest Preset assigned: ${plant.name} (${plant.optimalLux}Lx, ${plant.optimalTemperature}C, ${plant.optimalHumidity}%)',
        );

        // Expecting Ferns, Calathea, etc.
        // Candidates: Bucket Orchid (32), Spathiphyllum(if exists), etc.
        expect(plant.optimalLux, lessThanOrEqualTo(15000));
        expect(plant.optimalHumidity, greaterThanOrEqualTo(60));
      },
    );

    test('Average Indoor Conditions should return common plants', () {
      // 30,000 Lux, 22 C, 50% Humidity
      final plant = plantService.assignPlant(
        lux: 30000,
        temp: 22,
        humidity: 50,
      );

      print(
        'Indoor Preset assigned: ${plant.name} (${plant.optimalLux}Lx, ${plant.optimalTemperature}C, ${plant.optimalHumidity}%)',
      );

      // Just check it returns a valid plant
      expect(plant, isA<PlantSpecies>());
    });
  });
}
