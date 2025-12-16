# 1.3 Emotion Refinement: Caring (돌보기) UI Spec

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.3 |
| **Status** | Final Design Spec |
| **Date** | 2025-12-16 |
| **Author** | Mind-Gardener Committee |
| **Theme Ref** | `AppTheme.darkTheme` (Deep & Focused) |

## 1. Overview
*   **Goal:** 사용자가 기록된 감정에 대한 코칭 질문에 답하고, 가치를 발견하는 흐름을 시각적으로 구현.
*   **Key Metaphor:** "식물에게 물을 주듯, 내 마음을 돌본다."
*   **Theme:** **Night Garden (심야의 정원)** - 주변을 어둡게 처리하여 몰입감 조성.

---

## 2. Layout Structure (Root)

### 2.1 Scaffold
*   **BackgroundColor:** `AppTheme.darkScheme.background` (`#101418`)
*   **Status Bar:** Light Content (White icons)
*   **ResizeToAvoidBottomInset:** `false` (카드 뷰가 올라감)

### 2.2 Background Layer
*   **Effect:** 감정의 잔향 (Emotional Resonance)
*   **Implementation:** 화면 중앙에 기록된 감정 컬러(`EmotionColor`)의 Radial Gradient를 아주 은은하게 배치.

---

## 3. UI Flow & Component Specs

### 3.1 Header (Navigation)
*   **Type:** `AppBar` (Transparent)
*   **Leading:**
    *   **First Stage:** `CloseIcon` (`Icons.close`) - "그만하기"
    *   **Later Stages:** `BackIcon` (`Icons.arrow_back`) - "이전 질문"
*   **Title:** (Empty) - 식물과 질문에 집중.

### 3.2 Hero Content (The Plant)
*   **Position:** Top Center
*   **Widget:** `CaringPlantWidget`
*   **Size:** 120x120 dp
*   **Animation:** 'Breathing' (Scale 1.0 -> 1.05 -> 1.0, Duration: 4s loop)

### 3.3 Progress Indicator (Dots) [NEW]
*   **Location:** Below Plant.
*   **Widget:** `Row` of Dots.
*   **State:**
    *   Active Dot: `white` (Opacity 1.0)
    *   Inactive Dot: `white` (Opacity 0.3)
*   **Count:** `maxDepth` (1~3)에 따라 동적 생성.

### 3.4 Card: The Coaching Question (Flip Interaction)
*   **Layout:**
    *   **Width:** Screen Width - 48dp (Horizontal Margin 24dp)
    *   **Height:** Min 200dp
    *   **Decoration:** Dark Surface (`#14181C`), Rounded `24.0`, Border `1dp`.

#### State A: Question (Front)
*   **Content:**
    *   **Icon:** `Dr. Mind` or Stage Icon.
    *   **Text:** Contextual Question ("Ex: '{context}'라고 하셨는데...")
*   **Interaction:** Tap -> **Flip Animation**.

#### State B: Answer Input (Back)
*   **TextField:** `InputDecoration.collapsed`, MaxLines 5.
*   **Action Button:** (Dynamic Label)
    *   **Progression:** "다음 질문 보기" (`Icons.arrow_forward`)
    *   **Completion:** "가치 발견하기" (`Icons.auto_awesome`)

### 3.5 Value Discovery Sheet (Slide Up)
*   **Trigger:** 마지막 단계 완료 시.
*   **Content:** Tag Cloud (추천 가치 태그).
*   **Confirm:** "물 주기 (완료)" -> Reward Animation Trigger.

---

## 4. Animation Choreography

1.  **Entry:** Background Fade In -> Plant Scale Up -> Intro Text Slide Up.
2.  **Flip:** Card rotates Y-axis (pi). Text clears on flip back.
3.  **Reward:**
    *   Water Drop falls.
    *   Plant Glows (Gold/Green).
    *   Msg: "마음이 자라났어요."

---
