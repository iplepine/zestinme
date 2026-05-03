import 'package:isar/isar.dart';

part 'condition_record.g.dart';

@collection
class ConditionRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  // Core condition signals.
  int? energyScore; // Suggested range: 1-10
  int? focusScore; // Suggested range: 1-10
  int? recoveryScore; // Suggested range: 1-10
  int? stressScore; // Suggested range: 1-10

  // Lightweight descriptors for the state itself.
  List<String>? descriptors;

  // External and internal context that may explain the condition.
  List<String>? contextSignals;
  List<String>? bodySignals;

  // Freeform note for the check-in.
  String? note;

  @ignore
  bool get hasSignals =>
      energyScore != null ||
      focusScore != null ||
      recoveryScore != null ||
      stressScore != null ||
      (descriptors?.isNotEmpty ?? false) ||
      (contextSignals?.isNotEmpty ?? false) ||
      (bodySignals?.isNotEmpty ?? false) ||
      (note?.trim().isNotEmpty ?? false);
}
