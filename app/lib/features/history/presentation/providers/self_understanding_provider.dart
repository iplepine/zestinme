import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/condition_record.dart';
import '../../../../core/models/sleep_record.dart';
import '../../../../core/services/local_db_service.dart';

final weeklySelfUnderstandingProvider = FutureProvider<WeeklySelfUnderstanding>(
  (ref) async {
    final db = GetIt.I<LocalDbService>();
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));
    final end = now;

    final conditionRecords = await db.getConditionRecordsByDateRange(start, end);
    final sleepRecords = await db.getSleepRecordsByRange(start, end);

    return WeeklySelfUnderstanding.fromConditionRecords(conditionRecords, sleepRecords);
  },
);

class WeeklySelfUnderstanding {
  final int conditionRecordCount;
  final int stableRecordCount;
  final int sleepRecordCount;
  final double averageConditionScore;
  final double averageEnergy;
  final double averageFocus;
  final double averageRecovery;
  final double averageStress;
  final double averageSleepHours;
  final double averageSleepEfficiency;
  final List<WeeklyCount> topSignals;
  final String insight;

  const WeeklySelfUnderstanding({
    required this.conditionRecordCount,
    required this.stableRecordCount,
    required this.sleepRecordCount,
    required this.averageConditionScore,
    required this.averageEnergy,
    required this.averageFocus,
    required this.averageRecovery,
    required this.averageStress,
    required this.averageSleepHours,
    required this.averageSleepEfficiency,
    required this.topSignals,
    required this.insight,
  });

  bool get hasEnoughData => conditionRecordCount > 0 || sleepRecordCount > 0;
  double get caredRatio => conditionRecordCount == 0 ? 0 : stableRecordCount / conditionRecordCount;

  double get averageIntensity => averageStress;
  double get averageCaringIntensityDrop => averageRecovery - averageStress;
  List<WeeklyCount> get topEmotions => topSignals;
  List<WeeklyCount> get topContexts => const [];
  List<WeeklyCount> get topBodySensations => const [];

  factory WeeklySelfUnderstanding.fromConditionRecords(
    List<ConditionRecord> records,
    List<SleepRecord> sleepRecords,
  ) {
    final signalCounts = <String, int>{};
    final energyValues = <double>[];
    final focusValues = <double>[];
    final recoveryValues = <double>[];
    final stressValues = <double>[];
    final scoreValues = <double>[];
    var stableCount = 0;

    for (final record in records) {
      final score = _score(record);
      scoreValues.add(score);
      energyValues.add((record.energyScore ?? 0).toDouble());
      focusValues.add((record.focusScore ?? 0).toDouble());
      recoveryValues.add((record.recoveryScore ?? 0).toDouble());
      stressValues.add((record.stressScore ?? 0).toDouble());

      if (score >= 65) {
        stableCount++;
      }

      for (final item in [
        ...(record.descriptors ?? const <String>[]),
        ...(record.contextSignals ?? const <String>[]),
        ...(record.bodySignals ?? const <String>[]),
      ]) {
        final key = item.trim();
        if (key.isEmpty) continue;
        signalCounts[key] = (signalCounts[key] ?? 0) + 1;
      }
    }

    final totalSleepHours = sleepRecords.fold<double>(
      0,
      (sum, record) => sum + record.totalSleepHours,
    );
    final averageSleepHours = sleepRecords.isEmpty
        ? 0.0
        : totalSleepHours / sleepRecords.length;

    final totalSleepEfficiency = sleepRecords.fold<double>(
      0,
      (sum, record) => sum + (record.sleepEfficiency ?? record.averageScore * 10),
    );
    final averageSleepEfficiency = sleepRecords.isEmpty
        ? 0.0
        : totalSleepEfficiency / sleepRecords.length;

    final averageEnergy = _average(energyValues);
    final averageFocus = _average(focusValues);
    final averageRecovery = _average(recoveryValues);
    final averageStress = _average(stressValues);
    final averageConditionScore = _average(scoreValues);
    final topSignals = _topCounts(signalCounts);

    return WeeklySelfUnderstanding(
      conditionRecordCount: records.length,
      stableRecordCount: stableCount,
      sleepRecordCount: sleepRecords.length,
      averageConditionScore: averageConditionScore,
      averageEnergy: averageEnergy,
      averageFocus: averageFocus,
      averageRecovery: averageRecovery,
      averageStress: averageStress,
      averageSleepHours: averageSleepHours,
      averageSleepEfficiency: averageSleepEfficiency,
      topSignals: topSignals,
      insight: _buildInsight(
        conditionRecordCount: records.length,
        sleepRecordCount: sleepRecords.length,
        topSignals: topSignals,
        averageConditionScore: averageConditionScore,
        averageEnergy: averageEnergy,
        averageFocus: averageFocus,
        averageRecovery: averageRecovery,
        averageStress: averageStress,
        averageSleepHours: averageSleepHours,
        averageSleepEfficiency: averageSleepEfficiency,
      ),
    );
  }

