import 'package:isar/isar.dart';

part 'emotion_record.g.dart';

@collection
class EmotionRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  // Russell's Model
  double? valence; // -5 to +5
  double? arousal; // 0 to 10
  String? emotionLabel; // e.g. "Happy", "Angry"

  // Context
  List<String>? activities;
  List<String>? people;
  String? location;

  @enumerated
  late EmotionRecordStatus status;

  DateTime? analysisUnlockTime; // When incubation ends

  // Cold Cognition Fields
  String? detailedNote; // Full journal
  List<String>? cognitiveDistortions; // Selected distortion types
  String? alternativeThought; // Re-framed thought

  // Link to Quest
  String? questId;

  // Bio-Psycho
  List<String>? bodySensations;
  String? automaticThought;

  // Caring (Nurturing) Fields
  DateTime? caredAt; // When nurturing was completed
  String? coachingQuestionId; // ID of the question asked
  String? coachingAnswer; // User's answer/reflection
  List<String>? valueTags; // Discovered core values

  @ignore
  bool get isCared => caredAt != null;

  // Action
  String? actionTaken;
}

enum EmotionRecordStatus {
  caught, // Initial recording (Hot)
  incubating, // Waiting period
  readyForAnalysis, // Time passed
  analyzed, // Analysis complete (Cold)
}
