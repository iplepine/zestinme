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
  final bool isLoading;

  HomeState({
    this.uncaredRecords = const [],
    this.todaySleep,
    this.sleepEfficiency = 0.0,
    this.isLoading = true,
  });

  bool get isCaringNeeded => uncaredRecords.isNotEmpty;

  HomeState copyWith({
    List<EmotionRecord>? uncaredRecords,
    SleepRecord? todaySleep,
    double? sleepEfficiency,
    bool? isLoading,
  }) {
    return HomeState(
      uncaredRecords: uncaredRecords ?? this.uncaredRecords,
      todaySleep: todaySleep ?? this.todaySleep,
      sleepEfficiency: sleepEfficiency ?? this.sleepEfficiency,
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
    refresh();
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
      // Logic: If before noon, show last night's sleep (using today's date if logged)
      // If no record for today, show 0.
      final now = DateTime.now();
      // Assuming SleepRecord date is the wake-up date
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