  static double _score(ConditionRecord record) {
    final raw = ((record.energyScore ?? 5) +
            (record.focusScore ?? 5) +
            (record.recoveryScore ?? 5) +
            (11 - (record.stressScore ?? 5))) /
        4;
    return (raw * 10).clamp(10.0, 100.0);
  }

  static double _average(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  static List<WeeklyCount> _topCounts(Map<String, int> counts) {
    final items = counts.entries
        .map((entry) => WeeklyCount(label: entry.key, count: entry.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return items.take(3).toList();
  }

  static String _buildInsight({
    required int conditionRecordCount,
    required int sleepRecordCount,
    required List<WeeklyCount> topSignals,
    required double averageConditionScore,
    required double averageEnergy,
    required double averageFocus,
    required double averageRecovery,
    required double averageStress,
    required double averageSleepHours,
    required double averageSleepEfficiency,
  }) {
    if (conditionRecordCount == 0 && sleepRecordCount == 0) {
      return '이번 주 기록이 아직 많지 않아요. 체크인이나 회복 로그를 하나만 남겨도 흐름이 보이기 시작합니다.';
    }
    if (averageConditionScore >= 80 && averageSleepHours >= 7) {
      return '전체 흐름이 좋은 편이에요. 회복과 집중이 함께 유지되고 있으니 지금 루틴을 이어가보세요.';
    }
    if (averageStress >= 7 && averageRecovery <= 4.5) {
      return '스트레스가 회복보다 앞서 있어요. 오늘은 자극을 줄이고 쉬는 시간을 먼저 확보해보세요.';
    }
    if (averageEnergy >= 7 && averageFocus <= 5.5) {
      return '에너지는 있는데 집중이 분산되는 흐름이에요. 할 일의 범위를 좁히면 훨씬 안정적입니다.';
    }
    if (averageSleepHours > 0 && averageSleepHours < 6.5) {
      return '평균 수면 시간이 짧아요. 수면부터 보강하면 에너지와 집중도도 함께 올라옵니다.';
    }
    if (averageSleepEfficiency > 0 && averageSleepEfficiency < 80) {
      return '수면 효율이 낮은 편이에요. 잠들기 전 루틴과 아침 회복 리듬을 점검해보세요.';
    }
    if (topSignals.isNotEmpty) {
      return '이번 주에는 ${_signalLabel(topSignals.first.label)} 신호가 자주 나타났어요. 이 신호가 컨디션 흐름에 계속 영향을 주고 있습니다.';
    }
    if (averageConditionScore <= 45) {
      return '회복 여지가 큰 한 주였어요. 수면과 자극 관리부터 다시 맞추면 금방 안정될 수 있어요.';
    }
    return '이번 주 흐름은 비교적 안정적이에요. 에너지, 집중, 회복의 균형을 계속 살펴보면 좋습니다.';
  }

  static String _signalLabel(String label) {
    switch (label) {
      case 'LockedIn':
        return '몰입';
      case 'Drained':
        return '지침';
      case 'Wired':
        return '과긴장';
      case 'Foggy':
        return '흐릿함';
      case 'Overloaded':
        return '벅참';
      case 'Steady':
        return '안정';
      case 'Work':
        return '일/업무';
      case 'Relationship':
        return '인간관계';
      case 'Family':
        return '가족';
      case 'Money':
        return '금전';
      case 'Health':
        return '건강';
      case 'SleepDebt':
        return '수면 부족';
      case 'Exercise':
        return '운동';
      case 'Deadline':
        return '마감';
      case 'Social':
        return '사람 만남';
      case 'Travel':
        return '이동';
      case 'Alone':
        return '혼자 있음';
      case 'Future':
        return '미래 걱정';
      case 'ChestTight':
        return '가슴 답답함';
      case 'ShoulderTension':
        return '목/어깨 긴장';
      case 'Headache':
        return '두통';
      case 'Stomach':
        return '속 불편함';
      case 'Heartbeat':
        return '심장 두근거림';
      case 'Fatigue':
        return '피로감';
      case 'LowEnergy':
        return '기운 없음';
      case 'Sleepy':
        return '졸림';
      case 'EyeStrain':
        return '눈 피로';
      case 'ShallowBreath':
        return '숨이 얕음';
      case 'HeavyBody':
        return '몸이 무거움';
      case 'Restless':
        return '가라앉지 않음';
      default:
        return label;
    }
  }
}

class WeeklyCount {
  final String label;
  final int count;

  const WeeklyCount({required this.label, required this.count});
}
