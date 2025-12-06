import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_species.freezed.dart';

@freezed
class PlantSpecies with _$PlantSpecies {
  const factory PlantSpecies({
    required int id,
    required String name, // 한글명
    required String scientificName, // 학명
    required int rarity, // 1 (Common) ~ 5 (Legendary)
    required String description,
    required String flowerLanguage, // 꽃말
    // Environmental Preferences
    required double optimalLux,
    required double optimalTemperature,
    required double optimalHumidity,

    // Assets
    @Default('basil') String assetKey, // e.g. 'basil', 'mimosa'
  }) = _PlantSpecies;
}
