import 'plant_database.dart';
import '../domain/entities/plant_species.dart';

class PlantStaticData {
  static final Map<int, PlantSpecies> speciesMap = Map.fromIterable(
    PlantDatabase.species,
    key: (s) => (s as PlantSpecies).id,
    value: (s) => s as PlantSpecies,
  );

  static PlantSpecies getById(int id) {
    return speciesMap[id] ??
        speciesMap[31]!; // Default to Olive Tree (Hero Plant)
  }
}
