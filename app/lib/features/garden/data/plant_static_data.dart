import '../domain/entities/plant_species.dart';

class PlantStaticData {
  static const Map<int, PlantSpecies> speciesMap = {
    1: PlantSpecies(
      id: 1,
      name: '민감초',
      scientificName: 'Mimosa',
      rarity: 1,
      description: '잎을 건드리면 오므라들어 ‘잠자는 풀’로 불리는 열대 지역의 흔한 식물',
      flowerLanguage: '예민한 마음',
      optimalLux: 40000,
      optimalTemperature: 28,
      optimalHumidity: 70,
      assetKey: 'mimosa',
    ),
    6: PlantSpecies(
      id: 6,
      name: '스위트 바질',
      scientificName: 'Sweet Basil',
      rarity: 1,
      description: '향긋한 잎으로 사랑받는 키친 허브의 왕',
      flowerLanguage: '좋은 희망, 작은 사랑',
      optimalLux: 30000,
      optimalTemperature: 25,
      optimalHumidity: 60,
      assetKey: 'basil',
    ),
  };

  static PlantSpecies getById(int id) {
    return speciesMap[id] ?? speciesMap[6]!; // Default to Basil
  }
}
