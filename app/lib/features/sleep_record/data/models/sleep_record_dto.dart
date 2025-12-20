import 'package:hive/hive.dart';

part 'sleep_record_dto.g.dart';

@HiveType(typeId: 3)
class SleepRecordDto {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime inBedTime;

  @HiveField(2)
  final DateTime wakeTime;

  @HiveField(3)
  final int qualityScore;

  @HiveField(4)
  final int? selfRefreshmentScore;

  @HiveField(5)
  final List<String> tags;

  @HiveField(6)
  final String? memo;

  @HiveField(7)
  final DateTime date;

  SleepRecordDto({
    required this.id,
    required this.inBedTime,
    required this.wakeTime,
    required this.qualityScore,
    this.selfRefreshmentScore,
    this.tags = const [],
    this.memo,
    required this.date,
  });
}
