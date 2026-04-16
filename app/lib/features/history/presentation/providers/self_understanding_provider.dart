import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/models/emotion_record.dart';
import '../../../../core/models/sleep_record.dart';
import '../../../../core/services/local_db_service.dart';

final weeklySelfUnderstandingProvider = FutureProvider<WeeklySelfUnderstanding>(
  (ref) async {
    final db = GetIt.I<LocalDbService>();
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
    final end = now;

    final records = await db.getEmotionRecordsByDateRange(start, end);
    final sleepRecords = await db.getSleepRecordsByRange(start, end);

    return WeeklySelfUnderstanding.from(records, sleepRecords);
  },
);

class WeeklySelfUnderstanding {
  final int emotionRecordCount;
  final int caredRecordCount;
  final double averageIntensity;
  final double averageSleepHours;
  final double averageCaringIntensityDrop;
  final List<WeeklyCount> topEmotions;
  final List<WeeklyCount> topContexts;
  final List<WeeklyCount> topBodySensations;
  final String insight;

  const WeeklySelfUnderstanding({
    required this.emotionRecordCount,
    required this.caredRecordCount,
    required this.averageIntensity,
    required this.averageSleepHours,
    required this.averageCaringIntensityDrop,
    required this.topEmotions,
    required this.topContexts,
    required this.topBodySensations,
    required this.insight,
  });

  bool get hasEnoughData => emotionRecordCount > 0 || averageSleepHours > 0;

  double get caredRatio {
    if (emotionRecordCount == 0) return 0;
    return caredRecordCount / emotionRecordCount;
  }

  factory WeeklySelfUnderstanding.from(
    List<EmotionRecord> records,
    List<SleepRecord> sleepRecords,
  ) {
    final emotionCounts = <String, int>{};
    final contextCounts = <String, int>{};
    final bodyCounts = <String, int>{};
    var totalIntensity = 0;
    var totalCaringDrop = 0;
    var caringDropCount = 0;

    for (final record in records) {
      final emotion = record.emotionLabel;
      if (emotion != null && emotion.isNotEmpty && emotion != 'Untitled') {
        emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
      }

      for (final context in record.activities ?? const <String>[]) {
        contextCounts[context] = (contextCounts[context] ?? 0) + 1;
      }

      for (final body in record.bodySensations ?? const <String>[]) {
        bodyCounts[body] = (bodyCounts[body] ?? 0) + 1;
      }

      totalIntensity += _resolveIntensity(record);

      if (record.postCaringIntensity != null) {
        totalCaringDrop +=
            _resolveIntensity(record) - record.postCaringIntensity!;
        caringDropCount++;
      }
    }

    final caredCount = records.where((record) => record.isCared).length;
    final averageIntensity = records.isEmpty
        ? 0.0
        : totalIntensity / records.length;

    final totalSleepHours = sleepRecords.fold<double>(
      0,
      (sum, record) => sum + record.totalSleepHours,
    );
    final averageSleepHours = sleepRecords.isEmpty
        ? 0.0
        : totalSleepHours / sleepRecords.length;
    final averageCaringIntensityDrop = caringDropCount == 0
        ? 0.0
        : totalCaringDrop / caringDropCount;

    final topEmotions = _topCounts(emotionCounts);
    final topContexts = _topCounts(contextCounts);
    final topBodySensations = _topCounts(bodyCounts);

    return WeeklySelfUnderstanding(
      emotionRecordCount: records.length,
      caredRecordCount: caredCount,
      averageIntensity: averageIntensity,
      averageSleepHours: averageSleepHours,
      averageCaringIntensityDrop: averageCaringIntensityDrop,
      topEmotions: topEmotions,
      topContexts: topContexts,
      topBodySensations: topBodySensations,
      insight: _buildInsight(
        records: records,
        sleepRecords: sleepRecords,
        topEmotions: topEmotions,
        topContexts: topContexts,
        topBodySensations: topBodySensations,
        averageIntensity: averageIntensity,
        averageSleepHours: averageSleepHours,
        averageCaringIntensityDrop: averageCaringIntensityDrop,
      ),
    );
  }

  static int _resolveIntensity(EmotionRecord record) {
    final explicit = record.intensity;
    if (explicit != null) return explicit.clamp(1, 10);

    final valence = record.valence ?? 0;
    final arousal = record.arousal ?? 0;
    final magnitude = sqrt(valence * valence + arousal * arousal);
    return (magnitude * 7).round().clamp(1, 10);
  }

  static List<WeeklyCount> _topCounts(Map<String, int> counts) {
    final items = counts.entries
        .map((entry) => WeeklyCount(label: entry.key, count: entry.value))
        .toList();
    items.sort((a, b) => b.count.compareTo(a.count));
    return items.take(3).toList();
  }

  static String _buildInsight({
    required List<EmotionRecord> records,
    required List<SleepRecord> sleepRecords,
    required List<WeeklyCount> topEmotions,
    required List<WeeklyCount> topContexts,
    required List<WeeklyCount> topBodySensations,
    required double averageIntensity,
    required double averageSleepHours,
    required double averageCaringIntensityDrop,
  }) {
    if (records.isEmpty && sleepRecords.isEmpty) {
      return '아직 이번 주를 읽을 기록이 부족해요. 감정이나 수면을 하나만 남겨도 패턴을 볼 수 있어요.';
    }

    if (topEmotions.isNotEmpty && topContexts.isNotEmpty) {
      return '이번 주에는 ${topEmotions.first.label} 감정이 ${topContexts.first.label} 상황과 자주 함께 나타났어요.';
    }

    if (averageCaringIntensityDrop > 0) {
      return '이번 주 회고한 감정은 강도가 평균 ${averageCaringIntensityDrop.toStringAsFixed(1)}점 낮아졌어요.';
    }

    if (topEmotions.isNotEmpty && topBodySensations.isNotEmpty) {
      return '이번 주 ${topEmotions.first.label} 감정은 ${topBodySensations.first.label} 몸 반응과 함께 기록됐어요.';
    }

    if (averageSleepHours > 0 && averageSleepHours < 6.5) {
      return '이번 주 평균 수면이 짧은 편이에요. 감정 강도와 함께 보면 피로의 영향을 확인할 수 있어요.';
    }

    if (averageIntensity >= 7) {
      return '이번 주 감정 강도가 높은 편이에요. 강했던 기록부터 회고해보면 반복되는 맥락을 찾기 좋아요.';
    }

    if (topEmotions.isNotEmpty) {
      return '이번 주 가장 자주 남긴 감정은 ${topEmotions.first.label}이에요.';
    }

    return '이번 주 기록이 쌓이고 있어요. 감정, 상황, 수면을 같이 보면 더 분명한 패턴이 보입니다.';
  }
}

class WeeklyCount {
  final String label;
  final int count;

  const WeeklyCount({required this.label, required this.count});
}
