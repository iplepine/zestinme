# 10. Isar Entities

## 1. EmotionRecord
사용자의 감정 기록을 저장하는 핵심 엔티티입니다.

```dart
enum EmotionRecordStatus {
  caught,           // 초기 기록 단계
  incubating,       // 숙성 대기 시간 (4시간)
  readyForAnalysis, // 분석 가능한 상태
  analyzed,         // AI 분석 및 회고 완료 (Cold Cognition)
}

@collection
class EmotionRecord {
  Id id = Isar.autoIncrement;
  
  // Core Fields
  DateTime timestamp = DateTime.now();
  double? valence; // -1.0 to 1.0 (Pleasantness)
  double? arousal; // -1.0 to 1.0 (Intensity)
  String? emotionLabel;
  
  @enumerated
  late EmotionRecordStatus status; 

  DateTime? analysisUnlockTime; // 숙성 종료 시점
  
  // Cold Cognition (Pruning) Fields
  String? automaticThought; // 당시의 자동적 사고
  String? detailedNote;     // 전체 저널 기록
  List<String>? activities; // 관련 활동
  List<String>? cognitiveDistortions; // 인지적 오류 유형
  String? alternativeThought;       // 대안적 사고 (Re-framing)
  
  // Link to Quest
  String? questId; 
}
```

## 2. Quest
사용자의 행동 변화를 유도하는 실험(Mission) 엔티티입니다.

```dart
enum QuestStatus {
  available, // 시작 전
  active,    // 진행 중
  completed, // 완료
  failed,    // 실패 (기간 도과 등)
}

@collection
class Quest {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String questId; // 예: "quest_sleep_pattern"

  late String title;
  late String description;
  
  @enumerated
  late QuestStatus status; 
  
  DateTime? startDate;
  DateTime? endDate;
  
  List<String>? completedTasks; // 완료된 하위 태스크 ID 목록
  
  // 유연한 데이터 저장을 위한 JSON 블롭 (예: 기록된 수면 시간들)
  String? dataJson; 
}
```
