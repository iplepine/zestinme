# 1.2 Emotion Recording: The Seeding (마음 기록)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.2 |
| **Status** | Final Draft |
| **Date** | 2025-12-18 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/20-feature/01-home.md`, `spec/50-ui/01-home-screen.md` |

## 1. 개요 (Overview)
> **"당신의 솔직한 마음이 식물을 적시는 생명수(Watering)가 됩니다."**

사용자는 **'마음 기록(Record Mind)'** 버튼을 통해 진입하지만, 이 행위는 곧 식물에게 물을 주는 **'Watering'** 메타포로 연결됩니다.
기계적인 그래프가 아닌 심미적인 감정 좌표(Canvas)를 통해 직관적으로 마음을 선택합니다.

---

## 2. 화면 구성 (Layout)

### 2.1 Background: The Emotional Canvas
*   **Concept:** Valence(X) - Arousal(Y) 2차원 좌표계.
*   **Visual:** 부드러운 그라데이션 필드.
    *   **Top-Right (Energized):** **Sunglow (Yellow)** - 화창함.
    *   **Top-Left (Stressed):** **Paradise Pink (Red)** - 열정/스트레스.
    *   **Bottom-Left (Tired):** **Rich Blue (Teal)** - 차분함/우울.
    *   **Bottom-Right (Calm):** **Caribbean Mint (Green)** - 평온함.

### 2.2 Quadrant Guides
*   **Labels:** 축 이름 대신 키워드 배치 (활기참, 스트레스, 지침, 평온함).
*   **Typography:** 20pt Bold, 세련된 타이포그래피.

### 2.3 Foreground: The Spirit Drop (마음의 물방울)
*   **Visual:** 기존의 '씨앗' 대신, **'빛나는 물방울(Glowing Drop)'** 형태.
    *   사용자의 터치에 따라 색상이 실시간으로 변함.
    *   Arousal(Y축)에 따라 박동(Pulse) 속도 변화.

---

## 3. Interaction Flow

1.  **Entry:** 홈 화면 우측 하단 `Record Mind (마음 기록)` FAB 탭.
2.  **Explore (Drag):** 물방울을 드래그하여 감정의 위치 탐색. 배경색 반응.
3.  **Drop (Select):** 손을 떼면 위치 확정 -> **Value Discovery Panel** 등장.
4.  **Detail:** 태그 선택 및 간단 메모(Trigger/Thought/Tendency).
5.  **Confirm:** **`마음 담기`** 버튼 탭.
6.  **Feedback (Watering):**
    *   기록된 색상의 물방울이 홈 화면의 식물 위로 떨어져 스며드는 연출.
    *   홈 화면 날씨(Environment) 즉시 변경.

---

## 4. Value Discovery Framework
*   **Step 1:** 감정 입자도(Granularity) 태그 선택.
*   **Step 2:** Trigger/Thought/Tendency (3T) 메모 작성.
*   **Note:** 심층적인 가치 발견 코칭은 **'Pruning (다듬기)'** 단계로 이연(Delay)됨.
