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
    @Default('herb') String assetKey, // e.g. 'herb', 'flytrap', 'leaf'
    // Individual Layout Overrides (Responsive Ratios)
    double? customScale, // Multiplier (e.g. 1.1)
    double? customOffsetX, // Horizontal alignment delta (e.g. -0.05)
    double? customOffsetY, // Vertical alignment delta (e.g. -0.05)
  }) = _PlantSpecies;
}
