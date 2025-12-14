import 'package:isar/isar.dart';

part 'sleep_record.g.dart';

@collection
class SleepRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date; // The date this sleep record belongs to (usually the morning of waking up)

  late DateTime bedTime;
  late DateTime wakeTime;

  int durationMinutes = 0; // Calculated duration

  int qualityScore = 3; // 1-5 Scale

  bool isNaturalWake = false; // True if woke up without alarm

  List<String> tags = []; // Factors
}
