# Enums and Codes

## Emotion Categories (Russell's Model Mapping)

```typescript
// 감정의 4분면 분류
export enum EmotionZone {
  H_P = 'High_Pleasure', // 기쁨, 흥분 (1사분면)
  H_U = 'High_Unpleasure', // 분노, 공포 (2사분면)
  L_U = 'Low_Unpleasure', // 우울, 지루함 (3사분면)
  L_P = 'Low_Pleasure', // 평온, 이완 (4사분면)
}

// 구체적 감정 코드 (예시)
export enum EmotionCode {
  // H_U (Anger/Anxiety)
  ANGER = 'E_001',
  ANXIETY = 'E_002',
  IRRITATION = 'E_003', // 짜증

  // L_U (Sadness/Depression)
  SADNESS = 'E_101',
  LONELINESS = 'E_102',
  LETHARGY = 'E_103', // 무기력

  // ...
}