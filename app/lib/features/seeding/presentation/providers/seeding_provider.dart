import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/emotion_record.dart';
import '../../../../core/services/local_db_service.dart';

part 'seeding_provider.g.dart';

/// State for the Seeding Screen (The Catch)
class SeedingState {
  final double valence; // -1.0 to 1.0 (X-axis)
  final double arousal; // -1.0 to 1.0 (Y-axis)
  final bool isDragging;
  final bool isPlanted;

  // New Fields for Logic
  final List<String> selectedTags;
  final String note;
  final bool isSaving;

  const SeedingState({
    this.valence = 0.0,
    this.arousal = 0.0,
    this.isDragging = false,
    this.isPlanted = false,
    this.selectedTags = const [],
    this.note = '',
    this.isSaving = false,
  });

  SeedingState copyWith({
    double? valence,
    double? arousal,
    bool? isDragging,
    bool? isPlanted,
    List<String>? selectedTags,
    String? note,
    bool? isSaving,
  }) {
    return SeedingState(
      valence: valence ?? this.valence,
      arousal: arousal ?? this.arousal,
      isDragging: isDragging ?? this.isDragging,
      isPlanted: isPlanted ?? this.isPlanted,
      selectedTags: selectedTags ?? this.selectedTags,
      note: note ?? this.note,
      isSaving: isSaving ?? this.isSaving,
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
  void updateCoordinates(double x, double y) {
    // Clamp values to ensure they stay within -1.0 to 1.0
    final clampedX = x.clamp(-1.0, 1.0);
    final clampedY = y.clamp(-1.0, 1.0);

    state = state.copyWith(valence: clampedX, arousal: clampedY);
  }

  void startDrag() {
    // Reset selection and note when picking up the seed again
    state = state.copyWith(
      isDragging: true,
      isPlanted: false,
      selectedTags: [], // Clear tags
      note: '', // Clear note
    );
  }

  void endDrag() {
    state = state.copyWith(isDragging: false, isPlanted: true);
  }

  void reset() {
    state = const SeedingState();
  }

  // --- New Logic ---

  void toggleTag(String tag) {
    final currentTags = List<String>.from(state.selectedTags);
    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else {
      // Allow multiple selections (up to 3) for complex emotions
      if (currentTags.length < 3) {
        currentTags.add(tag);
      }
    }
    state = state.copyWith(selectedTags: currentTags);
  }

  void updateNote(String note) {
    state = state.copyWith(note: note);
  }

  Future<void> saveRecord() async {
    state = state.copyWith(isSaving: true);

    try {
      final record = EmotionRecord()
        ..timestamp = DateTime.now()
        ..valence = state.valence
        ..arousal = state.arousal
        ..emotionLabel = state.selectedTags.isNotEmpty
            ? state.selectedTags.first
            : 'Untitled'
        ..detailedNote = state.note
        ..status = EmotionRecordStatus.caught;

      // Save using LocalDbService via GetIt
      final db = GetIt.I<LocalDbService>();
      await db.saveEmotionRecord(record);
    } catch (e) {
      // Handle error (simple print for now)
      print("Error saving record: $e");
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  // Recommended Tags based on Quadrant
  List<String> getRecommendedTags() {
    if (state.valence.abs() < 0.2 && state.arousal.abs() < 0.2) {
      return ['Neutral']; // Center
    }

    if (state.arousal > 0) {
      // High Energy
      if (state.valence > 0) {
        // Top-Right: Yellow (Expansion)
        return [
          'Excited',
          'Proud',
          'Inspired',
          'Enthusiastic',
          'Curious',
          'Amused',
        ];
      } else {
        // Top-Left: Red (Threat/Boundary)
        return [
          'Angry',
          'Anxious',
          'Resentful',
          'Overwhelmed',
          'Jealous',
          'Annoyed',
        ];
      }
    } else {
      // Low Energy
      if (state.valence > 0) {
        // Bottom-Right: Green (Restoration)
        return [
          'Relaxed',
          'Grateful',
          'Content',
          'Serene',
          'Trusting',
          'Reflective',
        ];
      } else {
        // Bottom-Left: Blue (Loss/Lack)
        return ['Sad', 'Disappointed', 'Bored', 'Lonely', 'Guilty', 'Envious'];
      }
    }
  }
}
