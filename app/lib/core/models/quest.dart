import 'package:isar/isar.dart';

part 'quest.g.dart';

@collection
class Quest {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String questId; // e.g., "quest_sleep_pattern"

  late String title;
  late String description;

  @enumerated
  late QuestStatus status; // active, completed, failed

  DateTime? startDate;
  DateTime? endDate;

  List<String>? completedTasks; // IDs of completed sub-tasks

  // JSON blob for flexible data storage (e.g., recorded sleep times)
  String? dataJson;
}

enum QuestStatus { available, active, completed }
