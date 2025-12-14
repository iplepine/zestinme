import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/services/local_db_service.dart';
import '../../../../core/models/sleep_record.dart';

part 'sleep_provider.g.dart';

class SleepState {
  final int? id; // For editing existing records
  final DateTime bedTime;
  final DateTime wakeTime;

  // New Fields
  final int qualityScore; // 1 to 5 (General feel)
  final int selfRefreshmentScore; // 0-100 (Morning check-in slider)
  final int snoozeCount;
  final int sleepLatencyMinutes; // NEW: Time to fall asleep

  final int durationMinutes;

  final bool isNaturalWake;
  final bool isImmediateWake;

  final List<String> selectedTags;
  final String? memo; // NEW
  final bool isSaving;

  const SleepState({
    this.id,
    required this.bedTime,
    required this.wakeTime,
    this.qualityScore = 3,
    this.selfRefreshmentScore = 50, // Default mid
    this.snoozeCount = 0,
    this.sleepLatencyMinutes = 15, // Default average
    this.durationMinutes = 0,
    this.isNaturalWake = false,
    this.isImmediateWake = true,
    this.selectedTags = const [],
    this.memo,
    this.isSaving = false,
  });

  SleepState copyWith({
    int? id,
    DateTime? bedTime,
    DateTime? wakeTime,
    int? qualityScore,
    int? selfRefreshmentScore,
    int? snoozeCount,
    int? sleepLatencyMinutes,
    int? durationMinutes,
    bool? isNaturalWake,
    bool? isImmediateWake,
    List<String>? selectedTags,
    String? memo,
    bool? isSaving,
  }) {
    return SleepState(
      id: id ?? this.id,
      bedTime: bedTime ?? this.bedTime,
      wakeTime: wakeTime ?? this.wakeTime,
      qualityScore: qualityScore ?? this.qualityScore,
      selfRefreshmentScore: selfRefreshmentScore ?? this.selfRefreshmentScore,
      snoozeCount: snoozeCount ?? this.snoozeCount,
      sleepLatencyMinutes: sleepLatencyMinutes ?? this.sleepLatencyMinutes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isNaturalWake: isNaturalWake ?? this.isNaturalWake,
      isImmediateWake: isImmediateWake ?? this.isImmediateWake,
      selectedTags: selectedTags ?? this.selectedTags,
      memo: memo ?? this.memo,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  // Derived Metrics (Golden Hour Logic)
  double get sleepCycles {
    // Effective Sleep = Total Duration - Latency
    // Latency is now explicit from user
    if (durationMinutes <= sleepLatencyMinutes) return 0.0;
    return (durationMinutes - sleepLatencyMinutes) / 90.0;
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
  static const Map<String, List<String>> categorizedTags = {
    '섭취 (Ingestion)': ['☕️ 카페인', '🍺 알코올', '🍗 야식', '🍽 공복'],
    '활동 (Activity)': ['📱 스크린타임', '🏃 격한운동', '🧘 명상/독서', '💤 낮잠'],
    '환경 (Environment)': ['🔊 소음', '💡 빛', '🌡 온도', '🏨 잠자리변경'],
    '상태 (Condition)': ['🤯 스트레스', '🩸 생리/호르몬', '🤒 통증/질병', '💭 악몽'],
  };

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
      selfRefreshmentScore: record.selfRefreshmentScore ?? 50,
      snoozeCount: record.snoozeCount,
      sleepLatencyMinutes: record.sleepLatencyMinutes ?? 15,
      durationMinutes: record.durationMinutes,
      isNaturalWake: record.isNaturalWake,
      isImmediateWake: record.isImmediateWake,
      selectedTags: record.tags,
      memo: record.memo,
    );
  }

  void updateTimes(DateTime bedTime, DateTime wakeTime) {
    int duration = wakeTime.difference(bedTime).inMinutes;
    state = state.copyWith(
      bedTime: bedTime,
      wakeTime: wakeTime,
      durationMinutes: duration,
    );
  }

  void updateQuality(int score) {
    state = state.copyWith(qualityScore: score);
  }

  void updateRefreshmentScore(int score) {
    state = state.copyWith(selfRefreshmentScore: score);
  }

  void toggleNaturalWake(bool value) {
    state = state.copyWith(isNaturalWake: value);
    if (value) {
      // Natural wake implies no snooze usually
      state = state.copyWith(snoozeCount: 0);
    }
  }

  // Simplified: user doesn't care about count details, but we store it if needed
  void updateSnoozeCount(int count) {
    state = state.copyWith(snoozeCount: count);
  }

  void toggleImmediateWake(bool value) {
    state = state.copyWith(isImmediateWake: value);
    // If Immediate Wake is FALSE, it means they snoozed at least once.
    if (!value && state.snoozeCount == 0) {
      state = state.copyWith(snoozeCount: 1);
    } else if (value) {
      state = state.copyWith(snoozeCount: 0);
    }
  }

  void updateSleepLatency(int minutes) {
    state = state.copyWith(sleepLatencyMinutes: minutes);
  }

  void updateMemo(String value) {
    state = state.copyWith(memo: value);
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
        ..selfRefreshmentScore = state.selfRefreshmentScore
        ..isNaturalWake = state.isNaturalWake
        ..isImmediateWake = state.isImmediateWake
        ..snoozeCount = state.snoozeCount
        ..sleepLatencyMinutes = state.sleepLatencyMinutes
        ..tags = state.selectedTags
        ..memo = state.memo;

      // Scientific fields logic
      // Efficiency = (TST) / (TIB) * 100
      // TST = Duration - Latency (approximately, ignoring WASO for now)
      if (state.durationMinutes > 0) {
        double tst = (state.durationMinutes - state.sleepLatencyMinutes)
            .toDouble();
        if (tst < 0) tst = 0;
        record.sleepEfficiency = (tst / state.durationMinutes) * 100;
        // Clamp to 0-100
        if (record.sleepEfficiency! > 100) record.sleepEfficiency = 100;
      }

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
