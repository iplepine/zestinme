import 'package:isar/isar.dart';

part 'sleep_record.g.dart';

@collection
class SleepRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date; // The date this sleep record belongs to (usually the morning of waking up)

  // Behavior: 침대에 누운 시간
  late DateTime inBedTime;
  late DateTime wakeTime;

  // State: 실제 잠든 시간 (Derived)
  DateTime get sleepOnsetTime =>
      inBedTime.add(Duration(minutes: sleepLatencyMinutes ?? 0));

  // Scientific Analysis Fields
  DateTime? lightsOutTime; // When user tried to sleep
  int? sleepLatencyMinutes; // Time to fall asleep
  int? wasoMinutes; // Wake After Sleep Onset

  int durationMinutes = 0; // Calculated duration (TST)
  double? sleepEfficiency; // (TST / TIB) * 100

  // Subjective Fields
  int qualityScore = 3; // 1-5 Scale (General feel)
  int? selfRefreshmentScore; // 0-100 (Morning check-in slider)

  // Flags
  bool isNaturalWake = false; // True if woke up without alarm
  bool isImmediateWake = true; // True if woke up at once (no snooze)
  int snoozeCount = 0; // Number of snoozes

  List<String> tags = []; // Factors
  String? memo; // Optional note
}
