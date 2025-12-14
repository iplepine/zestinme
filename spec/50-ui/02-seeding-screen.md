# 1.2 Emotion Recording: The Seeding (심기)

| Attribute | Value |
| :--- | :--- |
| **Version** | 1.1 |
| **Status** | Final Draft |
| **Date** | 2025-12-07 |
| **Author** | Mind-Gardener Committee (w/ Artist Esthetic) |
| **Related** | `spec/20-feature/00-tutorial.md` |

## 1. 기획 의도 (Design Intent)
> **"The Mirror of Emotion, Beautifully Rendered."**

기존의 5단계 설문 방식을 폐기하고, **단 한 번의 제스처(One Swipe)**로 감정의 위치(좌표)를 잡습니다.
특히 **Artist Esthetic**의 주도 하에, 기계적인 그래프가 아닌 **심미적으로 완성된 감정의 풍경**을 제공하여 기록 행위 자체가 힐링이 되도록 설계했습니다.

## 2. 화면 구성 (Layout)

### 2.1 Background: The Emotional Canvas (감정의 캔버스)
*   **Concept:** 2D Cartesian Coordinate System (Russell's Circumplex Model) re-imagined as a soft gradient field.
*   **Color Palette (Trendy Aesthetic):**
    *   **Top-Right (Energized):** **Sunglow (Yellow)** - 따스하고 기분 좋은 햇살.
    *   **Top-Left (Stressed):** **Paradise Pink (Coral Red)** - 강렬하지만 세련된 경고.
    *   **Bottom-Left (Tired):** **Rich Blue (Teal)** - 깊고 차분한 심해.
    *   **Bottom-Right (Calm):** **Caribbean Mint (Green)** - 상쾌하고 청량한 휴식.
*   **Rendering (Corner Radial Gradient):**
    *   각 모서리의 **20%** 영역은 순수한 고유색(Solid Core)을 유지합니다.
    *   중심으로 갈수록 자연스럽게 투명해지며, 십자선(Crosshair) 위치에서 부드럽게 색이 섞입니다.
    *   불쾌한 대각선 경계(Diagonal Artifacts)를 완전히 제거하고 은은하게 퍼지는 효과 구현.

### 2.2 Quadrant Guides (감정의 이정표)
*   **Labels:** 축(Axis) 이름 대신 **각 사분면의 정체성**을 나타내는 키워드 배치.
    *   *활기참 (Energized) / 스트레스 (Stressed) / 지침 (Tired) / 차분함 (Calm)*
*   **Positioning:**
    *   **Horizontal:** 각 영역의 중앙 정렬 (화면 너비의 25%, 75%).
    *   **Vertical:** 화면 상하단으로 과감하게 확장 배치 (화면 높이의 18%, 82%).
*   **Typography:** **20pt Bold** 폰트를 사용하여 시원하고 명확한 타이포그래피 제공.
*   **Lines:** 중심과 끝부분이 사라지는 **Gradient Crosshairs**를 사용하여, 가이드라인이 시선을 방해하지 않도록 처리.

### 2.3 Foreground: The Spirit Seed (생명의 씨앗)
*   **Visual:** 단순한 아이콘이 아닌, **'살아 숨 쉬는(Breathing)'** 다층 구조의 위젯.
    *   **Core:** 하얗게 빛나는 핵.
    *   **Halo:** 은은하게 퍼지는 빛무리.
    *   **Pulse:** 각성도(Arousal)에 따라 박동 속도가 달라짐 (흥분 시 빠름, 이완 시 느림).
*   **Interaction:**
    *   드래그 시 주변 색상이 화면 전체로 확장(Spread)되며 몰입감을 줌.
    *   놓는(Drop) 순간 해당 위치의 감정 색상이 보존됨.

### 2.4 Post-Drag: Value Discovery Framework (가치 발견)
> **Refer to:** `spec/10-domain/23-emotion-value-framework.md`

*   **Transition:** 하단에서 부드럽게 올라오는(Slide-up) 디테일 패널.
*   **Section 1: Emotional Granularity (감정 입자도)**
    *   **Action:** 좌표 기반 추천 태그(Recommended Tags) 중 가장 적절한 단어 선택. (예: 분노 vs 짜증)
*   **Section 2: Contextual Logging (Guided Input)**
    *   **Format:** 단일 텍스트 필드 (Single Text Field). 복잡한 입력을 피하고 자유롭게 작성.
    *   **Smart Hint:** 3 T's 프레임워크를 자연스럽게 유도하는 힌트 텍스트(Placeholder) 롤링 제공.
        *   *"무엇이 이 감정을 불렀나요? (Trigger)"*
        *   *"그 순간 어떤 생각이 스쳤나요? (Thought)"*
        *   *"지금 당장 무엇을 하고 싶나요? (Tendency)"*
    *   **Value:** 사용자가 힌트를 보고 자연스럽게 맥락을 포함하여 기록하도록 유도.
*   **Plant Button:** 저장 ("이 마음을 심어서 가꾸기").

> **Note:** 핵심 가치 발견(Value Discovery) 및 코칭 질문은 **'심기(Seeding)' 단계가 아닌 '돌보기(Caring)' 단계**에서 진행합니다. (See: `spec/50-ui/03-caring-flow.md`)

## 3. Interaction Flow

1.  **Entry:** 홈 화면 FAB 탭 -> Seeding Screen 오버레이.
2.  **Explore (Quadrant):** 씨앗을 드래그하여 자신의 에너지/기분 상태(4분면) 탐색. 배경색 반응.
3.  **Plant (Drop):** 손을 떼면 씨앗이 심어지고(Fixed), 가치 발견 패널(Detail Panel) 등장.
4.  **Granularity:** 구체적 감정 단어 선택.
5.  **Context (Optional):** 힌트를 보며 간단한 메모 작성 (Trigger/Thought/Tendency).
6.  **Save:** '씨앗 심기' 버튼 탭 -> 데이터베이스 저장 및 홈 타임라인 반영. (가치 태깅은 나중으로 연기)
