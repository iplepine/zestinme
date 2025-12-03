# Data Model: EmotionRecord

## 개요
사용자의 감정 로그를 저장하는 핵심 엔티티. NoSQL(Document DB) 구조를 지향하여 유연성을 가짐.

## Schema (Typescript Interface style)

```typescript
interface EmotionRecord {
  id: string;
  userId: string;
  timestamp: Date; // 기록 시간 (실제 사건 시간과 다를 수 있음)
  eventTime: Date; // 사건 발생 시간

  // 1. 감정 상태 (Russell's Model)
  emotion: {
    primary: string; // 표면적 감정 (예: 분노)
    secondary?: string[]; // 이면의 감정 (예: 외로움, 수치심) - 심리학적 통찰
    valence: number; // -5(불쾌) ~ +5(쾌)
    arousal: number; // 0(이완) ~ 10(각성)
    intensity: number; // 1 ~ 10 (주관적 강도)
  };

  // 2. 상황적 맥락 (Context)
  context: {
    activities: string[]; // 행동 태그 (업무, 운전, 회의 등)
    people: string[]; // 함께 있던 사람
    location: string; // 장소
    environment?: { // (자동 수집 가능 시)
      weather: string;
      noiseLevel: string;
    };
  };

  // 3. 신체 및 인지 (Bio-Psycho)
  bodySensation: string[]; // 신체 반응 (두통, 심박수 증가)
  automaticThought: string; // 그 순간의 생각 (Text)
  cognitiveDistortion?: string[]; // 인지 왜곡 태그 (흑백논리, 과잉일반화 등 - AI 분석/유저 선택)

  // 4. 솔루션 및 피드백 (Coaching)
  actionTaken: string; // 감정 해소를 위해 한 행동 (심호흡, 소리지르기 등)
  effectScore: number; // 행동의 효과 (1~5)
  insightNote: string; // 추후 회고를 통해 얻은 인사이트
}