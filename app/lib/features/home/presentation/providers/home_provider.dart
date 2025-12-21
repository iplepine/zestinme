import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:zestinme/core/models/emotion_record.dart';
import 'package:zestinme/core/models/sleep_record.dart';
import 'package:zestinme/core/services/local_db_service.dart';
import 'package:zestinme/features/caring/domain/services/caring_service.dart';

// State
class HomeState {
  final List<EmotionRecord> uncaredRecords;
  final SleepRecord? todaySleep;
  final double sleepEfficiency; // 0.0 - 1.0 (for battery level)
  final double sunlightLevel; // 0.0 (Night) ~ 1.0 (Day)
  final bool isLoading;

  HomeState({
    this.uncaredRecords = const [],
    this.todaySleep,
    this.sleepEfficiency = 0.0,
    this.sunlightLevel = 1.0,
    this.isLoading = true,
  });

  bool get isCaringNeeded => uncaredRecords.isNotEmpty;

  HomeState copyWith({
    List<EmotionRecord>? uncaredRecords,
    SleepRecord? todaySleep,
    double? sleepEfficiency,
    double? sunlightLevel,
    bool? isLoading,
  }) {
    return HomeState(
      uncaredRecords: uncaredRecords ?? this.uncaredRecords,
      todaySleep: todaySleep ?? this.todaySleep,
      // Robust fallbacks for hot-reload state migration
      sleepEfficiency: sleepEfficiency ?? this.sleepEfficiency,
      sunlightLevel: sunlightLevel ?? this.sunlightLevel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Provider
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState()) {
    // Ensure we start with a clean state even after hot reload
    state = state.copyWith(sunlightLevel: _calculateDefaultSunlight());
    refresh();
  }

  double _calculateDefaultSunlight() {
    final hour = DateTime.now().hour;
    // 6 AM to 12 PM (0 -> 1), 12 PM to 6 PM (1 -> 0)
    if (hour >= 6 && hour < 12) return (hour - 6) / 6.0;
    if (hour >= 12 && hour < 18) return 1.0 - (hour - 12) / 6.0;
    return 0.0; // Night
  }

  void updateSunlight(double value) {
    state = state.copyWith(sunlightLevel: value.clamp(0.0, 1.0));
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    final db = GetIt.I<LocalDbService>();

    try {
      // 1. Fetch & Filter Uncared Records
      final candidates = await db.getUncaredEmotionRecords();
      final readyRecords = candidates
          .where((r) => CaringService.isRecordPendingCaring(r))
          .toList();

      // 2. Fetch Today's Sleep
      final now = DateTime.now();
      final todayRecord = await db.getSleepRecordByDate(now);

      double efficiency = 0.0;
      if (todayRecord != null && todayRecord.sleepEfficiency != null) {
        efficiency =
            todayRecord.sleepEfficiency! / 100.0; // Normalize to 0.0 - 1.0
      }

      state = state.copyWith(
        uncaredRecords: readyRecords,
        todaySleep: todayRecord,
        sleepEfficiency: efficiency,
        isLoading: false,
      );
    } catch (e) {
      // Handle error (silent for now)
      state = state.copyWith(isLoading: false);
    }
  }
}
