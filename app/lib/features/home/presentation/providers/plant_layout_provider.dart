import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/core/constants/plant_layout_constants.dart';

class PlantLayoutState {
  final double anchorYBias;
  final double offsetX;
  final double backgroundOffsetY;
  final double potWidth;
  final double plantBaseSize;
  final double plantBottomInternalOffset;
  final double scaleFactorPerStage;

  PlantLayoutState({
    required this.anchorYBias,
    required this.offsetX,
    required this.backgroundOffsetY,
    required this.potWidth,
    required this.plantBaseSize,
    required this.plantBottomInternalOffset,
    required this.scaleFactorPerStage,
  });

  factory PlantLayoutState.defaultConfig() {
    return PlantLayoutState(
      anchorYBias: PlantLayoutConstants.anchorYBias,
      offsetX: PlantLayoutConstants.offsetX,
      backgroundOffsetY: PlantLayoutConstants.backgroundOffsetY,
      potWidth: PlantLayoutConstants.potWidth,
      plantBaseSize: PlantLayoutConstants.plantBaseSize,
      plantBottomInternalOffset: PlantLayoutConstants.plantBottomInternalOffset,
      scaleFactorPerStage: PlantLayoutConstants.scaleFactorPerStage,
    );
  }

  PlantLayoutState copyWith({
    double? anchorYBias,
    double? offsetX,
    double? backgroundOffsetY,
    double? potWidth,
    double? plantBaseSize,
    double? plantBottomInternalOffset,
    double? scaleFactorPerStage,
  }) {
    return PlantLayoutState(
      anchorYBias: anchorYBias ?? this.anchorYBias,
      offsetX: offsetX ?? this.offsetX,
      backgroundOffsetY: backgroundOffsetY ?? this.backgroundOffsetY,
      potWidth: potWidth ?? this.potWidth,
      plantBaseSize: plantBaseSize ?? this.plantBaseSize,
      plantBottomInternalOffset:
          plantBottomInternalOffset ?? this.plantBottomInternalOffset,
      scaleFactorPerStage: scaleFactorPerStage ?? this.scaleFactorPerStage,
    );
  }
}

class PlantLayoutNotifier extends StateNotifier<PlantLayoutState> {
  PlantLayoutNotifier() : super(PlantLayoutState.defaultConfig()) {
    print(
      "DEBUG: PlantLayoutNotifier initialized with anchorYBias: ${state.anchorYBias}",
    );
  }

  void updateAnchorYBias(double value) =>
      state = state.copyWith(anchorYBias: value);
  void updateOffsetX(double value) => state = state.copyWith(offsetX: value);
  void updateBackgroundOffsetY(double value) =>
      state = state.copyWith(backgroundOffsetY: value);
  void updatePotWidth(double value) => state = state.copyWith(potWidth: value);
  void updatePlantBaseSize(double value) =>
      state = state.copyWith(plantBaseSize: value);
  void updatePlantBottomInternalOffset(double value) =>
      state = state.copyWith(plantBottomInternalOffset: value);
  void updateScaleFactorPerStage(double value) =>
      state = state.copyWith(scaleFactorPerStage: value);
}

final plantLayoutProvider =
    StateNotifierProvider<PlantLayoutNotifier, PlantLayoutState>((ref) {
      return PlantLayoutNotifier();
    });
