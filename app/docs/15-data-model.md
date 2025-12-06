# 15. Data Model

## EmotionRecord Updates
Existing `EmotionRecord` needs the following additions:

```dart
enum EmotionRecordStatus {
  caught, // Initial recording (Hot)
  incubating, // Waiting period
  readyForAnalysis, // Time passed
  analyzed, // Analysis complete (Cold)
}

class EmotionRecord {
  // ... existing fields ...

  @enumerated
  late EmotionRecordStatus status; 

  DateTime? analysisUnlockTime; // When incubation ends
  
  // Cold Cognition Fields
  String? detailedNote; // Full journal
  List<String>? cognitiveDistortions; // Selected distortion types
  String? alternativeThought; // Re-framed thought
  
  // Link to Quest
  String? questId; 
}
```

## New Entity: Quest
New collection to track quest progress.

```dart
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

enum QuestStatus {
  available,
  active,
  completed,
}
```
