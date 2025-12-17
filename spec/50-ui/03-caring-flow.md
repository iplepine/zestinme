# 1.3 Emotion Refinement: Pruning (다듬기) UI Spec

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.4 |
| **Status** | Final Design Spec |
| **Date** | 2025-12-18 |
| **Author** | Mind-Gardener Committee |
| **Theme Ref** | `AppTheme.darkTheme` (Deep & Focused) |

## 1. Overview
> **"마음을 다듬어, 성장의 양분으로 삼는다."**

*   **Goal:** 숙성된(4시간 경과) 감정 기록을 다시 회고하고 코칭 질문에 답하여 **식물을 성장**시키는 과정.
*   **Key Metaphor:** **Pruning (가지치기/다듬기)**.
    *   묵혀둔 감정을 정리해주는 행위.
*   **Trigger:** 홈 화면 식물 주변에 뜬 **물방울(Water Drop)** 터치.

---

## 2. Layout Structure (Night Garden)

### 2.1 Background
*   **Effect:** 집중을 위한 **Dark Vibe**.
*   **Color:** `#101418` (Deep Charcoal) + 은은한 감정 컬러 Glow.

### 2.2 Hero Content (The Plant)
*   **Position:** Top Center.
*   **Widget:** `MysteryPlantWidget` (Interactive).
*   **Animation:** 'Breathing' (사용자의 답변 진행도에 따라 빛이 강해짐).

---

## 3. Interaction Flow (The Pruning Loop)

### 3.1 Intro
*   **Msg:** "지난번 기록한 '{Emotion}' 감정, 지금은 어떤가요?"
*   **Content:** 과거 기록(메모, 태그) 리마인드.

### 3.2 Coaching (Pruning)
*   **Card UI:** 플립 가능한 질문 카드.
*   **Question Logic:** 감정의 깊이(Depth)에 따른 단계별 질문.
    *   **Level 1:** 사실 확인 (Fact checking).
    *   **Level 2:** 의미 탐색 (Finding meaning).
    *   **Level 3:** 행동 설계 (Action plan).
*   **Answer:** 텍스트 입력 또는 객관식 선택.

### 3.3 Value Discovery (Tagging)
*   **Action:** 답변 완료 후, 이 경험에서 발견한 **'가치(Value)'** 태그 선택.
    *   *Ex) 인내, 용기, 솔직함, 배움.*

### 3.4 Outro (Growth Reward) 🌟
*   **Animation:**
    1.  사용자가 선택한 가치 태그가 빛(Light)이 되어 식물에게 흡수됨.
    2.  식물이 진동하며 **Level Up (성장)**.
    3.  새로운 잎이 돋아나거나 꽃봉오리가 커짐.
*   **Feedback:** "마음이 한 뼘 더 자랐어요."

---

## 4. Animation Choreography
1.  **Entry:** Background Fade In -> Plant Scale Up.
2.  **Flip:** 질문 카드 뒤집기 (Pruning motion).
3.  **Growth:** **Particle Explosion** (성공/보상 연출).
