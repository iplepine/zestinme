import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/condition_record.dart';
import '../../../../core/services/local_db_service.dart';

part 'seeding_provider.g.dart';

class SeedingState {
  final int energyScore;
  final int focusScore;
  final int recoveryScore;
  final int stressScore;
  final List<String> selectedTags;
  final List<String> selectedContextTags;
  final List<String> selectedBodyTags;
  final String note;
  final bool isSaving;
  final String? errorMessage;

  const SeedingState({
    this.energyScore = 6,
    this.focusScore = 6,
    this.recoveryScore = 6,
    this.stressScore = 4,
    this.selectedTags = const [],
    this.selectedContextTags = const [],
    this.selectedBodyTags = const [],
    this.note = '',
    this.isSaving = false,
    this.errorMessage,
  });

  int get overallConditionScore {
    final raw = (energyScore + focusScore + recoveryScore + (11 - stressScore)) / 4;
    return (raw * 10).round().clamp(10, 100);
  }

  String get primaryTag {
    if (selectedTags.isNotEmpty) return selectedTags.first;
    return getFallbackTag(
      energyScore: energyScore,
      focusScore: focusScore,
      recoveryScore: recoveryScore,
      stressScore: stressScore,
    );
  }

  double get valence {
    final balance = ((focusScore + recoveryScore) / 2) - stressScore;
    return (balance / 5).clamp(-1.0, 1.0);
  }

  double get arousal {
    final activation = energyScore - ((recoveryScore + 1) / 2) + (stressScore / 2);
    return ((activation - 3) / 5).clamp(-1.0, 1.0);
  }

  // Legacy compatibility for older check-in widgets.
  int get intensity => stressScore.clamp(1, 10);

  SeedingState copyWith({
    int? energyScore,
    int? focusScore,
    int? recoveryScore,
    int? stressScore,
    List<String>? selectedTags,
    List<String>? selectedContextTags,
    List<String>? selectedBodyTags,
    String? note,
    bool? isSaving,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SeedingState(
      energyScore: energyScore ?? this.energyScore,
      focusScore: focusScore ?? this.focusScore,
      recoveryScore: recoveryScore ?? this.recoveryScore,
      stressScore: stressScore ?? this.stressScore,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedContextTags: selectedContextTags ?? this.selectedContextTags,
      selectedBodyTags: selectedBodyTags ?? this.selectedBodyTags,
      note: note ?? this.note,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  static String getFallbackTag({
    required int energyScore,
    required int focusScore,
    required int recoveryScore,
    required int stressScore,
  }) {
    if (recoveryScore <= 4 && energyScore <= 5) return 'Drained';
    if (stressScore >= 8 && energyScore >= 6) return 'Wired';
    if (focusScore <= 4) return 'Foggy';
    if (recoveryScore >= 7 && focusScore >= 7 && stressScore <= 4) return 'LockedIn';
    if (stressScore >= 8) return 'Overloaded';
    return 'Steady';
  }
}

@riverpod
class SeedingNotifier extends _$SeedingNotifier {
  static const List<String> contextTags = [
    'Work',
    'Relationship',
    'Family',
    'Money',
    'Health',
    'SleepDebt',
    'Exercise',
    'Deadline',
    'Social',
    'Travel',
    'Alone',
    'Future',
  ];

  static const List<String> bodyTags = [
    'ChestTight',
    'ShoulderTension',
    'Headache',
    'Stomach',
    'Heartbeat',
    'Fatigue',
    'LowEnergy',
    'Sleepy',
    'EyeStrain',
    'ShallowBreath',
    'HeavyBody',
    'Restless',
  ];

  @override
  SeedingState build() {
    return const SeedingState();
  }

  void reset() {
    state = const SeedingState();
  }

  void updateEnergy(int value) {
    state = state.copyWith(energyScore: value.clamp(1, 10), clearErrorMessage: true);
  }

  void updateFocus(int value) {
    state = state.copyWith(focusScore: value.clamp(1, 10), clearErrorMessage: true);
  }

  void updateRecovery(int value) {
    state = state.copyWith(recoveryScore: value.clamp(1, 10), clearErrorMessage: true);
  }

  void updateStress(int value) {
    state = state.copyWith(stressScore: value.clamp(1, 10), clearErrorMessage: true);
  }

  void updateIntensity(int value) {
    updateStress(value);
  }

  void toggleTag(String tag) {
    final currentTags = [...state.selectedTags];
    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else if (currentTags.length < 3) {
      currentTags.add(tag);
    }
    state = state.copyWith(selectedTags: currentTags, clearErrorMessage: true);
  }

  void toggleContextTag(String tag) {
    final currentTags = [...state.selectedContextTags];
    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else if (currentTags.length < 3) {
      currentTags.add(tag);
    }
    state = state.copyWith(selectedContextTags: currentTags, clearErrorMessage: true);
  }

  void toggleBodyTag(String tag) {
    final currentTags = [...state.selectedBodyTags];
    if (currentTags.contains(tag)) {
      currentTags.remove(tag);
    } else if (currentTags.length < 3) {
      currentTags.add(tag);
    }
    state = state.copyWith(selectedBodyTags: currentTags, clearErrorMessage: true);
  }

  void updateNote(String note) {
    state = state.copyWith(note: note, clearErrorMessage: true);
  }

  Future<bool> saveRecord() async {
    state = state.copyWith(isSaving: true, clearErrorMessage: true);

    try {
      final record = ConditionRecord()
        ..timestamp = DateTime.now()
        ..energyScore = state.energyScore
        ..focusScore = state.focusScore
        ..recoveryScore = state.recoveryScore
        ..stressScore = state.stressScore
        ..descriptors = state.selectedTags.isNotEmpty
            ? state.selectedTags
            : [state.primaryTag]
        ..contextSignals = state.selectedContextTags
        ..bodySignals = state.selectedBodyTags
        ..note = state.note.trim().isEmpty ? null : state.note.trim();

      final db = GetIt.I<LocalDbService>();
      await db.saveConditionRecord(record);
      return true;
    } catch (_) {
      state = state.copyWith(
        errorMessage: '컨디션 체크인을 저장하지 못했어요. 잠시 후 다시 시도해주세요.',
      );
      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  List<String> getRecommendedTags() {
    final state = this.state;

    if (state.recoveryScore <= 4 && state.energyScore <= 5) {
      return ['Drained', 'Heavy', 'Foggy', 'Flat', 'Slipping', 'NeedsReset'];
    }

    if (state.stressScore >= 8 && state.energyScore >= 6) {
      return ['Wired', 'Overloaded', 'Tense', 'Restless', 'Pressed', 'OnEdge'];
    }

    if (state.focusScore <= 4) {
      return ['Foggy', 'Scattered', 'Unfocused', 'Slipping', 'Heavy', 'Restless'];
    }

    if (state.recoveryScore >= 7 && state.focusScore >= 7 && state.stressScore <= 4) {
      return ['LockedIn', 'Sharp', 'Recovered', 'Grounded', 'Ready', 'Steady'];
    }

    if (state.recoveryScore >= 7 && state.stressScore <= 5) {
      return ['Calm', 'Recovered', 'Balanced', 'Stable', 'Steady', 'Light'];
    }

    return ['Steady', 'Building', 'Recovering', 'Balanced', 'Stable', 'Calm'];
  }
}
