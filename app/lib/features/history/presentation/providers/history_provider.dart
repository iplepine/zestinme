import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/condition_record.dart';
import '../../../../core/models/emotion_record.dart';
import '../../../../core/models/sleep_record.dart';
import '../../../../core/services/local_db_service.dart';

part 'history_provider.g.dart';

@riverpod
class HistoryDate extends _$HistoryDate {
  @override
  DateTime build() => DateTime.now();

  void updateDate(DateTime date) {
    state = date;
  }
}

@riverpod
Future<List<EmotionRecord>> historyRecords(HistoryRecordsRef ref) async {
  final monthDate = ref.watch(
    historyDateProvider.select((date) => DateTime(date.year, date.month)),
  );
  final db = GetIt.I<LocalDbService>();

  final startOfMonth = DateTime(monthDate.year, monthDate.month, 1);
  final endOfMonth = DateTime(
    monthDate.year,
    monthDate.month + 1,
    0,
    23,
    59,
    59,
  );

  final conditionRecords = await db.getConditionRecordsByDateRange(
    startOfMonth,
    endOfMonth,
  );
  final sleepRecords = await db.getSleepRecordsByRange(startOfMonth, endOfMonth);

  final entries = <EmotionRecord>[
    ...conditionRecords.map(_wrapConditionRecord),
    ...sleepRecords.map(_wrapSleepRecord),
  ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  return entries;
}

EmotionRecord _wrapConditionRecord(ConditionRecord source) {
  final score = _conditionScore(source);
  final descriptorTags = source.descriptors ?? const <String>[];
  final contextTags = source.contextSignals ?? const <String>[];
  final bodyTags = source.bodySignals ?? const <String>[];
  final primaryLabel = descriptorTags.isNotEmpty
      ? descriptorTags.first
      : _fallbackDescriptor(source);

  return EmotionRecord()
    ..timestamp = source.timestamp
    ..valence = (source.energyScore ?? 0).toDouble()
    ..arousal = (source.focusScore ?? 0).toDouble()
    ..intensity = (score / 10).round().clamp(1, 10).toInt()
    ..emotionLabel = primaryLabel
    ..status = EmotionRecordStatus.caught
    ..activities = <String>[
      'condition-checkin',
      ...descriptorTags.skip(1),
      ...contextTags,
    ]
    ..bodySensations = <String>[
      ...bodyTags,
      'stress:${source.stressScore ?? 0}',
    ]
    ..detailedNote = source.note
    ..postCaringIntensity = (source.recoveryScore ?? 0).clamp(0, 10).toInt();
}

EmotionRecord _wrapSleepRecord(SleepRecord source) {
  final score = _normalizeSleepScore(source);

  return EmotionRecord()
    ..timestamp = source.date
    ..valence = _normalizeSleepEnergy(source)
    ..arousal = source.qualityScore.toDouble().clamp(1.0, 10.0)
    ..intensity = score
    ..emotionLabel = source.selfRefreshmentScore != null
        ? 'sleep recovery'
        : 'sleep log'
    ..status = EmotionRecordStatus.caught
    ..activities = _sleepTags(source)
    ..bodySensations = _sleepSignals(source)
    ..detailedNote = _sleepNote(source)
    ..postCaringIntensity = source.selfRefreshmentScore != null
        ? (source.selfRefreshmentScore! / 10).round().clamp(1, 10).toInt()
        : score
    ..caredAt = source.selfRefreshmentScore != null ? source.date : null;
}

double _conditionScore(ConditionRecord record) {
  final raw = ((record.energyScore ?? 5) +
          (record.focusScore ?? 5) +
          (record.recoveryScore ?? 5) +
          (11 - (record.stressScore ?? 5))) /
      4;
  return (raw * 10).clamp(10.0, 100.0);
}

String _fallbackDescriptor(ConditionRecord record) {
  final score = _conditionScore(record);
  if (score >= 80) return 'LockedIn';
  if ((record.stressScore ?? 0) >= 8) return 'Overloaded';
  if ((record.recoveryScore ?? 10) <= 4) return 'Drained';
  if ((record.focusScore ?? 10) <= 4) return 'Foggy';
  return 'Steady';
}

double _normalizeSleepEnergy(SleepRecord source) {
  final refreshment = source.selfRefreshmentScore?.toDouble() ?? 50.0;
  return (refreshment / 10).clamp(1.0, 10.0);
}

int _normalizeSleepScore(SleepRecord source) {
  final candidate = source.selfRefreshmentScore?.toDouble() ?? source.averageScore;
  if (candidate <= 0) return 1;
  final adjusted = candidate > 10 ? candidate / 10.0 : candidate;
  return adjusted.round().clamp(1, 10).toInt();
}

String _sleepNote(SleepRecord source) {
  final segments = <String>[
    'sleep ${source.totalSleepHours.toStringAsFixed(1)}h',
    'quality ${source.qualityScore}/5',
  ];

  if (source.sleepEfficiency != null) {
    segments.add('efficiency ${(source.sleepEfficiency!).round()}%');
  }

  if (source.selfRefreshmentScore != null) {
    segments.add('refreshment ${source.selfRefreshmentScore}%');
  }

  if (source.memo != null && source.memo!.trim().isNotEmpty) {
    segments.add(source.memo!.trim());
  }

  return segments.join(' · ');
}

List<String> _sleepTags(SleepRecord source) {
  final tags = <String>['sleep'];
  if (source.isNaturalWake) tags.add('natural-wake');
  if (source.isImmediateWake) tags.add('fast-rise');
  if (source.snoozeCount > 0) tags.add('snooze:${source.snoozeCount}');
  tags.addAll(source.tags.map(_normalizeSleepTag));
  return tags;
}

List<String> _sleepSignals(SleepRecord source) {
  final signals = <String>[];
  if ((source.sleepLatencyMinutes ?? 0) >= 30) {
    signals.add('sleep-latency:${source.sleepLatencyMinutes}m');
  }
  if ((source.sleepEfficiency ?? 0) < 80) {
    signals.add('efficiency:${(source.sleepEfficiency ?? 0).round()}%');
  }
  if (source.selfRefreshmentScore != null) {
    signals.add('refreshment:${source.selfRefreshmentScore}%');
  }
  return signals;
}

String _normalizeSleepTag(String tag) {
  final normalized = tag.trim();
  if (normalized.isEmpty) return normalized;

  switch (normalized) {
    case 'screens':
      return 'screen-time';
    case 'exercise':
      return 'intense-workout';
    default:
      return normalized;
  }
}
