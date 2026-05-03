import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:zestinme/core/models/condition_record.dart';
import 'package:zestinme/core/models/sleep_record.dart';
import 'package:zestinme/core/services/local_db_service.dart';

class HomeState {
  final ConditionRecord? latestCondition;
  final List<ConditionRecord> uncaredRecords;
  final SleepRecord? todaySleep;
  final double sleepEfficiency;
  final double sunlightLevel;
  final String backgroundImagePath;
  final bool isLoading;
  final double conditionScore;
  final double averageEnergy;
  final double averageFocus;
  final double averageRecovery;
  final double averageStress;
  final int attentionCount;

  const HomeState({
    this.latestCondition,
    this.uncaredRecords = const [],
    this.todaySleep,
    this.sleepEfficiency = 0.0,
    this.sunlightLevel = 1.0,
    this.backgroundImagePath = 'assets/images/backgrounds/background_night.png',
    this.isLoading = true,
    this.conditionScore = 0.0,
    this.averageEnergy = 0.0,
    this.averageFocus = 0.0,
    this.averageRecovery = 0.0,
    this.averageStress = 0.0,
    this.attentionCount = 0,
  });

  bool get isCaringNeeded => attentionCount > 0;
  bool get needsConditionAttention => attentionCount > 0 || conditionScore < 65;

  HomeState copyWith({
    ConditionRecord? latestCondition,
    List<ConditionRecord>? uncaredRecords,
    SleepRecord? todaySleep,
    double? sleepEfficiency,
    double? sunlightLevel,
    String? backgroundImagePath,
    bool? isLoading,
    double? conditionScore,
    double? averageEnergy,
    double? averageFocus,
    double? averageRecovery,
    double? averageStress,
    int? attentionCount,
  }) {
    return HomeState(
      latestCondition: latestCondition ?? this.latestCondition,
      uncaredRecords: uncaredRecords ?? this.uncaredRecords,
      todaySleep: todaySleep ?? this.todaySleep,
      sleepEfficiency: sleepEfficiency ?? this.sleepEfficiency,
      sunlightLevel: sunlightLevel ?? this.sunlightLevel,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      isLoading: isLoading ?? this.isLoading,
      conditionScore: conditionScore ?? this.conditionScore,
      averageEnergy: averageEnergy ?? this.averageEnergy,
      averageFocus: averageFocus ?? this.averageFocus,
      averageRecovery: averageRecovery ?? this.averageRecovery,
      averageStress: averageStress ?? this.averageStress,
      attentionCount: attentionCount ?? this.attentionCount,
    );
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState()) {
    state = state.copyWith(sunlightLevel: _calculateDefaultSunlight());
    refresh();
  }

  double _calculateDefaultSunlight() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) return (hour - 6) / 6.0;
    if (hour >= 12 && hour < 18) return 1.0 - (hour - 12) / 6.0;
    return 0.0;
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    final db = GetIt.I<LocalDbService>();

    try {
      final now = DateTime.now();
      final weekStart = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 6));

      final latestCondition = await db.getLatestConditionRecord();
      final recentConditionRecords = await db.getConditionRecordsByDateRange(
        weekStart,
        now,
      );
      final todaySleep = await db.getSleepRecordByDate(now);

      final snapshot = _buildConditionSnapshot(recentConditionRecords);
      final attentionRecords = recentConditionRecords
          .where(_needsAttention)
          .toList(growable: false);

      state = state.copyWith(
        latestCondition: latestCondition,
        uncaredRecords: attentionRecords,
        todaySleep: todaySleep,
        sleepEfficiency: (todaySleep?.sleepEfficiency ?? 0) / 100.0,
        conditionScore: snapshot.conditionScore,
        averageEnergy: snapshot.averageEnergy,
        averageFocus: snapshot.averageFocus,
        averageRecovery: snapshot.averageRecovery,
        averageStress: snapshot.averageStress,
        attentionCount: attentionRecords.length,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  _ConditionSnapshot _buildConditionSnapshot(List<ConditionRecord> records) {
    if (records.isEmpty) return const _ConditionSnapshot();

    final energyValues = <double>[];
    final focusValues = <double>[];
    final recoveryValues = <double>[];
    final stressValues = <double>[];
    final scoreValues = <double>[];

    for (final record in records) {
      if (record.energyScore != null) {
        energyValues.add(record.energyScore!.toDouble());
      }
      if (record.focusScore != null) {
        focusValues.add(record.focusScore!.toDouble());
      }
      if (record.recoveryScore != null) {
        recoveryValues.add(record.recoveryScore!.toDouble());
      }
      if (record.stressScore != null) {
        stressValues.add(record.stressScore!.toDouble());
      }

      scoreValues.add(_score(record));
    }

    return _ConditionSnapshot(
      conditionScore: scoreValues.first,
      averageEnergy: _average(energyValues),
      averageFocus: _average(focusValues),
      averageRecovery: _average(recoveryValues),
      averageStress: _average(stressValues),
    );
  }

  bool _needsAttention(ConditionRecord record) {
    final score = _score(record);
    return score < 55 ||
        (record.stressScore ?? 0) >= 8 ||
        (record.recoveryScore ?? 10) <= 4;
  }

  double _score(ConditionRecord record) {
    final raw = ((record.energyScore ?? 5) +
            (record.focusScore ?? 5) +
            (record.recoveryScore ?? 5) +
            (11 - (record.stressScore ?? 5))) /
        4;
    return (raw * 10).clamp(10.0, 100.0);
  }

  double _average(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}

class _ConditionSnapshot {
  final double conditionScore;
  final double averageEnergy;
  final double averageFocus;
  final double averageRecovery;
  final double averageStress;

  const _ConditionSnapshot({
    this.conditionScore = 0.0,
    this.averageEnergy = 0.0,
    this.averageFocus = 0.0,
    this.averageRecovery = 0.0,
    this.averageStress = 0.0,
  });
}
