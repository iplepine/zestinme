# 1.0 Onboarding: The Void Garden

| Attribute | Value |
| :--- | :--- |
| **Version** | 2.0 |
| **Status** | Spec Updated |
| **Date** | 2025-12-06 |
| **Author** | Mind-Angler Committee |
| **Related** | `spec/15-data-model/30-json-schemas.md` |

## 1. 기획 의도 (Design Intent)

> **Dr. Mind:**
> "우리의 마음은 정원과 같습니다. 오래 돌보지 않으면 잡초가 무성해지지만, 다시 관심을 주면 언제든 싹이 틔어납니다."

*   **Nurturing over Hunting:** 낚시(사냥)에서 양육(가드닝)으로의 전환. 공격적인 행위 대신 부드러운 터치(쓰다듬기, 물주기)를 유도합니다.
*   **Restoration:** '낡고 방치된 화분'을 발견하고 닦아내는 행위를 통해, 자신의 마음을 다시 돌보겠다는 **서약(Commitment)**을 은유합니다.

## 2. 시퀀스 상세 흐름 (User Flow)

### Scene 0: 초기 상태 (The Neglected Pot)
*   **Visual:** 칠흑 같은 어둠 속, 덩그러니 놓인 낡은 화분 하나. 먼지가 쌓여 있고 표면이 흐릿함.
*   **Audio:** 고요한 적막, 아주 미세한 바람 소리.
*   **Prompt:** "오랫동안 비어있던 화분이네요." (Fade-in)
*   **Interaction:** 화분을 터치하거나 문지르는 제스처 유도.

### Scene 1: 정체성 확인 (Identity)
*   **Action:** 사용자가 화분의 먼지를 문질러서 닦아냄 (Scratch card effect).
*   **Event:** 먼지가 걷히며 화분의 '이름표'가 드러남.
    *   **Feedback:** "이름표가 있네요. 누구의 화분인가요?"
*   **Input:** 사용자 닉네임 입력 (키보드 호출).
*   **Outcome:** 입력 완료 시 화분이 깨끗해지고, 희미한 빛이 들어오기 시작함.

### Scene 2: 환경 조성 (Environment / Baseline)
*   **Transition:** 빛이 조금 들어오며 화분 주변의 풍경이 희미하게 보임.
*   **Metaphor (SAM Scale 변형):**
    *   **빛의 양 (Valence):** 화면 우측 슬라이더(해 높이). (위: 따스한 햇살 ↔ 아래: 차분한 달빛)
    *   **물의 양 (Arousal):** 화면 하단 슬라이더(수분). (왼쪽: 건조함/차분 ↔ 오른쪽: 촉촉함/생기)
*   **Question:** "지금 이 화분에는 무엇이 필요한가요?"
*   **Visual Feedback:** 빛과 물의 양에 따라 흙의 질감과 주변 조명이 실시간 변화.

### Scene 3: 씨앗 심기 (Goal Setting / Seeding)
*   **Event:** 환경이 조성되면, 3가지 씨앗 중 하나를 선택하여 심음.
    1.  **🌙 달맞이꽃 씨앗:** 수면 관리 (Deep Sleep)
    2.  **🌵 선인장 돌보기:** 분노/스트레스 관리 (Anger)
    3.  **🌻 해바라기 씨앗:** 긍정/행복 찾기 (Happiness)
*   **Interaction:** 씨앗을 드래그하여 화분 흙에 심음.
*   **Outcome:** 싹이 트는 애니메이션과 함께 메인 홈(정원)으로 진입.

## 3. 데이터 요구사항 (Data Schema)

```json
{
  "user_profile": {
    "nickname": "String",
    "created_at": "Timestamp"
  },
  "initial_garden_state": {
    "environment": {
      "sunlight_level": "Float (0.0 ~ 1.0) // Valence",
      "water_level": "Float (0.0 ~ 1.0) // Arousal"
    },
    "planted_seed": {
      "type": "String ('moon_flower' | 'cactus' | 'sunflower')",
      "planted_at": "Timestamp"
    }
  }
}
```

## 4. 구현 가이드 (Technical Notes)

### 4.1 Visuals
*   **Pot Interaction:** `CustomPainter`로 화분과 먼지(Dust) 레이어를 그림. 사용자의 드래그 좌표에 따라 먼지 레이어의 투명도(Alpha)를 지워나가는 방식.
*   **Grow Animation:** 씨앗을 심었을 때, `rive` 또는 절차적 애니메이션으로 작은 새싹이 올라오는 연출 필수.

### 4.2 Haptics
*   **Rubbing:** 먼지를 닦을 때 미세한 진동 (`HapticFeedback.selectionClick`)을 연속적으로 주어 '사각거리는' 느낌 구현.
*   **Planting:** 씨앗이 흙에 닿을 때 묵직한 진동 (`heavyImpact`).
