# 1.2 Emotion Recording: The Seeding (심기)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.0 |
| **Status** | Draft |
| **Date** | 2025-12-07 |
| **Author** | Mind-Gardener Committee |
| **Related** | `spec/20-feature/00-tutorial.md`, `app/docs/20-feature-emotion-flow.md` |

## 1. 기획 의도 (Design Intent)
> **"Don't think, just feel."**

기존의 5단계 설문 방식을 폐기하고, **단 한 번의 제스처(One Swipe)**로 감정의 위치(좌표)를 잡는 것에 집중합니다.
사용자는 씨앗을 심는 행위를 통해 자신의 감정을 직관적으로 호명합니다.

## 2. 화면 구성 (Layout)

### 2.1 Background: The Soil (감정의 흙)
*   **Concept:** 2D Cartesian Coordinate System (Russell's Circumplex Model)
    *   **X-axis:** Unpleasant (Left) <-> Pleasant (Right)
    *   **Y-axis:** Low Energy (Bottom) <-> High Energy (Top)
*   **Visual:** 단순한 그래프가 아닌, **'흙의 질감과 색상'**으로 표현.
    *   **Top-Right (High/Pleasant):** 따뜻하고 부드러운 황토색/주황빛 (Sunny Soil).
    *   **Top-Left (High/Unpleasant):** 붉고 거친 자갈밭 (Volcanic Soil).
    *   **Bottom-Left (Low/Unpleasant):** 차갑고 축축한 잿빛 진흙 (Swampy Soil).
    *   **Bottom-Right (Low/Pleasant):** 평온하고 고요한 숲의 흙 (Mossy Soil).
*   **Interaction:** 씨앗(터치 포인트)의 위치에 따라 배경 전체의 Gradient가 실시간으로 블렌딩됩니다.

### 2.2 Foreground: The Seed (씨앗)
*   **Initial State:** 화면 중앙 하단에 떠 있는 빛나는 씨앗 아이콘.
*   **Action:** 사용자가 이를 드래그하여 화면 어디든 놓을 수 있습니다.
*   **Feedback:**
    *   **Haptic:** 드래그 중 중심에서 멀어질수록 미세한 진동(Tension) 발생 (Optional).
    *   **Visual:** 씨앗 주변으로 파문(Ripple)이 퍼지며 현재 좌표의 색상을 강조.

### 2.3 Post-Drag: The Tagging (명명)
*   **Trigger:** 드래그를 멈추고 손을 떼면(Drop), 씨앗이 심어지는 애니메이션 수행.
*   **Transition:** 심어진 위치 바로 위에 **3~4개의 추천 감정 키워드**가 칩(Chip) 형태로 떠오름.
    *   *Algorithm:* 좌표(Valence/Arousal)에 근접한 감정 단어 추천.
*   **Action:** 하나를 탭하면 선택 완료. (아무것도 선택 안 하고 배경 탭하면 '무제(Untitled)'로 기록).

## 3. Interaction Flow

1.  **Entry:** 홈 화면에서 '+' 버튼 탭 -> Seeding Screen 오버레이 혹은 전환.
2.  **Gesture:** 씨앗을 드래그하여 내 마음의 위치 찾기 (탐색).
3.  **Drop:** 손을 뗌 -> "툭" 하는 소리와 함께 씨앗이 박힘.
4.  **Tag (Optional):** "지금 이 기분은..." -> [화남] [짜증] [답답] 중 선택.
5.  **Exit:** "씨앗이 심어졌습니다." 토스트 메시지와 함께 홈으로 복귀.

## 4. Technical Spec
*   **Coordinate:** X(-1.0 ~ 1.0), Y(-1.0 ~ 1.0) 정규화 좌표 사용.
*   **Assets:**
    *   Seed Icon (Draggable)
    *   Soil Textures or Gradient Mesh (Background)
