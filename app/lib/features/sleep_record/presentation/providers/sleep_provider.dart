import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/services/local_db_service.dart';
import '../../../../core/models/sleep_record.dart';

part 'sleep_provider.g.dart';

class SleepState {
  final int? id; // For editing existing records
  final DateTime bedTime;
  final DateTime wakeTime;
  final int qualityScore; // 1 to 5
  final int durationMinutes;
  final bool isNaturalWake;
  final bool isImmediateWake; // New
  final List<String> selectedTags;
  final bool isSaving;

  const SleepState({
    this.id,
    required this.bedTime,
    required this.wakeTime,
    this.qualityScore = 3,
    this.durationMinutes = 0,
    this.isNaturalWake = false,
    this.isImmediateWake = true, // New
    this.selectedTags = const [],
    this.isSaving = false,
  });

  SleepState copyWith({
    int? id,
    DateTime? bedTime,
    DateTime? wakeTime,
    int? qualityScore,
    int? durationMinutes,
    bool? isNaturalWake,
    bool? isImmediateWake, // New
    List<String>? selectedTags,
    bool? isSaving,
  }) {
    return SleepState(
      id: id ?? this.id,
      bedTime: bedTime ?? this.bedTime,
      wakeTime: wakeTime ?? this.wakeTime,
      qualityScore: qualityScore ?? this.qualityScore,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isNaturalWake: isNaturalWake ?? this.isNaturalWake,
      isImmediateWake: isImmediateWake ?? this.isImmediateWake, // New
      selectedTags: selectedTags ?? this.selectedTags,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  // Derived Metrics (Golden Hour Logic)
  double get sleepCycles {
    // Basic Latency assumption: 15 minutes to fall asleep
    // Effective Sleep = Total Duration - Latency
    if (durationMinutes <= 15) return 0.0;
    return (durationMinutes - 15) / 90.0;
  }

  bool get isGoldenHour {
    if (durationMinutes < 180) return false; // Minimum 3 hours
    final cycles = sleepCycles;
    // Check if within +/- 10% of a full cycle (approx +/- 9 mins)
    final diff = (cycles - cycles.round()).abs();
    return diff <= 0.1;
  }
}

@riverpod
class SleepNotifier extends _$SleepNotifier {
  // Predefined Factor Tags
  static const List<String> factorTags = [
    '🍺 음주',
    '☕ 카페인',
    '📱 스마트폰',
    '🍗 야식',
    '🏃 운동',
    '🛁 샤워',
    '💊 약',
    '🧘 명상',
  ];

  @override
  SleepState build() {
    // Default: Bedtime 23:00 yesterday, WakeTime 07:00 today
    final now = DateTime.now();
    final todayMorning = DateTime(now.year, now.month, now.day, 7, 0);
    final yesterdayNight = todayMorning.subtract(const Duration(hours: 8));

    return SleepState(
      bedTime: yesterdayNight,
      wakeTime: todayMorning,
      durationMinutes: 480, // 8 hours
    );
  }

  void initializeWithRecord(SleepRecord record) {
    state = state.copyWith(
      id: record.id,
      bedTime: record.bedTime,
      wakeTime: record.wakeTime,
      qualityScore: record.qualityScore,
      durationMinutes: record.durationMinutes,
      isNaturalWake: record.isNaturalWake,
      isImmediateWake: record.isImmediateWake,
      selectedTags: record.tags,
    );
  }

  void updateTimes(DateTime bedTime, DateTime wakeTime) {
    // Calculate duration
    int duration = wakeTime.difference(bedTime).inMinutes;
    // Handle case where wakeTime is 'next day' relative to bedtime but calculation might be negative if logic is purely time-of-day based.
    // Assuming UI passes full DateTimes.
    // If negative (e.g. user set bedtime to tomorrow?), we should handle or trust UI.

    state = state.copyWith(
      bedTime: bedTime,
      wakeTime: wakeTime,
      durationMinutes: duration,
    );
  }

  void updateQuality(int score) {
    state = state.copyWith(qualityScore: score);
  }

  void toggleNaturalWake(bool value) {
    state = state.copyWith(isNaturalWake: value);
  }

  void toggleImmediateWake(bool value) {
    state = state.copyWith(isImmediateWake: value);
  }

  void toggleTag(String tag) {
    final current = [...state.selectedTags];
    if (current.contains(tag)) {
      current.remove(tag);
    } else {
      current.add(tag);
    }
    state = state.copyWith(selectedTags: current);
  }

  Future<void> saveRecord() async {
    state = state.copyWith(isSaving: true);
    try {
      final db = GetIt.I<LocalDbService>();

      final record = SleepRecord()
        ..date = state.wakeTime
        ..bedTime = state.bedTime
        ..wakeTime = state.wakeTime
        ..durationMinutes = state.durationMinutes
        ..qualityScore = state.qualityScore
        ..isNaturalWake = state.isNaturalWake
        ..isImmediateWake = state.isImmediateWake
        ..tags = state.selectedTags;

      // If updating an existing record, set the ID
      if (state.id != null) {
        record.id = state.id!;
      }

      await db.saveSleepRecord(record);
    } catch (e) {
      print('Error saving sleep record: $e');
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
