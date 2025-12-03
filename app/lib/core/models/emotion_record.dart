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

  // Bio-Psycho
  List<String>? bodySensations;
  String? automaticThought;

  // Action
  String? actionTaken;
}
