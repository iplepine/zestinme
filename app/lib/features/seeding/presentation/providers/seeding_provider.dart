import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seeding_provider.g.dart';

/// State for the Seeding Screen (The Catch)
class SeedingState {
  final double valence; // -1.0 to 1.0 (X-axis)
  final double arousal; // -1.0 to 1.0 (Y-axis)
  final bool isDragging;
  final bool isPlanted;

  const SeedingState({
    this.valence = 0.0,
    this.arousal = 0.0,
    this.isDragging = false,
    this.isPlanted = false,
  });

  SeedingState copyWith({
    double? valence,
    double? arousal,
    bool? isDragging,
    bool? isPlanted,
  }) {
    return SeedingState(
      valence: valence ?? this.valence,
      arousal: arousal ?? this.arousal,
      isDragging: isDragging ?? this.isDragging,
      isPlanted: isPlanted ?? this.isPlanted,
    );
  }
}

@riverpod
class SeedingNotifier extends _$SeedingNotifier {
  @override
  SeedingState build() {
    return const SeedingState();
  }

  /// Updates the coordinates based on normalized input
  /// [x] and [y] should be normalized values between -1.0 and 1.0
  void updateCoordinates(double x, double y) {
    // Clamp values to ensure they stay within -1.0 to 1.0
    final clampedX = x.clamp(-1.0, 1.0);
    final clampedY = y.clamp(-1.0, 1.0);

    state = state.copyWith(valence: clampedX, arousal: clampedY);
  }

  void startDrag() {
    state = state.copyWith(isDragging: true, isPlanted: false);
  }

  void endDrag() {
    state = state.copyWith(isDragging: false, isPlanted: true);
  }

  void reset() {
    state = const SeedingState();
  }
}
