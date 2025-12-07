# 1.3 Emotion Refinement: Nurturing (가꾸기)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.0 |
| **Status** | Draft |
| **Date** | 2025-12-08 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/10-domain/23-emotion-value-framework.md`, `spec/50-ui/02-seeding-screen.md` |

## 1. 기획 의도 (Design Intent)
> **"Seed First, Nurture Later."**

감정을 기록하는 순간(Seeding)은 빠르고 가벼워야 하지만, 감정을 이해하는 과정(Nurturing)은 깊어야 합니다. 이 흐름은 사용자가 준비되었을 때(시간차를 두고) 자신의 감정을 다시 마주하고, 그 안에 숨겨진 가치를 발견하도록 돕습니다.

## 2. Interaction Flow

### 2.1 Trigger (진입점)
*   **Context:** 홈 화면 타임라인(History) 혹은 '마음 정원'의 식물.
*   **Indication:** 심어진 지 일정 시간(예: 4시간)이 지난 씨앗/잎사귀에 **"물방울 아이콘(💧)"**이 반짝임.
*   **Action:** 사용자가 해당 아이콘을 탭.

### 2.2 Reflection Panel (성찰 패널)
*   **Transition:** 부드럽게 화면이 어두워지며 중앙에 질문 카드가 뜸.
*   **Content (Progressive Disclosure):**
    1.  **Recall:** "아까 '{Emotion}' 기분을 느꼈을 때..."
    2.  **The 3 T's Review:** (이전에 입력했다면 보여주고, 안 했다면 질문)
        *   "무엇이 트리거였나요?"
        *   "그때 무슨 생각을 했나요?"
    3.  **Coaching Question (Core):** `spec/10-domain/23-emotion-value-framework.md`에 정의된 4분면별 질문 제시.
        *   *(예: Red Zone)* "그 상황에서 지키고 싶었던 당신의 기준은 무엇이었나요?"

### 2.3 Value Discovery (가치 발견)
*   **Selection:** 답변에 따라 추천되는 **핵심 가치 태그 (#Values)** 선택.
    *   *Red:* #공정성, #안전, #존중, #성장...
    *   *Blue:* #연결, #의미, #휴식...
*   **Feedback:** 태그를 선택하면 식물에 빛이 스며들거나(Nutrient), 새로운 잎이 돋아나는(Growth) 시각적 보상 제공.

## 3. UI/UX Detail
*   **Tone:** 평가하지 않고(Non-judgmental), 호기심을 갖는(Curious) 어조.
*   **Visual:** '숙제'가 아니라 '식물 돌보기'라는 메타포를 유지하기 위해, 텍스트 입력창보다는 식물에 물을 주거나 비료를 주는 애니메이션과 결합.
